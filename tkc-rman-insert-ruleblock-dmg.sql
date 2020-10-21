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
                
                is_active:2
                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        dod => eadv.dmg_dod.dt.max();
        
        gender => eadv.dmg_gender.val.last();
        
        alive : {dod? => 1},{=>0};
        
        /* Constants */
        st_rman_ver : {.=> 1000};
        
        st_rman_init : {. => 1010};
        
        st_rman_rb : {. => 2010};
        
        st_rman_rb_err : {. => 2014};
        [[rb_id]] : { 1=1 => 1},{=>0};  
        
        #define_attribute(
            dob,
            {
                label:"Date of birth [last recorded]",
                type:12,
                is_reportable:1
            }
        );
        
        #define_attribute(
            dod,
            {
                label:"Date of death [last recorded]",
                type:12,
                is_reportable:1
            }
        );
        
        #define_attribute(
            gender,
            {
                label:"Gender [male=1 female=2]",
                type:12,
                is_reportable:1
            }
        );
        
        #define_attribute(
            alive,
            {
                label:"Alive with absent DOD",
                type:02,
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
                is_active:2
                
            }
        );
        
        /*
        Key index
        01   source         (3 digits)
        02   state          (1 digits 7 default)
        03   region         (1 digit)
        04   district       (2 digits)
        06   locality       (5 digits)
        11   sub-locality   (2 digits)
        13   level of care  (1 digit P=1,T=2)
        
        */
        
        
        mode_24_ => eadv.dmg_location.val.stats_mode().where(dt > sysdate - 730 and substr(val,-1)=1);
        
        mode_full_ => eadv.dmg_location.val.stats_mode().where(substr(val,-1)=1);
        
        loc_mode_24 : {.=> to_number(substr(mode_24_,4))};
        
        loc_mode : {.=> to_number(substr(mode_full_,4))};
        
        loc_active : {loc_mode_24!? => 1},{=>0};
        
        loc_mode_def : {loc_mode_24!? => loc_mode_24},{loc_mode!? => loc_mode};
        
        last => eadv.dmg_location._.lastdv().where(substr(val,-1)=1 and dt > sysdate - 730);
        
        loc_last_val : {.=> to_number(substr(last_val,4))};       
        
        last_1 => eadv.dmg_location._.lastdv(1).where(substr(val,-1)=1 and dt > sysdate - 730);
        
        loc_last_1_val : {.=> to_number(substr(last_1_val,4))};       
        
        loc_n => eadv.dmg_location.val.count().where(substr(val,-1)=1);
        
        loc_mode_n => eadv.dmg_location.val.count().where(substr(val,4)=loc_mode_def);
        
        loc_last_n => eadv.dmg_location.val.count().where(substr(val,4)=loc_last_val);
        
        /*
        loc_last_2y => eadv.dmg_location.val.serializedv2(substr(val,4)~dt).where(dt>sysdate-365 and substr(val,-1)=1);
        */
        
        
        loc_def : {loc_last_val=loc_last_1_val and last_dt-last_1_dt>90 => loc_last_val},{=>loc_mode_def}
        
        loc_def_fd => eadv.dmg_location.dt.min().where(substr(val,4)=loc_last_val);
        
        loc_district : {loc_def!? => substr(loc_def,6,2)};
        
        loc_locality : {loc_def!? => substr(loc_def,8,5)};
        
        
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
                description: "Algorithm to assess demographic source",
                is_active:2
                
            }
        );
                
        
        tc_caresys_n => eadv.dmg_location.dt.count().where(substr(val,2,2)=2);
        
        tc_caresys_ld => eadv.dmg_location.dt.max().where(substr(val,2,2)=2);
        
        tc_labtrak_n => eadv.dmg_location.dt.count().where(substr(val,2,2)=7);
        
        tc_labtrak_ld => eadv.dmg_location.dt.max().where(substr(val,2,2)=7);
        
        pcis_n => eadv.dmg_location.dt.count().where(dt>sysdate-1000 and substr(val,2,2)=1);
        
        pcis_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=1);
        
        eacs_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=3);
        
        eacs_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=3);
        
        laynhapuy_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=4);
        
        laynhapuy_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=4);
        
        miwatj_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=5);
        
        miwatj_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=5);
        
        anyinginyi_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=6);
        
        anyinginyi_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=6);
        
        congress_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2) in(8,10,11,12,13));
        
        congress_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2) in(8,10,11,12,13));
        
        wurli_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=14);
        
        wurli_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=14);
        
        kwhb_n => eadv.dmg_location.dt.count().where(dt>sysdate-1000 and substr(val,2,2)=9);
        
        kwhb_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=9);
        
        phc_0 => eadv.dmg_location.val.stats_mode().where(dt > sysdate-1000 and substr(val,2,2) in (1,4,5,6,8,9,10,11,12,13,14));
        
        phc_1 : { phc_0!? => to_number(substr(phc_0,2,2))},{=>0};
        
        phc_pcis : { phc_1=1 => 1 },{=>0};
        
        phc_miwatj : { phc_1=5 => 1 },{=>0};
        
        phc_congress : { phc_1 in(8,11,12,13,14) => 1 },{=>0};
        
        phc_wurli : { phc_1=9 => 1 },{=>0};

        phc_kwhb : { phc_1=10 => 1 },{=>0};
        
        
        [[rb_id]] : { phc_1!? => phc_1 };    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Demographic phc source",
                type:2,
                is_reportable:1
            }
        );
        
        
        #define_attribute(
            phc_pcis,
            {
                label:"Demographic phc source Pcis",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_miwatj,
            {
                label:"Demographic phc source Miwatj",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_congress,
            {
                label:"Demographic phc source Congress",
                type:2,
                is_reportable:1
            }
        );
        
        #define_attribute(
            phc_wurli,
            {
                label:"Demographic phc source Wurli",
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





