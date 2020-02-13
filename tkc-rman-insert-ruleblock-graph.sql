CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    
    
    
--     -- BEGINNING OF RULEBLOCK --
--
--    rb.blockid:='egfr_graph';
--
--    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
--    
--    rb.picoruleblock:='
--    
--        /* Algorithm to compute egfr graph  */
--        
--            
--             #define_ruleblock(egfr_graph,
--                {
--                    description: "Algorithm to serialize egfr",
--                    version: "0.0.1.1",
--                    blockid: "egfr_graph",
--                    target_table:"rout_egfr_graph",
--                    environment:"DEV_2",
--                    rule_owner:"TKCADMIN",
--                    is_active:2,
--                    def_exit_prop:"egfr_graph",
--                    def_predicate:">0",
--                    exec_order:1
--                    
--                }
--            );
--            
--            rrt => rout_rrt.rrt.val.bind();
--            
--            
--            egfr_graph => eadv.lab_bld_egfr_c.val.serializedv(round(val,0)~dt);
--            
--            egfr_n => eadv.lab_bld_egfr_c.val.count(0);
--            
--                        
--            egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
--            
--            egfr_l => eadv.lab_bld_egfr_c.val.lastdv();
--            
--            dspan : {1=1 => egfr_l_dt - egfr_f_dt };
--            
--            s1_mu => eadv.lab_bld_egfr_c.val.avg().where(dt < (egfr_l_dt -(dspan/2)));
--            
--            s2_mu => eadv.lab_bld_egfr_c.val.avg().where(dt > (egfr_f_dt +(dspan/2)));
--            
--            mu_delta_30 : { s1_mu - s2_mu >30 =>1},{=>0};
--            
--            egfr_graph_xline_60 => eadv.lab_bld_egfr_c.dt.max().where(val>60);
--            
--            egfr60_last => eadv.lab_bld_egfr_c.val.lastdv().where(val>60);
--   
--            graph_canvas_x : {1=1 => 600};
--            
--            graph_canvas_y : {1=1 => 400};
--            
--            graph_y_max : {1=1 => 150};
--            
--            graph_y_min : {1=1 => 0};
--            
--            x_scale : {dspan>0 => round(graph_canvas_x/dspan,1)};
--            
--            
--            y_scale : {1=1 => round(graph_canvas_y/graph_y_max,1)};
--            
--            
--            line1_x1 : {1=1 => round(( egfr60_last_dt - egfr_f_dt )* x_scale,0) };
--            
--            line1_x2 : {1=1 => round(( egfr_l_dt - egfr_f_dt )* x_scale,0) };
--            
--            line1_y1 : {1=1 => round((graph_y_max-egfr60_last_val) * y_scale,0) };
--            
--            line1_y2 : {1=1 => round((graph_y_max-egfr_l_val) * y_scale,0) };
--                
--            
--
--            mspan : { egfr_n>0 => round((egfr_l_dt-egfr_f_dt)/12,0)};
--            
--            egfr_graph_yscale : {1=1 => 10};
--            
--            egfr_graph : {rrt=0 and egfr_graph_val is not null and egfr_n>2 and mspan>=3 =>1},{=>0};
--            
--    ';
--    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
--    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
--    
--    COMMIT;
--    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='egfr_graph2';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute egfr graph 2 */
        
            
             #define_ruleblock(egfr_graph2,
                {
                    description: "Algorithm to serialize egfr",
                    version: "0.0.1.1",
                    blockid: "egfr_graph2",
                    target_table:"rout_egfr_graph2",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"egfr_graph2",
                    def_predicate:">0",
                    exec_order:2
                    
                }
            );
            
            rrt => rout_rrt.rrt.val.bind();
            
            egfr_n => eadv.lab_bld_egfr_c.val.count(0);
            
            egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
            
            egfr_l => eadv.lab_bld_egfr_c.val.lastdv();
            
            
            egfr_max => eadv.lab_bld_egfr_c.val.maxldv();
            
            egfr_min => eadv.lab_bld_egfr_c.val.minldv();
            
            
            egfr60_last => eadv.lab_bld_egfr_c.val.lastdv().where(val>60);
            
            
            
            dspan : {1=1 => egfr_l_dt - egfr_f_dt };
            
            egfr_graph => eadv.lab_bld_egfr_c.val.serializedv(round(val,0)~dt).where(dt > sysdate-365);
            
            egfr_graph_canvas_x : {1=1 => 600};
            
            egfr_graph_canvas_y : {1=1 => 400};
            
            egfr_graph_y_max : {1=1 => 150};
            
            egfr_graph_y_min : {1=1 => 0};
            
            
            
            x_scale : { dspan >0 => round(egfr_graph_canvas_x / dspan,5)};
            
            
            y_scale : {1=1 => round( egfr_graph_canvas_y /( egfr_graph_y_max - egfr_graph_y_min),5)};
            
            
            line1_x1 : {1=1 => round(( egfr60_last_dt - egfr_f_dt )* x_scale,0) };
            
            line1_x2 : {1=1 => round(( egfr_l_dt - egfr_f_dt )* x_scale,0) };
            
            line1_y1 : {1=1 => round((egfr_graph_y_max-egfr60_last_val) * y_scale,0) };
            
            line1_y2 : {1=1 => round((egfr_graph_y_max-egfr_l_val) * y_scale,0) };
                
            slope1 : { egfr_l_dt - egfr60_last_dt>0 =>round(((egfr_l_val - egfr60_last_val)/(egfr_l_dt - egfr60_last_dt))*365.25,2) },{=>0};
            
            show_slope1 : { slope1 <-5 => 1 },{=>0};
            
            txt_slope1_x : {1=1 => round((line1_x1 + ((egfr_l_dt-egfr60_last_dt)/2))*x_scale,0)};
            
            txt_slope1_y : {1=1 => round((150-50)* y_scale,0)};

            mspan : { egfr_n>0 => round((egfr_l_dt-egfr_f_dt)/12,0)};
            
            
            
            egfr_graph2 : {rrt=0 and egfr_graph_val is not null and egfr_n>2 and mspan>=3 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
--         -- BEGINNING OF RULEBLOCK --
--
--    rb.blockid:='egfr_graph2';
--
--    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
--    
--    rb.picoruleblock:='
--    
--        /* Algorithm to compute egfr graph 2 */
--        
--            
--             #define_ruleblock(egfr_graph2,
--                {
--                    description: "Algorithm to serialize egfr",
--                    version: "0.0.1.1",
--                    blockid: "egfr_graph2",
--                    target_table:"rout_egfr_graph2",
--                    environment:"DEV_2",
--                    rule_owner:"TKCADMIN",
--                    is_active:2,
--                    def_exit_prop:"egfr_graph2",
--                    def_predicate:">0",
--                    exec_order:2
--                    
--                }
--            );
--            
--            rrt => rout_rrt.rrt.val.bind();
--            
--            egfr_n => rout_egfr_metrics.egfr_n.val.bind();
--            
--            egfr_f_dt => rout_egfr_metrics.egfr_r1_dt.val.bind();
--            
--            egfr_f_val => rout_egfr_metrics.egfr_r1_val.val.bind();
--            
--            egfr_l_dt => rout_egfr_metrics.egfr_rn_dt.val.bind();
--            
--            egfr_l_val => rout_egfr_metrics.egfr_rn_val.val.bind();
--            
--            egfr_max_dt => rout_egfr_metrics.egfr_max_dt.val.bind();
--            
--            egfr_max_val => rout_egfr_metrics.egfr_max_val.val.bind();
--            
--            egfr_min_dt => rout_egfr_metrics.egfr_min_dt.val.bind();
--            
--            egfr_min_val => rout_egfr_metrics.egfr_min_val.val.bind();
--            
--            egfr60_last_dt => rout_egfr_metrics.egfr60_last_dt.val.bind();
--            
--            egfr60_last_val => rout_egfr_metrics.egfr60_last_val.val.bind();
--            
--            
--            
--            
--            egfr_graph => eadv.lab_bld_egfr_c.val.serializedv(round(val,0)~dt);
--            
--            dspan : {1=1 => egfr_l_dt - egfr_f_dt };
--            
--        
--            
--   
--   
--           
--
--            mspan : { egfr_n>0 => round((egfr_l_dt-egfr_f_dt)/12,0)};
--            
--            
--            
--            egfr_graph2 : {rrt=0 and egfr_graph_val is not null and egfr_n>2 and mspan>=3 =>1},{=>0};
--            
--    ';
--    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
--    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
--    
--    COMMIT;
--    -- END OF RULEBLOCK --
   
   
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='acr_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute acr graph  */
        
            
             #define_ruleblock(acr_graph,
                {
                    description: "Algorithm to serialize acr",
                    version: "0.0.1.1",
                    blockid: "acr_graph",
                    target_table:"rout_acr_graph",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"acr_graph",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
            rrt => rout_rrt.rrt.val.bind();
            
            acr_graph => eadv.lab_ua_acr.val.serializedv(abs(round(log(10,val+1),1))~dt);
            
            acr_n => eadv.lab_ua_acr.val.count(0);
            
            acr_fd => eadv.lab_ua_acr.dt.min();
            
            acr_ld => eadv.lab_ua_acr.dt.max();
            
            mspan : { acr_n > 0 => round((acr_ld-acr_fd)/12,0)};
            
            acr_graph_yscale : {1=1 => 0.25};
            
            acr_graph : {rrt=0 and acr_graph_val is not null and acr_n>2 and mspan>=3 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='hb_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute hb graph  */
        
            
             #define_ruleblock(hb_graph,
                {
                    description: "Algorithm to serialize hb",
                    version: "0.0.1.1",
                    blockid: "hb_graph",
                    target_table:"rout_hb_graph",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"hb_graph",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
            esa => eadv.rxnc_b03xa.val.lastdv();
            
            hb_graph => eadv.lab_bld_hb.val.serializedv(round(val,0)~dt).where(dt>sysdate-730);    
            
            hb_distinct => eadv.lab_bld_hb.val.serialize2();
                       
            hb_n => eadv.lab_bld_hb.val.count(0).where(dt>sysdate-365);
            
            hb_fd => eadv.lab_bld_hb.dt.min().where(dt>sysdate-365);
            
            hb_ld => eadv.lab_bld_hb.dt.max().where(dt>sysdate-365);
            
            mspan : { hb_n > 0 => round((hb_ld-hb_fd)/12,0)};
            
            hb_graph_yscale : {1=1 => 10};
            
            hb_graph : {nvl(esa_val,0)>0 and hb_graph_val is not null and hb_n>2 and mspan>=3 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
       
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='bp_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute bp graph  */
        
            
             #define_ruleblock(bp_graph,
                {
                    description: "Algorithm to show BP TIR",
                    version: "0.0.1.1",
                    blockid: "bp_graph",
                    target_table:"rout_bp_graph",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"bp_graph",
                    def_predicate:">0",
                    exec_order:2
                    
                }
            );
            
            rrt => rout_rrt.rrt.val.bind();  
            
            bp_graph_canvas_x : {1=1 => 350};
            
            bp_graph_canvas_y : {1=1 => 100};
            
            htn => rout_cd_htn.htn.val.bind();
            
            sigma_1 => rout_cd_htn.sigma_1.val.bind();
            
            sbp_max => rout_cd_htn.sbp_max_2y.val.bind();
            
            sbp_min => rout_cd_htn.sbp_min_2y.val.bind();
            
            sbp_target_max => rout_cd_htn.sbp_target_max.val.bind();
            
            sbp_target_min => rout_cd_htn.sbp_target_min.val.bind();
            
            tir => rout_cd_htn.n_qt_1.val.bind();
            
            sbp_graph => eadv.obs_bp_systolic.val.serializedv(round(val,0)~dt).where(dt>sysdate-730);    
            
            
            bp_graph_y_max : {1=1 => sbp_max};
            
            bp_graph_y_min : {sbp_min < sbp_target_min => sbp_min},{=> sbp_target_min};
            
            bp_graph_x_scale : {1=1 => round(bp_graph_canvas_x/730,5)};
            
            bp_graph_y_scale : { bp_graph_y_max > bp_graph_y_min => round(bp_graph_canvas_y/(bp_graph_y_max-bp_graph_y_min),5)},{=>round(bp_graph_canvas_y/10,5)};
            
            
            
            tir_pct : {1=1 => tir*100};
            
            
            
            radius : {1=1 => 25};
            
            circum : {1=1 => radius * 2* 3.14159 };
            
            tir_arc : {1=1 => tir_pct * circum/100};
            
            pie_colour : { tir>=0.7 => `green`},{ tir>=0.5 and tir<0.7=> `orange`},{ tir<0.5 => `tomato`};
            
            
            line_upper_y : {1=1 => 0};
            
            line_lower_y : {1=1 => (bp_graph_y_max-bp_graph_y_min) * bp_graph_y_scale};
            
            line_target_upper_y : {bp_graph_y_min< sbp_target_max and bp_graph_y_max> sbp_target_max => (bp_graph_y_max-140) * bp_graph_y_scale};
            
            
            
            
            bp_graph : { (htn >0 and sigma_1 >1) or rrt>0 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='multi_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute multi_graph  */
        
            
             #define_ruleblock(multi_graph,
                {
                    description: "Algorithm to show multi_graph",
                    version: "0.0.1.1",
                    blockid: "multi_graph",
                    target_table:"rout_multi_graph",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"multi_graph",
                    def_predicate:">0",
                    exec_order:2
                    
                }
            );
            

            
            hb0 => eadv.lab_bld_hb.val.lastdv();
            
            hb1 => eadv.lab_bld_hb.val.lastdv(1);
            
            hb_ref_u : {1=1 =>150};
            
            hb_ref_l : {1=1 =>100};
            
            hb_mu : {1=1 => (hb_ref_u + hb_ref_l)/2};
            
            hb0_y : { 1=1 => (300/hb_mu) * hb0_val};
            
            hb1_y : { 1=1 => (300/hb_mu) * hb1_val};
            
            multi_graph_canvas_x : {1=1 => 350};
            
            multi_graph_canvas_y : {1=1 => 100};
            
            
            
            multi_graph : { hb0_val>0 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
END;





