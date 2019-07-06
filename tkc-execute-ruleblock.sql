CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE


BEGIN 
    DBMS_OUTPUT.PUT_LINE('Exec');
--    rman_pckg.compile_active_ruleblocks;    
--        rman_pckg.execute_active_ruleblocks(1);
    rman_pckg.execute_ruleblock('cvra_1_1',1,1,1);
    
END;

