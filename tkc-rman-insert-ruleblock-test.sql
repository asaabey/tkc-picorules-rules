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
                out_att : "test1",
                filter : "6811"
                
            }
        );
        
        
        
        
      
        creat_pat => eadv.lab_bld_creatinine.val.match_first((p1+p2+p3+)~ 
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

        COMMIT;
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='test2';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Test  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a test algorithm",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:1,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        hb_last => eadv.lab_bld_hb.val.last();
        
        is_anaemic : { hb_last < 120 => 1},{=>0};
        
        [[rb_id]] : {1=1 =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable cs"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







