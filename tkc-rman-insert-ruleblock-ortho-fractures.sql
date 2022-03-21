CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ortho_fractures';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Identify fractures phenotypes */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Identify fracture phenotypes",
                is_active:2
                
            }
        );
        
        pelvic_frac_ld => eadv.[icd_s32_1].dt.last();
        
        pelvic_frac : {pelvic_frac_ld!? => 1},{=>0};
        
        [[rb_id]] : { coalesce(pelvic_frac,0)>0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of fracture",
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







