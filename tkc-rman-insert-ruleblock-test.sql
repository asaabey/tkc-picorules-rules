CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='test1';
    rb.target_table:='rout_test1';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='test1';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Test  */
        
        uacr0 => eadv.lab_ua_acr.val.lastdv().where(dt>sysdate-365);
        
        uacr_done : { uacr0_dt is not null =>1},{=>0};
        
        #def(uacr_done,
            { 
                label: "This is test variable", 
                is_trigger:true, 
                is_reportable:true
            }
        );
        
        

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,5);

    -- END OF RULEBLOCK --
        COMMIT;
    -- END OF RULEBLOCK --
END;





