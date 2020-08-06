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
        
        ckd_icpc_val => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039,icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j95,6].val.last();
        
        
        u88_att => eadv.[
                            icpc_u88j91,
                            icpc_u88j92,
                            icpc_u88j93,
                            icpc_u88j94,
                            icpc_u88j95,
                            icpc_u88j96
                        ].att.last();
        
        u88_dt => eadv.[icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j96].dt.last();
        
        u99_att => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].att.last();
        
        u99_dt => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].dt.last();
        
        u99f : { u99_att!? => to_number(substr(u99_att,-2))};
        
        u99v : { u99f=35 => 1},{ u99f=36 => 2},{ u99f=37 => 3},{ u99f=43 => 3},{ u99f=44 => 4},{ u99f=38 => 5},{ u99f=39 => 6},{=> 0};
        
        u88v : { u88_att!? => to_number(substr(u88_att,-1))},{=>0};
        
        ckd_icpc_ext : { u99_dt > u88_dt => u99v },{ u88_dt > u99_dt => u88v},{ => greatest(u88v,u99v)};
        
        err_flag : { ckd_icpc_val<> ckd_icpc_ext =>1},{=>0};
        
        [[rb_id]] : {. =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='test3';
    
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
                is_active:0,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        dm_icd_fd => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%].dt.min();
        
        dm_icpc_fd => eadv.[icpc_t89%,icpc_t90%].dt.min();
        
        
        
        dm_fd : { . => rman_min_dt(dt_args(dm_icd_fd,dm_icpc_fd))};
        
        
        [[rb_id]] : {1=1 =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='test4';
    
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
                is_active:0,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        rrt_n => eadv.icd_z49_1.dt.count();
        
        rrt_last_dt => eadv.icd_z49_1.dt.max();
        
        rrt_first_dt => eadv.icd_z49_1.dt.min();
        
        rrt_reg => eadv.icd_z49_1.dt.temporal_regularity();
        
        
        [[rb_id]] : {1=1 =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='test6';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a test algorithm",
                is_active:0
                
            }
        );
        
        na_ser1 => eadv.lab_bld_sodium._.serializedv4(val,dt,5).where(dt>sysdate-(365*3));
        
        
        
        [[rb_id]] : {1=1 =>1};
        
        #define_attribute([[rb_id]],
            { 
                label: "This is a test variable uics"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







