CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
       
    
        -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cd_dyslip';
  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess for dyslipidaemia*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess for cd_dyslipidaemia",
                version: "0.1.1.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:6
                
            }
        );
        
        
        ascvd => rout_cvra.cvd_prev.val.bind();
        
        dyslip_code_dt => eadv.[icd_e78%,icpc_t93%].dt.min();
        
        ldl => eadv.lab_bld_cholesterol_ldl._.lastdv().where(dt>sysdate-365);
        
        ldl_unl : { ascvd=1 => 1.8},{=>4.9};
        
        ldl_subopt : { (ldl_val/ldl_unl)>1.2 =>1},{=>0};
        
        
        [[rb_id]] :  {(ascvd=1 and nvl(ldl_val,0)>1.8) or nvl(ldl_val,0)>4.9 or dyslip_code_dt!? => 1},{=>0};
  
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);  
    -- END OF RULEBLOCK --
END;





