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
        
        icpc_ld => eadv.[icpc_w05%,icpc_w17%,icpc_w18%,icpc_w29%,icpc_w70%,icpc_w78%,icpc_w84%,icpc_w85%].dt.last();
        
        us_2_ld => eadv.[ris_img_uspreg%].dt.last().where(dt < us_ld - 304); 
        
        preg_1y_f : { coalesce(us_ld,icpc_ld)> sysdate-365 =>1},{=>0};
        
        preg_ld : { .=> greatest_date(us_ld,icpc_ld)};
        
        [[rb_id]] : { coalesce(us_ld,icpc_ld)!? => 1},{=>0};
        
        #define_attribute(
            [[rb_id]],{
                label:"Major abdominal colorectal surgery",
                type:2,
                is_reportable:0
        });
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
           
END;





