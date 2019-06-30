CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='test_1_1';
    rb.target_table:='rout_' || 'test1';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='test';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Last2 functions*/
        
        egfr_last_val => eadv.lab_bld_egfr_c.val.last();      
        
        egfr_last_dt => eadv.lab_bld_egfr_c.dt.max();
        
        egfr_first_val => eadv.lab_bld_egfr_c.val.first();       
        
        egfr_first_dt => eadv.lab_bld_egfr_c.dt.min();
        
        egfr_max_lv => eadv.lab_bld_egfr_c.val.max();
        
        egfr_max_ld => eadv.lab_bld_egfr_c.dt.max().where(val=egfr_max_lv);
        
        
        egfr_n => eadv.lab_bld_egfr_c.dt.count();
        
        test :  {egfr_last_val > 90 => 1},
                {=>0};
        
            
        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    rb.blockid:='test_2_1';
    rb.target_table:='rout_' || 'test2';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='test';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Last2 functions*/
        
         
        egfr_last2 => eadv.lab_bld_egfr_c.val.lastdv();
        
        egfr_first2 => eadv.lab_bld_egfr_c.val.firstdv();
        
        egfr_max2 => eadv.lab_bld_egfr_c.val.maxldv();
        
        egfr_n => eadv.lab_bld_egfr_c.dt.count();
        
        test :  { egfr_last2_val > 90 => 1},{=>0};
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    
    
END;





