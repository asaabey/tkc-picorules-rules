CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
  
    
    
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ckd_prog_vm';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Assemble CKD progress view model */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Assemble CKD progress view model",
                is_active:2
                
            }
        );
                
        age => rout_dmg.age.val.bind();
        
        gender => rout_dmg.gender.val.bind();
        
        tkc_provider => rout_dmg_source.tkc_provider.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        ckd_stage => rout_ckd.ckd_stage.val.bind();
        
        ckd_stage_val => rout_ckd.ckd_stage_val.val.bind();
        
        enc_ld => rout_engmnt_renal.enc_ld.val.bind();
        
        
                
        ipa_sep_ld => rout_ipa_sep.icd_ld.val.bind();
        
        opa_sep_ld => rout_opa_sep.op_ld.val.bind();
        
        creat1_val => rout_ckd_labs.creat1_val.val.bind();
        
        egfr1_val => rout_ckd_labs.egfr1_val.val.bind();
        
        egfr1_dt => rout_ckd_labs.egfr1_dt.val.bind();
        
        uacr1_val => rout_ckd_labs.uacr1_val.val.bind();
        
        uacr1_dt => rout_ckd_labs.uacr1_dt.val.bind();
        
        htn_rxn_acei => rout_cd_htn.htn_rxn_acei.val.bind();
        
        htn_rxn_arb => rout_cd_htn.htn_rxn_arb.val.bind();
        
        sbp_target_max => rout_cd_htn_bp_control.sbp_target_max.val.bind();
        
        dbp_target_max => rout_cd_htn_bp_control.dbp_target_max.val.bind();
        
        sbp_mu_1 => rout_cd_htn_bp_control.sbp_mu_1.val.bind(); 
        
        sbp_max => rout_cd_htn_bp_control.sbp_max.val.bind(); 
        
        dbp_mu_1 => rout_cd_htn_bp_control.dbp_mu_1.val.bind(); 
        
        review_int  : {rrt>0 =>3},{ ckd_stage_val>4 => 3},{ckd_stage_val>2 =>6},{=>12};
        
        
        
        [[rb_id]] : { ckd>0 => 1};    
        
       
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        
    
           
END;





