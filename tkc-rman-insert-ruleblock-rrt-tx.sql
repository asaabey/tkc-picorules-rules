CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_tx';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Tx metrics*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Tx metrics",
                is_active:2,
                filter: "SELECT eid FROM rout_rrt WHERE rrt=3"
                
            }
        );

        #doc(,
            {
                txt : "Transplant graft status"
            }
        );
        
        tx_dt => rout_rrt.tx_dt.val.bind();
        
        
        cr_min => eadv.lab_bld_creatinine._.minfdv().where(dt > tx_dt);
        
        cr_last => eadv.lab_bld_creatinine._.lastdv().where(dt > tx_dt);
        
        enc_op_ld => eadv.enc_op_ren_rnt.dt.last();
        
        rx_l04ad => eadv.rxnc_l04ad.dt.last().where(val=1);
        
        tdm_tac => eadv.lab_bld_tdm_tacrolimus._.lastdv().where(dt > sysdate-365);
        
        rx_l04aa => eadv.rxnc_l04aa.dt.last().where(val=1);
        
        tdm_evl => eadv.lab_bld_tdm_everolimus._.lastdv().where(dt > sysdate-365);
        
        rx_l04ax => eadv.rxnc_l04ax.dt.last().where(val=1);
        
        
        rx_h02ab => eadv.rxnc_l04ab.dt.last().where(val=1);
        
        tac : { rx_l04ad!? and tdm_tac_val>2 =>1},{=>0};
        
        evl : { rx_l04aa!? and tdm_evl_val>2 =>1},{=>0};
        
        rxn : { coalesce(rx_l04ad,rx_l04aa,rx_l04ax,rx_h02ab)!? => 1},{=>0};
        
        tac_c0 => eadv.lab_bld_tdm_tacrolimus._.lastdv();
        
        
        [[rb_id]] : { cr_min_val!? and rxn>0 =>1},{=>0};
        
        #define_attribute(
            [[rb_id]] ,
            {
                label:"Graft function known and therapy",
                is_reportable:1,
                type:2
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
  
END;





