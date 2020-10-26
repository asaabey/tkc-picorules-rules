CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_endo_hypothyroid';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify hypothyroidism  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify hypothyroidism",
                is_active:2
                
            }
        );
        
        cong_fd => eadv.[icd_e03_1,icpc_t86004].dt.min();
        
        rx_induced_fd => eadv.[icd_e03_2,icpc_t86008].dt.min();
        
        post_mx_fd => eadv.[icd_89%,icpc_t86005,icpc_t86006].dt.min();
        
        nos_fd => eadv.[icpc_t86009,icpc_t86003,icd_e03_5,icd_e03_8,icd_e03_9].dt.min();
        
        code_fd : { . => least_date(cong_fd,rx_induced_fd,post_mx_fd,nos_fd)};
        
        rx_h03aa_ld => eadv.[rxnc_h03aa].dt.max().where(val=1);
        
        [[rb_id]] : { coalesce(code_fd,rx_h03aa_ld)!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of hypothyroidism"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







