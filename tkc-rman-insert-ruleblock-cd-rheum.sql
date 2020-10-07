CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_rheum_sle';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify SLE e-phenotype  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify SLE e-phenotype",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_m32_%].dt.min();
        
        icpc_fd => eadv.[icpc_l99056,icpc_l99065].dt.min();
        
        rxn_l04ax => eadv.[rxnc_l04ax].dt.min().where(val=1);
        
        rxn_p01ba => eadv.[rxnc_p01ba].dt.min().where(val=1);
        
        sle_fd : { .=> least_date(icd_fd,icpc_fd)};
        
        [[rb_id]] : { coalesce(icd_fd,icpc_fd)!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of SLE",
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







