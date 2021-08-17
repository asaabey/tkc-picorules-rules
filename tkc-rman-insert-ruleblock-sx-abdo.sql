CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    
                 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='sx_abdo';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess abdominal colorectal surgical procedures */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess abdominal colorectal surgical procedures",
                is_active:2
                
            }
        );
        
        exp_lap_fd => eadv.[caresys_3037300].dt.first();
        
        r_hemi_fd => eadv.[caresys_32000%,caresys_32003%,caresys_32004%,caresys_32005%].dt.first();
        
        l_hemi_fd => eadv.[caresys_32006%].dt.first();
        
        hemi : {coalesce(r_hemi_fd, l_hemi_fd)!? =>1},{=>0};
        
        h_ar_fd => eadv.[caresys_3202400].dt.first();
        
        l_ar_fd => eadv.[caresys_3202500,caresys_3202600,caresys_3202800].dt.first();
        
        ar : {coalesce(h_ar_fd,l_ar_fd)!? =>1},{=>0};
        
        hartmann_fd => eadv.[caresys_32051%].dt.first();
        
        [[rb_id]] : { coalesce(exp_lap_fd, r_hemi_fd, l_hemi_fd, h_ar_fd,l_ar_fd,hartmann_fd)!? => 1},{=>0};
        
        #define_attribute(
            [[rb_id]],{
                label:"Major abdominal colorectal surgery",
                type:2,
                is_reportable:0
        });
        #define_attribute(
            hemi,{
                label:"Left or Right Hemicolectomy",
                type:2,
                is_reportable:1
        });
        #define_attribute(
            ar,{
                label:"Anterior Resection",
                type:2,
                is_reportable:1
        });
        
        
                
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





