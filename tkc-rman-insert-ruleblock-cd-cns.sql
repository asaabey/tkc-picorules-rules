CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cns';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify cns  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify cns",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        code_md_dt => eadv.[icd_f3%,icpc_p76%].dt.min();
        
        rx_n06_dt => eadv.[rxnc_n06%].dt.max().where(val=1);
        
        md : {code_md_dt!? and rx_n06_dt!? =>1},{=>0};

        code_schiz_dt => eadv.[icd_f40%,icpc_p72%].dt.min();        
        
        rx_n05a_dt => eadv.[rxnc_n05a%].dt.max().where(val=1);
        
        schiz : {code_schiz_dt!? and rx_n05a_dt!? => 2},{rx_n05a_dt!? => 1},{=>0};
         
        code_epil_dt => eadv.[icd_g40%,icpc_n88%].dt.min();
        
        rx_n03_dt => eadv.[rxnc_n03%].dt.max().where(val=1);
        
        epil : {code_epil_dt!? and rx_n03_dt!? => 1},{=>0};
        
        code_pd_dt => eadv.[icpc_n87%].dt.min();
        
        rx_n04_dt => eadv.[rxnc_n04%].dt.max().where(val=1);
        
        pd : {code_pd_dt!? and rx_n04_dt!? => 1},{=>0};
        
        [[rb_id]] : { greatest(md,epil,pd,schiz)>0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of CNS disorder"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







