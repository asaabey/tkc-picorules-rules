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
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess demographics",
                version: "0.0.1.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        dod => eadv.dmg_dod.dt.max();
        
        gender => eadv.dmg_gender.val.last();
        
        /* Constants */
        
        status_rman_init : {. => 1010};
        
        [[rb_id]] : { 1=1 => 1},{=>0};  
        
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
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographics */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess demographics",
                version: "0.0.1.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
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
        
        
        
        [[rb_id]] : { nvl(loc_def,0)>0 =>loc_def };    
        
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
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
         -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_source';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographic source */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess demographics",
                version: "0.0.1.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
                
        
        tc_caresys_n => eadv.dmg_source_02.dt.count();
        
        tc_caresys_ld => eadv.dmg_source_02.dt.max();
        
        tc_labtrak_n => eadv.dmg_source_07.dt.count();
        
        tc_labtrak_ld => eadv.dmg_source_07.dt.max();
        
        pcis_n => eadv.dmg_source_01.dt.count(0).where(dt>sysdate-1000);
        
        pcis_ld => eadv.dmg_source_01.dt.max().where(dt>sysdate-1000);
        
        eacs_n => eadv.dmg_source_03.dt.count(0).where(dt>sysdate-1000);
        
        eacs_ld => eadv.dmg_source_03.dt.max().where(dt>sysdate-1000);
        
        laynhapuy_n => eadv.dmg_source_04.dt.count(0).where(dt>sysdate-1000);
        
        laynhapuy_ld => eadv.dmg_source_04.dt.max().where(dt>sysdate-1000);
        
        miwatj_n => eadv.dmg_source_05.dt.count(0).where(dt>sysdate-1000);
        
        miwatj_ld => eadv.dmg_source_05.dt.max().where(dt>sysdate-1000);
        
        anyinginyi_n => eadv.dmg_source_06.dt.count(0).where(dt>sysdate-1000);
        
        anyinginyi_ld => eadv.dmg_source_06.dt.max().where(dt>sysdate-1000);
        
        phc_1 :   { greatest(eacs_n,laynhapuy_n,miwatj_n,anyinginyi_n,pcis_n)=0 =>0},
                        { pcis_n > greatest(eacs_n,laynhapuy_n,miwatj_n,anyinginyi_n) => 1},
                        { eacs_n > greatest(laynhapuy_n,miwatj_n,anyinginyi_n) => 3},
                        { laynhapuy_n > greatest(miwatj_n,anyinginyi_n) => 4},
                        { miwatj_n > anyinginyi_n => 5},
                        { anyinginyi_n>0 =>6};

        
        [[rb_id]] : { . => phc_1 };    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Demographic phc source",
                type:2,
                is_reportable:1
            }
        );
        
       
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
   
   
END;





