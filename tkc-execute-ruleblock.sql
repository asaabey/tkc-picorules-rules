CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE


BEGIN 
    DBMS_OUTPUT.PUT_LINE('Exec');
        rman_pckg.execute_active_ruleblocks(1);

    
END;




