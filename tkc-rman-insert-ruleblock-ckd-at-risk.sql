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
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess [[rb_id]]",                
                is_active:2
                
            }
        );
        
        #doc(,
                {
                    txt: "Risk factor assessment for CKD",
                    cite: "at_risk_ckd_ref1, at_risk_ckd_ref2, at_risk_ckd_ref3"
                }
            ); 
        
        
        
        ckd => rout_ckd.ckd.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        dm => rout_cd_dm_dx.dm.val.bind();
        
        htn => rout_cd_htn.cd_htn.val.bind();
        
        cad => rout_cd_cardiac_cad.cad.val.bind();
        cva => rout_cd_cardiac_cad.cva.val.bind();
        pvd => rout_cd_cardiac_cad.pvd.val.bind();
        
        cvd : { greatest(cad,cva,pvd)>0 =>1},{=>0};
        
        obesity => rout_cd_obesity.cd_obesity.val.bind();
        
        
        aki_fd => eadv.[icd_n17%].dt.min();
        
        aki : {aki_fd!? =>1},{=>0};
        
        smoker => eadv.status_smoking_h2_v1.val.last().where(val>=29);
        
        
        dod => rout_dmg.dod.val.bind();
    
        #doc(,
            {
                txt:"Check if active"
            }
        );
       
        
        
        obs_ld => eadv.[obs%].dt.max().where(dt > sysdate-730);
        
        is_active_2y : {obs_ld!? and dod? => 1},{=>0};
              
        
        
        #doc(,
            {
                txt:"Determine at risk for CKD, and active cohort"
            }
        );
        
            
        [[rb_id]] : {greatest(dm,htn,cvd,obesity,aki,smoker)>0   
                and ckd=0 
                and rrt=0 =>1},
                {=>0};
        
        active : {. => is_active_2y};
        
        
        
        tkc_cohort : { greatest(ckd,rrt,at_risk)>0 =>1},{=>0};
        
        
        #doc(,
            {
                txt:"Determine if renal screened"
            }
        );
        
        egfr_ld => eadv.lab_bld_egfr.dt.max().where(dt > sysdate-365);
        
        acr_ld => eadv.lab_ua_acr.dt.max().where(dt > sysdate-365);
        
        bp_ld => eadv.obs_bp_systolic.dt.max().where(dt > sysdate-365);
        
        screen_egfr : { egfr_ld!? =>1},{=>0};
        
        screen_acr : { acr_ld!? =>1},{=>0};
        
        screen_bp : { bp_ld!? =>1},{=>0};
        
        screen_3 : { . => screen_egfr + screen_acr + screen_bp};
        
        #define_attribute(
            [[rb_id]],
                {
                    label:"At risk for CKD",
                    is_reportable:1,
                    type:2
                }
        );
        
        #define_attribute(
            tkc_cohort,
                {
                    label:"TKC cohort",
                    is_reportable:1,
                    type:2
                }
        );
        #define_attribute(
            active,
                {
                    label:"Is Active within last 2y",
                    is_reportable:1,
                    type:2
                }
        );
        
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
   
END;





