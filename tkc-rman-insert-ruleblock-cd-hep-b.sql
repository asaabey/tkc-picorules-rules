CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   

    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_hepb';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a test algorithm",
                is_active:0
                
            }
        );
        
        hepb_vac => eadv.icpc_d72j97.dt.min();
        
        hepb_imm => eadv.icpc_d72j99.dt.min();
        
        
        
        [[rb_id]] : {1=1 =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







