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

       calcium1 => eadv.lab_bld_calcium._.lastdv().where(dt>sysdate-120);
       calcium2 => eadv.lab_bld_calcium._.lastdv(1).where(dt>sysdate-120);
       calcium3 => eadv.lab_bld_calcium._.lastdv(2).where(dt>sysdate-120);
       
       ca_n_30d => eadv.lab_bld_calcium.dt.count().where(dt>sysdate-30);
       
       phos1 => eadv.lab_bld_phosphate._.lastdv().where(dt>sysdate-120);
       phos2 => eadv.lab_bld_phosphate._.lastdv(1).where(dt>sysdate-120);
       phos3 => eadv.lab_bld_phosphate._.lastdv(2).where(dt>sysdate-120);

       pth1 => eadv.lab_bld_pth._.lastdv().where(dt>sysdate-120);
       pth2 => eadv.lab_bld_pth._.lastdv(1).where(dt>sysdate-120 and dt< pth1_dt-30);
       
       
       pth_qt: { coalesce(pth2_val,0)>0 and coalesce(pth1_val,0)>0 => round(pth1_val/pth2_val,2)};
       
       cinacalcet_ld => eadv.rxnc_hb05bx.dt.last().where(val=1);
       
       calcitriol_ld => eadv.rxnc_a11cc.dt.last().where(val=1);
       
       phos_bind_ld => eadv.rxnc_v03ae.dt.last().where(val=1);
    
      
       [[rb_id]] : { (rrt in(1,2,4) or ckd>4) and pth1_val!? => 1 },{=>0};
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_labs_cmp';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests",
                is_active:2,
                
            }
        );

       calcium1 => eadv.lab_bld_calcium.val.lastdv().where(dt>sysdate-730);
       calcium2 => eadv.lab_bld_calcium.val.lastdv(1).where(dt>sysdate-730);
       calcium3 => eadv.lab_bld_calcium.val.lastdv(2).where(dt>sysdate-730);
       
       phos1 => eadv.lab_bld_phosphate.val.lastdv().where(dt>sysdate-730);
       phos2 => eadv.lab_bld_phosphate.val.lastdv(1).where(dt>sysdate-730);
       phos3 => eadv.lab_bld_phosphate.val.lastdv(2).where(dt>sysdate-730);

       pth1 => eadv.lab_bld_pth.val.lastdv().where(dt>sysdate-730);
       pth2 => eadv.lab_bld_pth.val.lastdv(1).where(dt>sysdate-730);
       pth3 => eadv.lab_bld_pth.val.lastdv(2).where(dt>sysdate-730);
       
       
      
       [[rb_id]] : {coalesce(calcium1_val,0)>0 and coalesce(calcium2_val,0)>0 => 1 },{=>0};
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
END;





