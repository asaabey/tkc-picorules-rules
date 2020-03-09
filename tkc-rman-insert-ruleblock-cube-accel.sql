CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_dense';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Optimized Rule block for cube generation in CKD*/
        
        #define_ruleblock(ckd_dense,
            {
                description: "Optimized Rule block for cube generation in CKD",
                version: "0.0.1.0",
                blockid: "ckd_dense",
                target_table:"rout_ckd_dense",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckd_dense",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        dod => eadv.dmg_dod.dt.max();
        
        gender => eadv.dmg_gender.val.last();
        
        loc_mode_phc => eadv.dmg_location.val.stats_mode().where(substr(val,-1)=1);
        
        
        
        
        iq_uacr => eadv.lab_ua_acr.val.count(0);
        iq_egfr => eadv.lab_bld_egfr_c.val.count(0);
        iq_coding => eadv.[icd_%,icpc_%].dt.count(0);
        
        iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4},
                {least(iq_egfr,iq_uacr)>=2 => 3},
                {least(iq_egfr,iq_uacr)>=1 => 2},
                {iq_egfr>0 or iq_uacr>0 => 1},
                {=>0};
                
        hd_z49_n => eadv.icd_z49_1.dt.count(0);
        
        hd_z49_1y_n => eadv.icd_z49_1.dt.count(0).where(dt>sysdate-365);
        
        hd_dt => eadv.icd_z49_1.dt.max(1900); 
        
        hd_dt_min => eadv.icd_z49_1.dt.min();
        
        
        pd_dt => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.max(1900);
        
        tx_dt => eadv.[icpc_u28001,icd_z94%].dt.max(1900);
        
        homedx_dt => eadv.[icpc_u59j99].dt.max(1900);
        
        
        ren_enc => eadv.enc_op_renal.dt.max(1900);
        
        
        
        rrt:{hd_dt > greatest(pd_dt,tx_dt,homedx_dt) and hd_z49_1y_n>10  and hd_dt>sysdate-365 => 1},
            {pd_dt > greatest(hd_dt,tx_dt,homedx_dt) => 2},
            {tx_dt > greatest(hd_dt,pd_dt,homedx_dt) => 3},
            {homedx_dt > greatest(hd_dt,pd_dt,tx_dt) => 4},
            {=>0};

             
        pd_dt_min => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.min();
        
        
        hd_start : {hd_dt_min > sysdate-365 and hd_z49_n>=10 => 1},{=>0};
          
        pd_start : {pd_dt_min > sysdate-365 => 1},{=>0};
        
        rrt_start : { hd_start=1 or pd_start=1 => 1},{=>0};
        
        egfr_l => eadv.lab_bld_egfr_c.val.lastdv().where(dt > sysdate - 365);
        
        egfr_l1 => eadv.lab_bld_egfr_c.val.lastdv().where(dt<egfr_l_dt-90 and dt>egfr_l_dt-365);
        
        egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
        
        
        egfr_single:{ iq_egfr=1 =>1},{=>0};
        egfr_multiple:{ iq_egfr>1 =>1},{=>0};
        egfr_outdated:{ (sysdate-egfr_l_dt>730) =>1},{=>0};
        
        egfr_tspan : {1=1 => egfr_l_dt-egfr_f_dt};
        

        
        #doc(,
            {
                txt : "Check for 3 month egfr assumption violation"
            }
        );
        
        egfr_3m_n2 => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfr_l_dt-30);
        egfr_3m_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfr_l_dt-30);
        
        egfr_3m_qt : {egfr_3m_n2>=2 => round(egfr_l_val/egfr_3m_mu,2)};
        
        asm_viol_3m : {nvl(egfr_3m_qt,1)>1.2 or nvl(egfr_3m_qt,1)<0.8  => 1},{=> 0};
               
        
   
        acr_l => eadv.lab_ua_acr.val.lastdv().where(dt > sysdate - 365);
        
        acr_l1 => eadv.lab_ua_acr.val.lastdv().where(dt < acr_l_dt-30 and dt > sysdate - 365);    
        
        egfr_3m_n => eadv.lab_bld_egfr_c.val.count(0).where(dt<egfr_l_dt-90 and val<60);
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt<acr_l_dt-30 and val>3);
        
        pers : {least(egfr_3m_n,acr_3m_n)>0 => 1},{=>0};
        
        g_l_val:  {egfr_l_val>=90 AND rrt=0 => 1},
                {egfr_l_val<90 AND egfr_l_val>=60  AND rrt=0 => 2},
                {egfr_l_val<60 AND egfr_l_val>=45  AND rrt=0 => 3},
                {egfr_l_val<45 AND egfr_l_val>=30  AND rrt=0 => 4},
                {egfr_l_val<30 AND egfr_l_val>=15  AND rrt=0 => 5},
                {egfr_l_val<15 AND rrt=0 => 6},
                {=>0};
        
        g_l1_val:  {egfr_l1_val>=90 AND rrt=0 => 1},
                {egfr_l1_val<90 AND egfr_l1_val>=60  AND rrt=0 => 2},
                {egfr_l1_val<60 AND egfr_l1_val>=45  AND rrt=0 => 3},
                {egfr_l1_val<45 AND egfr_l1_val>=30  AND rrt=0 => 4},
                {egfr_l1_val<30 AND egfr_l1_val>=15  AND rrt=0 => 5},
                {egfr_l1_val<15 AND rrt=0 => 6},
                {=>0};
        
        g_l_l1_gap : { greatest(g_l_val,g_l1_val)>0 => g_l_val-g_l1_val};
                
                
        a_l_val: {acr_l_val<3 => 1},
                {acr_l_val<30 AND acr_l_val>=3 => 2},
                {acr_l_val<300 AND acr_l_val>=30 => 3},
                {acr_l_val>300 => 4},{=>0};
        
        a_l1_val: {acr_l1_val<3 => 1},
                {acr_l1_val<30 AND acr_l1_val>=3 => 2},
                {acr_l1_val<300 AND acr_l1_val>=30 => 3},
                {acr_l1_val>300 => 4},{=>0};
        
        ckd_stage :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => `1`},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => `2`},
                {cga_g=`G3A` => `3A`},
                {cga_g=`G3B` => `3B`},
                {cga_g=`G4` => `4`},
                {cga_g=`G5` => `5`},
                {=> null};
        
        
        
        
        ckd :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) and rrt=0 => 1},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) and rrt=0 => 2},
                {cga_g=`G3A` and rrt=0 => 3},
                {cga_g=`G3B` and rrt=0 => 4},
                {cga_g=`G4` and rrt=0 => 5},
                {cga_g=`G5` and rrt=0 => 6},
                {=> 0};
        
        
        cert_level : {ckd>0 and pers=1 and asm_viol_3m=0 =>3},{ckd>0 and pers=1 and asm_viol_3m=1 =>2},{ckd>0 and pers=0 and asm_viol_3m=0 =>1};
        
        
        cp_l => eadv.careplan_h9_v1.val.lastdv();
        
        cp_ckd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_ckd_ld : {cp_l_dt is not null => cp_l_dt};
        
        
        dx_ckd0_  => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039,icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j95,6].val.last();
        
        dx_ckd : { 1=1 => nvl(dx_ckd0_,0)};
        
        
        dx_ckd_stage :{dx_ckd=1 => `1`},
                {dx_ckd=2 => `2`},
                {dx_ckd=3 => `3A`},
                {dx_ckd=4 => `3B`},
                {dx_ckd=5 => `4`},
                {dx_ckd=6 => `5`},
                {dx_ckd=0 => `0`};
                
        
        dx_ckd_diff :{abs(ckd-dx_ckd)>=2 => 1 },{=>0};
        
        
        avf => eadv.caresys_3450901.dt.max();
        
        cp_mis :{cp_ckd>0 and (ckd - cp_ckd)>=2 => 1},{=>0};
        
        avf_has : { avf is not null =>1},{=>0};
        
  

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --

         
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='at_risk_dense';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Test  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is the at_risk_dense algorithm",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:1,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        ckd_icpc_val => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].dt.max();
        
        dm_icd_fd => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%].dt.min();
        
        dm_icpc_fd => eadv.[icpc_t89%,icpc_t90%].dt.min();
        
        dm_fd : { dm_icd_fd!? and dm_icpc_fd!? => least(dm_icd_fd,dm_icpc_fd) },{dm_icd_fd!? => dm_icd_fd},{dm_icpc_fd!? => dm_icpc_fd};
        
        dm_prev : { dm_fd!? => 1 },{=>0};
        
        dm_incd : { dm_fd > sysdate - 365 => 1},{=>0};
        
        htn_icd_fd => eadv.[icd_i10_%,icd_i15_%].dt.min();
        
        htn_icpc_fd => eadv.[icpc_k85%,icpc_k86%,icpc_k87%].dt.min();

        htn_fd : { htn_icd_fd!? and htn_icpc_fd!? => least(htn_icd_fd,htn_icpc_fd) },{htn_icd_fd!? => htn_icd_fd},{htn_icpc_fd!? => htn_icpc_fd};
        
        htn_prev : { htn_fd!? => 1 },{=>0};
        
        htn_incd : { htn_fd > sysdate - 365 => 1},{=>0};
        
        ihd_fd => eadv.[icd_z95_1%,icpc_k54007,icd_i21%,icd_i22%,icd_i23%,icd_i24%,icd_i25%,icpc_k74%,icpc_k75%,icpc_k76%].dt.min(2900);
        
        cva_fd => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min(2900);
            
        pvd_fd => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.min(2900);
        
        cvd_fd : { least(ihd_fd,cva_fd,pvd_fd)< to_date(`29000101`,`YYYYMMDD`) => least(ihd_fd,cva_fd,pvd_fd)};
        
        
        cvd_prev : { cvd_fd!? => 1 },{=>0};
        
        cvd_incd : { cvd_fd > sysdate - 365 => 1},{=>0};
        
        
        
        dyslip_fd => eadv.[icpc_t93%].dt.min();
        
        dyslip_prev : { dyslip_fd!? => 1 },{=>0};
        
        dyslip_incd : { dyslip_fd > sysdate - 365 => 1},{=>0};
            
        egfr_1y_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt > sysdate -365);
        
        uacr_1y_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt > sysdate -365);
        
        bp_1y_n => eadv.obs_bp_systolic.dt.count(0).where(dt > sysdate -365);
        
        screen_egfr : { egfr_1y_n>0 =>1 },{ => 0}; 
        
        screen_uacr : { uacr_1y_n>0 =>1 },{ => 0};
        
        screen_bp : { bp_1y_n>0 =>1 },{ => 0};
        
        screen_full : { . => screen_egfr + screen_uacr + screen_bp};
        
        mbs_715 => eadv.mbs_715.dt.count().where(dt > sysdate -365);
        
        mbs_721 => eadv.mbs_721.dt.count().where(dt > sysdate -365);
        
        mbs_flag : { . => coalesce(mbs_715,mbs_721)};
        [[rb_id]] : {1=1 =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
  
    
  
END;





