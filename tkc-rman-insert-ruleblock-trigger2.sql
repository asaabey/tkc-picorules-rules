CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    
 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4410';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephrotic syndrome */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to detect nephrotic syndrome",
                is_active:2
                
                
            }
        );
        
        
        #doc(,
            {
                txt:"Calculate information quantity"
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        

        
        iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-365);
        iq_egfr => eadv.lab_bld_egfr.val.count(0).where(dt>sysdate-365);
        iq_alb => eadv.lab_bld_albumin.val.count(0).where(dt>sysdate-365);
        iq_chol => eadv.lab_bld_cholesterol_total.val.count(0).where(dt>sysdate-365);
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-365);
        iq_ana => eadv.lab_bld_ana.val.count(0).where(dt>sysdate-(365*5));
        iq_spep => eadv.lab_bld_ana.val.count(0).where(dt>sysdate-(365*5));
        
        iq_tier :
                {iq_uacr>=2 and least(iq_egfr,iq_alb,iq_chol,iq_sbp,iq_ana,iq_spep)>1 => 4},
                {iq_uacr>=2 and least(iq_egfr,iq_alb,iq_chol,iq_sbp,0)>1 => 3},
                {iq_uacr>=2 and least(iq_egfr,iq_alb)>1 => 2},
                {iq_uacr>=2 and iq_alb>1 => 1},
                {=>0};
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4410._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
               
        rrt => rout_rrt.rrt.val.bind();
        dm => rout_cd_dm_dx.dm.val.bind();
        ckd => rout_ckd.ckd.val.bind();
       
        #doc(,
            {
                txt:"Exclude previously diagnosed nephrotic and if recent renal encounters"
            }
        );  
        
        
        
        dx_nephrotic => eadv.[icd_n04%].dt.count(0);
        
                
        ref_ren => rout_engmnt_renal.ref_renal.val.bind();
        
        enc_ren => rout_engmnt_renal.enc_renal.val.bind();
        
                
        ex_flag :{greatest(rrt,dm,enc_ren,dx_nephrotic)>0 or dod!? or ckd>4 or csu_act_dt!? or dmg_source=999 => 1},{=>0};

        
        #doc(,{
                txt:"Inclusions for nephrotic syndrome",
                cite: "tg4410_ref1, tg4410_ref2"
        });
        
        uacr_n => eadv.lab_ua_acr.dt.count(0).where(val>300 and dt>sysdate-365);
        
        uacr1 => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        uacr2 => eadv.lab_ua_acr.val.last(1).where(dt>sysdate-365);
        
        #doc(,{
                txt:"Use delta of log transformed uacr" 
        });
       
        uacr_log_delta : {uacr1>0 and uacr2>0 => round(log(10,uacr1)-log(10,uacr2),1)};
        
        #doc(,{
                txt:"Nephrotic associations of albumin and cholesterol"
        });
        
        
        alb1 => eadv.lab_bld_albumin.val.last().where(dt>sysdate-365);
        
        alb2 => eadv.lab_bld_albumin.val.last(1).where(dt>sysdate-365);
        
        chol1 => eadv.lab_bld_cholesterol_total.val.last(1).where(dt>sysdate-365);
        
        
        
        low_alb : {nvl(alb1,0)<30=>1},{=>0};
        high_chol : {nvl(chol1,0)>7=>1},{=>0};
        
        
                
        [[rb_id]] : {ex_flag=0 and uacr1>300 and uacr2>300 and uacr_log_delta>-0.1 => 1 },{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Alert:Nephrotic range proteinuria in the absence of diabetes",
                desc:"Integer [0-1] if meets criteria ",
                is_reportable:1,
                is_trigger:1,
                type:2,
                priority:1
            }
        );
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4420';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephritic syndrome */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to detect nephritic syndrome",
                
                is_active:2,
                
                priority:2
                
            }
        );
        
        #doc(,
            {
                txt:"Calculate information quantity"
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4420._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-365);
        iq_egfr => eadv.lab_bld_egfr.val.count(0).where(dt>sysdate-365);
        iq_urbc => eadv.lab_ua_rbc.val.count(0).where(dt>sysdate-365);
        iq_uleu => eadv.lab_ua_leucocytes.val.count(0).where(dt>sysdate-365);
        
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-365);
        
        iq_ana => eadv.lab_bld_ana.val.count().where(dt>sysdate-(365*5));
        iq_anca => eadv.[lab_bld_anca_pr3,lab_bld_anca_mpo].val.count(0).where(dt>sysdate-(365*5));
        iq_comp => eadv.[lab_bld_complement_c3,lab_bld_complement_c4].val.count(0).where(dt>sysdate-(365*5));
        
        #doc(,
            {
                txt:"Exclusions RRT"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        #doc(,
            {
                txt:"Exclude previously diagnosed nephrotic syndromes from coding"
            }
        );
        
      
        
        dx_nephritic => eadv.[icd_n0%].dt.count(0);
        
        #doc(,
            {
                txt:"Exclude if renal encounters present"
            }
        );
        
        
        
        ref_ren => rout_engmnt_renal.ref_renal.val.bind();
        
        enc_ren => rout_engmnt_renal.enc_renal.val.bind();
        
                
        ex_flag:{greatest(rrt,enc_ren,dx_nephritic)>0 or dod!? or csu_act_dt!? or dmg_source=999 => 1},{=>0};
        
        #doc(,
            {
                txt:"Inclusions for nephritic syndrome"
                cite: "tg4420_ref1, tg4420_ref2, tg4420_ref3"
            }
        );
        
        #doc(,
            {
                txt:"Inclusion by urine rbc"
            }
        );
        
        /*  Urine analysis */        
        
        ua_rbc => eadv.lab_ua_rbc.val.last().where(dt>sysdate-365);
        
        ua_leu => eadv.lab_ua_leucocytes.val.last().where(dt>sysdate-365);
        
        ua_acr => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        #doc(,
            {
                txt:"urine rbc threshold more than 100 provided leucs less than 40"
            }
        );
        
        
        
        t4420_code : {ua_rbc>100 and ua_leu<40 and ua_acr>30 => 2},
                    {ua_rbc>100 and ua_leu<40 => 1},    
                    {=>0};
        
        [[rb_id]] : { t4420_code >=2 and ex_flag=0 => 1},{=>0};            
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Alert:Possible nephritic syndrome",
                desc:"Integer [0-1] if meets criteria ",
                is_reportable:1,
                is_trigger:1,
                type:2,
                priority:1
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4100';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI trigger   */
        
         #define_ruleblock(rb_id,
            {
                description: "Algorithm to generate AKI trigger from labs",
                
                is_active:2
                
            }
        );
        
        #doc(,{
                txt:"External bindings"
        });
        
        dod => rout_dmg.dod.val.bind();
          
        rrt => rout_rrt.rrt.val.bind(); 
          
        ckd => rout_ckd.ckd.val.bind();
          
          #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4100._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();



        
          cr_n => eadv.lab_bld_creatinine.dt.count(); 
          cr_fd => eadv.lab_bld_creatinine.dt.min(); 
          cr_ld => eadv.lab_bld_creatinine.dt.max(); 
          
          egfr_base => eadv.lab_bld_egfr_c.val.lastdv().where(dt<cr_ld-90 and dt>cr_ld-365);
          
          cr_span_days : {1=1 => cr_ld-cr_fd}; 
          cr_tail_days : {1=1 => ROUND(SYSDATE-cr_ld,0)}; 
        
        #doc(,{
                txt:"Minima Maxima and last"
        });  
          
        
          cr_lv => eadv.lab_bld_creatinine.val.last().where(dt>sysdate-365); 
          cr_max_1y => eadv.lab_bld_creatinine.val.max().where(dt>sysdate-365); 
          cr_min_1y_real => eadv.lab_bld_creatinine.val.min().where(dt>sysdate-365);
          
        #doc(,{
                txt:"adjust creatinine for unusually low values due to error"
        }); 
         
          cr_median_1y => eadv.lab_bld_creatinine.val.median().where(dt<cr_ld-90);  
         
          cr_min_1y : { cr_min_1y_real > 40 => cr_min_1y_real},{=> cr_median_1y};  
          
         #doc(,
            {
                txt:"Date of event and window"
            }
        ); 
        
        
          cr_max_ld_1y => eadv.lab_bld_creatinine.dt.max().where(val=cr_max_1y and dt>sysdate-365); 
          win_lb : {1=1 => cr_max_ld_1y-30 };
          win_ub : {1=1 => cr_max_ld_1y+30 };
          
        #doc(,
            {
                txt:"Determine true baseline"
            }
        );

          
          cr_avg_2y => eadv.lab_bld_creatinine.val.avg().where(val<cr_max_1y and val>cr_min_1y and dt>sysdate-730 and dt<cr_ld-30);
          cr_avg_min_1y_qt : {nvl(cr_avg_2y,0)>0 => round(cr_min_1y/cr_avg_2y,1) };
          cr_base : {cr_avg_min_1y_qt<0.5 => cr_avg_2y},{=>cr_min_1y};
          
        #doc(,
            {
                txt:"Calculate proportions
            }
        );
          
        
        
          
          cr_base_max_1y_qt : {nvl(cr_base,0)>0 => round(cr_max_1y/cr_base,1) };
          
          
          cr_base_lv_1y_qt : {nvl(cr_base,0)>0 => round(cr_lv/cr_base,1) };
          
          cr_max_lv_1y_qt : {nvl(cr_lv,0)>0 => round(cr_max_1y/cr_lv,1) };
          
        
        
        #doc(,
            {
                txt:AKI Stage as per AKIN excluding stage 1",
                cite: "tg4100_ref1, tg4100_ref2"
            }
        );
          
         /*Sensitivity adjustment : only for ckd <4 */
         
         
          
          akin_stage : {cr_base_max_1y_qt>2 => 3 },
                        {cr_base_max_1y_qt>1.5 => 2 },
                        {cr_base_max_1y_qt between 1 and 1.5 => 1 },
                        {=>0};
        
        #doc(,
            {
                txt:"AKI context as per baseline function"
            }
        );
          
          
          
          aki_context : { akin_stage>=1 and egfr_base_val>=60 => 1},
                        { akin_stage>=1 and egfr_base_val>30 and egfr_base_val<60 => 2},
                        { akin_stage>=1 and egfr_base_val<30 => 3},{=>0};
        
        #doc(,
            {
                txt:"AKI resolution to baseline"
            }
        );  
          

          
          aki_outcome : {akin_stage>=1 and cr_max_lv_1y_qt>=1 and cr_max_lv_1y_qt<1.2 => 3 },
                        {akin_stage>=1 and cr_max_lv_1y_qt>=1.2 and cr_max_lv_1y_qt<1.7 => 2},
                        {akin_stage>=1 and cr_max_lv_1y_qt>=1.7 => 1};  
          
          ex_flag : {dod!? or rrt>0 or ckd>4 or csu_act_dt!? or dmg_source=999 => 1},{=>0};
          
          
          [[rb_id]] : {cr_base_max_1y_qt>4 and akin_stage>=2 and aki_outcome>=2 and ex_flag=0 => 1 },{=>0};
          
          #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Acute kidney injury in community",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            );
                        
          
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4110';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI from hospital coded diagnosis   */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to generate AKI from hospital coded diagnosis",
                
                is_active:0,
                priority:2
                
            }
        );
        
        #doc(,
            {
                txt:"Based only on ICD 10CM coding"
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        aki_icd => eadv.[icd_n17%].dt.count(0).where(dt>sysdate-180);
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4110._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();



        
        ex_flag : {dod!? or csu_act_dt!? or dmg_source=999 => 1},{=>0};
          
        [[rb_id]] : {aki_icd>0 and ex_flag=0 => 1},{=>0};
          
        
                        
         #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Acute kidney injury in hospital by coding",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    

    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4610';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD2 or 3, rapid progression (20% decline per annum)   */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to generate CKD2 or 3 rapid progression 20% decline per annum ",
                
                is_active:2
                
            }
        );
        
        #doc(,{
                txt:"Get CKD stage"
        });
        
        
        
        age => rout_dmg.age.val.bind();
        
        dod => rout_dmg.dod.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4610._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        ckd_stage => rout_ckd.ckd_stage.val.bind();
        
        cga_a_val => rout_ckd.cga_a_val.val.bind();               
               
        #doc(,{
                txt:"Get last l-1 and maximum where max is earlier than l-1"
        });
        
        egfr_l => eadv.lab_bld_egfr_c._.lastdv().where(dt > sysdate-365);
        
        egfr_l1 => eadv.lab_bld_egfr_c._.lastdv().where(dt < egfr_l_dt and dt>egfr_l_dt - 180);
        
        egfr_max => eadv.lab_bld_egfr_c._.maxldv().where(dt>sysdate-730 and dt < egfr_l1_dt);
        
        #doc(,{
                txt:"Calc slope from max to last"
        });
        
        eb : {egfr_l_dt > egfr_max_dt => round((egfr_l_val-egfr_max_val)/((egfr_l_dt-egfr_max_dt)/365),2)};  
        
        #doc(,{
                txt:"Calc l and l-1 ratio to establish steady within 6 months accepting 20pct variance"
        });
        
        
        egfr_l_l1_qt : { coalesce(egfr_l1_val,0)>0 =>(egfr_l_val/egfr_l1_val)},{=>0};
        
        egfr_ss : { egfr_l_l1_qt>0.8 and egfr_l_l1_qt<1.2 =>1 },{=>0};
        
        #doc(,{
                txt:"Slope threshold for 1 and 2 is -20 per year for 3 onwards -30"
        });
        
        eb_thresh : {ckd<3 => -20},{ckd>=3 and ckd<6 => -30};
        
        
        ckd_null : { nvl(ckd,0)=0 =>1},{=0};
        
        #doc(,{
                txt:"Exclude existing referred or reviewed"
        });
        
        ref_ren => rout_engmnt_renal.ref_renal.val.bind();
        
        enc_ren => rout_engmnt_renal.enc_renal.val.bind();
        
        #doc(,
            {
                txt:"Triggered for stage 1 or 2 with eb of minus 20pc provided no renal encounter",
                cite: "tg4610_ref1"
            }
        );
        
        #doc(,
            {
                txt:"only if slope x is more than 180 and egfr last value less than 80 and max is known"
            }
        );
        
        #doc(,
            {
                txt:"sensitivity adjustment with inclusion of a3 albuminuria"
            }
        );
        ex_flag : {dod!? or enc_ren=1 or ref_ren=1  or dmg_source=0 or age>69 or csu_act_dt!? or dmg_source=999=> 1},{=>0};
          
        [[rb_id]] : {
                        ckd>0 and ckd<6 and nvl(eb,0)<eb_thresh 
                        and egfr_l_dt - egfr_max_dt >180 
                        and egfr_l_val<80 and egfr_max_val is not null 
                        and egfr_ss=1
                        and cga_a_val>3
                        and ex_flag=0 => 1
                    },{=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Unmanaged possible early CKD with rapid progression",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4620';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD4 or 5 rapid progression 5% decline per annum no AVF   */
        
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to generate CKD4 or 5 rapid progression 5% decline per annum no AVF",
                is_active:2
                
            }
        );
        
        #doc(,
            {
                txt:"Get CKD G stage and slope and AVF proc codes"
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        age => rout_dmg.age.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        eb => rout_ckd_egfr_metrics.egfr_slope2.val.bind();
        
        assert_level => rout_ckd.assert_level.val.bind();
        
        ckd_stage =>rout_ckd.ckd_stage.val.bind();
        
        avf => rout_ckd.avf.val.bind();
        
        
        
        ref_ren => rout_engmnt_renal.ref_renal.val.bind();
        
        enc_ren_1y => rout_engmnt_renal.enc_renal_1y.val.bind();
          
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4620._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        #doc(,
            {
                txt:"Triggered for stage 4+ with eb of minus 5pc or more and no avf proc"
                cite: "tg4620_ref1, tg4620_ref2"
            }
        );
        
        ex_flag : {dod!? or enc_ren_1y=1 or age>69 or assert_level<111100 or csu_act_dt!? or dmg_source=999=> 1},{=>0};
          
        [[rb_id]] : {ckd=6  and avf=0 and ex_flag=0 => 1},{=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:No AVF with advanced CKD 4+ with rapid progression",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4720';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to detect new RRT   */
        
         #define_ruleblock(tg4720,
            {
                description: "Algorithm to detect new RRT",
                
                is_active:2
                
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4720._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        hd_dt_min => eadv.icd_z49_1.dt.min();
        hd_n => eadv.icd_z49_1.dt.count(0);
        hd_dt_max => eadv.icd_z49_1.dt.max();
        
        
        
        pd_dt_min => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.min();
        
        
        hd_start : {hd_dt_min > sysdate-90 and hd_n>=10 => 1},{=>0};
          
        pd_start : {pd_dt_min > sysdate-90 => 1},{=>0};
        
        rrt_start :{ .=> greatest_date(hd_dt_min,pd_dt_min)};
        
        ex_flag : {dod!? or dmg_source=999 => 1},{=>0};
          
        tg4720 : { hd_start=1 or pd_start=1 and ex_flag=0 or csu_act_dt!? => 1},{=>0};
        
        #define_attribute(
                tg4720,
                {
                    label:"Alert:New commencement on Renal replacement therapy within last 3 months",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:3
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);      
    -- END OF RULEBLOCK --
       -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4722';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to detect new RRT within 1 year  */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to detect new RRT",
                
                is_active:2
                
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4722._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        hd_dt_min => eadv.icd_z49_1.dt.min();
        hd_n => eadv.icd_z49_1.dt.count(0);
        hd_dt_max => eadv.icd_z49_1.dt.max();
        
        
        
        pd_dt_min => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.min();
        
        
        hd_start : {hd_dt_min > sysdate-365 and hd_n>=10 => 1},{=>0};
          
        pd_start : {pd_dt_min > sysdate-365 => 1},{=>0};
        
        rrt_start :{ .=> greatest_date(hd_dt_min,pd_dt_min)};
        
        ex_flag : {dod!? or csu_act_dt!? or dmg_source=999 => 1},{=>0};
          
        [[rb_id]] : { hd_start=1 or pd_start=1 and ex_flag=0 => 1},{=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:New commencement on Renal replacement therapy within 1 year",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:3
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);      
    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4660';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm medication safety concern in CKD   */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm medication safety concern in CKD ",
                
                is_active:2,
                
                priority:2
                
            }
        );
        
        ckd => rout_ckd.ckd.val.bind();
        
        dod => rout_dmg.dod.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4660._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        #doc(,
            {
                txt:"presence of biguanide sglt2 nsaids ",
                cite: "tg4660_ref1, tg4660_ref2, tg4660_ref3"
            }
        );
        
        
        dm_rxn_bg => rout_cd_dm_dx.dm_rxn_bg.val.bind();
        
        dm_rxn_sglt2 => rout_cd_dm_dx.dm_rxn_sglt2.val.bind();
        
        rx_nsaids => eadv.[rxnc_m01a%].dt.count(0).where(val=1);
        
        #doc(,
            {
                txt:"activate if ckd3+ and above present"
            }
        );
        
        ex_flag : {dod!? or csu_act_dt!? or dmg_source=999=> 1},{=>0};
          
        [[rb_id]] : { ckd>3 and coalesce(dm_rxn_bg,dm_rxn_sglt2) is not null and rx_nsaids >0 and ex_flag=0 => 1},{=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Medication safety concern",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);     
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg2610';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to detect detect untreated chronic disease   */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to detect untreated chronic disease",
                
                is_active:2
                
                
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg2610._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        dm => rout_cd_dm_dx.dm.val.bind();
        
        dm_rxn => rout_cd_dm_dx.dm_rxn.val.bind();
        
        hba1c_n0_val => rout_cd_dm_glyc_cntrl.hba1c_n0_val.val.bind();
        
        cga_a => rout_ckd.cga_a_val.val.bind();
        
        cga_g => rout_ckd.ckd.val.bind();
        
        acr_outdt => rout_ckd.acr_outdated.val.bind();
        
        egfr_outdt => rout_ckd.egfr_outdated.val.bind();
        
        res_outdt : { greatest(acr_outdt,egfr_outdt)>0 =>1},{=>0};
        
        ckd_met : { cga_a >= 3 and cga_g >=1 and cga_g<4 and res_outdt=0 =>1},{=>0};
        
        
        raas_aa => eadv.[rxnc_c09aa].val.lastdv();
        
        raas_ca => eadv.[rxnc_c09ca].val.lastdv();
        
        /*  raas => eadv.[rxnc_c09%].val.lastdv(); */
        
        
        raas_cur : { coalesce(raas_aa_val,0)=1 or coalesce(raas_ca_val,0)=1 =>1},{=>0};
        
        raas_past : { (raas_aa_dt!? or raas_ca_dt!?) and raas_cur=0 =>1 },{=>0};
        
        
        
        sbp => eadv.obs_bp_systolic.val.lastdv();
        
        k => eadv.lab_bld_potassium.val.lastdv();
        
        sbp_safe : { sbp_val> 110 and sbp_dt>sysdate-365 =>1},{=>0};
        
        k_safe : { k_val< 5 and k_dt>sysdate-365 => 1},{=>0};
        
        
        ckd_untreat : { ckd_met=1 and sbp_safe=1 and k_safe=1 and raas_cur=0 =>1},{=>0};
        
        dm_untreat : {dm=1 and nvl(dm_rxn,0)=0 and nvl(hba1c_n0_val,0)>8 => 1},{=>0};
        
        ex_flag : {dod!? or csu_act_dt!? or dmg_source=999=> 1},{=>0};

        #doc(,
            {
                txt:"Chronic diseases include ckd, dm, possibly not on treatment",
                cite: "tg2610_ref1, tg2610_ref2"
            }
        );

        [[rb_id]] : { coalesce(ckd_untreat,dm_untreat)=1 and ex_flag=0 => 1},{=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Potentially untreated chronic disease",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:2
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4810';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to detect high haemoglobin while on ESA  */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to detect high haemoglobin while on ESA",
                
                is_active:2
                
            }
        );
        
        dod => rout_dmg.dod.val.bind();
        
        #doc(,{
                txt:"previous CSU action and assumes that the trigger will never fire again"
        });  
        
        csu_act => eadv.csu_action_tg4810._.lastdv();
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        esa_dt => eadv.rxnc_b03xa.dt.max().where(val=1);
        
        hb_i => eadv.lab_bld_hb.val.lastdv().where(dt>sysdate-180);
        
        hb_i1 => eadv.lab_bld_hb.val.lastdv(1);
        
        ex_flag : {dod!? or csu_act_dt!? or dmg_source=999=> 1},{=>0};

        #doc(,
            {
                txt:"activate if ckd3+ and above present",
                cite: "tg4810_ref1, tg4810_ref2"
            }
        );

        [[rb_id]] : { hb_i_val>130 and esa_dt is not null and hb_i1_val<hb_i_val and esa_dt < hb_i_dt and ex_flag=0 => 1},{=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert: High Hb associated with ESA therapy",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:2
                }
            ); 

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);    
    COMMIT;
    -- END OF RULEBLOCK --
    
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4122';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  CKD stage 4 has not been seen in 12 months (PHC or nephrology)   */
        
         #define_ruleblock([[rb_id]],
            {
                description: "CKD stage 4 has not been seen in 12 months ",
                
                is_active:2
                
            }
        );
        
        age => rout_dmg.age.val.bind();
        
        dod => rout_dmg.dod.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        csu => eadv.csu_action_tg4122.dt.last();

        ren_enc => rout_engmnt_renal.enc_renal.val.bind();

        mbs => eadv.[mbs%].dt.last().where(dt > sysdate - 365);

        ex_flag : {dod!? or csu!? =>1 },{=>0};

          
        [[rb_id]] : {ckd > 4 and ren_enc=0 and mbs? and ex_flag=0 => 1} , {=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Unmanaged possible CKD stage 4",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4123';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  CKD 5 has not been seen in 6 months (PHC or nephrology)   */
        
         #define_ruleblock([[rb_id]],
            {
                description: "CKD 5 has not been seen in 6 months ",
                
                is_active:2
                
            }
        );
        
        age => rout_dmg.age.val.bind();
        
        dod => rout_dmg.dod.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        csu => eadv.csu_action_tg4123.dt.last();

        ren_ec => rout_engmnt_renal.enc_renal.val.bind();

        mbs => eadv.[mbs%].dt.last().where(dt > sysdate - 180);

        ex_flag : {dod!? or csu!? =>1 },{=>0}

          
        [[rb_id]] : {ckd > 5 and ren_enc=0 and mbs? and ex_flag=0 => 1} , {=>0};
        
        #define_attribute(
                [[rb_id]],
                {
                    label:"Alert:Unmanaged possible CKD stage 5",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
END;





