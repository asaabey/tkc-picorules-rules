CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='test1';
    
--    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Test  */
        
        #define_ruleblock(test1,
            {
                description: "This is a test algorithm",
                version: "0.0.0.1",
                blockid: "test1",
                target_table:"rout_test1",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:1,
                def_exit_prop:"test1",
                def_predicate:">0",
                exec_order:1,
                out_att : "test1"
            }
        );
        /*
        neg_def_point => eadv.lab_bld_egfr_c.val.max_neg_delta_dv();
        */
        
        creat_last => eadv.lab_bld_creatinine.val.lastdv();
        
        creat_seq => eadv.lab_bld_creatinine.val.serialize2().where(dt>creat_last_dt-3000);
        
        test1 : { 1=1 => 1},{=>0};
        
        #define_attribute(test1,
            { 
                label: "This is test variable"
            }
        );
        
        

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);


    -- END OF RULEBLOCK --
        COMMIT;
    -- END OF RULEBLOCK --
END;







