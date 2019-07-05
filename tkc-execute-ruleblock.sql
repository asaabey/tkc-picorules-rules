CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
--PROCEDURE execute_active_ruleblocks
--IS
--    rbs rman_ruleblocks_type;
--BEGIN
--    SELECT * BULK COLLECT INTO rbs 
--    FROM rman_ruleblocks WHERE IS_ACTIVE=2 ;
--    
--    FOR i IN 1..rbs.COUNT LOOP
--        rman_pckg.execute_ruleblock(rbs.blockid,1,0);
--        DBMS_OUTPUT.put_line('rb: ' || rbs.blockid);
--    END LOOP;
--    
--        
--END execute_active_ruleblocks;

BEGIN 
--    rman_pckg.execute_ruleblock('careplan',1,0);
--    rman_pckg.execute_ruleblock('cd_dm_2',1,0);
    
--    rman_pckg.execute_ruleblock('cvra_1_1',1,0);
--    rman_pckg.execute_ruleblock('cd_htn_2',1,0);
    
--    rman_pckg.execute_ruleblock('ckd_cause_2_1',1,0);
--      rman_pckg.execute_ruleblock('ckd_2_1',1,0);
--    rman_pckg.execute_ruleblock('tg4620_1_1',0,1);


--    rman_pckg.execute_ruleblock('ckd_journey_2_1',0,1);
    rman_pckg.execute_ruleblock('ckd_diagnostics_2_1',1,0);
    
--    rman_pckg.execute_ruleblock('ckd_complications_2_1',1,0);
--    rman_pckg.execute_ruleblock('rrt_2_1',1,0);
    
--    rman_pckg.execute_ruleblock('kfre_2_1',1,0);

--    rman_pckg.execute_ruleblock('test_2_1',1,0);

--    rman_pckg.execute_ruleblock('pcd_2_1',1,0);

--        rman_pckg.execute_active_ruleblocks;

END;

