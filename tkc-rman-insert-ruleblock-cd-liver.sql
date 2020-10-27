CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cirrhosis';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify cirrhosis e-phenotype  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify cirrhosis e-phenotype",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_k74_%].dt.min();
        
        icpc_fd => eadv.[icpc_d97005].dt.min();
    
        code_fd : {.=> least_date(icd_fd,icpc_fd)};    
        
        
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of Cirrhosis",
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







