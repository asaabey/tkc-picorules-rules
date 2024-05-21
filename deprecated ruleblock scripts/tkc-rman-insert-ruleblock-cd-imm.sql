CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_imm_vasculitis';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify vasculitic phenotypes  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify vasculitic phenotypes",
                is_active:2
                
            }
        );
        
        gpa_fd => eadv.[icd_m31_3].dt.min();
        
        gca_fd => eadv.[icd_m31_5,icd_m31_6].dt.min();
        
        mpo_fd => eadv.[icd_m31_7].dt.min();
        
        tak_fd => eadv.[icd_m31_4].dt.min();
                
        
        rxn_l01xc => eadv.[rxnc_l01xc].dt.min();
        
        rxn_h02ab => eadv.[rxnc_h02ab].dt.max().where(val=1);
        
       
        
        [[rb_id]] : { coalesce(gpa_fd,gca_fd,mpo_fd,tak_fd)!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            {
                label: "Presence of vasculitis",
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







