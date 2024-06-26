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
        
        #define_ruleblock([[rb_id]],
            {
                description: "Optimized Rule block for cube generation in CKD",
                is_active:0,

                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        dod => eadv.dmg_dod.dt.max();
        
        alive : { dod < sysdate-365 => 0},{ => 1};
        
        gender => eadv.dmg_gender.val.last();
        
        loc_mode_phc => eadv.dmg_location.val.stats_mode().where(substr(val,-1)=1);
        
        loc_mode => eadv.dmg_location.val.stats_mode().where(dt > sysdate - 730);
        
        source => eadv.dmg_source.val.last();
        
        
        
                
        hd_z49_n => eadv.icd_z49_1.dt.count(0);
        
        hd_z49_1y_n => eadv.icd_z49_1.dt.count(0).where(dt>sysdate-365);
        
        hd_dt => eadv.icd_z49_1.dt.max(1900);
        
        hd_dt_min => eadv.icd_z49_1.dt.min();
        
        
        pd_dt => eadv.[caresys_1310006,caresys_1310007,caresys_1310008,icpc_u59007,icpc_u59009,icd_z49_2].dt.max(1900);
        
        tx_dt => eadv.[icpc_u28001,icd_z94%].dt.max(1900);
        
        homedx_dt => eadv.[icpc_u59j99].dt.max(1900);
        
        
        ren_enc => eadv.[enc_op_ren_%,enc_op_renal_edu].dt.max(1900);
        
        rrt_ex_flag : { alive=0 =>1},{=>0};
        
        rrt:{hd_dt > greatest(pd_dt,tx_dt,homedx_dt) and hd_z49_1y_n>10  and hd_dt>sysdate-365  and rrt_ex_flag=0 => 1},
            {pd_dt > greatest(hd_dt,tx_dt,homedx_dt) and rrt_ex_flag=0 => 2},
            {tx_dt > greatest(hd_dt,pd_dt,homedx_dt) and rrt_ex_flag=0 => 3},
            {homedx_dt > greatest(hd_dt,pd_dt,tx_dt) and rrt_ex_flag=0 => 4},
            {=>0};

             
        pd_dt_min => eadv.[caresys_1310006,caresys_1310007,caresys_1310008,icpc_u59007,icpc_u59009,icd_z49_2].dt.min();
        
        
        hd_incd : {hd_dt_min > sysdate-365 and hd_z49_n>=10 => 1},{=>0};
          
        pd_incd : {pd_dt_min > sysdate-365 => 1},{=>0};
        
        rrt_incd : { hd_incd=1 or pd_incd=1 => 1},{=>0};
        
        #doc(,
            {
                txt : "CKD staging based KDIGO 2012"
            }
        );
        
        #doc(,
            {
                txt : "Exclusions"
            }
        );
        
        ckd_ex_flag : { rrt>0 or alive=0 =>1},{=>0};
        
        #doc(,
            {
                txt : "Read last,first, -30 day and -365 day egfr values"
            }
        );
        
        egfr_l => eadv.lab_bld_egfr_c.val.lastdv().where(dt > sysdate - 365);
        
        egfr_l1 => eadv.lab_bld_egfr_c.val.lastdv().where(dt < egfr_l_dt-90 and dt>egfr_l_dt-365);
        
        egfr_l2 => eadv.lab_bld_egfr_c.val.lastdv().where(dt < egfr_l_dt-365);
        
        egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
        
        
        #doc(,
            {
                txt : "Check for 30 day egfr assumption violation"
            }
        );
        
        egfr_30_n2 => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfr_l_dt-30);
        egfr_30_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfr_l_dt-30);
        
        egfr_30_qt : {egfr_30_n2>=2 => round(egfr_l_val/egfr_30_mu,2)};
        
        asm_viol_30 : {nvl(egfr_30_qt,1)>1.2 or nvl(egfr_30_qt,1)<0.8  => 1},{=> 0};
        
        asm_viol_ex : {asm_viol_30=1 =>0},{=>1};
               
        #doc(,
            {
                txt : "Check for 90 day egfr persistence"
            }
        );
        
        
        g_pers : { egfr_l1_val<90 and egfr_l_val<60 => 1},{ egfr_l2_val<90 and egfr_l_val<60 =>1},{=>0};
        
        
        #doc(,
            {
                txt : "Check for 1y egfr progression"
            }
        );
        
        ckd_prog : { egfr_l2_val!? =>1},{=>0};
   
        l_l2_delta : { egfr_l2_val!? => egfr_l_val-egfr_l2_val};
        
        g_stage_prog : {l_l2_delta < -15 =>1},{=>0};
        
        #doc(,
            {
                txt : "Check for 30 day uacr persistence"
            }
        );
        
        acr_l => eadv.lab_ua_acr.val.lastdv().where(dt > sysdate - 365);
        
        acr_l1 => eadv.lab_ua_acr.val.lastdv().where(dt < acr_l_dt-30 and dt > sysdate - 730);
        
        a_pers : {acr_l_val>3 and acr_l1_val>3 => 1},{=>0};
        
        ckd_pers : {greatest(g_pers,a_pers)>0 => 1},{=>0};
        
        g_l_val:  {egfr_l_val>=90  => 1},
                {egfr_l_val<90 AND egfr_l_val>=60  AND rrt=0 => 2},
                {egfr_l_val<60 AND egfr_l_val>=45  AND rrt=0 => 3},
                {egfr_l_val<45 AND egfr_l_val>=30  AND rrt=0 => 4},
                {egfr_l_val<30 AND egfr_l_val>=15  AND rrt=0 => 5},
                {egfr_l_val<15 AND rrt=0 => 6},
                {=>0};
                
                
        a_l_val: {acr_l_val<3 => 1},
                {acr_l_val<30 AND acr_l_val>=3 => 2},
                {acr_l_val<300 AND acr_l_val>=30 => 3},
                {acr_l_val>300 => 4},{=>0};
        
        
        
        avf => eadv.caresys_3450901.dt.max();
        
        ckd :{g_l_val=1 and a_l_val>1 and ckd_ex_flag=0=> 1},
                {g_l_val=2 and a_l_val>1 and ckd_ex_flag=0 => 2},
                {g_l_val>2 and ckd_ex_flag=0 => g_l_val},
                {=> 0};
        
        dx_ckd0_  => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039,icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j96].val.last();
        
        dx_ckd : { 1=1 => nvl(dx_ckd0_,0)};
        
        dx_ckd_diff :{abs(ckd-dx_ckd)>=2 => 1 },{=>0};
        
        
        
        
        
        assert_level : {. => 100000 + ckd_pers*10000 + asm_viol_ex*1000 + ckd_prog*100};

        [[rb_id]] : { . => 1 },{ => 0 };
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
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
                is_active:0
                
            }
        );
        
        ckd => rout_ckd_dense.ckd.val.bind();
        
        rrt => rout_ckd_dense.rrt.val.bind();
        
        alive => rout_ckd_dense.alive.val.bind();
        
        ckd_icpc_ld => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].dt.max();
        
        dm_icd_fd => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%].dt.min();
        
        dm_icpc_fd => eadv.[icpc_t89%,icpc_t90%].dt.min();
        
        
        
        dm_fd : {.=>least_date(dm_icd_fd, dm_icpc_fd)};
        
        dm_prev : { dm_fd!? => 1 },{=>0};
        
        dm_incd : { dm_fd > sysdate - 365 => 1},{=>0};
        
        htn_icd_fd => eadv.[icd_i10%,icd_i15%].dt.min();
        
        htn_icpc_fd => eadv.[icpc_k85%,icpc_k86%,icpc_k87%].dt.min();

        htn_fd : { htn_icd_fd!? and htn_icpc_fd!? => least(htn_icd_fd,htn_icpc_fd) },{htn_icd_fd!? => htn_icd_fd},{htn_icpc_fd!? => htn_icpc_fd};
        
        htn_prev : { htn_fd!? => 1 },{=>0};
        
        htn_incd : { htn_fd > sysdate - 365 => 1},{=>0};
        
        ihd_fd => eadv.[icd_z95_1%,icpc_k54007,icd_i21%,icd_i22%,icd_i23%,icd_i24%,icd_i25%,icpc_k74%,icpc_k75%,icpc_k76%].dt.min(2999);
        
        cva_fd => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min(2999);
            
        pvd_fd => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.min(2999);
        
        cvd_fd : { least(ihd_fd,cva_fd,pvd_fd)< to_date(`29991231`,`YYYYMMDD`) => least(ihd_fd,cva_fd,pvd_fd)};
        
        
        cvd_prev : { cvd_fd!? => 1 },{=>0};
        
        cvd_incd : { cvd_fd > sysdate - 365 => 1},{=>0};
        
        
        
        dyslip_fd => eadv.[icpc_t93%].dt.min();
        
        dyslip_prev : { dyslip_fd!? => 1 },{=>0};
        
        dyslip_incd : { dyslip_fd > sysdate - 365 => 1},{=>0};
        
        obese_fd => eadv.[icd_e66%,icpc_t82%].dt.min();
        
        obese_prev : { obese_fd!? => 1 },{=>0};
        
        obese_incd : { obese_fd > sysdate - 365 => 1},{=>0};
        
        at_risk : {coalesce(obese_fd, dyslip_fd,cvd_fd,htn_fd,dm_fd)!? and ckd=0 and rrt=0 and alive=1 =>1},{=>0};
        
            
        egfr_1y_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt > sysdate -365);
        
        uacr_1y_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt > sysdate -365);
        
        
        
        screen_egfr : { egfr_1y_n>0 =>1 },{ => 0};
        
        screen_uacr : { uacr_1y_n>0 =>1 },{ => 0};
        
        
        
        screen_full : { . => screen_egfr + screen_uacr };
        
        mbs_715 => eadv.mbs_715.dt.count().where(dt > sysdate -365);
        
        mbs_715_2y => eadv.mbs_715.dt.count().where(dt > sysdate -730);
        
        mbs_721 => eadv.mbs_721.dt.count().where(dt > sysdate -365);
        
        mbs_723 => eadv.mbs_721.dt.count().where(dt > sysdate -365);
        
        mbs_flag : { . => coalesce(mbs_715,mbs_721,mbs_723)};
        [[rb_id]] : { . => 1 },{ => 0 };
        
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





