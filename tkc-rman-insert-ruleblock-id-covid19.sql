CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='id_covid19';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  algorithm to identify covid19  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify covid19",
                is_active:2
                
            }
        );
        
        covid19_icpc => eadv.[icpc_r83015].dt.last();
                        
        [[rb_id]] : { covid19_icpc!? => 1 },{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of covid19 infection",
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







