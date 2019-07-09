CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE


BEGIN 
    DBMS_OUTPUT.PUT_LINE('Exec');
        rman_pckg.execute_active_ruleblocks(1);
--            rman_pckg.execute_ruleblock('rrt',1,0,0,1);
--            rman_pckg.execute_ruleblock('ckd',1,1,0,1);        
--                    rman_pckg.execute_ruleblock('cd_dm',1,1,0,1);        
--
--            rman_pckg.execute_ruleblock('tg4410',1,1,0,1);  
--          rman_pckg.execute_ruleblock('tg4420',1,1,0,1);    
--          rman_pckg.execute_ruleblock('tg4100',1,1,0,1);    
--          rman_pckg.execute_ruleblock('tg4410',1,1,0,1); 
--          rman_pckg.execute_ruleblock('tg4610',1,1,0,1); 
--          rman_pckg.execute_ruleblock('tg4620',1,1,0,1); 
--            rman_pckg.compile_ruleblock('tg4410');
END;




