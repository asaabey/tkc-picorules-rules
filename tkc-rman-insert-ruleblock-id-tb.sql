CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='id_tb';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify Tuberculosis  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify Tuberculosis",
                is_active:2
                
            }
        );
        
        tb_code => eadv.[icpc_a700%,icd_m49%,icd_j65].dt.min();
        
        ltb_code => eadv.[icpc_a70j99].dt.min();
                
        [[rb_id]] : { coalesce(tb_code,ltb_code)!? => 1 },{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of tuberculosis",
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







