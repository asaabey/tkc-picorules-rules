CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
       -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='kfre';
  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Ruleblock to calculate KFRE */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to calculate KFRE",
               
                is_active:2
                
            }
        );
        
        
        #doc(,
            {
                txt:"External bindings"
            }
            
        );
        
        
        ckd => rout_ckd.ckd.val.bind();
        
        #doc(,
            {
                txt:"Gather variables"
            }
            
        );
       
        
        dob => eadv.dmg_dob.dt.max();
        
        male => eadv.dmg_gender.val.max();
        
        egfr => eadv.lab_bld_egfr_c.val.lastdv();
        
        uacr => eadv.lab_ua_acr.val.lastdv();
        

        
        #doc(,
            {
                txt:"Determine if 4 variable equation is applicable - apply for CKD G3a, 3b, 4"
            }
            
        );
        
        kfre4v_ap : { least(dob,egfr_dt,uacr_dt) is not null and male is not null and ckd>=3 and ckd<5 => 1},{=>0};
        
        egfr_1 : { 1=1 => egfr_val};
        
        
        ln_uacr_1 : { nvl(uacr_val,0)>0  => ln(uacr_val * 8.84)};
        
        
        age : { 1=1 => round(((egfr_dt-dob)/365.25),0)};
        
        #doc(,
            {
                txt:"Apply KFRE 4 variable equation. Note: KFRE is not validated in Indigenous populations.",
                cite: "kfre_ref1, kfre_ref2"
            }
            
        );
        
        
        kfre4v_exp : { kfre4v_ap =1 => exp((-0.5567*(egfr_1/5-7.222))+(0.2467*(male - 0.5642))+(0.451*(ln_uacr_1-5.137))-(0.2201*(age/10-7.036)))},{=>0};
        
        kfre4v_2yr : { kfre4v_ap =1 => round(1-power(0.9832,kfre4v_exp) ,2)};
        
        kfre4v_5yr : { kfre4v_ap =1 => round(1-power(0.9365,kfre4v_exp) ,2)};
        
        [[rb_id]] : { 1=1 => kfre4v_ap};
        
                  
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock); 
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='pcd';
  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Ruleblock for PCD Traffic light report */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess PCD Traffic light report",
                
                is_active:0
                
            }
        );
        
        #doc(,
            {
                txt:"External bindings"
            }
            
        );
        
        
        ckd => rout_ckd.ckd.val.bind();
        
        dm => rout_cd_dm_dx.dm.val.bind();
        
        cvra_calc => rout_cvra.cvra.val.bind();
        
        
        #doc(,
            {
                txt:"Gather variables "
            }
            
        );
        
        
        dob => eadv.dmg_dob.dt.max();
        
        male => eadv.dmg_gender.val.max();
        
        pcd_dt => eadv.mbs_721.dt.max();
        
        cvra => eadv.asm_cvra.val.lastdv();
        
        tc => eadv.lab_bld_cholesterol_tot.va.lastdv();
        
        sbp130 => eadv.obs_bp_systolic.val.last();
        
        rx_raas => eadv.[rxnc_c09%].val.last().where(val=1);
        
        rx_bb => eadv.[rxnc_c07%].val.last().where(val=1);
        
        rx_ccb => eadv.[rxnc_c08%].val.last().where(val=1);
        
        rx_htn2 => eadv.[rxnc_c02%].val.last().where(val=1);
        
        rx_statin => eadv.[rxnc_c10aa].val.last().where(val=1);
        
        hba => eadv.lab_bld_hba1c.val.lastdv();
        
        acr => eadv.lab_ua_acr.val.lastdv();
        
        smoke0 => eadv.status_smoking_h2_v1.val.lastdv();
        
        gpmp_dt => eadv.mbs_721.dt.max();
        
        ahc_dt => eadv.mbs_715.dt.max();
        
        
        
        pcd12m : { pcd_dt < sysdate-365 => 1 },{=>0};
        
        cvra12m : { cvra_dt < sysdate-365 =>1},{=>0};
        
        age : { dob< sysdate => (sysdate-dob)/365.25};
        
        [[rb_id]] : { pcd_dt is not null =>1},{=>0};       
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);  
    COMMIT;
    -- END OF RULEBLOCK --

END;





