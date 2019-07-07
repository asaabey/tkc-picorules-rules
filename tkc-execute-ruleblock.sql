CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE


BEGIN 
    DBMS_OUTPUT.PUT_LINE('Exec');
--    rman_pckg.compile_active_ruleblocks;    
        rman_pckg.execute_active_ruleblocks(1);
--      with index 440.58
--      with index 380.58
--rman_pckg.execute_ruleblock('rrt',0,0,1,1);
--rman_pckg.execute_ruleblock('ckd',0,0,1,1); 
--    rman_pckg.execute_ruleblock('ckd_diagnostics',0,0,1,1);
    
END;




