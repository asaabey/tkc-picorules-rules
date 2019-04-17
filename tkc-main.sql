CLEAR SCREEN;
SET SERVEROUTPUT ON;
DECLARE
    sqlout      VARCHAR2(2000);
    strsql      VARCHAR2(5000);
    t varchar2(32767);
    o varchar2(32767);
    
    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    
    vstack  vstack_type;




BEGIN
    DELETE FROM rpipe;
      
    INSERT INTO rpipe 
    VALUES('r1', 'egfrl => eGFR; acrl => ACR;');
    
    INSERT INTO rpipe 
    VALUES('r2', 'hdld => EADV.[Z49.1].DT.LAST();');
    
    INSERT INTO rpipe 
    VALUES('r3', 'ckdstage(egfr.last,acrl):{egfrl>=90 => 1}{egfrl<90 AND egfrl>=60  AND acrl>=30 => 2},{egfrl<60 AND egfrl>=45 => 3b},{egfrl<45 AND egfrl>=30 => 3a},{egfrl<30 AND egfrl>=15 => 4},{egfrl<15=> 5}');
--            
INSERT INTO rpipe 
VALUES('r4', 'ckdstage(egfrl,acrl):{egfrl>=90 AND acrl>30 => 1},{egfrl<90 AND egfrl>=60  AND acrl>30 => 2},{egfrl<60 AND egfrl>=45 => 3b},{egfrl<45 AND egfrl>=30 => 3a},{egfrl<30 AND egfrl>=15 => 4},{egfrl<15=> 5}');
    
     rman_pckg.parse_rpipe(strsql);

    DBMS_OUTPUT.PUT_LINE(strsql);
END;


