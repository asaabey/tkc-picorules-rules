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
            
            egfr_max => eadv.lab_bld_egfr_c.val.maxldv();
            
            gap_fl : { egfr_n>1 => egfr_rn_val-egfr_r1_val};
            
            gap_maxl : { egfr_n>1 => egfr_rn_val-egfr_max_val};
            
            
            egfr60_last => eadv.lab_bld_egfr_c.val.lastdv().where(val>60);
            
            crash_pt => eadv.lab_bld_egfr_c.dt.max().where(val>60);
            
            gap_max => eadv.lab_bld_egfr_c.val.max_neg_delta_dv();
            
            mspan : { egfr_n>0 => round((egfr_rn_dt-egfr_r1_dt)/365.25,0)};
            
            n_avg : { mspan>0 => round(egfr_n/mspan,1)};
            
            
            egfr_metrics : {1=1 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
   
   
END;





