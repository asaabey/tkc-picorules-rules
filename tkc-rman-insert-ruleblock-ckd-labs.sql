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
                description: "Rule block to gather lab tests"
                
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
       
       uacr_min => eadv.lab_ua_acr.val.minldv().where(dt>sysdate-730);
       uacr_max => eadv.lab_ua_acr.val.maxldv().where(dt>sysdate-730);
       
      
       sodium1 => eadv.lab_bld_sodium.val.lastdv().where(dt>sysdate-730);
       sodium2 => eadv.lab_bld_sodium.val.lastdv(1).where(dt>sysdate-730);
       sodium3 => eadv.lab_bld_sodium.val.lastdv(2).where(dt>sysdate-730);
       
       sodium_min => eadv.lab_bld_sodium.val.minldv().where(dt>sysdate-730);
       sodium_max => eadv.lab_bld_sodium.val.maxldv().where(dt>sysdate-730);
       
       sodium_ref_u : {1=1 =>140};
       sodium_ref_l : {1=1 =>130};
       sodium_mu : {1=1 => (sodium_ref_u + sodium_ref_l)/2};
       
       sodium1_x : { 1=1 => round(( 200/sodium_mu) * sodium1_val,0)};
       sodium2_x : { 1=1 => round(( 200/sodium_mu) * sodium2_val,0)};
       
       sodium_min_x : { 1=1 => round(( 200/sodium_mu) * sodium_min_val,0)};
       sodium_max_x : { 1=1 => round(( 200/sodium_mu) * sodium_max_val,0)};
       
       potassium1 => eadv.lab_bld_potassium.val.lastdv().where(dt>sysdate-730);
       potassium2 => eadv.lab_bld_potassium.val.lastdv(1).where(dt>sysdate-730);
       potassium3 => eadv.lab_bld_potassium.val.lastdv(2).where(dt>sysdate-730);
       
       potassium_min => eadv.lab_bld_potassium.val.minldv().where(dt>sysdate-730);
       potassium_max => eadv.lab_bld_potassium.val.maxldv().where(dt>sysdate-730);
       
       potassium_ref_u : {1=1 =>5.5};
       potassium_ref_l : {1=1 =>3.5};
       potassium_mu : {1=1 => (potassium_ref_u + potassium_ref_l)/2};
       
       potassium1_x : { 1=1 => round(( 200/potassium_mu) * potassium1_val,0)};
       potassium2_x : { 1=1 => round(( 200/potassium_mu) * potassium2_val,0)};
       
       potassium_min_x : { 1=1 => round(( 200/potassium_mu) * potassium_min_val,0)};
       potassium_max_x : { 1=1 => round(( 200/potassium_mu) * potassium_max_val,0)};
       
       bicarb1 => eadv.lab_bld_bicarbonate.val.lastdv().where(dt>sysdate-730);
       bicarb2 => eadv.lab_bld_bicarbonate.val.lastdv(1).where(dt>sysdate-730);
       bicarb3 => eadv.lab_bld_bicarbonate.val.lastdv(2).where(dt>sysdate-730);
       
       bicarb_min => eadv.lab_bld_bicarbonate.val.minldv().where(dt>sysdate-730);
       bicarb_max => eadv.lab_bld_bicarbonate.val.maxldv().where(dt>sysdate-730);
       
       calcium1 => eadv.lab_bld_calcium.val.lastdv().where(dt>sysdate-730);
       calcium2 => eadv.lab_bld_calcium.val.lastdv(1).where(dt>sysdate-730);
       calcium3 => eadv.lab_bld_calcium.val.lastdv(2).where(dt>sysdate-730);
       
       calcium_min => eadv.lab_bld_calcium.val.minldv().where(dt>sysdate-730);
       calcium_max => eadv.lab_bld_calcium.val.maxldv().where(dt>sysdate-730);

       phos1 => eadv.lab_bld_phosphate.val.lastdv().where(dt>sysdate-730);
       phos2 => eadv.lab_bld_phosphate.val.lastdv(1).where(dt>sysdate-730);
       phos3 => eadv.lab_bld_phosphate.val.lastdv(2).where(dt>sysdate-730);
       
       phos_min => eadv.lab_bld_phosphate.val.minldv().where(dt>sysdate-730);
       phos_max => eadv.lab_bld_phosphate.val.maxldv().where(dt>sysdate-730);
       
       hb1 => eadv.lab_bld_hb.val.lastdv().where(dt>sysdate-730);
       hb2 => eadv.lab_bld_hb.val.lastdv(1).where(dt>sysdate-730);
       hb3 => eadv.lab_bld_hb.val.lastdv(2).where(dt>sysdate-730);
       
       hb_min => eadv.lab_bld_hb.val.minldv().where(dt>sysdate-730);
       hb_max => eadv.lab_bld_hb.val.maxldv().where(dt>sysdate-730);
       
       
       ferritin1 => eadv.lab_bld_ferritin.val.lastdv().where(dt>sysdate-730);
       ferritin2 => eadv.lab_bld_ferritin.val.lastdv(1).where(dt>sysdate-730);
       ferritin3 => eadv.lab_bld_ferritin.val.lastdv(2).where(dt>sysdate-730);
       
       ferritin_min => eadv.lab_bld_phosphate.val.minldv().where(dt>sysdate-730);
       ferritin_max => eadv.lab_bld_phosphate.val.maxldv().where(dt>sysdate-730);

       ckd_labs : {nvl(egfr1_val,0)>0 and nvl(egfr2_val,0)>0 => 1 },{=>0};
       
       
     
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
END;





