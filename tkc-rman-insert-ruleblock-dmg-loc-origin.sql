CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
       
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc_origin';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /* Algorithm to assess demographics origin*/
        
        #define_ruleblock(dmg_loc_origin,
            {
                description: "Algorithm to assess demographics origin",
                is_active:2
                
            }
        );
        
        
        
        /* Uses 715 assumption */
        
        loc_first => eadv.[mbs_715, mbs_13105].loc.first();
        
        loc_code : {loc_first!? => substr(loc_first,4)};
        
        loc_district : {loc_first!? => substr(loc_first,6,2)};
        
        loc_region : {loc_first!? => substr(loc_first,5,1)};
        
        loc_locality : {loc_first!? => substr(loc_first,8,1)};
        
        dmg_loc_origin : { loc_first!? => 1},{=>0};
        
        #define_attribute(loc_code,
        {
                label:"Origin PHC Location code",
                type:1,
                is_reportable:1
        });
        
        #define_attribute(loc_district,
        {
                label:"Origin PHC District",
                type:1,
                is_reportable:1
        });
        
        #define_attribute(loc_region,
        {
                label:"Origin PHC Region",
                type:1,
                is_reportable:1
        });
        #define_attribute(loc_locality,
        {
                label:"Origin PHC Locality",
                type:1,
                is_reportable:1
        });
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
         
END;





