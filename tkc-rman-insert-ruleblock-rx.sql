CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb RMAN_RULEBLOCKS%ROWTYPE;


BEGIN


    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_desc';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
    
        /* Algorithm to assess Medication  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to serialize active medications",
                    
                    is_active:2
                    
                }
            );
            
            
            rxn_0 => eadv.[rxnc_%].dt.count().where(val=1);
            
            rx_name_obj => eadv.rx_desc.val.serialize2();
            
            rx_n => eadv.rx_desc.val.count(0);
            
            [[rb_id]] : {rx_n>0 =>1},{=>0};
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_desc_ptr';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
    
        /* Algorithm to assess Medication  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to serialize active medications",
                    
                    is_active:2
                    
                }
            );
            
            
            
            
            rx_name_obj => eadv.rx_desc_ptr.val.serialize2();
            
            rx_n => eadv.rx_desc_ptr.val.count();
            
            [[rb_id]] : {coalesce(rx_n,0)>0 =>1},{=>0};
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --


END;





