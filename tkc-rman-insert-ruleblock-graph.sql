CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    


    rb.blockid:='egfr_graph2';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute egfr graph 2 */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to serialize egfr",
                    version: "0.0.1.1",
                    blockid: "[[rb_id]]",
                    target_table:"rout_[[rb_id]]",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"[[rb_id]]",
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
            


            egfr_graph => eadv.lab_bld_egfr_c.val.serializedv2(round(val,0)~dt);

            
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
            
            line2_y1 : {1=1 => round((egfr_graph_y_max-egfr_f_val) * y_scale,0) };
            
            line_max_y : {1=1 => round((egfr_graph_y_max - egfr_max_val)*y_scale,0) };
                
            slope1 : { egfr_l_dt - egfr60_last_dt>0 =>round(((egfr_l_val - egfr60_last_val)/(egfr_l_dt - egfr60_last_dt))*365.25,2) },{=>0};
            
            show_slope1 : { slope1 <-5 => 1 },{=>0};
            
            
            txt_upper_y : { 1=1 => line_max_y -5};
            
            txt_lower_y : { 1=1 => line1_y2 - 5};
            
            
            txt_slope1_x : {1=1 => round((line1_x1 + ((egfr_l_dt-egfr60_last_dt)/2))*x_scale,0)};
            
            txt_slope1_y : {1=1 => round((150-50)* y_scale,0)};

            mspan : { egfr_n>0 => round((egfr_l_dt-egfr_f_dt)/12,0)};
            
            
            
            [[rb_id]] : {rrt=0 and egfr_graph_val is not null and egfr_n>2 and mspan>=3 =>1},{=>0};
            
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
   
   
   
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
                    is_active:0,
                    def_exit_prop:"acr_graph",
                    def_predicate:">0",
                    exec_order:2
                    
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
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
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
                    is_active:0,
                    def_exit_prop:"hb_graph",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
            esa => eadv.rxnc_b03xa.val.lastdv();
            
            hb_graph => eadv.lab_bld_hb.val.serializedv2(round(val,0)~dt).where(dt>sysdate-1825);    
            
            hb_distinct => eadv.lab_bld_hb.val.serialize2();
                       
            hb_n => eadv.lab_bld_hb.val.count(0).where(dt>sysdate-365);
            
            hb_fd => eadv.lab_bld_hb.dt.min().where(dt>sysdate-365);
            
            hb_ld => eadv.lab_bld_hb.dt.max().where(dt>sysdate-365);
            
            mspan : { hb_n > 0 => round((hb_ld-hb_fd)/12,0)};
            
            hb_graph_yscale : {1=1 => 10};
            
            hb_graph : {nvl(esa_val,0)>0 and hb_graph_val is not null and hb_n>2 and mspan>=3 =>1},{=>0};
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
       
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='bp_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute bp graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to show BP TIR",
                    version: "0.0.1.1",
                    blockid: "[[rb_id]]",
                    target_table:"rout_[[rb_id]]",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"[[rb_id]]",
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
            
            sbp_graph => eadv.obs_bp_systolic.val.serializedv2(round(val,0)~dt).where(dt>sysdate-1825);    
            
            
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
            
            
            
            
            [[rb_id]] : { (htn >0 and sigma_1 >1) or rrt>0 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='hba1c_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute hba1c graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to show hba1c TIR",
                    version: "0.0.1.1",
                    blockid: "[[rb_id]]",
                    target_table:"rout_[[rb_id]]",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"[[rb_id]]",
                    def_predicate:">0",
                    exec_order:2
                    
                }
            );
            
            hba1c_max => eadv.lab_bld_hba1c_ngsp._.maxldv();
            
            hba1c_min => eadv.lab_bld_hba1c_ngsp._.minldv();
            
            hba1c_f => eadv.lab_bld_hba1c_ngsp._.firstdv();
            
            hba1c_l => eadv.lab_bld_hba1c_ngsp._.lastdv();
            
            
            dspan : { hba1c_l_dt> hba1c_f_dt => hba1c_l_dt - hba1c_f_dt};
            
            dspan_y : { dspan>0 => ceil(dspan/365)};
            
            hba1c_n => eadv.lab_bld_hba1c_ngsp.dt.count();
            
            hba1c_graph_canvas_x : {1=1 => 350};
            
            hba1c_graph_canvas_y : {1=1 => 100};
            
            dm => rout_cd_dm_dx.cd_dm_dx.val.bind();
            
            
            
            hba1c_target_max : { . => 10};
            hba1c_target_min : { . => 6};
            
            
                       
            hba1c_graph => eadv.lab_bld_hba1c_ngsp.val.serializedv2(round(val,0)~dt);    
            
            
            hba1c_graph_y_max : {. => hba1c_max_val};
            
            hba1c_graph_y_min : {hba1c_min_val < hba1c_target_min => hba1c_min_val},{=> hba1c_target_min};
            
            hba1c_graph_x_scale : {. => round(hba1c_graph_canvas_x/dspan,5)};
            
            hba1c_graph_y_scale : { hba1c_graph_y_max > hba1c_graph_y_min => round(hba1c_graph_canvas_y/(hba1c_graph_y_max-hba1c_graph_y_min),5)},{=>round(hba1c_graph_canvas_y/10,5)};
            
            
            
                        
            line_upper_y : {.=> 0};
            
            line_lower_y : {. => (hba1c_graph_y_max-hba1c_graph_y_min) * hba1c_graph_y_scale};
            
            line_target_upper_y : {hba1c_graph_y_min< hba1c_target_max and hba1c_graph_y_max> hba1c_target_max => (hba1c_graph_y_max-10) * hba1c_graph_y_scale};
            
            

            
            [[rb_id]] : { dm=1 and hba1c_n>3 and dspan>365 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='acr_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute acr graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to show acr ",
                    version: "0.0.1.1",
                    blockid: "[[rb_id]]",
                    target_table:"rout_[[rb_id]]",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"[[rb_id]]",
                    def_predicate:">0",
                    exec_order:2
                    
                }
            );
            
            acr_max => eadv.lab_ua_acr._.maxldv();
            
            acr_min => eadv.lab_ua_acr._.minldv();
            
            acr_f => eadv.lab_ua_acr._.firstdv();
            
            acr_l => eadv.lab_ua_acr._.lastdv();
            
            dspan : { acr_l_dt> acr_f_dt => acr_l_dt - acr_f_dt};
            
            dspan_y : { dspan>0 => ceil(dspan/365)};
                        
            acr_n => eadv.lab_ua_acr.dt.count();
            
            acr_n_30 => eadv.lab_ua_acr.val.count();
            
            acr_graph_canvas_x : {1=1 => 350};
            
            acr_graph_canvas_y : {1=1 => 100};

            acr_graph => eadv.lab_ua_acr.val.serializedv2(round(val,0)~dt);    
            
            
            acr_graph_y_max : {. => acr_max_val};
            
            acr_graph_y_min : { . => acr_min_val};
            
            acr_graph_x_scale : {. => round(acr_graph_canvas_x/dspan,5)};
            
            acr_graph_y_scale : { acr_graph_y_max > acr_graph_y_min => round(acr_graph_canvas_y/(acr_graph_y_max-acr_graph_y_min),5)},{=>round(acr_graph_canvas_y/10,5)};
            
                        
            line_upper_y : {.=> 0};
            
            line_lower_y : {. => (acr_graph_y_max-acr_graph_y_min) * acr_graph_y_scale};
            
            
            [[rb_id]] : { acr_n_30>3 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='hb_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute hb graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to show hb",
                    version: "0.0.1.1",
                    blockid: "[[rb_id]]",
                    target_table:"rout_[[rb_id]]",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"[[rb_id]]",
                    def_predicate:">0",
                    exec_order:2
                    
                }
            );
            
            hb_max => eadv.lab_bld_hb._.maxldv().where(dt>sysdate-730);
            
            hb_min => eadv.lab_bld_hb._.minldv().where(dt>sysdate-730);
            
                        
            hb_n => eadv.lab_bld_hb.dt.count().where(dt>sysdate-730);
            
            rrt => rout_rrt.rrt.val.bind();
            
            hb_graph_canvas_x : {1=1 => 350};
            
            hb_graph_canvas_y : {1=1 => 100};
            
            
            hb_target_max : { . => 130};
            hb_target_min : { . => 100};
            
            
                       
            hb_graph => eadv.lab_bld_hb.val.serializedv2(round(val,0)~dt).where(dt>sysdate-730);    
            
            
            hb_graph_y_max : {. => hb_max_val};
            
            hb_graph_y_min : { hb_min_val < hb_target_min => hb_min_val},{=> hb_target_min};
            
            hb_graph_x_scale : {. => round(hb_graph_canvas_x/730,5)};
            
            hb_graph_y_scale : { hb_graph_y_max > hb_graph_y_min => round(hb_graph_canvas_y/(hb_graph_y_max-hb_graph_y_min),5)},{=>round(hb_graph_canvas_y/10,5)};
            
                        
            line_upper_y : {.=> 0};
            
            line_lower_y : {. => (hb_graph_y_max-hb_graph_y_min) * hb_graph_y_scale};
            
            line_target_upper_y : {hb_graph_y_min< hb_target_max and hb_graph_y_max> hb_target_max => (hb_graph_y_max-10) * hb_graph_y_scale};
            
            
            [[rb_id]] : { rrt=1 and hb_n>3 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    

END;





