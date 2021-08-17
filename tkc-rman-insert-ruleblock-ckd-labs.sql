CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
     
     
       -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_labs2';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests",
                is_active:2,
                
            }
        );


       egfr1 => eadv.lab_bld_egfr_c.val.lastdv().where(dt>sysdate-730);
       egfr2 => eadv.lab_bld_egfr_c.val.lastdv(1).where(dt>sysdate-730);
       egfr3 => eadv.lab_bld_egfr_c.val.lastdv(2).where(dt>sysdate-730);
       
       creat1 => eadv.lab_bld_creatinine.val.lastdv().where(dt>sysdate-730);
       creat2 => eadv.lab_bld_creatinine.val.lastdv(1).where(dt>sysdate-730);
       creat3 => eadv.lab_bld_creatinine.val.lastdv(2).where(dt>sysdate-730);
       
       uacr1 => eadv.lab_ua_acr.val.lastdv().where(dt>sysdate-730);
       uacr2 => eadv.lab_ua_acr.val.lastdv(1).where(dt>sysdate-730);
       uacr3 => eadv.lab_ua_acr.val.lastdv(2).where(dt>sysdate-730);
       
       
      
       sodium1 => eadv.lab_bld_sodium.val.lastdv().where(dt>sysdate-730);
       sodium2 => eadv.lab_bld_sodium.val.lastdv(1).where(dt>sysdate-730);
       sodium3 => eadv.lab_bld_sodium.val.lastdv(2).where(dt>sysdate-730);
       
       
       potassium1 => eadv.lab_bld_potassium.val.lastdv().where(dt>sysdate-730);
       potassium2 => eadv.lab_bld_potassium.val.lastdv(1).where(dt>sysdate-730);
       potassium3 => eadv.lab_bld_potassium.val.lastdv(2).where(dt>sysdate-730);
       
       
       bicarb1 => eadv.lab_bld_bicarbonate.val.lastdv().where(dt>sysdate-730);
       bicarb2 => eadv.lab_bld_bicarbonate.val.lastdv(1).where(dt>sysdate-730);
       bicarb3 => eadv.lab_bld_bicarbonate.val.lastdv(2).where(dt>sysdate-730);
       
       calcium1 => eadv.lab_bld_calcium.val.lastdv().where(dt>sysdate-730);
       calcium2 => eadv.lab_bld_calcium.val.lastdv(1).where(dt>sysdate-730);
       calcium3 => eadv.lab_bld_calcium.val.lastdv(2).where(dt>sysdate-730);
       
       phos1 => eadv.lab_bld_phosphate.val.lastdv().where(dt>sysdate-730);
       phos2 => eadv.lab_bld_phosphate.val.lastdv(1).where(dt>sysdate-730);
       phos3 => eadv.lab_bld_phosphate.val.lastdv(2).where(dt>sysdate-730);
       
       
       hb1 => eadv.lab_bld_hb.val.lastdv().where(dt>sysdate-730);
       hb2 => eadv.lab_bld_hb.val.lastdv(1).where(dt>sysdate-730);
       hb3 => eadv.lab_bld_hb.val.lastdv(2).where(dt>sysdate-730);

       
       
       
       ferritin1 => eadv.lab_bld_ferritin.val.lastdv().where(dt>sysdate-730);
       ferritin2 => eadv.lab_bld_ferritin.val.lastdv(1).where(dt>sysdate-730);
       ferritin3 => eadv.lab_bld_ferritin.val.lastdv(2).where(dt>sysdate-730);
       
       
       [[rb_id]] : {nvl(egfr1_val,0)>0 and nvl(egfr2_val,0)>0 => 1 },{=>0};
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    

       -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_labs_euc';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests",
                is_active:2,
                
            }
        );

       
       creat1 => eadv.lab_bld_creatinine.val.lastdv().where(dt>sysdate-730);
       creat2 => eadv.lab_bld_creatinine.val.lastdv(1).where(dt>sysdate-730);
       creat3 => eadv.lab_bld_creatinine.val.lastdv(2).where(dt>sysdate-730);
             
       sodium1 => eadv.lab_bld_sodium.val.lastdv().where(dt>sysdate-730);
       sodium2 => eadv.lab_bld_sodium.val.lastdv(1).where(dt>sysdate-730);
       sodium3 => eadv.lab_bld_sodium.val.lastdv(2).where(dt>sysdate-730);
       
       potassium1 => eadv.lab_bld_potassium.val.lastdv().where(dt>sysdate-730);
       potassium2 => eadv.lab_bld_potassium.val.lastdv(1).where(dt>sysdate-730);
       potassium3 => eadv.lab_bld_potassium.val.lastdv(2).where(dt>sysdate-730);
       
       bicarb1 => eadv.lab_bld_bicarbonate.val.lastdv().where(dt>sysdate-730);
       bicarb2 => eadv.lab_bld_bicarbonate.val.lastdv(1).where(dt>sysdate-730);
       bicarb3 => eadv.lab_bld_bicarbonate.val.lastdv(2).where(dt>sysdate-730);
       
       [[rb_id]] : {nvl(egfr1_val,0)>0 and nvl(egfr2_val,0)>0 => 1 },{=>0};
       
       
     
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
    
    
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_labs_haem';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests",
                is_active:2,
                
            }
        );

       hb1 => eadv.lab_bld_hb._.lastdv().where(dt>sysdate-730);
       hb2 => eadv.lab_bld_hb._.lastdv(1).where(dt>sysdate-730);
       hb3 => eadv.lab_bld_hb._.lastdv(2).where(dt>sysdate-730);

       plt1 => eadv.lab_bld_platelets._.lastdv().where(dt>sysdate-730);
        
       wcc_neut1 => eadv.lab_bld_wcc_neutrophils._.lastdv().where(dt>sysdate-730);
        
       wcc_eos1 => eadv.lab_bld_wcc_eosinophils._.lastdv().where(dt>sysdate-730);
       
       fer1 => eadv.lab_bld_ferritin._.lastdv().where(dt>sysdate-730);
        
       crp1 => eadv.lab_bld_crp._.lastdv().where(dt>sysdate-730);
        
       tsat1 => eadv.lab_bld_tsat._.lastdv().where(dt>sysdate-730);
       
             
       [[rb_id]] : {coalesce(hb1_val,0)>0 => 1 },{=>0};
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
END;





