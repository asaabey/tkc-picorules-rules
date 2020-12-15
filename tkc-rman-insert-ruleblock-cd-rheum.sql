CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_rheum_sle';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify SLE e-phenotype  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify SLE e-phenotype",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_m32_%].dt.min();
        
        icpc_fd => eadv.[icpc_l99056,icpc_l99065].dt.min();
        
        
        
        rxn_l04ax => eadv.[rxnc_l04ax].dt.min().where(val=1);
        
        rxn_p01ba => eadv.[rxnc_p01ba].dt.min().where(val=1);
        
        sle_fd : { .=> least_date(icd_fd,icpc_fd)};
        
        [[rb_id]] : { sle_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of SLE",
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
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_rheum_ra';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to identify Rheumatoid Arthritis  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to identify Rheumatoid Arthritis",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_m05%].dt.min();
        
        icpc_fd => eadv.[icpc_l88004].dt.min();
        
        
        
        rxn_l04ax => eadv.[rxnc_l04ax].dt.min().where(val=1);
        
        rxn_p01ba => eadv.[rxnc_p01ba].dt.min().where(val=1);
        
        rxn_a07ec => eadv.[rxnc_a07ec].dt.min().where(val=1);
        
        op_enc_ld => eadv.[enc_op_med_rhe].dt.max();
        
        ra_fd : { .=> least_date(icd_fd,icpc_fd)};
        
        [[rb_id]] : { ra_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of Rheumatoid arthritis",
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
    
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_rheum_aps';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to identify Antiphosphlipid syndrome  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to identify Antiphosphlipid syndrome",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_d68_61%].dt.min();
        
        icpc_fd => eadv.[icpc_b83021].dt.min();

        rxn_anticoag_dt => rout_cd_cardiac_rx.rxn_anticoag.val.bind();
        
        op_enc_ld => eadv.[enc_op_med_rhe].dt.max();
        
        aps_fd : { .=> least_date(icd_fd,icpc_fd)};
        
        [[rb_id]] : { aps_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of Antiphosphlipid syndrome",
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







