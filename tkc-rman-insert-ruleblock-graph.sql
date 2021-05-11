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
                   
                    is_active:2
                    
                }
            );
            
            rrt => rout_rrt.rrt.val.bind();
            
            egfr_n => eadv.lab_bld_egfr_c.val.count(0).where(dt > sysdate - 3650);
            
            egfr_f => eadv.lab_bld_egfr_c.val.firstdv().where(dt > sysdate - 3650);
            
            egfr_l => eadv.lab_bld_egfr_c.val.lastdv().where(dt > sysdate - 3650);
            
            
            egfr_max => eadv.lab_bld_egfr_c.val.maxldv().where(dt > sysdate - 3650);
            
            egfr_min => eadv.lab_bld_egfr_c.val.minldv().where(dt > sysdate - 3650);
            
            
            egfr60_last => eadv.lab_bld_egfr_c.val.lastdv().where(val>60);
            
            
            
            dspan : { . => egfr_l_dt - egfr_f_dt };
            
            yspan : { . => round((dspan/365.25),1)};

            egfr_graph => eadv.lab_bld_egfr_c.val.serializedv2(round(val,0)~dt).where(dt > sysdate - 3650);

            
            egfr_graph_canvas_x : {1=1 => 600};
            
            egfr_graph_canvas_y : {1=1 => 400};
            
            egfr_graph_y_max : {1=1 => egfr_max_val + 10 };
            
            egfr_graph_y_min : {1=1 => egfr_min_val };
            
            
            
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
    
        /* Algorithm to plot acr graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot acr graph ",
                    
                    is_active:2
                    
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
                    
                    is_active:2
                    
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
                    is_active:2
                    
                    
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





