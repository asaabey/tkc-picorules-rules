CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    
                 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ipa_icu';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess Inpatient activity for ICU admissions */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Inpatient activity for ICU admissions",
                is_active:2
                
            }
        );
        
        icu_vent_los => eadv.adm_icu_vent_los._.lastdv();
        
        vent_ld => eadv.[caresys_1387900, caresys_1388200, caresys_1388201, caresys_1388202].dt.last();
        
        vent_fd => eadv.[caresys_1387900, caresys_1388200, caresys_1388201, caresys_1388202].dt.last();
        
        icu_los => eadv.adm_icu._.lastdv();
        
        icu_vent_max_los => eadv.adm_icu_vent_los._.maxldv();
        
        icu_max_los => eadv.adm_icu._.maxldv();
        
        cvvhf_ld => eadv.[caresys_1310004, caresys_1310002].dt.last();
        
        cvvhf_fd => eadv.[caresys_1310004, caresys_1310002].dt.first();
        
        dt_diff : { icu_los_val<icu_max_los_val => 1},{=>0};
        
        icu_ld : {.=> greatest_date(cvvhf_ld, vent_ld)};
        
        icu_fd : {.=> least_date(cvvhf_fd, vent_fd)};
        
        [[rb_id]] : { coalesce(icu_vent_los_dt, icu_los_dt, cvvhf_ld, vent_ld)!? => 1 },{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Inpatient activity for ICU admissions",
                is_reportable:0,
                type:1001
            }
        );
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ipa_sep';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess Inpatient activity*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Inpatient activity with exclusions",
                is_active:2
                
            }
        );
        
        
        
        icd_ld => eadv.[icd_%].dt.last().where(att not in(`icd_z49_1`));
        
        icd_n => eadv.[icd_%].dt.distinct_count().where(att not in(`icd_z49_1`));
        
        icd_fd => eadv.[icd_%].dt.first().where(att not in(`icd_z49_1`));
        
        [[rb_id]] : { icd_ld!? => 1 },{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Inpatient activity",
                is_reportable:0,
                type:1001
            }
        );
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 

END;





