CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='hba1c_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to plot hba1c graph  */
        
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to plot hba1c graph",
               
                is_active:2
                
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
    
    
    

END;





