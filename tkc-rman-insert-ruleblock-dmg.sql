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
    
        /* Algorithm to assess demographics */
        
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
        
        #define_attribute(
            dob,
            {
                label:"Date of birth (latest )",
                desc:"Date",
                is_reportable:0
            }
        );
        
                
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographics */
        
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
        
        
        loc_mode_24 => eadv.dmg_location.val.stats_mode().where(dt > sysdate- 730);
        
        loc_mode_full => eadv.dmg_location.val.stats_mode();
        
        loc_last => eadv.dmg_location.val.lastdv();
        
        loc_n => eadv.dmg_location.val.count();
        
        loc_mode_n => eadv.dmg_location.val.count().where(val=loc_mode_full);
        
        loc_cont3 => eadv.dmg_location.val.match_last((a{3,})~
            a as val=next(val)
        );
        
        
        loc_last_2y => eadv.dmg_location.val.serialize2().where(dt>sysdate-730);
        
        diff_last_mode : {loc_mode_full<>loc_last_val =>1},{=>0};
        
        diff_mode2y_mode : {loc_mode_full<>loc_mode_24 =>1},{=>0};
        
        mode_pct : {loc_n>0 => round(loc_mode_n/loc_n,2)*100};
        
       
        episode_single : { loc_n=1 => 1},{=>0};
        
        loc_single : { mode_pct=1 =>1},{=>0}; 
        
        dmg_loc : { 1=1 =>loc_mode_full };    
        
                
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
   
   
END;





