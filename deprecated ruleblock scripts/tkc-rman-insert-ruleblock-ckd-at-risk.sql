CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
  
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='at_risk';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess at risk population for CKD */
        
        #define_ruleblock(at_risk,
            {
                description: "Ruleblock to assess at_risk",
                is_active:2
                
            }
        );
        
        #doc(,
                {
                    txt: "Risk factor assessment for CKD",
                    cite: "at_risk_ckd_ref1, at_risk_ckd_ref2, at_risk_ckd_ref3"
                }
            );
        
        ld => eadv.[icd_%,icpc_%,lab_%,rxnc_%,obs_%,mbs_%].dt.max();
        
        is_active : { ld > sysdate-730 =>1 },{=>0};
        
        ckd => rout_ckd.ckd.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        dm => rout_cd_dm_dx.dm.val.bind();
        
        htn => rout_cd_htn.cd_htn.val.bind();
        
        cad => rout_cd_cardiac_cad.cad.val.bind();
        cva => rout_cd_cardiac_cad.cva.val.bind();
        pvd => rout_cd_cardiac_cad.pvd.val.bind();
        
        aki_stage => rout_tg4100.akin_stage.val.bind();
        
        cr_max_ld => rout_tg4100.cr_max_ld_1y.val.bind();
        
        cvd : { greatest(cad,cva,pvd)>0 =>1},{=>0};
        
        obesity => rout_cd_obesity.cd_obesity.val.bind();
        
        rhd => rout_cd_cardiac_rhd.cd_cardiac_rhd.val.bind();
        
        hepb => rout_cd_hepb_master.chb_flag.val.bind();
        
        
        aki_icd_ld => eadv.[icd_n17%].dt.max();
        
        
        
        
        aki : {aki_icd_ld!? or aki_stage>0 =>1},{=>0};
        
        aki_ld : { coalesce(aki_icd_ld, cr_max_ld)!? => least_date(aki_icd_ld, cr_max_ld)};
        
        smoker => eadv.status_smoking_h2_v1.val.last().where(val>=29);
        
        
        dod => rout_dmg.dod.val.bind();
    
        #doc(,
            {
                txt:"Check if active"
            }
        );
       
        
        
        /* obs_ld => eadv.[obs%].dt.max().where(dt > sysdate-730);*/
        
        is_active_2y : {is_active=1 and dod? => 1},{=>0};
              
        
        
        #doc(,{
                txt:"Determine at risk for CKD, and active cohort"
        });
        
        risk_sum : { . => dm + htn + cvd + obesity + aki + rhd + hepb  },{=>0};
            
        at_risk : {ckd=0 and rrt=0 and risk_sum>0 =>1},{=>0};
        
        active : {. => is_active_2y};
        
        
        
        tkc_cohort : { greatest(ckd,rrt,at_risk)>0 and active=1 =>1},{=>0};
        
        #doc(,{
                txt:"Determine tkc category"
        });
        
        
        tkc_cat : { ckd>0 or rrt>0 => 1 },{ at_risk=1 => 2},{ => 3};
        
        tkc_cat2_lbl : {at_risk = 1 => `At risk`},
                       {ckd = 1 => `CKD stage 1`},
                       {ckd = 2 => `CKD stage 2`},
                       {ckd = 3 => `CKD stage 3a`},
                       {ckd = 4 => `CKD stage 3b`},
                       {ckd = 5 => `CKD stage 4`},
                       {ckd = 6 => `CKD stage 5`},
                       {rrt = 1 => `Haemodialysis`},
                       {rrt = 2 => `Peritoneal dialysis`},
                       {rrt = 3 => `Transplant`},
                       {rrt = 4 => `Home haemodialysis`},
                       {=> `Undefined`};
        
        #doc(,{
                txt:"Determine if renal screened"
        });
        
        egfr_ld => eadv.lab_bld_egfr.dt.max().where(dt > sysdate-365);
        
        acr_ld => eadv.lab_ua_acr.dt.max().where(dt > sysdate-365);
        
        bp_ld => eadv.obs_bp_systolic.dt.max().where(dt > sysdate-365);
        
        last_bp_val => eadv.obs_bp_systolic.val.last().where(dt > sysdate-365);
        
        hba1c_ld => eadv.lab_bld_hba1c_ngsp.dt.max().where(dt > sysdate-365);
        
        last_hba1c_val => eadv.lab_bld_hba1c_ngsp.val.last().where(dt > sysdate-365);
 
        screen_egfr : { egfr_ld!? =>1},{=>0};
        
        screen_acr : { acr_ld!? =>1},{=>0};
        
        screen_bp : { bp_ld!? =>1},{=>0};
        
        screen_hba1c : { hba1c_ld!? =>1},{=>0};
        
        screen_3 : { . => screen_egfr + screen_acr + screen_bp};
        
        screen_4 : { . => screen_egfr + screen_acr + screen_bp + screen_hba1c};
        
        #define_attribute(at_risk,{
                    label:"At risk for CKD",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:1001
        });
        
        #define_attribute(ckd,{
                    label:"Presence of CKD",
                    is_bi_obj:1,
                    type:2
        });
        
        #define_attribute(rrt,{
                    label:"Presence of RRT",
                    is_bi_obj:1,
                    type:2
        });
        
        #define_attribute(dm,{
                    label:"Presence of Diabetes",
                    is_bi_obj:1,
                    type:1001
        });
        
        
        #define_attribute(htn,{
                    label:"Presence of Hypertension",
                    is_bi_obj:1,
                    type:1001
        });
        
        #define_attribute(cvd,{
                    label:"Presence of Cardiovascular disease",
                    is_bi_obj:1,
                    type:1001
        });
        
        
        #define_attribute(obesity,{
                    label:"Presence of Obesity",
                    is_bi_obj:1,
                    type:1001
        });
        
        #define_attribute(aki,{
                    label:"Presence of AKI",
                    is_bi_obj:1,
                    type:1001
        });
        
        
        #define_attribute(tkc_cohort,{
                    label:"TKC cohort",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
        });
        
        #define_attribute(tkc_cat,{
                    label:"TKC category",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
        });
        
        #define_attribute(
            active,
                {
                    label:"Is Active within last 2y",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
                }
        );
        #define_attribute(
            smoker,
                {
                    label:"Prevalent smoker",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
                }
        );
        
        #define_attribute(
            screen_egfr,
                {
                    label:"Screened by egfr within last 1y",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
                }
        );
        
        #define_attribute(
            screen_acr,
                {
                    label:"Screened by uACR within last 1y",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
                }
        );
        
        #define_attribute(
            screen_bp,
                {
                    label:"Screened by blood pressure within last 1y",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:1001
                }
        );
        
        #define_attribute(
            screen_hba1c,
                {
                    label:"Screened by HbA1c within last 1y",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
                }
        );
        
        #define_attribute(
            screen_3,
                {
                    label:"Screened by blood pressure uACR and eGFR within last 1y as per recommendations",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:2
                }
        );
        
        #define_attribute(tkc_cat2_lbl,{
                label: "TKC Category 2 label",
                is_reportable:1,
                is_bi_obj:1,
                type:1
        });
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
    
    
   
END;





