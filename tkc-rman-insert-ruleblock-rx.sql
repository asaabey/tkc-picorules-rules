CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='rx_desc';
    rb.target_table:='rout_rx_desc';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=0 ;
    rb.def_exit_prop:='rx_desc';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess Medication  */
        
            
            
            
            
            rxn_0 => eadv.[rxnc_%].dt.count().where(val=1);
            
            rx_name_obj => vw_eadv_rx.rx_desc.val.serialize().where(dt>sysdate-1000);
            
            rx_desc : {nvl(rxn_0,0)>0 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,1);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
END;





