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
        
         #define_ruleblock(tg4410,
            {
                description: "Algorithm to detect nephrotic syndrome",
                version: "0.0.1.1",
                blockid: "tg4410",
                target_table:"rout_tg4410",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:"2",
                def_exit_prop:"tg4410",
                def_predicate:">0",
                exec_order:"5"
                
                
            }
        );
        
        
        #doc(,
            {
                txt:"Calculate information quantity"
            }
        );
        
        
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
        
        
        
        
        
        rrt => rout_rrt.rrt.val.bind();
        dm => rout_cd_dm.dm.val.bind();
       
        #doc(,
            {
                txt:"Exclude previously diagnosed nephrotic and if recent renal encounters"
            }
        );  
        
        
        
        dx_nephrotic => eadv.[icd_n04%].dt.count(0);
        
                
        enc_ren => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
                
        ex_flag :{greatest(rrt,dm,enc_ren,dx_nephrotic)>0 => 1},{=>0};
        
        #doc(,
            {
                txt:"Inclusions"
            }
        );
        
        uacr_n => eadv.lab_ua_acr.dt.count(0).where(val>300 and dt>sysdate-365);
        
        uacr1 => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        uacr2 => eadv.lab_ua_acr.val.last(1).where(dt>sysdate-365);
        
        #doc(,
            {
                txt:"Use delta of log transformed uacr" 
            }
        );
       
        uacr_log_delta : {uacr1>0 and uacr2>0 => round(log(10,uacr1)-log(10,uacr2),1)};
        
        #doc(,
            {
                txt:"Nephrotic associations of albumin and cholesterol"
            }
        );
        
        
        alb1 => eadv.lab_bld_albumin.val.last().where(dt>sysdate-365);
        
        alb2 => eadv.lab_bld_albumin.val.last(1).where(dt>sysdate-365);
        
        chol1 => eadv.lab_bld_cholesterol_total.val.last(1).where(dt>sysdate-365);
        
        
        
        low_alb : {nvl(alb1,0)<30=>1},{=>0};
        high_chol : {nvl(chol1,0)>7=>1},{=>0};
        
        
                
        tg4410 : {ex_flag=0 and uacr1>300 and uacr2>300 and uacr_log_delta>-0.1 => 1 },{=>0};
        
        #define_attribute(
            tg4410,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4420';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephritic syndrome */
        
         #define_ruleblock(tg4420,
            {
                description: "Algorithm to detect nephritic syndrome",
                version: "0.0.1.1",
                blockid: "tg4420",
                target_table:"rout_tg4420",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4420",
                def_predicate:">0",
                exec_order:5,
                priority:2
                
            }
        );
        
        #doc(,
            {
                txt:"Calculate information quantity"
            }
        );
        
        
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
        
        
        
        enc_ren => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
                
        ex_flag:{greatest(rrt,enc_ren,dx_nephritic)>0 => 1},{=>0};
        
        #doc(,
            {
                txt:"Inclusions"
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
        );vvvv
        
        t4420_code : {ua_rbc>100 and ua_leu<40 and ua_acr>30 => 2},
                    {ua_rbc>100 and ua_leu<40 => 1},    
                    {=>0};
        
        tg4420 : {t4420_code>=2 => 1},{=>0};            
        
        #define_attribute(
            tg4420,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4100';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI trigger   */
        
         #define_ruleblock(tg4100,
            {
                description: "Algorithm to detect nephritic syndrome",
                version: "0.0.1.1",
                blockid: "tg4100",
                target_table:"rout_tg4100",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4100",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        #doc(,
            {
                txt:"External bindings"
            }
        );
        
          rrt => rout_rrt.rrt.val.bind(); 
          
        
          cr_n => eadv.lab_bld_creatinine.dt.count(); 
          cr_fd => eadv.lab_bld_creatinine.dt.min(); 
          cr_ld => eadv.lab_bld_creatinine.dt.max(); 
          
          egfr_base => eadv.lab_bld_egfr_c.val.lastdv().where(dt<cr_ld-90 and dt>cr_ld-365);
          
          cr_span_days : {1=1 => cr_ld-cr_fd}; 
          cr_tail_days : {1=1 => ROUND(SYSDATE-cr_ld,0)}; 
        #doc(,
            {
                txt:"Minima Maxima and last"
            }
        );  
          
        
          cr_lv => eadv.lab_bld_creatinine.val.last().where(dt>sysdate-365); 
          cr_max_1y => eadv.lab_bld_creatinine.val.max().where(dt>sysdate-365); 
          cr_min_1y => eadv.lab_bld_creatinine.val.min().where(dt>sysdate-365);
         
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
        
       
          
          cr_avg_2y => eadv.lab_bld_creatinine.val.avg().where(val<cr_max_1y and val>cr_min_1y and dt>sysdate-730);
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
                txt:AKI Stage as per AKIN excluding stage 1"
            }
        );
          
         
          
          akin_stage : {rrt=0 and cr_base_max_1y_qt>2 => 3 },{rrt=0 and cr_base_max_1y_qt>1.5 => 2 },{=>0};
        
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
          
          tg4100 : {akin_stage>=2 and aki_outcome>=2 => 1},{=>0};
          
          #define_attribute(
                tg4100,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4110';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI from coding   */
        
         #define_ruleblock(tg4110,
            {
                description: "Algorithm to detect nephritic syndrome",
                version: "0.0.1.1",
                blockid: "tg4110",
                target_table:"rout_tg4110",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4110",
                def_predicate:">0",
                exec_order:5,
                priority:2
                
            }
        );
        
        #doc(,
            {
                txt:"Based only on ICD 10CM coding"
            }
        );
        
        
        aki_icd => eadv.[icd_n17%].dt.count(0).where(dt>sysdate-180);
          
        tg4110 : {aki_icd>0 => 1},{=>0};
          
        
                        
         #define_attribute(
                tg4110,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4610';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD23 10 pa   */
        
         #define_ruleblock(tg4610,
            {
                description: "Algorithm to generate CKD23 10 pa ",
                version: "0.0.1.1",
                blockid: "tg4610",
                target_table:"rout_tg4610",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4610",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        #doc(,
            {
                txt:"Get CKD G stage and slope"
            }
        );
                cga_g => rout_ckd.cga_g.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        eb => rout_ckd.egfr_slope2.val.bind();
        
        egfr_max_v => rout_ckd.egfr_max_val.val.bind();
        
        egfr_max_ld => rout_ckd.egfr_max_dt.val.bind();
        
        
        
        
        
        egfrld => rout_ckd.egfr_l_dt.val.bind();
        egfrlv => rout_ckd.egfr_l_val.val.bind();
        
        ckd_null : { nvl(ckd,0)=0 =>1},{=0};
        
        enc => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
        #doc(,
            {
                txt:"Triggered for stage 1 or 2 with eb of minus 20pc provided no renal encounter"
            }
        );
        
        #doc(,
            {
                txt:"only if slope x is more than 180 and egfr last value less than 80 and max is known"
            }
        );
          
        tg4610 : {cga_g in (`G2`,`G1`) and nvl(eb,0)<-20 and enc=0 and egfrld - egfr_max_ld >180 and egfrlv<80 and egfr_max_v is not null=> 1},{=>0};
        
        #define_attribute(
                tg4610,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4620';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD45 10 pa without AVF   */
        
        
         #define_ruleblock(tg4620,
            {
                description: "Algorithm to generate CKD45 10 pa without AVF",
                version: "0.0.1.1",
                blockid: "tg4620",
                target_table:"rout_tg4620",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4620",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        #doc(,
            {
                txt:"Get CKD G stage and slope and AVF proc codes"
            }
        );
        
        ckd => rout_ckd.ckd.val.bind();
        
        ckd_stage =>rout_ckd.ckd_stage.val.bind();
        
        avf => rout_ckd.avf.val.bind();
        
        eb => rout_ckd.egfr_slope2.val.bind();
        
        enc => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
          
        #doc(,
            {
                txt:"Triggered for stage 4+ with eb of minus 5pc or more and no avf proc"
            }
        );
        
          
        tg4620 : {ckd>4 and nvl(eb,0)<-5 and enc=0 and avf is null=> 1},{=>0};
        
        #define_attribute(
                tg4620,
                {
                    label:"Alert:Unmanaged advanced CKD with rapid progression",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 

    ';
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
                description: "Algorithm to detect nephritic syndrome",
                version: "0.0.1.1",
                blockid: "tg4720",
                target_table:"rout_tg4720",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4720",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        hd_dt_min => eadv.icd_z49_1.dt.min();
        hd_n => eadv.icd_z49_1.dt.count(0);
        hd_dt_max => eadv.icd_z49_1.dt.max();
        
        pd_dt_min => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.min();
        
        
        hd_start : {hd_dt_min>sysdate-90 and hd_n>=10 => 1},{=>0};
          
        pd_start : {pd_dt_min > sysdate-9 => 1},{=>0};
        
        
          
        tg4720 : { hd_start=1 or pd_start=1 => 1},{=>0};
        
        #define_attribute(
                tg4720,
                {
                    label:"Alert:New commencement on Renal replacement therapy",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2,
                    priority:1
                }
            ); 

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);      
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4660';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm medication safety concern in CKD   */
        
         #define_ruleblock(tg4660,
            {
                description: "Algorithm medication safety concern in CKD ",
                version: "0.0.1.1",
                blockid: "tg4660",
                target_table:"rout_tg4660",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4660",
                def_predicate:">0",
                exec_order:5,
                priority:2
                
            }
        );
        
        ckd => rout_ckd.ckd.val.bind();
        
        #doc(,
            {
                txt:"Exclude if previous cse action"
            }
        );
        
        
        
        csu_act => eadv.csu_action_tg4660_tg4660.val.lastdv();
        
        #doc(,
            {
                txt:"presence of biguanide sglt2 nsaids "
            }
        );
        
        
        dm_rxn_bg => rout_cd_dm.dm_rxn_bg.val.bind();
        
        dm_rxn_sglt2 => rout_cd_dm.dm_rxn_sglt2.val.bind();
        
        rx_nsaids => eadv.[rxnc_m01a%].dt.count(0).where(val=1);
        
        #doc(,
            {
                txt:"activate if ckd3+ and above present"
            }
        );
        
          
        tg4660 : { ckd>3 and coalesce(dm_rxn_bg,dm_rxn_sglt2) is not null and rx_nsaids >0 => 1},{=>0};
        
        #define_attribute(
                tg4660,
                {
                    label:"Alert:Medication safety concern",
                    desc:"Integer [0-1] if meets criteria ",
                    is_reportable:1,
                    is_trigger:1,
                    type:2
                }
            ); 

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);     
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg2610';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to detect untreated dm   */
        
         #define_ruleblock(tg2610,
            {
                description: "Algorithm to detect nephritic syndrome",
                version: "0.0.1.1",
                blockid: "tg2610",
                target_table:"rout_tg2610",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg2610",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        dm => rout_cd_dm.dm.val.bind();
        
        dm_rxn => rout_cd_dm.dm_rxn.val.bind();
        
        hba1c_n0_val => rout_cd_dm.hba1c_n0_val.val.bind();
        
        cga_a => rout_ckd.cga_a_val.val.bind();
        
        cga_g => rout_ckd.ckd.val.bind();
        
        acr_outdt => rout_ckd.acr_outdated.val.bind();
        
        egfr_outdt => rout_ckd.egfr_outdated.val.bind();
        
        res_outdt : { greatest(acr_outdt,egfr_outdt)>0 =>1},{=>0};
        
        ckd_met : { cga_a >= 3 and cga_g >=1 and cga_g<4 and res_outdt=0 =>1},{=>0};
        
        raas => eadv.[rxnc_c09%].val.lastdv();
        
        
        raas_cur : { nvl(raas_val,0)=1 =>1},{=>0};
        raas_past : { raas_dt is not null and raas_val=0 =>1 },{=>0};
        
        
        
        sbp => eadv.obs_bp_systolic.val.lastdv();
        
        k => eadv.lab_bld_potassium.val.lastdv();
        
        sbp_safe : { sbp_val> 110 and sbp_dt>sysdate-365 =>1},{=>0};
        
        k_safe : { k_val< 5 and k_dt>sysdate-365 => 1},{=>0};
        
        
        ckd_untreat : { ckd_met=1 and sbp_safe=1 and k_safe=1 and raas_cur=0 =>1},{=>0};
        
        dm_untreat : {dm=1 and nvl(dm_rxn,0)=0 and nvl(hba1c_n0_val,0)>8 => 1},{=>0};
        
        
          
        tg2610 : { coalesce(ckd_untreat,dm_untreat)=1 => 1},{=>0};
        
        #define_attribute(
                tg2610,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4810';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to detect high haemoglobin while on ESA  */
        
         #define_ruleblock(tg4810,
            {
                description: "Algorithm to detect high haemoglobin while on ESA",
                version: "0.0.1.1",
                blockid: "tg4810",
                target_table:"rout_tg4810",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"tg4810",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        esa_dt => eadv.rxnc_b03xa.dt.max().where(val=1);
        
        hb_i => eadv.lab_bld_hb.val.lastdv().where(dt>sysdate-180);
        
        hb_i1 => eadv.lab_bld_hb.val.lastdv(1);
        
        
          
        tg4810 : { hb_i_val>130 and esa_dt is not null and hb_i1_val<hb_i_val and esa_dt < hb_i_dt=> 1},{=>0};
        
        #define_attribute(
                tg4810,
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);    
    COMMIT;
    -- END OF RULEBLOCK --
END;





