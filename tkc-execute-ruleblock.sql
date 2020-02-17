CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
ret_val pls_integer;

BEGIN 

/*
    API usage
    
*/

/*
    Compile single ruleblock 
    
    
    usage :
        rman_pckg.compile_ruleblock(ruleblockid=varchar2);
        eg :
        rman_pckg.compile_ruleblock('cd_cardiac');
*/

--rman_pckg.compile_ruleblock('rrt',ret_val);
----
--rman_pckg.compile_ruleblock(
--    bid_in =>'ckd',
--    return_code => ret_val
--);
--

/*
    Compile all ruleblocks 
    
    
    usage :
        rman_pckg.compile_active_ruleblocks();
        eg :
        rman_pckg.compile_active_ruleblocks();
*/
--rman_pckg.compile_active_ruleblocks;
--

/*
    Execute single ruleblock regardless of active status
    will fail if dependency target table is absent
    
    usage :
        rman_pckg.execute_ruleblock(ruleblockid=varchar2,create target table = {0,1} write to eadvx as json ={0,1},,recompile={0,1});
        eg :
        rman_pckg.execute_ruleblock('cd_dm',1,1,0,1); 
    rman_pckg.execute_ruleblock(
            bid_in => 'rrt',
            create_wide_tbl => 1,
            push_to_long_tbl =>1 ,
            push_to_long_tbl2=>0,
            recompile=>1,
            return_code=>ret_val
        ); 
*/

--    rman_pckg.execute_ruleblock('htn_rcm',1,0,0,1);  

--    rman_pckg.execute_ruleblock('rrt',1,1,0,1); 

--    rman_pckg.execute_ruleblock('careplan',1,0,0,1);  

rman_pckg.execute_ruleblock(
        bid_in => 'egfr_graph2',
        create_wide_tbl => 1,
        push_to_long_tbl =>1,
        push_to_long_tbl2=>0,
        recompile=>1,
        return_code=>ret_val
); 
    
/*
    Execute all active ruleblock 
    order determined by execution order
    
    usage :
        rman_pckg.execute_active_ruleblocks(recompile={0,1});
        eg :
--        rman_pckg.execute_active_ruleblocks;
*/

--        rman_pckg.execute_ruleblocks(
--            batch_level_filter => '', 
--            drop_rout_tables_flag => 0,
--            compute_stats => 0    
--        ); 


    DBMS_OUTPUT.PUT_LINE('Exec');
    DBMS_OUTPUT.PUT_LINE('Return code->' || ret_val);
 





END;


 




