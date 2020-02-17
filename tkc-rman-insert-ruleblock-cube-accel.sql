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
        
        egfr_l => eadv.lab_bld_egfr_c.val.lastdv();
        
        egfr_l1 => eadv.lab_bld_egfr_c.val.lastdv().where(dt<egfr_l_dt-90 and dt>egfr_l_dt-365);
        
        egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
        
        
        egfr_single:{ iq_egfr=1 =>1},{=>0};
        egfr_multiple:{ iq_egfr>1 =>1},{=>0};
        egfr_outdated:{ (sysdate-egfr_l_dt>730) =>1},{=>0};
        
        egfr_tspan : {1=1 => egfr_l_dt-egfr_f_dt};
        
        #doc(,
            {
                txt : "Check for 1 year egfr assumption violation"
            }
        );
        
        egfr_1y_delta : {egfr_l1_val is not null => egfr_l_val-egfr_l1_val};
        
        asm_viol_1y : {abs(egfr_1y_delta)>20 => 1},{=> 0};
        
        #doc(,
            {
                txt : "Check for 3 month egfr assumption violation"
            }
        );
        
        egfr_3m_n2 => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfr_l_dt-30);
        egfr_3m_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfr_l_dt-30);
        
        egfr_3m_qt : {egfr_3m_n2>=2 => round(egfr_l_val/egfr_3m_mu,2)};
        
        asm_viol_3m : {nvl(egfr_3m_qt,1)>1.2 or nvl(egfr_3m_qt,1)<0.8  => 1},{=> 0};
               
        
   
        acr_l => eadv.lab_ua_acr.val.lastdv();
            
        
        egfr_3m_n => eadv.lab_bld_egfr_c.val.count(0).where(dt<egfr_l_dt-90 and val<60);
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt<acr_l_dt-30 and val>3);
        
        pers : {least(egfr_3m_n,acr_3m_n)>0 => 1},{=>0};
        
        
        
        
        cga_g:  {egfr_l_val>=90 AND rrt=0 => `G1`},
                {egfr_l_val<90 AND egfr_l_val>=60  AND rrt=0 => `G2`},
                {egfr_l_val<60 AND egfr_l_val>=45  AND rrt=0 => `G3A`},
                {egfr_l_val<45 AND egfr_l_val>=30  AND rrt=0 => `G3B`},
                {egfr_l_val<30 AND egfr_l_val>=15  AND rrt=0 => `G4`},
                {egfr_l_val<15 AND rrt=0 => `G5`},
                {=>`NA`};

        

            
        cga_a: {acr_l_val<3 => `A1`},
                {acr_l_val<30 AND acr_l_val>=3 => `A2`},
                {acr_l_val<300 AND acr_l_val>=30 => `A3`},
                {acr_l_val>300 => `A4`},{=>`NA`};
                
        cga_a_val: {acr_l_val<3 => 1},
                {acr_l_val<30 AND acr_l_val>=3 => 2},
                {acr_l_val<300 AND acr_l_val>=30 => 3},
                {acr_l_val>300 => 4},{=>0};
        
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
  
    
  
END;





