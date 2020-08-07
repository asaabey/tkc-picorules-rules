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
                is_active:0
                
            }
        );

        egfr => eadv.lab_bld_egfr_c._.serializedv4(val,dt,5).where(dt>sysdate-(365*3));

        creat => eadv.lab_bld_creatinine._.serializedv4(val,dt,5).where(dt>sysdate-(365*3));        
            
        uacr => eadv.lab_ua_acr._.serializedv4(val,dt,5).where(dt>sysdate-(365*3));
              
        sodium => eadv.lab_bld_sodium._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
        
        potassium => eadv.lab_bld_potassium._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
       
        bicarb => eadv.lab_bld_bicarbonate._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
        
        calcium => eadv.lab_bld_calcium._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
        
        phos => eadv.lab_bld_phosphate._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
        
        hb => eadv.lab_bld_hb._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
        
        ferritin => eadv.lab_bld_ferritin._.serializedv3(val,dt,5).where(dt>sysdate-(365*3));
       
        [[rb_id]] : {. => 1 };
       
       
     
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_labs3';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests"
                
            }
        );

        egfr => eadv.lab_bld_egfr_c._.serializedv4(val,dt,5).where(dt>sysdate-(365*3));

        
        
        [[rb_id]] : { egfr!? =>1},{=>0};
        
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
END;





