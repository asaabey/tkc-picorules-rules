CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect chronic disease entities */
        
        #define_ruleblock(dmg,
            {
                description: "Algorithm to assess demographics",
                version: "0.0.1.1",
                blockid: "dmg",
                target_table:"rout_dmg",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"dmg",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        dod => eadv.dmg_dod.dt.max();
        
        gender => eadv.dmg_gender.val.last();
        
  
        
        dmg : { 1=1 => 1},{=>0};    
        
                
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect chronic disease entities */
        
        #define_ruleblock(dmg_loc,
            {
                description: "Algorithm to assess demographics",
                version: "0.0.1.1",
                blockid: "dmg_loc",
                target_table:"rout_dmg_loc",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"dmg_loc",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        
        loc_mode_24 => eadv_loc.dmg_location.val.stats_mode().where(dt > sysdate- 730);
        
        loc_mode_full => eadv_loc.dmg_location.val.stats_mode();
        
        loc_last_full => eadv_loc.dmg_location.val.last();
        
        
        dmg_loc : { 1=1 => 1},{=>0};    
        
                
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
   
   
END;





