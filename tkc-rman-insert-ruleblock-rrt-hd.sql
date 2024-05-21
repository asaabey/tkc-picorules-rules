CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     


    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_1_metrics';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine RRT 1 metrics*/
        
        #define_ruleblock(rrt_1_metrics,
            {
                description: "Rule block to determine RRT 1 metrics",
                is_active:2
                
            }
        );

        #doc(,
            {
                txt : "rrt session regularity"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        hd_ld => eadv.[icd_z49_1,mbs_13105].dt.max();
        
        hd_fd => eadv.[icd_z49_1,mbs_13105].dt.min();
        
        hd_n => eadv.[icd_z49_1,mbs_13105].dt.count();
        
        hd0_2w_f : { (sysdate - hd_ld)<14 => 1},{=>0};
        
        tspan : { . => hd_ld-hd_fd };
        
        tspan_y : { .=> round(tspan/365,1) };
        
        hd_oe : { tspan > 1 => round(100*(hd_n /tspan)/0.427,0)},{=>0};
        
        hd_tr => eadv.icd_z49_1.dt.temporal_regularity();
        
        hd_sl : { .=> round(hd_tr*100,0) };
        
        canddt : {rrt in(1,4) =>1},{=>0};
        
        
        rrt_1_metrics : {rrt in(1,4) =>1};
        
       
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
 
    
    
        
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_acc_iv';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Fistula intervention*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Fistula intervention",
                is_active:2
                
            }
        );

        #doc(,
            {
                txt : "Intervntion codes from RIS episodes"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        acc_side => eadv.hd_access_side._.lastdv();
        
        acc_type => eadv.hd_access_type._.lastdv();
        
        acc_detail : {coalesce(acc_side_val,acc_type_val)!? => 1},{=>0};
        
        avf_dt => rout_ckd_access.avf_dt.val.bind();
        
        avf_us_ld => eadv.enc_ris_usavfist.dt.last();
        
        av_gram_ld => eadv.[enc_ris_dshfist,enc_ris_dsarenal].dt.last();
        
        av_plasty_ld => eadv.[enc_ris_dshplas%, enc_ris_angplas%,enc_ris_dsarenal].dt.last();
        
        av_plasty_1_ld => eadv.[enc_ris_dshplas%, enc_ris_angplas%,enc_ris_dsarenal].dt.last(1);
        
        av_plasty_fd => eadv.[enc_ris_dshplas%, enc_ris_angplas%,enc_ris_dsarenal].dt.first();
        
        av_plasty_n => eadv.[enc_ris_dshplas1%, enc_ris_angplas%,enc_ris_dsarenal].dt.count();
        
        av_surv_ld : {.=> greatest(avf_us_ld,av_gram_ld,av_plasty_ld)};
        
        plasty_gap : {.=> av_plasty_ld-av_plasty_1_ld};
        
        iv_periodicity : {plasty_gap between 0 and 100 => 3},
                        {plasty_gap between 100 and 200 => 6},
                        {plasty_gap between 200 and 600 => 12},
                        {plasty_gap >400 or plasty_gap?=> 99};
                        
        av_iv : {av_plasty_ld!? => 1},{=>0};
        
        [[rb_id]] : { rrt in (1,4) and (av_surv_ld!? or avf_dt!? or acc_detail=1)=>1},{=>0};
        
        #define_attribute(
            [[rb_id]] ,
            {
                label:"AV fistuloplasty",
                is_reportable:1,
                type:1001
            }
        );
        
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
      
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_param';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Haemodialysis parameters*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Haemodialysis parameters",
                is_active:2
                
            }
        );

        
        
        rrt => rout_rrt.rrt.val.bind();
        
        mode => eadv.[psi_hd_param_mode]._.lastdv();
        
        hours => eadv.hd_param_hours._.lastdv();
        
        ibw => eadv.obs_dry_weight._.lastdv().where(dt > sysdate-90);
        
        bw => eadv.obs_weight._.lastdv().where(dt > sysdate-90);
        
        ex_wt : {bw_dt > ibw_dt => bw_val - ibw_val};
        
        dx => eadv.[psi_hd_param_dx]._.lastdv();
        
        mode_hdf : {mode_val in (20,22)=>1},{=>0};
        
        
        [[rb_id]] : { rrt in (1,4) and coalesce(mode_val,hours_val,ibw_val,dx_val)!? =>1},{=>0};
        

    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
          -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_adequacy';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Haemodialysis adequacy*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Haemodialysis adequacy",
                is_active:2
                
            }
        );

        
        
        rrt => rout_rrt.rrt.val.bind();
        
        #doc(,{
                txt : "Post dialysis urea"
        });
        
        post_u => eadv.lab_bld_urea_post_hd._.lastdv();
        
        pre_u => eadv.lab_bld_urea_pre_hd._.lastdv().where(dt = post_u_dt);
        
        urr : { pre_u_val>post_u_val and post_u_val>0 => round((pre_u_val - post_u_val)/pre_u_val,2)};
        
        #doc(,{
                txt : "Post dialysis urea preceding 1st"
        });
        
        post_u_1 => eadv.lab_bld_urea_post_hd._.lastdv(1);
        
        pre_u_1 => eadv.lab_bld_urea_pre_hd._.lastdv(1).where(dt = post_u_1_dt);
        
        urr_1 : { pre_u_1_val>post_u_1_val and post_u_1_val>0 => round((pre_u_1_val - post_u_1_val)/pre_u_1_val,2)};
        
        
        #doc(,{
                txt : "Post dialysis urea preceding 2nd"
        });
        
        post_u_2 => eadv.lab_bld_urea_post_hd._.lastdv(2);
        
        pre_u_2 => eadv.lab_bld_urea_pre_hd._.lastdv(2).where(dt = post_u_2_dt);
        
        urr_2 : { pre_u_2_val>post_u_2_val and post_u_2_val>0 => round((pre_u_2_val - post_u_2_val)/pre_u_2_val,2)};
        
        #doc(,{
                txt : "Persistent suboptimal flag"
        });
        
        low_urr_flag : {urr<0.65 and (urr_1<0.65 or urr_2<0.65) and rrt=1 =>1},{=>0};
        
        #doc(,{
                txt : "Erroneous collection flag"
        });
        
        err_urr_flag : {urr<0.5 and rrt=1 =>1},{=>0};
        
        #doc(,{
                txt : "Calc spKTV based Ln transformation"
        });
        
        spktv : { coalesce(urr,0)>0 => round(ln(1-urr)*-1,2) };
            
        
        [[rb_id]] : { rrt in (1,4) and urr!? =>1},{=>0};
        
       
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --

--            -- BEGINNING OF RULEBLOCK --
--    
--        
--    rb.blockid:='rrt_hd_location';
--
--    
--    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
--    
--    rb.picoruleblock:='
--    
--        /* Rule block to determine Haemodialysis location or facility*/
--        
--        #define_ruleblock([[rb_id]],
--            {
--                description: "Rule block to determine Haemodialysis",
--                is_active:2
--                
--            }
--        );
--
--        
--        
--        rrt => rout_rrt.rrt.val.bind();
--        
--        #doc(,{
--                txt : "Determine localtion from icd z49 or mbs 13105"
--        });
--        
--        hd_code_1_dt => eadv.[icd_z49_1,mbs_13105].dt.last().where(dt > sysdate-60);
--        
--        loc_1 => eadv.dmg_location.val.last().where(dt = hd_code_1_dt);
--        
--        loc_1s : {.=>substr(loc_1,4)};
--        
--        
--        hd_code_2_dt => eadv.[icd_z49_1,mbs_13105].dt.last(1).where(dt > sysdate-60);
--        
--        loc_2 => eadv.dmg_location.val.last().where(dt = hd_code_2_dt);
--        
--        loc_2s : {.=>substr(loc_2,4)};
--        
--        hd_code_3_dt => eadv.[icd_z49_1,mbs_13105].dt.last(2).where(dt > sysdate-60);
--        
--        loc_3 => eadv.dmg_location.val.last().where(dt = hd_code_3_dt);
--        
--        loc_3s : {.=>substr(loc_3,4)};
--        
--        loc_fixed : {loc_1s=loc_2s and loc_1s=loc_3s=>1},{=>0};
--        
--        loc_1_fd => eadv.dmg_location.dt.first(where val=loc_1);
--        
--        loc_1_n => eadv.dmg_location.dt.count(where val=loc_1);
--        
--        loc_hd_tehs_nru : { loc_1s = 720600013032  => 1},{=>0};
--        
--        loc_hd_tehs_7ad : { loc_1s = 720600015062  => 1},{=>0};
--        
--        
--        [[rb_id]] : {loc_1!? =>1},{=>0};
--        
--       
--        #define_attribute(
--            loc_hd_tehs_nru,
--            {
--                label:"Prevalent Nightcliff satellite dialysis",
--                is_reportable:1,
--                type:2
--            }
--        );
--        #define_attribute(
--            loc_hd_tehs_7ad,
--            {
--                label:"Prevalent 7A satellite dialysis",
--                is_reportable:1,
--                type:2
--            }
--        );
--    ';
--    
--    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
--    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
--   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
--    
--    -- END OF RULEBLOCK --
    
        -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_location';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Haemodialysis location or facility 2023 update*/
        
        #define_ruleblock(rrt_hd_location,
            {
                description: "Rule block to determine Haemodialysis location or facility 2023 update",
                is_active:2
                
            }
        );

        
        
        rrt => rout_rrt.rrt.val.bind();
        
        dod => eadv.dmg_dod.dt.max();
        
        #doc(,{
                txt : "Determine unrestricted from proc 131000"
        });
        
        hd_loc_mode => eadv.[caresys_1310000].loc.stats_mode();
        
        
        hd_131000_n => eadv.[caresys_1310000].loc.count().where(dt>sysdate-60);
        
        hd_131000_ld => eadv.[caresys_1310000].dt.max().where(dt>sysdate-60);
        
        #doc(,{
                txt : "Determine primary facility from proc 131000"
        });
        
        hd_131000_pri_loc => eadv.[caresys_1310000].loc.stats_mode().where(dt>sysdate-60);
        
        hd_131000_pri_n => eadv.[caresys_1310000].loc.count().where(dt>sysdate-60 and loc=hd_131000_pri_loc);
        
        hd_131000_pri_ld => eadv.[caresys_1310000].dt.max().where(dt>sysdate-60 and substr(to_char(loc),-5) = substr(to_char(hd_131000_pri_loc),-5));
        
        
        
        #doc(,{
                txt : "Determine secondary facility from proc 131000"
        });
        
        
        
        hd_131000_sec_loc => eadv.[caresys_1310000].loc.stats_mode().where(dt>sysdate-60 and substr(to_char(loc),-5) <> substr(to_char(hd_131000_pri_loc),-5));
        
        hd_131000_sec_n => eadv.[caresys_1310000].loc.count().where(dt>sysdate-60 and loc=hd_131000_sec_loc);
        
        hd_131000_sec_ld => eadv.[caresys_1310000].dt.max().where(dt>sysdate-60 and loc=hd_131000_sec_loc);
        
        
        
        #doc(,{
                txt : "Determine remote facility from proc 13105"
        });
        
        hd_13105_loc => eadv.[mbs_13105].loc.stats_mode().where(dt>sysdate-60);
        
        hd_13105_n => eadv.[mbs_13105].loc.count().where(dt>sysdate-60 and loc=hd_13105_loc);
        
        hd_13105_ld => eadv.[mbs_13105].dt.max();
        
        #doc(,{
                txt : "last session date"
        });
        
        hd_ld : { . => greatest_date(hd_13105_ld,hd_131000_ld )};
        
        #doc(,{
                txt : "summation of all sessions"
        });
        
        hd_n_sum : { . => hd_131000_pri_n + hd_131000_sec_n + hd_13105_n };
        
        #doc(,{
                txt : "perecentage based on predicted 20 under observed"
        });
        
        hd_tot_obs_pct : { . => round(hd_n_sum/20,2) };
        
        #doc(,{
                txt : "perecentage at satellite facility"
        });
        
        hd_tot_sat_pct : { . => round((hd_131000_pri_n + hd_131000_sec_n)/20,2)  };
        
        #doc(,{
                txt : "perecentage at remote facility"
        });
        
        hd_tot_rem_pct : { . => round(hd_13105_n/20,2)  };
        
        #doc(,{
                txt : "perecentage based on predicted under observed"
        });
        
        
        hd_status : {rrt not in (0, 1,4) => `coding uncertain`},
        {dod!? => `deceased`},
        {(hd_131000_pri_n > 15 and hd_131000_pri_ld > sysdate -14) or (hd_tot_sat_pct>0.8)  => `active single unit`},
        {(hd_131000_pri_ld > sysdate -14) or (hd_tot_sat_pct>0.3)  => `active multi unit`},
        {(hd_13105_ld > sysdate - 21) or (hd_13105_ld > hd_131000_pri_ld) => `active remote unit` },
        {(hd_131000_n>0)  => `indetermined hd status`};
        
        loc_mode_1m_txt : {hd_131000_pri_loc in (190721600013032,150721600013032 ) => `NTG-TEHS-NRU`},
        {hd_131000_pri_loc in (190721600015062,150721600015062,190721600006002 ) => `NTG-TEHS-7A`},
        {hd_131000_pri_loc in 
        (190721500016042,190721500016052,150721500016042 ) => `FM-TE-KDH`},
        {hd_131000_pri_loc in (190721600013012,190721600015052,150721600013012 ) => `NTG-TEHS-HT`},
        {hd_131000_pri_loc in (190721600005012,190721600014022,150721600005012 ) => `NTG-TEHS-PRH`},
        {hd_131000_pri_loc in (150721600017012,190721600017012 ) => `NTG-TEHS-TIW`},
        {hd_131000_pri_loc in (190721700007002) => `NTG-TEHS-GDH`},
        {hd_131000_pri_loc in (190710500004042,190710500012022 ) => `NTG-CAHS-TCH`},
        {hd_131000_pri_loc in (190711800003062,190711800010122,190711811460051 ) => `NTG-CAHS-ASH`},
        {hd_131000_pri_loc in (190711800010132 ) => `FM-CA-GAP`},
        {hd_131000_pri_loc in (190711800011112 ) => `PUR-PUR`},
        {hd_13105_loc in (115711810146051 ) => `PUR-CA-AMPILATWATJA `},
        {hd_13105_loc in (115711811460051 ) => `PUR-CA-ALICE SPRINGS `},
        {hd_13105_loc in (115721711066051 ) => `PUR-CA-ALYANGULA`},
        {hd_13105_loc in (115711810044051 ) => `PUR-CA-HERMANNSBURG`},
        {hd_13105_loc in (115711810114051 ) => `PUR-CA-SANTA TERESA`},
        {hd_13105_loc in (115721510073051 ) => `PUR-TE-LAJAMANU`},
        {hd_13105_loc in (115721515190051 ) => `PUR-TE-KALKARINGI`},
        {hd_13105_loc in (115711815410051 ) => `PUR-CA-DOCKER RIVER`},
        {hd_13105_loc in (115711810136051 ) => `PUR-CA-YUENDUMU`},
        {hd_13105_loc in (115711811153051 ) => `PUR-CA-UTOPIA`},
        {hd_13105_loc in (115711811556051 ) => `PUR-CA-PAPUNYA`},
        {hd_13105_loc in (115711810202051 ) => `PUR-CA-KINTORE`},
        {hd_13105_loc in (115711800011112 ) => `PUR-CA-NEWMAN`},
        {hd_13105_loc in (134721710053011 ) => `MIW-TE-ANGURUGU`},
        {hd_13105_loc in (134721710027001 ) => `MIW-TE-NGALKANBUY`},
        {hd_13105_loc in (134721710539001 ) => `MIW-TE-YIRRKALA`},
        {hd_13105_loc in (115711811460012 ) => `PUR-WA-WARBURTON`},
        {hd_131000_ld > sysdate - 14 => `UNKNOWN`} ;
        
        
        rrt_hd_location : {hd_131000_pri_loc!? or hd_13105_loc!? =>1},{=>0};
        
       
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --



END;





