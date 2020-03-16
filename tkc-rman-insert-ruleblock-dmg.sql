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
                label:"Date of birth",
                type:12,
                is_reportable:1
            }
        );
        
        #define_attribute(
            dod,
            {
                label:"Date of death",
                type:12,
                is_reportable:1
            }
        );
        
        #define_attribute(
            gender,
            {
                label:"Gender",
                type:12,
                is_reportable:1
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
        
        
        loc_mode_24 => eadv.dmg_location.val.stats_mode().where(dt > sysdate - 730 and substr(val,-1)=1);
        
        loc_mode => eadv.dmg_location.val.stats_mode().where(substr(val,-1)=1);
        
        loc_active : {loc_mode_24!? => 1},{=>0};

        loc_mode_def : {loc_mode_24!? => loc_mode_24},{loc_mode!? => loc_mode};
        
        loc_last => eadv.dmg_location.val.lastdv().where(substr(val,-1)=1 and dt > sysdate - 730);
        
        loc_last_1 => eadv.dmg_location.val.lastdv(1).where(substr(val,-1)=1 and dt > sysdate - 730);
        
        loc_n => eadv.dmg_location.val.count().where(substr(val,-1)=1);
        
        loc_mode_n => eadv.dmg_location.val.count().where(val=loc_mode_def);
        
        loc_last_n => eadv.dmg_location.val.count().where(val=loc_last_val);
        
        loc_last_2y => eadv.dmg_location.val.serialize2().where(dt>sysdate-365 and substr(val,-1)=1);
        
        source => eadv.dmg_source.val.last();
        
        loc_def : {loc_last_val=loc_last_1_val and loc_last_dt-loc_last_1_dt>90 => loc_last_val},{=>loc_mode_def}
        
        loc_district : {loc_def!? => substr(loc_def,3,2)};
        
        loc_locality : {loc_def!? => substr(loc_def,5,5)};
        
        
        diff_last_mode : {loc_mode_def<>loc_last_val =>1},{=>0};
        
        
        mode_pct : {loc_n>0 => round(loc_mode_n/loc_n,2)*100};
        
       
        episode_single : { loc_n=1 => 1},{=>0};
        
        loc_single : { mode_pct=1 =>1},{=>0}; 
        
        dmg_loc : { 1=1 =>loc_def };    
        
        #define_attribute(
            dmg_loc,
            {
                label:"Demographic location",
                type:1002,
                is_reportable:1
            }
        );
        
        #define_attribute(
            loc_active,
            {
                label:"Is location active",
                type:1001,
                is_reportable:1
            }
        );
                
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
   
   
END;





