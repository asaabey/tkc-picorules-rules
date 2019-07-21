CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE


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

--rman_pckg.compile_ruleblock('test1');


/*
    Compile all ruleblocks 
    
    
    usage :
        rman_pckg.compile_active_ruleblocks();
        eg :
        rman_pckg.compile_active_ruleblocks();
*/
rman_pckg.compile_active_ruleblocks();


/*
    Execute single ruleblock regardless of active status
    will fail if dependency target table is absent
    
    usage :
        rman_pckg.execute_ruleblock(ruleblockid=varchar2,create target table = {0,1} write to eadvx as json ={0,1},,recompile={0,1});
        eg :
        rman_pckg.execute_ruleblock('cd_dm',1,1,0,1); 
*/

--    rman_pckg.execute_ruleblock('test1',1,0,0,1);  
    
/*
    Execute all active ruleblock 
    order determined by execution order
    
    usage :
        rman_pckg.execute_active_ruleblocks(recompile={0,1});
        eg :
        rman_pckg.execute_active_ruleblocks(1);
*/

--        rman_pckg.execute_active_ruleblocks(1); 


    DBMS_OUTPUT.PUT_LINE('Exec');
    
 

--rman_pckg.execute_ruleblock('qa_data_geom',1,1,0,1); 
--            rman_pckg.compile_ruleblock('cd_cardiac');
END;




