CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;

BEGIN
     
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='kpi_uncategorised';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        #define_ruleblock([[rb_id]],
            {
                description: "these are the rules for KPIs which do not fit into other categories",
                is_active:0
            }
        );
        
        #doc(,
            {
                txt : "Get billing status over last year"
            }
        );

        mbs_715_1y_n => eadv.[mbs_715].dt.count(0).where(dt > sysdate-365);
        mbs_721_1y_n => eadv.[mbs_721].dt.count(0).where(dt > sysdate-365);
        mbs_723_1y_n => eadv.[mbs_723].dt.count(0).where(dt > sysdate-365);
        mbs_732_1y_n => eadv.[mbs_732].dt.count(0).where(dt > sysdate-365);

        mbs_715_1y : {mbs_715_1y_n > 0 => 1},{=> 0};
        mbs_721_1y : {mbs_721_1y_n > 0 => 1},{=> 0};
        mbs_723_1y : {mbs_723_1y_n > 0 => 1},{=> 0};
        mbs_732_1y : {mbs_732_1y_n > 0 => 1},{=> 0};


        #doc(,
            {
                txt : "Get number of non Z49.1 discharges in last year"
            }
        );

        total_dc_n => eadv.[icd_%].dt.distinct_count(0).where(dt > sysdate-365);
        #define_attribute(total_dc_n,
            {
                label: "The total number of discharges."
            }
        );

        z491_dc_n => eadv.[icd_z49_1].dt.distinct_count(0).where(dt > sysdate-365);
        #define_attribute(z491_dc_n,
            {
                label: "The number of discharges with Z49 icd code as diagnosis."
            }
        );

        [[rb_id]] : {. =>1};
        
        #define_attribute([[rb_id]],
            {
                label: "This is a placeholder variable, useful info stored in other variables in this block"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;




