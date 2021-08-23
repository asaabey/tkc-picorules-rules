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
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests",
                is_active:2,
                
            }
        );

       rrt => rout_rrt.rrt.val.bind();
       
       loc_1s => rout_rrt_hd_location.loc_1s.val.bind();
       
       loc_1s_txt : {loc_1s = 710100010132 => `CA-GAP`}, 
                    {loc_1s = 720600013032 => `TEHS-NRU`},
                    {loc_1s = 710100010122 => `CA-FD`},
                    {loc_1s = 710500012022 => `CA-TCH`},
                    {loc_1s = 720600015062 => `TEHS-7AD`},
                    {loc_1s = 720900016042  or loc_1s = 720900016052 => `TEHS-KDH`},
                    {loc_1s = 720600005012 => `TEHS-PDU`},
                    {loc_1s = 721200017012 => `TEHS-TIW`},
                    {loc_1s in (710111460001,710111460051,710410202051)=>`CA-OTHER`},
                    {loc_1s in (720600014022,720600013012)=>`TEHS-OTHER`},
                    {=>`UNDETERMINED`}
                    ;
       
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
       
       pth1_dt =>rout_ckd_shpt.pth1_val.dt.bind();
       
       hb1_val => rout_ckd_anaemia.hb_val.val.bind();
       
       hb1_dt => rout_ckd_anaemia.hb_dt.val.bind();
       
       plt1_val => rout_ckd_anaemia.plt1_val.val.bind();
       
       fer1_val => rout_ckd_anaemia.fer_val.val.bind();
       
       tsat1_val => rout_ckd_anaemia.tsat1_val.val.bind();
       
       
       av_plasty_ld => rout_rrt_hd_acc_iv.av_plasty_ld.val.bind();
       
       hours => rout_rrt_hd_param.hours_val.val.bind();
       
       /*  mode => rout_rrt_hd_param.mode_val.val.bind();*/
       
       
       urr => rout_rrt_hd_adequacy.urr_1.val.bind();
       
       spktv => rout_rrt_hd_adequacy.spktv.val.bind();
       
       hd_clinic_ld => rout_rrt_journey.hd_clinic_ld.val.bind();
       
       
       
       
       [[rb_id]] : {rrt=1 => 1},{=>0};
       
       #define_attribute(loc_1s_txt,{
                label:"Dialysis panel satellite facility location",
                is_reportable:1,
                type:3
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
                type:2
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
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
        
     
END;





