CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='egfr_graph';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to compute egfr graph  */
        
            
             #define_ruleblock(egfr_graph,
                {
                    description: "Algorithm to serialize egfr",
                    version: "0.0.1.1",
                    blockid: "egfr_graph",
                    target_table:"rout_egfr_graph",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"egfr_graph",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
            rrt=> rout_rrt.rrt.val.bind();
            
            egfr_graph => eadv.lab_bld_egfr_c.val.serializedv(round(val,0)~dt);
            
            egfr_n => eadv.lab_bld_egfr_c.val.count(0);
            
            egfr_fd => eadv.lab_bld_egfr_c.dt.min();
            
            egfr_ld => eadv.lab_bld_egfr_c.dt.max();
            
            egfr_graph_xline_60 => eadv.lab_bld_egfr_c.dt.max().where(val>60);
            
            mspan : { egfr_n>0 => round((egfr_ld-egfr_fd)/12,0)};
            
            egfr_graph_yscale : {1=1 => 10};
            
            egfr_graph : {rrt=0 and egfr_graph_val is not null and egfr_n>2 and mspan>=3 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
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
            
            hb_graph => eadv.lab_bld_hb.val.serializedv(round(val,0)~dt).where(dt>sysdate-365);    
                       
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
END;




