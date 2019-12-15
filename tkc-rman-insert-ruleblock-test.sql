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
        
        
        
        
        
        creat_pat => eadv.lab_bld_creatinine.val.match((p1+p2+p3+)~ 
            p1 AS ( val * 80/100 < prev(val) ),
            p2 AS ( val * 80/100 > prev(val) ),
            p3 AS ( val * 80/100 < prev(val) )
            );
        
        
        test1 : {1=1 =>1};
        
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







