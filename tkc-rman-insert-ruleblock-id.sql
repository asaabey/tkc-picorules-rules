CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='id_sti';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify soft tissue infection  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify soft tissue infection",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_l0%].dt.min();
        
        icd_ld => eadv.[icd_l0%].dt.max();
        
        icd_n => eadv.[icd_l0%].dt.count();
        
        icpc_ld => eadv.[icpc_s10%,icpc_76%].dt.max();
        
        code_ld : { . => greatest_date(icd_ld,icpc_ld)};
        
        gap : { icd_fd!? => round((icd_ld-icd_fd)/365,1)};
        
        multi : { coalesce(icd_n,0)>1 and coalesce(gap,0)>1 =>1},{=>0};
        
        [[rb_id]] : { code_ld!? and multi=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of recurrent soft tissue infection",
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







