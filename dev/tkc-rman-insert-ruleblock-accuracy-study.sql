CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
    
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='acc_study';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a test algorithm",
                is_active:0
                
            }
        );
        
        cand => rout_core_info_entropy.is_study_cand1.val.bind();
        
        ckd => rout_ckd.ckd_stage_val.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        at_risk => rout_at_risk.at_risk.val.bind();
        
        
        
        
        [[rb_id]] : {. =>1};
        
        #define_attribute([[rb_id]],
            {
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







