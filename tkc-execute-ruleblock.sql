CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE

BEGIN 
--    rman_pckg.execute_ruleblock('cd_dm_2');
--    rman_pckg.execute_ruleblock('cd_htn_2');
    
--    rman_pckg.execute_ruleblock('ckd_cause_2_1');
    rman_pckg.execute_ruleblock('ckd_2_1');
END;

