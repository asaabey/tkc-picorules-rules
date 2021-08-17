CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    
      
             -- BEGINNING OF RULEBLOCK --

    rb.blockid:='opa_sep';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess Outpatient activity*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Outpatient activity with exclusions",
                is_active:2
            }
        );
        
        
        
        op_ld => eadv.[enc_op_%].dt.last();
        
        op_n => eadv.[enc_op_%].dt.distinct_count();
        
        op_fd => eadv.[enc_op_%].dt.first();
        
        op_att => eadv.[enc_op_%].att.last();
        
        [[rb_id]] : { op_ld!? => 1 },{=>0};    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Inpatient activity",
                type:2,
                is_reportable:0
            }
        );
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
END;





