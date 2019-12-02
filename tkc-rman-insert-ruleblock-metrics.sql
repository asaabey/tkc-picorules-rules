CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='egfr_metrics';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute egfr metrics  */
        
            
             #define_ruleblock(egfr_metrics,
                {
                    description: "Algorithm to derive egfr metrics",
                    version: "0.0.1.1",
                    blockid: "egfr_metrics",
                    target_table:"rout_egfr_metrics",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"egfr_metrics",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
                       
            
            
            egfr_n => eadv.lab_bld_egfr_c.val.count(0);
            
            egfr_r1 => eadv.lab_bld_egfr_c.val.firstdv();
            
            egfr_rn => eadv.lab_bld_egfr_c.val.lastdv();
            
            egfr_rn1 => eadv.lab_bld_egfr_c.val.lastdv(1);
            
            egfr_max => eadv.lab_bld_egfr_c.val.maxldv();
            
            egfr_min => eadv.lab_bld_egfr_c.val.minldv();
            
            qt_r1_max : { egfr_r1_val>0 => round(egfr_max_val/egfr_r1_val,1)};

            qt_rn_min : { egfr_min_val>0 => round(egfr_rn_val/egfr_min_val,1)};
            
            qt_rn_rn1 : { egfr_rn1_val>0 => round(egfr_rn_val/egfr_rn1_val,1)};
            
            r1_stg : { egfr_r1_val>=90 => 1},{ egfr_r1_val>=60 => 2},{ egfr_r1_val>=45 => 3},{ egfr_r1_val>=30 => 4},{ egfr_r1_val>=15 => 5},{ egfr_r1_val<15 => 6},{=>0};
            
            rn_stg : { egfr_rn_val>=90 => 1},{ egfr_rn_val>=60 => 2},{ egfr_rn_val>=45 => 3},{ egfr_rn_val>=30 => 4},{ egfr_rn_val>=15 => 5},{ egfr_rn_val<15 => 6},{=>0};
            
            rmax_stg : { egfr_max_val>=90 => 1},{ egfr_max_val>=60 => 2},{ egfr_max_val>=45 => 3},{ egfr_max_val>=30 => 4},{ egfr_max_val>=15 => 5},{ egfr_max_val<15 => 6},{=>0};
            
            rmin_stg : { egfr_min_val>=90 => 1},{ egfr_min_val>=60 => 2},{ egfr_min_val>=45 => 3},{ egfr_min_val>=30 => 4},{ egfr_min_val>=15 => 5},{ egfr_min_val<15 => 6},{=>0};
            
            gap_fl : { egfr_n>1 => egfr_rn_val-egfr_r1_val};
            
            gap_maxl : { egfr_n>1 => egfr_rn_val-egfr_max_val};
            
            
            egfr60_last => eadv.lab_bld_egfr_c.val.lastdv().where(val>60);
            
            p1_disc : { nvl(qt_r1_max,0)>1.5 =>1},{=>0};
            
            p3_disc : { nvl(qt_rn_min,0)>1.5 =>1},{=>0};
            
            p3_egfr45_n => eadv.lab_bld_egfr_c.val.count().where(val>45 and dt>egfr60_last_dt);
            
            p3pg_signal : {p3_egfr45_n>2 and egfr_rn_dt-egfr60_last_dt>=180 =>1},{=>0};
            
            p3rc_signal : {egfr_rn_val>20 and qt_rn_rn1>1.2 => 1},{=>0};
            
            p3_slope : { p3pg_signal=1 => (round((egfr_rn_val-egfr60_last_val)/(egfr_rn_dt-egfr60_last_dt),3))},{=>null};
            
            p3_b1 => eadv.lab_bld_egfr_c.val.regr_slope().where(dt>egfr60_last_dt);
            
            p3_b0 => eadv.lab_bld_egfr_c.val.regr_intercept().where(dt>egfr60_last_dt);
            
            p3_r2 => eadv.lab_bld_egfr_c.val.regr_r2().where(dt>egfr60_last_dt);
            
            px_b1 => eadv.lab_bld_egfr_c.val.regr_slope();
            
            px_b0 => eadv.lab_bld_egfr_c.val.regr_intercept();
            
            px_r2 => eadv.lab_bld_egfr_c.val.regr_r2();
            
            est_esrd_d : { nvl(p3_slope,0)<0 and egfr_rn_val>=5 => (5-egfr_rn_val)/p3_slope};

            est_esrd_dt : { nvl(est_esrd_d,0)>0 and nvl(est_esrd_d,0)<1500 => (egfr_rn_dt + est_esrd_d)};
            
            est_esrd_lapsed : { sysdate>est_esrd_dt => 1};
            
            gap_max => eadv.lab_bld_egfr_c.val.max_neg_delta_dv();
            
            mspan : { egfr_n>0 => round((egfr_rn_dt-egfr_r1_dt)/365.25,0)};
            
            n_avg : { mspan>0 => round(egfr_n/mspan,1)};
            
            
            egfr_metrics : {1=1 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='egfr_metrics';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute egfr metrics  */
        
            
             #define_ruleblock(egfr_metrics,
                {
                    description: "Algorithm to derive egfr metrics",
                    version: "0.0.1.1",
                    blockid: "egfr_metrics",
                    target_table:"rout_egfr_metrics",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"egfr_metrics",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
                       
            rrt => rout_rrt.rrt.val.bind();
            
            egfr_n => eadv.lab_bld_egfr_c.val.count(0);
            
            egfr_r1 => eadv.lab_bld_egfr_c.val.firstdv();
            
            egfr_rn => eadv.lab_bld_egfr_c.val.lastdv();
            
            egfr_rn1 => eadv.lab_bld_egfr_c.val.lastdv(1);
            
            egfr_max => eadv.lab_bld_egfr_c.val.maxldv();
            
            egfr_min => eadv.lab_bld_egfr_c.val.minldv();
            
           
            
            egfr60 => eadv.lab_bld_egfr_c.val.lastdv().where(val>60);
            
            slope_2v : { egfr_rn_dt > egfr60_dt and egfr_rn_val > 45=> (egfr_rn_val-egfr60_val)/(egfr_rn_dt-egfr60_dt)}; 

            slope_regr => eadv.lab_bld_egfr_c.val.regr_slope().where(dt > egfr60_dt);
            
            qt_b1 : { rrt=0 and nvl(abs(slope_2v),0)>0 => round((slope_regr/slope_2v),2) };
            
            egfr_metrics : {1=1 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
   
   
   
END;





