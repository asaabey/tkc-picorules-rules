CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
       
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='bp_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        
        /* Algorithm to plot bp graph  */
        
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to plot bp graph",
               
                is_active:2
                
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        bp_graph_canvas_x : {1=1 => 350};
        
        bp_graph_canvas_y : {1=1 => 100};
        
        htn => rout_cd_htn.cd_htn.val.bind();
        
        /*avg_bp_1y => rout_cd_htn.avg_bp_1y.val.bind();*/
        
        /*sigma_1 => rout_cd_htn.sigma_1.val.bind();*/
        
        sbp_max => rout_cd_htn_bp_control.sbp_max.val.bind();
        
        sbp_min => rout_cd_htn_bp_control.sbp_min.val.bind();
        
        sbp_target_max => rout_cd_htn_bp_control.sbp_target_max.val.bind();
        
        sbp_target_min => rout_cd_htn_bp_control.sbp_target_min.val.bind();
        
        tir => rout_cd_htn_bp_control.sbp_tir_1y.val.bind();
        
        sbp_graph => eadv.obs_bp_systolic.val.serializedv2(round(val,0)~dt).where(dt>sysdate-1825);
        
        sbp_graph_n => eadv.obs_bp_systolic.val.count().where(dt>sysdate-1825);
        
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
        
        
        
        
        [[rb_id]] : {  sbp_graph_n>2 and sbp_graph_val!? =>1},{=>0};
        
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    

END;





