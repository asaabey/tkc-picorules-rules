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
        
        #define_ruleblock([[rb_id]],
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
        
        loc_def => rout_rrt_hd_location.loc_1s.val.bind();
        
        loc_1_fd => rout_rrt_hd_location.loc_1_fd.val.bind();
        
        loc_fixed => rout_rrt_hd_location.loc_fixed.val.bind();
        
        loc_1_n => rout_rrt_hd_location.loc_1_n.val.bind();
        
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
        
        
        [[rb_id]] : {rrt in(1,4) =>1};
        
       
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
                description: "Rule block to determine Tx metrics",
                is_active:2,
                filter: "SELECT eid FROM rout_rrt WHERE rrt IN (1,4)"
                
            }
        );

        #doc(,
            {
                txt : "Intervntion codes from RIS episodes"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        avf_dt => rout_ckd_access.avf_dt.val.bind();
        
        avf_us_ld => eadv.ris_img_usavfist.dt.last();
        
        av_gram_ld => eadv.ris_img_dshfist.dt.last();
        
        av_plasty_ld => eadv.ris_img_dshplas1.dt.last();
        
        av_plasty_1_ld => eadv.ris_img_dshplas1.dt.last(1);
        
        av_plasty_fd => eadv.ris_img_dshplas1.dt.first();
        
        av_plasty_n => eadv.ris_img_dshplas1.dt.count();
        
        av_surv_ld : {.=> greatest(avf_us_ld,av_gram_ld,av_plasty_ld)};
        
        plasty_gap : {.=> av_plasty_ld-av_plasty_1_ld};
        
        iv_periodicity : {plasty_gap between 0 and 100 => 3},
                        {plasty_gap between 100 and 200 => 6},
                        {plasty_gap between 200 and 600 => 12},
                        {plasty_gap >400 or plasty_gap?=> 99};
                        
        av_iv : {av_plasty_ld!? => 1},{=>0};
        
        [[rb_id]] : { rrt in (1,4) and (av_surv_ld!? or avf_dt!?)=>1},{=>0};
        
        #define_attribute(
            [[rb_id]] ,
            {
                label:"AV fistuloplasty",
                is_reportable:1,
                type:2
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
        
        ibw => eadv.[psi_hd_param_ibw]._.lastdv();
        
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

            -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_location';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Haemodialysis location or facility*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Haemodialysis",
                is_active:2
                
            }
        );

        
        
        rrt => rout_rrt.rrt.val.bind();
        
        #doc(,{
                txt : "Determine localtion from icd z49 or mbs 13105"
        });
        
        hd_code_1_dt => eadv.[icd_z49_1,mbs_13105].dt.last().where(dt > sysdate-60);
        
        loc_1 => eadv.dmg_location.val.last().where(dt = hd_code_1_dt);
        
        loc_1s : {.=>substr(loc_1,4)};
        
        
        hd_code_2_dt => eadv.[icd_z49_1,mbs_13105].dt.last(1).where(dt > sysdate-60);
        
        loc_2 => eadv.dmg_location.val.last().where(dt = hd_code_2_dt);
        
        loc_2s : {.=>substr(loc_2,4)};
        
        hd_code_3_dt => eadv.[icd_z49_1,mbs_13105].dt.last(2).where(dt > sysdate-60);
        
        loc_3 => eadv.dmg_location.val.last().where(dt = hd_code_3_dt);
        
        loc_3s : {.=>substr(loc_3,4)};
        
        loc_fixed : {loc_1s=loc_2s and loc_1s=loc_3s=>1},{=>0};
        
        loc_1_fd => eadv.dmg_location.dt.first(where val=loc_1);
        
        loc_1_n => eadv.dmg_location.dt.count(where val=loc_1);
        
        loc_hd_tehs_nru : { loc_1s = 720600013032  => 1},{=>0};
        
        loc_hd_tehs_7ad : { loc_1s = 720600015062  => 1},{=>0};
        
        
        [[rb_id]] : {loc_1!? =>1},{=>0};
        
       
        #define_attribute(
            loc_hd_tehs_nru,
            {
                label:"Prevalent Nightcliff satellite dialysis",
                is_reportable:1,
                type:2
            }
        );
        #define_attribute(
            loc_hd_tehs_7ad,
            {
                label:"Prevalent 7A satellite dialysis",
                is_reportable:1,
                type:2
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --

 -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_location';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Haemodialysis location or facility*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Haemodialysis",
                is_active:2
                
            }
        );

        
        
        rrt => rout_rrt.rrt.val.bind();
        
        #doc(,{
                txt : "Determine localtion from icd z49 or mbs 13105"
        });
        
        hd_code_1_dt => eadv.[icd_z49_1,mbs_13105].dt.last().where(dt > sysdate-60);
        
        loc_1 => eadv.dmg_location.val.last().where(dt = hd_code_1_dt);
        
        loc_1s : {.=>substr(loc_1,4)};
        
        
        hd_code_2_dt => eadv.[icd_z49_1,mbs_13105].dt.last(1).where(dt > sysdate-60);
        
        loc_2 => eadv.dmg_location.val.last().where(dt = hd_code_2_dt);
        
        loc_2s : {.=>substr(loc_2,4)};
        
        hd_code_3_dt => eadv.[icd_z49_1,mbs_13105].dt.last(2).where(dt > sysdate-60);
        
        loc_3 => eadv.dmg_location.val.last().where(dt = hd_code_3_dt);
        
        loc_3s : {.=>substr(loc_3,4)};
        
        loc_fixed : {loc_1s=loc_2s and loc_1s=loc_3s=>1},{=>0};
        
        loc_1_fd => eadv.dmg_location.dt.first(where val=loc_1);
        
        loc_1_n => eadv.dmg_location.dt.count(where val=loc_1);
        
        loc_hd_tehs_nru : { loc_1s = 720600013032  => 1},{=>0};
        
        loc_hd_tehs_7ad : { loc_1s = 720600015062  => 1},{=>0};
        
        
        [[rb_id]] : {loc_1!? =>1},{=>0};
        
       
        #define_attribute(
            loc_hd_tehs_nru,
            {
                label:"Prevalent Nightcliff satellite dialysis",
                is_reportable:1,
                type:2
            }
        );
        #define_attribute(
            loc_hd_tehs_7ad,
            {
                label:"Prevalent 7A satellite dialysis",
                is_reportable:1,
                type:2
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --


END;





