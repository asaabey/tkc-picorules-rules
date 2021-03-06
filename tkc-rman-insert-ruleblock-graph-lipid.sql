CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ldl_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to plot LDL graph  */
        
            
             #define_ruleblock([[rb_id]],
                {
                    description: "Algorithm to plot LDL graph",
                    is_active:2
                    
                    
                }
            );
            
            dyslip => rout_cd_dyslip.cd_dyslip.val.bind();
            
            g_max => eadv.lab_bld_cholesterol_ldl._.maxldv();
            
            g_min => eadv.lab_bld_cholesterol_ldl._.minldv();
                        
            g_n => eadv.lab_bld_cholesterol_ldl.dt.count();
            
            g_graph => eadv.lab_bld_cholesterol_ldl.val.serializedv2(round(val,1)~dt);
            
            
            g_graph_canvas_x : { . => 350};
            
            g_graph_canvas_y : { . => 100};
            
            
            g_target_max : { . => 4.0};
            g_target_min : { . => 1.0};
            
            
                       
                
            
            
            g_graph_y_max : {. => greatest(g_max_val,g_target_max)};
            
            g_graph_y_min : {. => least(g_min_val,g_target_min)};
            
            g_graph_x_scale : {. => round(g_graph_canvas_x/730,5)};
            
            g_graph_y_scale : { . => round(g_graph_canvas_y/(g_graph_y_max-g_graph_y_min),5)};
            
                        
            line_upper_y : {.=> 0};
            
            line_lower_y : {. => 100};
            
            
            line_target_upper_y : { g_max_val > g_target_max => (g_max_val - g_target_max) * g_graph_y_scale },{ => 0 };
            
            line_target_lower_y : { g_min_val < g_target_min => (g_target_min - g_min_val) * g_graph_y_scale },{ => g_graph_canvas_y };
            
            canddt : { dyslip>0 and g_n>2 =>1},{=>0};
            
            [[rb_id]] : { canddt=1 =>1},{=>0};
            
            
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    

END;





