CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    


    rb.blockid:='egfr_graph2';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to plot egfr graph 2 */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot egfr graph 2",
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

    rb.blockid:='bp_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to plot bp graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot bp graph",
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
            
            
            
            
            [[rb_id]] : { htn >0  or rrt>0 =>1},{=>0};
            
            
            
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
    
        /* Algorithm to plot hba1c graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot hba1c graph",
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
    
        /* Algorithm to plot acr graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot acr graph ",
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
            
            
            [[rb_id]] : { acr_n_30>3 and rrt=0 =>1},{=>0};
            
            
            
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
    
        /* Algorithm to plot hb graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot hb graph",
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
    
    
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='phos_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to plot phosphate graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot phosphate graph",
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
            
            phos_max => eadv.lab_bld_phosphate._.maxldv().where(dt>sysdate-730);
            
            phos_min => eadv.lab_bld_phosphate._.minldv().where(dt>sysdate-730);
            
                        
            phos_n => eadv.lab_bld_phosphate.dt.count().where(dt>sysdate-730);
            
            rrt => rout_rrt.rrt.val.bind();
            
            phos_graph_canvas_x : {1=1 => 350};
            
            phos_graph_canvas_y : {1=1 => 100};
            
            
            phos_target_max : { . => 1.7};
            phos_target_min : { . => 1.1};
            
            
                       
            phos_graph => eadv.lab_bld_phosphate.val.serializedv2(round(val,1)~dt).where(dt>sysdate-730);    
            
            
            phos_graph_y_max : {. => greatest(phos_max_val,phos_target_max)};
            
            phos_graph_y_min : {. => least(phos_min_val,phos_target_min)};
            
            phos_graph_x_scale : {. => round(phos_graph_canvas_x/730,5)};
            
            phos_graph_y_scale : { . => round(phos_graph_canvas_y/(phos_graph_y_max-phos_graph_y_min),5)};
            
                        
            line_upper_y : {.=> 0};
            
            line_lower_y : {. => 100};
            
            
            line_target_upper_y : { phos_max_val > phos_target_max => (phos_max_val - phos_target_max) * phos_graph_y_scale },{ => 0 };
            
            line_target_lower_y : { phos_min_val < phos_target_min => (phos_target_min - phos_min_val) * phos_graph_y_scale },{ => phos_graph_canvas_y };
            [[rb_id]] : { rrt in (1,2,4) and phos_n>3 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    

END;





