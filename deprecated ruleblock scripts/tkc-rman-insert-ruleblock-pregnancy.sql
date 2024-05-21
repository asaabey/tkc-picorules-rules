CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    
                 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='pregnancy';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess pregnancy */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess pregnancy",
                is_active:2
                
            }
        );
        
        us_ld => eadv.[ris_img_uspreg%].dt.last();
        
        gravid_icpc_ld => eadv.[icpc_w05%,icpc_w17%,icpc_w18%,icpc_w29%,icpc_w70%,icpc_w78%,icpc_w84%,icpc_w85%, icd_o24%].dt.last();
        
        partum_ld => eadv.[icd_z37%,icd_o82%].dt.last();
        
        partum_n => eadv.[icd_z37%,icd_o82%].dt.distinct_count();
        
        partum_lscs_ld => eadv.[icd_o82%].dt.last();
        
        partum_lscs_n => eadv.[icd_o82%].dt.distinct_count();
        
        us_2_ld => eadv.[ris_img_uspreg%].dt.last().where(dt < us_ld - 304);
        
        preg_1y_f : { coalesce(us_ld,gravid_icpc_ld, partum_ld)> sysdate-365 =>1},{=>0};
        
        preg_ld : { .=> greatest_date(us_ld,gravid_icpc_ld, partum_ld)};
        
        gdm_code_fd => eadv.[icd_o24%,icpc_w85001,icpc_w85002].dt.min();
        
        [[rb_id]] : { coalesce(us_ld,gravid_icpc_ld,partum_ld,gdm_code_fd)!? => 1},{=>0};
        
        #define_attribute(
            [[rb_id]],{
                label:"Pregnancy",
                is_reportable:0,
                type:1001
        });
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
           
END;





