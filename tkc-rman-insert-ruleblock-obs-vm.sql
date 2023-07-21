CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='obs_vm';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Observation view model  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Observation view model",
                is_active:2
                
            }
        );
        
        ht_dt => rout_cd_obesity.ht_dt.val.bind();
        ht_val => rout_cd_obesity.ht_val.val.bind();
        ht_err => rout_cd_obesity.ht_err.val.bind();
        wt_dt => rout_cd_obesity.wt_dt.val.bind();
        wt_val => rout_cd_obesity.wt_val.val.bind();
        wt_err => rout_cd_obesity.wt_err.val.bind();
        bmi_val => rout_cd_obesity.bmi.val.bind();
        sbp_val => rout_cd_htn_bp_control.sbp_val.val.bind();
        sbp_dt => rout_cd_htn_bp_control.sbp_dt.val.bind();
        dbp_val => rout_cd_htn_bp_control.dbp_val.val.bind();
        dbp_dt => rout_cd_htn_bp_control.dbp_dt.val.bind();
        sbp_mu_1 => rout_cd_htn_bp_control.sbp_mu_1.val.bind();
        dbp_mu_1 => rout_cd_htn_bp_control.dbp_mu_1.val.bind();
        sbp_max_1 => rout_cd_htn_bp_control.sbp_max_1.val.bind();
        sbp_min_1 => rout_cd_htn_bp_control.sbp_min_1.val.bind();
        dbp_max_1 => rout_cd_htn_bp_control.dbp_max_1.val.bind();
        dbp_min_1 => rout_cd_htn_bp_control.dbp_min_1.val.bind();
        obs_vm : {coalesce(sbp_dt, wt_dt)!? => 1},{=>0};

    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
    
      
END;







