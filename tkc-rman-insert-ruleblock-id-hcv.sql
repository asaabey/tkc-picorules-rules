CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='id_hcv';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to identify Chronic Hepatitis C  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to identify Chronic Hepatitis C",
                is_active:2
                
            }
        );
        
        icpc_code => eadv.[icpc_d72008].dt.min();
        
        icd_code => eadv.[icd_b18_2%].dt.min();
                
        [[rb_id]] : { coalesce(icpc_code,icd_code)!? => 1 },{=>0};
        
        #define_attribute([[rb_id]],
            {
                label: "Presence of Chronic Hepatitis C",
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







