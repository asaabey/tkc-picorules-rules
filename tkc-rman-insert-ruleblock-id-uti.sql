CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='id_uti';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify uti  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify uti",
                is_active:2
                
            }
        );
        
        uti_fd => eadv.[icd_n39%, icd_n30%,icpc_u71%].dt.min();
        
        uti_ld => eadv.[icd_n39%, icd_n30%,icpc_u71%].dt.max();
        
        uti_rec_icpc_ld => eadv.[icpc_u71015,icpc_u71014].dt.max();
        
        
        [[rb_id]] : { uti_ld -uti_fd >90 or uti_rec_icpc_ld!? => 1 },{=>0};
        
        #define_attribute([[rb_id]],
            {
                label: "Presence of recurrent uti",
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







