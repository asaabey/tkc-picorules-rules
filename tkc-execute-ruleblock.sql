CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE

BEGIN 
    rman_pckg.execute_ruleblock('cd_dm_2',1,0);
    
--    rman_pckg.execute_ruleblock('cvra_1_1',1,1);
--    rman_pckg.execute_ruleblock('cd_htn_2');
    
--    rman_pckg.execute_ruleblock('ckd_cause_2_1');
--      rman_pckg.execute_ruleblock('ckd_2_1',1,1);
--    rman_pckg.execute_ruleblock('tg4620_1_1',0,1);
--    rman_pckg.execute_ruleblock('careplan',1,0);

--    rman_pckg.execute_ruleblock('ckd_journey_2_1',0,1);
--    rman_pckg.execute_ruleblock('ckd_diagnostics_2_1',1,1);
    
--    rman_pckg.execute_ruleblock('ckd_complications_2_1',0,1);
--    rman_pckg.execute_ruleblock('rrt_2_1',1,1);
    
--    rman_pckg.execute_ruleblock('kfre_2_1',1,0);

--    rman_pckg.execute_ruleblock('test_2_1',1,0);
END;

