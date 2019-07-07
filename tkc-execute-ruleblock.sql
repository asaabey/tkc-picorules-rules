CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE


BEGIN 
    DBMS_OUTPUT.PUT_LINE('Exec');
--    rman_pckg.compile_active_ruleblocks;    
        rman_pckg.execute_active_ruleblocks(1);

--    rman_pckg.execute_ruleblock('ckd_diagnostics',1,0,0,1);
    
    --run   480.071
    --run2  228.413
    
END;




