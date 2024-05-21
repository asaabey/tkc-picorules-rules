CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
  
    
    
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_vm';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographic view model */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess demographic view model",
                is_active:2
                
            }
        );
        
        
        
        loc_def => rout_dmg_loc.loc_def.val.bind();
        
        loc_mode_n => rout_dmg_loc.loc_mode_n.val.bind();
        
        loc_n => rout_dmg_loc.loc_n.val.bind();
        
        mode_pct => rout_dmg_loc.mode_pct.val.bind();
        
        hrn => rout_dmg_hrn.hrn_last.val.bind();
        

        pcis_n => rout_dmg_source.pcis_n.val.bind();
        
        pcis_ld => rout_dmg_source.pcis_ld.val.bind();
        
        eacs_n => rout_dmg_source.eacs_n.val.bind();
        
        eacs_ld => rout_dmg_source.eacs_ld.val.bind();
        
        laynhapuy_n => rout_dmg_source.laynhapuy_n.val.bind();
        
        laynhapuy_ld => rout_dmg_source.laynhapuy_ld.val.bind();
        
        miwatj_n => rout_dmg_source.miwatj_n.val.bind();
        
        miwatj_ld => rout_dmg_source.miwatj_ld.val.bind();
        
        anyinginyi_n => rout_dmg_source.anyinginyi_n.val.bind();
        
        anyinginyi_ld => rout_dmg_source.anyinginyi_ld.val.bind();
        
        congress_n => rout_dmg_source.congress_n.val.bind();
        
        congress_ld => rout_dmg_source.congress_ld.val.bind();
        
        wurli_n => rout_dmg_source.wurli_n.val.bind();
        
        wurli_ld => rout_dmg_source.wurli_ld.val.bind();
        
        kwhb_n => rout_dmg_source.kwhb_n.val.bind();
        
        kwhb_ld => rout_dmg_source.kwhb_ld.val.bind();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        tkc_provider => rout_dmg_source.tkc_provider.val.bind();
        
        ipa_sep_ld => rout_ipa_sep.icd_ld.val.bind();
        
        ipa_sep_fd => rout_ipa_sep.icd_fd.val.bind();
        
        ipa_sep_n => rout_ipa_sep.icd_n.val.bind();
        
        opa_sep_ld => rout_opa_sep.op_ld.val.bind();
        
        opa_sep_fd => rout_opa_sep.op_fd.val.bind();
        
        opa_sep_n => rout_opa_sep.op_n.val.bind();
        
        icu_fd => rout_ipa_icu.icu_fd.val.bind();
        
        icu_ld => rout_ipa_icu.icu_ld.val.bind();
        
        preg_ld => rout_pregnancy.preg_ld.val.bind();
        
        preg_1y_f => rout_pregnancy.preg_1y_f.val.bind();
        
        [[rb_id]] : { .=> dmg_source};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Demographic phc source",
                type:2,
                is_reportable:1
            }
        );
        
        
        #define_attribute(
            phc_pcis,
            {
                label:"Demographic phc source Pcis",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_miwatj,
            {
                label:"Demographic phc source Miwatj",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_congress,
            {
                label:"Demographic phc source Congress",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_congress_mutitjulu,
            {
                label:"Demographic phc source Congress Mutitjulu",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_wurli,
            {
                label:"Demographic phc source Wurli",
                type:2,
                is_reportable:1
            }
        );
        

        #define_attribute(
            loc_def,
            {
                label:"Default locality",
                type:1002,
                is_reportable:1
            }
        );
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        
    
           
END;





