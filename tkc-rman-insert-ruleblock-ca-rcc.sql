CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ca_rcc';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify renal cell carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify renal cell carcinoma",
                is_active:2
                
            }
        );
        
        
        rcc_fd => rout_ckd_c_rnm.c_c64.val.bind();
                
        [[rb_id]] : { rcc_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of Renal cell carcinoma RCC",
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







