CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_pulm';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify pulmonary disease  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify pulmonary disease",
                is_active:2
                
            }
        );
        
        code_copd_dt => eadv.[icpc_r95%,icd_j44%].dt.max();
        
        rx_r03_dt => eadv.[rxnc_r03%].dt.max().where(val=1);
        
        copd : {code_copd_dt!? or rx_r03_dt!?=> 1},{=>0};
        
        [[rb_id]] : { greatest(copd)>0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            {
                label: "Presence of COPD"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







