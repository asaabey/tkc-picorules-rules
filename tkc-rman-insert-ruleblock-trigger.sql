CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    
 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4410';
    rb.target_table:='rout_tg4410';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='tg4410';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephrotic syndrome */
        
        /*  Calculate information quotient */
        
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
        
        
        /*  External bindings   */
        rrt => rout_rrt.rrt.val.bind();
        dm => rout_cd_dm.dm.val.bind();
       
          
        
        
        /*  Exclude previously diagnosed nephrotic syndromes from coding */
        
        dx_nephrotic => eadv.[icd_n04%].dt.count(0);
        
        /*  Exclude if renal encounters present */
        
        enc_ren => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
                
        ex_flag :{greatest(rrt,dm,enc_ren,dx_nephrotic)>0 => 1},{=>0};
        
        /*  Inclusion   */
        
        uacr_n => eadv.lab_ua_acr.dt.count(0).where(val>300 and dt>sysdate-365);
        
        uacr1 => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        uacr2 => eadv.lab_ua_acr.val.last(1).where(dt>sysdate-365);
        
        uacr_log_delta : {uacr1>0 and uacr2>0 => round(log(10,uacr1)-log(10,uacr2),1)};
        
        alb1 => eadv.lab_bld_albumin.val.last().where(dt>sysdate-365);
        
        alb2 => eadv.lab_bld_albumin.val.last(1).where(dt>sysdate-365);
        
        chol1 => eadv.lab_bld_cholesterol_total.val.last(1).where(dt>sysdate-365);
        
        
        
        low_alb : {nvl(alb1,0)<30=>1},{=>0};
        high_chol : {nvl(chol1,0)>7=>1},{=>0};
        
        
                
        tg4410 : {ex_flag=0 and uacr1>300 and uacr2>300 and uacr_log_delta>-0.1 => 1 },{=>0};
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4420';
    rb.target_table:='rout_tg4420';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='tg4420';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephritic syndrome */
        
        /*  Calculate information quotient */
        
        iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-365);
        iq_egfr => eadv.lab_bld_egfr.val.count(0).where(dt>sysdate-365);
        iq_urbc => eadv.lab_ua_rbc.val.count(0).where(dt>sysdate-365);
        iq_uleu => eadv.lab_ua_leucocytes.val.count(0).where(dt>sysdate-365);
        
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-365);
        
        iq_ana => eadv.lab_bld_ana.val.count().where(dt>sysdate-(365*5));
        iq_anca => eadv.[lab_bld_anca_pr3,lab_bld_anca_mpo].val.count(0).where(dt>sysdate-(365*5));
        iq_comp => eadv.[lab_bld_complement_c3,lab_bld_complement_c4].val.count(0).where(dt>sysdate-(365*5));
        
        /*  Exclusions */
         /*  External bindings    */
        rrt => rout_rrt.rrt.val.bind();
        
        
        /*  Exclude previously diagnosed nephrotic syndromes from coding */
        
        dx_nephritic => eadv.[icd_n0%].dt.count(0);
        
        /*  Exclude if renal encounters present */
        
        enc_ren => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
                
        ex_flag:{greatest(rrt,enc_ren,dx_nephritic)>0 => 1},{=>0};
        
        /*  Inclusion   */
        
        /*  Urine analysis */        
        
        ua_rbc => eadv.lab_ua_rbc.val.last().where(dt>sysdate-365);
        
        ua_leu => eadv.lab_ua_leucocytes.val.last().where(dt>sysdate-365);
        
        ua_acr => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        
        
        t4420_code : {ua_rbc>100 and ua_leu<40 and ua_acr>30 => 2},
                    {ua_rbc>100 and ua_leu<40 => 1},    
                    {=>0};
        
        t4410 : {t4420_code>=2 => 1},{=>0};            
        
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4100';
    rb.target_table:='rout_tg4100';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='tg4100';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI trigger   */
        
        /*  Exclusions  */  
          rrt => rout_rrt.rrt.val.bind(); 
          
          
          cr_n => eadv.lab_bld_creatinine.dt.count(); 
          cr_fd => eadv.lab_bld_creatinine.dt.min(); 
          cr_ld => eadv.lab_bld_creatinine.dt.max(); 
          cr_span_days : {1=1 => cr_ld-cr_fd}; 
          cr_tail_days : {1=1 => ROUND(SYSDATE-cr_ld,0)}; 
          
          
          /* Minima, Maxima and last */
          cr_lv => eadv.lab_bld_creatinine.val.last().where(dt>sysdate-365); 
          cr_max_1y => eadv.lab_bld_creatinine.val.max().where(dt>sysdate-365); 
          cr_min_1y => eadv.lab_bld_creatinine.val.min().where(dt>sysdate-365);
          
          
          /* Date of event and window */
          cr_max_ld_1y => eadv.lab_bld_creatinine.dt.max().where(val=cr_max_1y and dt>sysdate-365); 
          win_lb : {1=1 => cr_max_ld_1y-30 };
          win_ub : {1=1 => cr_max_ld_1y+30 };
          
          
          /* Determine true baseline */
          cr_avg_2y => eadv.lab_bld_creatinine.val.avg().where(val<cr_max_1y and val>cr_min_1y and dt>sysdate-730);
          cr_avg_min_1y_qt : {cr_avg_2y is not null => round(cr_min_1y/cr_avg_2y,1) };
          cr_base : {cr_avg_min_1y_qt<0.5 => cr_avg_2y},{=>cr_min_1y};
          
          
          /* Calculate proportion */
          cr_base_max_1y_qt : {cr_base is not null => round(cr_max_1y/cr_base,1) };
          cr_base_lv_1y_qt : {cr_base is not null => round(cr_lv/cr_base,1) };
          cr_max_lv_1y_qt : {cr_lv is not null => round(cr_max_1y/cr_lv,1) };
          
          
          akin_stage : {cr_base_max_1y_qt>2 => 3 },{cr_base_max_1y_qt>1.5 => 2 };
          
          aki_outcome : {akin_stage>=1 and cr_max_lv_1y_qt>=1 and cr_max_lv_1y_qt<1.2 => 3 },
                        {akin_stage>=1 and cr_max_lv_1y_qt>=1.2 and cr_max_lv_1y_qt<1.7 => 2},
                        {akin_stage>=1 and cr_max_lv_1y_qt>=1.7 => 1};  
          
          tg4100 : {akin_stage>=2 and aki_outcome>=2 => 1},{=>0};
          
          
                        
          
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4110';
    rb.target_table:='rout_tg4110';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='tg4110';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI from coding   */
        
        aki_icd => eadv.[icd_n17%].dt.count(0).where(dt>sysdate-180);
          
        tg4110 : {aki_icd>0 => 1},{=>0};
          
        tg4110_code : {1=1=> 1};
                        
          
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4610';
    rb.target_table:='rout_tg4610';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='tg4610';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD23 10 pa   */
        
        cga_g => rout_ckd.cga_g.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        eb => rout_ckd.egfr_slope2.val.bind();
        
        egfr_max_v => rout_ckd.egfr_max_v.val.bind();
        
        egfr_max_ld => rout_ckd.egfr_max_ld.val.bind();
        
        egfrld => rout_ckd.egfrld.val.bind();
        egfrlv => rout_ckd.egfrlv.val.bind();
        
        ckd_null : { nvl(ckd,0)=0 =>1},{=0};
        
        enc => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
          
        tg4610 : {cga_g in (`G2`,`G1`) and nvl(eb,0)<-20 and enc=0 and egfrld - egfr_max_ld >180 and egfrlv<80 and egfr_max_v is not null=> 1},{=>0};

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4620';
    rb.target_table:='rout_tg4620';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='tg4620';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD45 10 pa   */
        
        ckd => rout_ckd.ckd.val.bind();
        
        ckd_stage =>rout_ckd.ckd_stage.val.bind();
        
        avf => rout_ckd.avf.val.bind();
        
        eb => rout_ckd.egfr_slope2.val.bind();
        
        enc => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
          
        
          
        tg4620 : {ckd>4 and nvl(eb,0)<-5 and enc=0 => 1},{=>0};

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
END;





