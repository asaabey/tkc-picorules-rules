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
        
        avf => rout_ckd_access.avf.val.bind();
        
        avf_dt => rout_ckd_access.avf_dt.val.bind();
        
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
        
        dm => rout_cd_dm_dx.cd_dm_dx.val.bind();
        
        hba1c_lv => rout_cd_dm_glyc_cntrl.hba1c_n0_val.val.bind();
        
        hba1c_ld => rout_cd_dm_glyc_cntrl.hba1c_n0_dt.val.bind();
        
        hba1c_stmt => rout_cd_dm_glyc_cntrl.hba1c_stmt.val.bind();
        
        review_int  : {rrt>0 =>3},{ ckd_stage_val>4 => 3},{ckd_stage_val>2 =>6},{=>12};
        
        edu_init => rout_ckd_journey.edu_init.val.bind();
        
        edu_rv => rout_ckd_journey.edu_rv.val.bind();
        
        cp_ckd_val => rout_ckd_careplan.cp_ckd_val.val.bind();
        
        cp_ckd_ld => rout_ckd_careplan.cp_ckd_ld.val.bind();
        
        hb_lv => rout_ckd_complications.hb_val.val.bind();
        
        hb_ld => rout_ckd_complications.hb_dt.val.bind();
        
        esa_ld => rout_ckd_complications.esa_dt.val.bind();
        
        ipa_sep_ld => rout_ipa_sep.icd_ld.val.bind();
        
        opa_sep_ld => rout_opa_sep.op_ld.val.bind();
        
        #define_attribute(ckd_stage,{label:"CKD CKD stage",is_reportable:1,type:1});
        #define_attribute(ipa_sep_ld,{label:"CKD ipa_sep_ld",is_reportable:1,type:12});
        #define_attribute(opa_sep_ld,{label:"CKD opa_sep_ld",is_reportable:1,type:12});
        #define_attribute(creat1_val,{label:"CKD Creatinine",is_reportable:1,type:2});
        #define_attribute(egfr1_val,{label:"CKD eGFR",is_reportable:1,type:2});
        #define_attribute(egfr1_dt,{label:"CKD eGFR date",is_reportable:1,type:12});
        #define_attribute(uacr1_val,{label:"CKD uACR",is_reportable:1,type:2});
        #define_attribute(uacr1_dt,{label:"CKD uACR date",is_reportable:1,type:12});
        #define_attribute(avf,{label:"CKD AVF present",is_reportable:1,type:2});
        #define_attribute(avf_dt,{label:"CKD AVF formation date",is_reportable:1,type:12});
        #define_attribute(cp_ckd_val,{label:"CKD Careplan",is_reportable:1,type:2});
        #define_attribute(cp_ckd_ld,{label:"CKD Careplan date",is_reportable:1,type:12});
        #define_attribute(hb_lv,{label:"CKD Haemoglobin",is_reportable:1,type:2});
        #define_attribute(hb_ld,{label:"CKD Haemoglobin date",is_reportable:1,type:12});
        #define_attribute(esa_ld,{label:"CKD Anaemia ESA date",is_reportable:1,type:12});
        #define_attribute(sbp_mu_1,{label:"CKD Blood pressure mean",is_reportable:1,type:2});
        #define_attribute(dm,{label:"CKD Diabetes Present",is_reportable:1,type:2});
        #define_attribute(hba1c_ld,{label:"CKD Diabetes HbA1c date",is_reportable:1,type:12});
        #define_attribute(hba1c_lv,{label:"CKD Diabetes HbA1c",is_reportable:1,type:2});
        #define_attribute(edu_init,{label:"CKD CKD Education Initial",is_reportable:1,type:12});
        #define_attribute(edu_rv,{label:"CKD CKD Education Review",is_reportable:1,type:12});
        
        [[rb_id]] : { ckd>0 => 1};    
        
       
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        
    
           
END;





