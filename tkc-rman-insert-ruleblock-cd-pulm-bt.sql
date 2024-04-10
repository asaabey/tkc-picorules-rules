CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_pulm_bt';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to identify bronchiectasis  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to identify bronchiectasis",
                is_active:2
                
            }
        );
        
        bt_fd => eadv.[icd_j47%, icpc_r99018].dt.min();
        
        cd_pulm_bt : { bt_fd!? =>1},{=>0};
        
        #define_attribute(cd_pulm_bt,
            {
                label: "Presence of Bronchiectasis"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







