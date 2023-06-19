CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
     
  

       -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_panel_vm';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to generate rrt panel view model */
        
        #define_ruleblock(rrt_panel_vm,
            {
                description: "Rule block to generate rrt panel view model",
                is_active:2,
                
            }
        );

       rrt => rout_rrt.rrt.val.bind();
       
       loc_1s_txt => rout_rrt_hd_location.loc_mode_1m_txt.val.bind();
       
       hd_recent_flag => rout_rrt.hd_recent_flag.val.bind();
             
       sodium1_val => rout_rrt_labs_euc.sodium1_val.val.bind();
       
       sodium1_dt => rout_rrt_labs_euc.sodium1_dt.val.bind();
       
       potassium1_val => rout_rrt_labs_euc.potassium1_val.val.bind();
       
       bicarb1_val => rout_rrt_labs_euc.bicarb1_val.val.bind();
       
       
       calcium1_val => rout_ckd_shpt.calcium1_val.val.bind();
       
       calcium1_dt => rout_ckd_shpt.calcium1_dt.val.bind();
       
       magnesium1_val => rout_ckd_shpt.magnesium1_val.val.bind();
    
       phosphate1_val => rout_ckd_shpt.phos1_val.val.bind();
    
       pth1_val =>rout_ckd_shpt.pth1_val.val.bind();
       
       pth1_dt =>rout_ckd_shpt.pth1_dt.val.bind();
       
       pth_qt =>rout_ckd_shpt.pth_qt.val.bind();
       
       hb1_val => rout_ckd_anaemia.hb_val.val.bind();
       
       hb1_dt => rout_ckd_anaemia.hb_dt.val.bind();
       
       hb_qt => rout_ckd_anaemia.hb2_1_qt.val.bind();
       
       plt1_val => rout_ckd_anaemia.plt1_val.val.bind();
       
       fer1_val => rout_ckd_anaemia.fer_val.val.bind();
       
       tsat1_val => rout_ckd_anaemia.tsat1_val.val.bind();
       
       acc_type => rout_rrt_hd_acc_iv.acc_type_val.val.bind();
       
       av_plasty_ld => rout_rrt_hd_acc_iv.av_plasty_ld.val.bind();
       
       hours => rout_rrt_hd_param.hours_val.val.bind();
       
       /*  mode => rout_rrt_hd_param.mode_val.val.bind();*/
       
       
       urr => rout_rrt_hd_adequacy.urr.val.bind();
       
       spktv => rout_rrt_hd_adequacy.spktv.val.bind();
       
       hd_oe => rout_rrt_1_metrics.hd_oe.val.bind();
       
       hd_years =>rout_rrt_1_metrics.tspan_y.val.bind();
       
       hd_hours => rout_rrt_hd_param.hours_val.val.bind();
       
       hd_ibw => rout_rrt_hd_param.ibw_val.val.bind();
       
       enc_ld => rout_rrt_hd_prog_vm.enc_ld.val.bind();
       
       ipa_sep_ld => rout_rrt_hd_prog_vm.ipa_sep_ld.val.bind();
       
       sbp_mu_1 => rout_cd_htn_bp_control.sbp_mu_1.val.bind();
       
       sbp_max => rout_cd_htn_bp_control.sbp_max.val.bind();
       
       dbp_mu_1 => rout_cd_htn_bp_control.dbp_mu_1.val.bind();
       
       rrt_panel_vm : {rrt in (1,4) => 1},{=>0};
       
       #define_attribute(loc_1s_txt,{
                label:"Dialysis panel satellite facility location",
                is_reportable:1,
                type:1
        });
       #define_attribute(hd_recent_flag,{
                label:"Dialysis panel Hd recency flag",
                is_reportable:1,
                type:2
       });
       
       #define_attribute(sodium1_val,{
                label:"Dialysis panel Labs sodium",
                is_reportable:1,
                type:2
       });
       #define_attribute(potassium1_val,{
                label:"Dialysis panel Labs potassium",
                is_reportable:1,
                type:2
       });
       #define_attribute(bicarb1_val,{
                label:"Dialysis panel Labs bicarb",
                is_reportable:1,
                type:2
       });
        
       #define_attribute(calcium1_val,{
                label:"Dialysis panel Labs calcium",
                is_reportable:1,
                type:2
       });
       #define_attribute(magnesium1_val,{
                label:"Dialysis panel Labs magnesium",
                is_reportable:1,
                type:2
        });
       #define_attribute(phosphate1_val,{
                label:"Dialysis panel Labs phosphate",
                is_reportable:1,
                type:2
       });
       #define_attribute(pth1_val,{
                label:"Dialysis panel Labs pth",
                is_reportable:1,
                type:2
       });
       #define_attribute(cinacalcet_ld,{
                label:"Dialysis panel Meds cinacalcet",
                is_reportable:1,
                type:2
       });
       #define_attribute(calcitriol_ld,{
                label:"Dialysis panel Meds calcitriol",
                is_reportable:1,
                type:2
       });
       #define_attribute(phos_bind_ld,{
                label:"Dialysis panel Meds phos_bind_ld",
                is_reportable:1,
                type:2
       });
       #define_attribute(hb1_val,{
                label:"Dialysis panel Labs Haemoglobin",
                is_reportable:1,
                type:2
       });
       #define_attribute(hb_qt,{
                label:"Dialysis panel Labs Haemoglobin change pct",
                is_reportable:1,
                type:2
       });
       #define_attribute(plt1_val,{
                label:"Dialysis panel Labs platelets",
                is_reportable:1,
                type:2
       });
       #define_attribute(fer1_val,{
                label:"Dialysis panel Labs ferritin",
                is_reportable:1,
                type:2
       });
       #define_attribute(tsat1_val,{
                label:"Dialysis panel Labs tsat",
                is_reportable:1,
                type:2
       });
       #define_attribute(av_plasty_ld,{
                label:"Dialysis panel AV plasty",
                is_reportable:1,
                type:12
        });
       
       #define_attribute(
            mode_hdf,{
                label:"Dialysis panel parameters mode",
                is_reportable:1,
                type:2
       });
        
       #define_attribute(hours,{
                label:"Dialysis panel parameters hours",
                is_reportable:1,
                type:2
       });
        #define_attribute(urr,{
                label:"Dialysis panel Labs URR",
                is_reportable:1,
                type:2
        });
        #define_attribute(spktv,{
                label:"Dialysis panel Labs spKTV",
                is_reportable:1,
                type:2
        });
        
        #define_attribute(hd_clinic_ld,{
                label:"Dialysis panel last hd clinic",
                is_reportable:1,
                type:2
        });
        #define_attribute(hd_years,{
                label:"Dialysis panel years on dialysis",
                is_reportable:1,
                type:2
        });
        #define_attribute(hd_oe,{
                label:"Dialysis panel attendence pct",
                is_reportable:1,
                type:2
        });
        #define_attribute(hd_hours,{
                label:"Dialysis panel prescription hours",
                is_reportable:1,
                type:2
        });
        #define_attribute(hd_ibw,{
                label:"Dialysis panel prescription IBW",
                is_reportable:1,
                type:2
        });
        #define_attribute(enc_ld,{
                label:"Dialysis panel last clinic",
                is_reportable:1,
                type:12
        });
        #define_attribute(ipa_sep_ld,{
                label:"Dialysis panel last hospitalization",
                is_reportable:1,
                type:12
        });
        #define_attribute(sbp_mu_1,{
                label:"Dialysis panel systolic bp mean",
                is_reportable:1,
                type:2
        });
        #define_attribute(sbp_max,{
                label:"Dialysis panel systolic bp max",
                is_reportable:1,
                type:2
        });
        #define_attribute(dbp_mu_1,{
                label:"Dialysis panel diastolic bp mean",
                is_reportable:1,
                type:2
        });
        #define_attribute(pth_qt,{
                label:"Dialysis panel pth change pct",
                is_reportable:1,
                type:2
        });
        #define_attribute(acc_type,{
                label:"Dialysis panel access type",
                is_reportable:1,
                type:2
        });
 
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
       
    
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='rrt_hd_prog_vm';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Assemble hd progress view model */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Assemble hd progress view model",
                is_active:2
                
            }
        );
                
        age => rout_dmg.age.val.bind();
        
        gender => rout_dmg.gender.val.bind();
        
        tkc_provider => rout_dmg_source.tkc_provider.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        enc_ld => rout_engmnt_renal.enc_ld.val.bind();      
                
        ipa_sep_ld => rout_ipa_sep.icd_ld.val.bind();
        
        opa_sep_ld => rout_opa_sep.op_ld.val.bind();
        
        ibw_val  => rout_rrt_hd_param.ibw_val.val.bind();
        
        ibw_dt  => rout_rrt_hd_param.ibw_dt.val.bind();
        
        sbp_mu_1 => rout_cd_htn_bp_control.sbp_mu_1.val.bind(); 
        
        dbp_mu_1 => rout_cd_htn_bp_control.dbp_mu_1.val.bind();
        
        sbp_max => rout_cd_htn_bp_control.sbp_max.val.bind(); 
        
        spktv => rout_rrt_hd_adequacy.spktv.val.bind();
        
        hours => rout_rrt_hd_param.hours_val.val.bind(); 
        
            
        

        
        [[rb_id]] : { rrt in (1,3) => 1};    
        
       
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        
     
END;





