CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
     
     
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_shpt';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to assess for secondary hyperparathyroidism */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to assess for secondary hyperparathyroidism",
                is_active:2,
                
            }
        );
    
       ckd => rout_ckd.ckd_stage_val.val.bind();
       
       rrt => rout_rrt.rrt.val.bind();

       calcium1 => eadv.lab_bld_calcium_corrected._.lastdv().where(dt>sysdate-60);
       calcium2 => eadv.lab_bld_calcium_corrected._.lastdv(1).where(dt>sysdate-60);
       
       
       ca_n_30d => eadv.lab_bld_calcium_corrected.dt.count().where(dt>sysdate-30);
       
       magnesium1 => eadv.lab_bld_magnesium.val.lastdv().where(dt>sysdate-60);
       
       phos1 => eadv.lab_bld_phosphate._.lastdv().where(dt>sysdate-60);
       phos2 => eadv.lab_bld_phosphate._.lastdv(1).where(dt>sysdate-60);
       

       pth1 => eadv.lab_bld_pth._.lastdv().where(dt>sysdate-120);
       pth2 => eadv.lab_bld_pth._.lastdv(1).where(dt>sysdate-120 and dt< pth1_dt-30);
       
       
       pth_qt: { coalesce(pth2_val,0)>0 and coalesce(pth1_val,0)>0 => round(pth2_val - pth1_val/pth2_val,2)};
       
       cinacalcet_ld => eadv.rxnc_hb05bx.dt.last().where(val=1);
       
       
       calcitriol_ld => eadv.rxnc_a11cc.dt.last().where(val=1);
       
       phos_bind_ld => eadv.rxnc_v03ae.dt.last().where(val=1);
    
      
       [[rb_id]] : { (rrt in(1,2,4) or ckd>4) and pth1_val!? => 1 },{=>0};
       
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
        #define_attribute(phos1_val,{
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
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
END;





