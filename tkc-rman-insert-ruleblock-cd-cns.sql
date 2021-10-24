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
                is_active:2

                
            }
        );
        
        #doc(,
            {
                txt:"Mood disorders"
            }
        );
        
        code_md_dt => eadv.[icd_f3%,icpc_p76%].dt.min();
        
        rx_n06_dt => eadv.[rxnc_n06%].dt.max().where(val=1);
        
        md : {code_md_dt!? and rx_n06_dt!? =>1},{=>0};
        
        #doc(,
            {
                txt:"Dementia"
            }
        );
        
        code_dem_dt => eadv.[icd_f01%,icd_f02%,icd_f03%,icpc_p70004,icpc_p70003,icpc_p70011,icpc_p70009,icpc_p15004].dt.min();
                
        dem : {code_dem_dt!? =>1},{=>0};

        #doc(,
            {
                txt:"Schizophrenia"
            }
        );
        
        code_schiz_dt => eadv.[icd_f40%,icpc_p72%].dt.min();        
        
        rx_n05a_dt => eadv.[rxnc_n05a%].dt.max().where(val=1);
        
        schiz : {code_schiz_dt!? and rx_n05a_dt!? => 2},{rx_n05a_dt!? => 1},{=>0};
         
        #doc(,
            {
                txt:"Epilepsy"
            }
        );
        code_epil_dt => eadv.[icd_g40%,icpc_n88%].dt.min();
        
        /* 
        pregabalin captured as antiepileptic although correct , inapp
        rx_n03_dt => eadv.[rxnc_n03%].dt.max().where(val=1);
        */
        
        epil : {code_epil_dt!? => 1},{=>0};
        
        #doc(,
            {
                txt:"Parkinsons"
            }
        );
        
        code_pd_dt => eadv.[icpc_n87%].dt.min();
        
        rx_n04_dt => eadv.[rxnc_n04%].dt.max().where(val=1);
        
        
        pd : {code_pd_dt!? and rx_n04_dt!? => 1},{=>0};
        
        [[rb_id]] : { greatest(md,epil,pd,schiz)>0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of CNS disorder"
            }
        );
        
        #define_attribute(dem,
            { 
                label: "Presence of Dementia",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(epil,
            { 
                label: "Presence of Epilepsy",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(pd,
            { 
                label: "Presence of Parkinsons disease",
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







