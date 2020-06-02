CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cd_cva';
  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess for cva*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess for cva",
                version: "0.1.1.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        
        cva_infarct_dt => eadv.[icd_i63%,icd_i65%,icd_i66%,icd_i67%].dt.min();
        
        cva_hmrage_dt => eadv.[icd_i60%,icd_i61%,icd_i62%].dt.min();
        
        cva_nos_dt =>  eadv.icd_i64.dt.min();
        
        cva_icpc_dt => eadv.[icpc_k90%,icpc_k91%].dt.min();
        
        cva_dt : {.=> least_date(cva_infarct_dt,cva_nos_dt,cva_hmrage_dt,cva_icpc_dt)};
        
        
        [[rb_id]] :  {cva_dt!? => 1},{=>0};
        

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);  
    -- END OF RULEBLOCK --
END;





