CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE

BEGIN 
    rman_pckg.execute_ruleblock('cd_dm_2');
END;

