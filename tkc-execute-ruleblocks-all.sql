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
    Execute all active ruleblock 
    order determined by execution order
    
    usage :
        rman_pckg.execute_active_ruleblocks(recompile={0,1});
        eg :
--        rman_pckg.execute_active_ruleblocks;
*/

        rman_pckg.execute_active_ruleblocks; 


    DBMS_OUTPUT.PUT_LINE('Exec');
    DBMS_OUTPUT.PUT_LINE('Return code->' || ret_val);
 



END;


 




