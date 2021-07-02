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
        
        age : { dob!? => round((sysdate-dob)/365.25,0)};
        
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
             1 digit : parity
             2 digits: Source table code
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
        
        last => eadv.dmg_location._.lastdv().where(substr(val,-1)=1);
        
        last_t => eadv.dmg_location._.lastdv().where(substr(val,-1)<>1);
        
        loc_last_val : {.=> to_number(substr(last_val,4))};       
        
        loc_last_t_val : {.=> to_number(substr(last_t_val,4))};  
        
        last_1 => eadv.dmg_location._.lastdv(1).where(substr(val,-1)=1);
        
        loc_last_1_val : {.=> to_number(substr(last_1_val,4))};       
        
        loc_n => eadv.dmg_location.val.count().where(substr(val,-1)=1);
        
        loc_mode_n => eadv.dmg_location.val.count().where(substr(val,4)=loc_mode_def);
        
        loc_last_n => eadv.dmg_location.val.count().where(substr(val,4)=loc_last_val);

        loc_def : {loc_last_val=loc_last_1_val and last_dt-last_1_dt>90 => loc_last_val},{=> loc_mode_def};

        loc_def_alt : {loc_def? =>loc_last_t_val};      
        
        loc_null : {coalesce(loc_def,loc_def_alt)?=>1},{=>0};
        
        loc_def_fd => eadv.dmg_location.dt.min().where(substr(val,4)=loc_last_val);
        
        loc_region : {loc_def!? => to_number(substr(loc_def,2,1))};
        
        loc_district : {loc_def!? => to_number(substr(loc_def,6,2))};
        
        loc_locality : {loc_def!? => to_number(substr(loc_def,8,5))};
        
        
        diff_last_mode : {loc_mode_def<>loc_last_val =>1},{=>0};
        
        
        mode_pct : {loc_n>0 => round(loc_mode_n/loc_n,2)*100};
        
       
        episode_single : { loc_n=1 => 1},{=>0};
        
        loc_single : { mode_pct=1 =>1},{=>0}; 
        
        
        
        [[rb_id]] : { coalesce(loc_def,0)>0 =>loc_def },{ coalesce(loc_def_alt,0)>0 => loc_def_alt},{=>0};    
        
        
        
        
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
                
        
                
        loc_def => rout_dmg_loc.loc_def.val.bind();
        
        loc_def_alt => rout_dmg_loc.loc_def_alt.val.bind();
        
        loc_null => rout_dmg_loc.loc_null.val.bind();
        
        loc_mode_n => rout_dmg_loc.loc_mode_n.val.bind();
        
        loc_n => rout_dmg_loc.loc_n.val.bind();
        
        mode_pct => rout_dmg_loc.mode_pct.val.bind();
        
        hrn => rout_dmg_hrn.hrn_last.val.bind();
        
        loc_region => rout_dmg_loc.loc_region.val.bind();
        
        tc_caresys_n => eadv.dmg_location.dt.count().where(substr(val,2,2)=11);
        
        tc_caresys_ld => eadv.dmg_location.dt.max().where(substr(val,2,2)=11);
        
        tc_labtrak_n => eadv.dmg_location.dt.count().where(substr(val,2,2)=12);
        
        tc_labtrak_ld => eadv.dmg_location.dt.max().where(substr(val,2,2)=12);
        
        pcis_n => eadv.dmg_location.dt.count().where(dt>sysdate-1000 and substr(val,2,2)=21);
        
        pcis_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=21);
        
        eacs_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=22);
        
        eacs_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=22);
        
        laynhapuy_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=33);
        
        laynhapuy_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=33);
        
        miwatj_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=34);
        
        miwatj_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=34);
        
        anyinginyi_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=32);
        
        anyinginyi_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=32);
        
        congress_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2) in(37,38,39,41,42));
        
        congress_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2) in(37,38,39,41,42));
        
        wurli_n => eadv.dmg_location.dt.count(0).where(dt>sysdate-1000 and substr(val,2,2)=36);
        
        wurli_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=36);
        
        kwhb_n => eadv.dmg_location.dt.count().where(dt>sysdate-1000 and substr(val,2,2)=35);
        
        kwhb_ld => eadv.dmg_location.dt.max().where(dt>sysdate-1000 and substr(val,2,2)=35);
        
        
        phc_0 => eadv.dmg_location.val.stats_mode().where(dt > sysdate-1000 and substr(val,2,2) between 20 and 50);
        
        phc_1 : { phc_0!? => to_number(substr(phc_0,2,2))},{=>0};
        
        phc_pcis : { phc_1=21 => 1 },{=>0};
        
        phc_miwatj : { phc_1=34 => 1 },{=>0};
        
        phc_congress : { phc_1 in(36,37,38,39,41,42) => 1 },{=>0};
        
        
        phc_wurli : { phc_1=36 => 1 },{=>0};

        phc_kwhb : { phc_1=35 => 1 },{=>0};
        
        tkc_provider : { coalesce(loc_region,0)=1 or phc_1 in(36,37,38,39,41,42) =>1},{=>2};
        
        [[rb_id]] : { phc_1 > 0 => phc_1 },{=>999};    
        
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
            phc_congress_mutitjulu,
            {
                label:"Demographic phc source Congress Mutitjulu",
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
        

        #define_attribute(
            loc_def,
            {
                label:"Default locality",
                type:1002,
                is_reportable:1
            }
        );
       
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_residency';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess residential status */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess residential status",
                is_active:2
                
            }
        );
         
        mbs731 => eadv.mbs_731.dt.max().where(dt > sysdate -730);
        
        nhr : { mbs731!? => 1},{=>0};
        
        [[rb_id]] : { nhr=1 => 1 },{=>0};    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Nursing home resident",
                type:2,
                is_reportable:1
            }
        );
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
              -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_eid_alt';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess alternative eid */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess alternative eid",
                is_active:2
                
            }
        );
         
        alt_eid_last => eadv.dmg_eid_alt.val.last();
        
        alt_eid_last_1 => eadv.dmg_eid_alt.val.last(1);

        [[rb_id]] : { alt_eid_last!? => 1 },{=>0};    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Potential duplicate client",
                type:2,
                is_reportable:1
            }
        );
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
   -- END OF RULEBLOCK 
    
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_hrn';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess HRN */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess HRN",
                is_active:2
                
            }
        );
         
        hrn_last => eadv.dmg_hrn.val.last();

        [[rb_id]] : { hrn_last!? => 1 },{=>0};    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Last HRN",
                type:2,
                is_reportable:0
            }
        );
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
                  -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_tkcuser_interact';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess TKC user interaction */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess TKC user interaction",
                is_active:2                
            }
        );
         
        corr_ld => eadv.tkc_corresp.dt.max();
        
        tag_sys_pr => eadv.[sys_record_partial]._.lastdv();
        
        [[rb_id]] : { coalesce(corr_ld,tag_sys_pr_dt)!? => 1 },{=>0};    
        
        #define_attribute(
            tag_sys_pr_dt,
            {
                label:"Sys flag raised",
                type:2,
                is_reportable:0
            }
        );
              
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
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
        
        icu_los => eadv.adm_icu._.lastdv(); 
        
        icu_vent_max_los => eadv.adm_icu_vent_los._.maxldv(); 
        
        icu_max_los => eadv.adm_icu._.maxldv(); 
        
        dt_diff : { icu_los_val<icu_max_los_val=>1},{=>0};
        
        [[rb_id]] : { coalesce(icu_vent_los_dt,icu_los_dt)!? => 1 },{=>0};    
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Inpatient activity for ICU admissions",
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





