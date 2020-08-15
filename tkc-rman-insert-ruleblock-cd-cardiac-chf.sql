CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_chf';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  CHF  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a assess CHF",
                is_active:2
                
            }
        );
        
        #doc(,
                {
                    section:"CHF"
                }
            );
            
        chf_code => eadv.[icd_i50_%],icpc_k77%].dt.min();
            
        chf : {chf_code!? =>1},{=>0};
        
        [[rb_id]] : {chf=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "presence of CHF",
                type : 1001
                
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --

   
END;





