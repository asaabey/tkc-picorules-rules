CLEAR SCREEN;
SET SERVEROUTPUT ON;
DECLARE
    txt varchar2(4000);
    varstr varchar2(4000);
    varr tbl_type;
BEGIN
    txt:='egfrl => eadv.egfr.val.last(3)';
    
    DBMS_OUTPUT.PUT_LINE(trim(substr(txt,1,instr(txt,'=>',1,1)-1)));
    DBMS_OUTPUT.PUT_LINE(trim(substr(txt,instr(txt,'=>',1,1)+2,length(txt))));
    
    --varstr:=trim(substr(txt,instr(txt,'=>',1,1)+2,length(txt)));
    varr:=rman_pckg.splitstr(trim(substr(txt,instr(txt,'=>',1,1)+2,length(txt))),'.');
    
    IF varr.COUNT=4 THEN
        DBMS_OUTPUT.PUT_LINE(varr(1));
        DBMS_OUTPUT.PUT_LINE(varr(2));
        DBMS_OUTPUT.PUT_LINE(varr(3));
        DBMS_OUTPUT.PUT_LINE(varr(4));
        DBMS_OUTPUT.PUT_LINE(SUBSTR(varr(4), 1, INSTR(varr(4),'(',1,1)-1));
        
        DBMS_OUTPUT.PUT_LINE(REGEXP_SUBSTR(varr(4), '\((.*)?\)', 1, 1, 'i', 1));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Syntax error');
    END IF;
    
    
    
    
--     rman_pckg.build_func_sql_exp(1,'LAST',3, 'eGFR', 'EADV', 'VAL', 'egfrl',sqlout);
END;

WITH CTE00000 AS (SELECT EID FROM EADV GROUP BY EID),
cte00001 AS (SELECT EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID,ATT ORDER BY EID,DT DESC) AS rank  FROM eadv WHERE ATT='egfr'),
cte00002 AS (SELECT EID,VAL AS egfrl FROM cte00001 WHERE rank=2),
cte00003 AS (SELECT EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID,ATT ORDER BY EID,DT DESC) AS rank  FROM eadv WHERE ATT='acr'),
cte00004 AS (SELECT EID,VAL AS acrl FROM cte00003 WHERE rank=2),
cte00005 AS (SELECT CASE WHEN egfrl<90 AND egfrl>=60 THEN '2' WHEN egfrl<60 AND egfrl>=45 THEN '3b' WHEN egfrl<45 AND egfrl>=30 THEN '3a' WHEN egfrl<30 AND egfrl>=15 THEN '4' ELSE '5' END AS CKDSTAGE,cte00002.EID  FROM cte00002 INNER JOIN cte00004 ON cte00004.EID=cte00002.EID ) 
SELECT CTE00000.EID, cte00002.egfrl ,cte00004.acrl ,cte00005.ckdstage 
FROM CTE00000
LEFT OUTER JOIN cte00002 ON cte00002.EID=CTE00000.EID 
LEFT OUTER JOIN cte00004 ON cte00004.EID=CTE00000.EID 
LEFT OUTER JOIN cte00005 ON cte00005.EID=CTE00000.EID ;


WITH CTE00000 AS (SELECT EID FROM EADV GROUP BY EID),
CTE00001 AS (SELECT EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID,ATT ORDER BY EID,DT DESC) AS rank  FROM EADV WHERE ATT='egfr'),
CTE00002 AS (SELECT EID,VAL AS egfrl FROM CTE00001 WHERE rank=2),
CTE00003 AS (SELECT EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID,ATT ORDER BY EID,DT DESC) AS rank  FROM EADV WHERE ATT='acr'),
CTE00004 AS (SELECT EID,VAL AS acrl FROM CTE00003 WHERE rank=2),
CTE00005 AS (SELECT CASE WHEN egfrl<90 AND egfrl>=60 THEN '2' WHEN egfrl<60 AND egfrl>=45 THEN '3b' WHEN egfrl<45 AND egfrl>=30 THEN '3a' WHEN egfrl<30 AND egfrl>=15 THEN '4' ELSE '5' END AS CKDSTAGE,CTE00002.EID  FROM CTE00002 INNER JOIN CTE00004 ON CTE00004.EID=CTE00002.EID ) 
SELECT CTE00000.EID, cte00002.egfrl ,cte00004.acrl ,cte00005.ckdstage 
FROM CTE00000 
LEFT OUTER JOIN CTE00002 ON CTE00002.EID=CTE00000.EID 
LEFT OUTER JOIN CTE00004 ON CTE00004.EID=CTE00000.EID 
LEFT OUTER JOIN CTE00005 ON CTE00005.EID=CTE00000.EID ;


 DELETE FROM rpipe;
    
    
    INSERT INTO rpipe 
    VALUES('r1', q'[egfrl => EADV.eGFR.VAL.LAST(1)]');
    
    INSERT INTO rpipe 
    VALUES('r2', q'[egfrl => EADV.ACR.VAL.LAST(1)]');
    
    INSERT INTO rpipe 
    VALUES('r3', q'[ckdstage(eGFRLast,ACRLast):{egfrl<90 AND egfrl>=60 => 2},
            {egfrl<60 AND egfrl>=45 => 3b},
            {egfrl<45 AND egfrl>=30 => 3a},
            {egfrl<30 AND egfrl>=15 => 4},
            {=> 5}]');