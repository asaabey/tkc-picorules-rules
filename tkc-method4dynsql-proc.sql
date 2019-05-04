CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    s CLOB;

PROCEDURE exec_dsql(sqlstmt clob,tbl_name varchar2) 
IS
    colCount            PLS_INTEGER;
    colValue            VARCHAR2(4000);
    tbl_desc            dbms_sql.desc_tab2;
    select_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    insert_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    status              PLS_INTEGER;
    fetched_rows        PLS_INTEGER;
    i                   PLS_INTEGER;
    typ01_val           VARCHAR2(4000); 
    typ02_val           NUMBER;
    typ12_val           DATE;
    typ96_val           VARCHAR2(4);
    typ00_val           VARCHAR2(4000);
    
   

    create_tbl_sql_str  VARCHAR2(4000);
    insert_tbl_sql_str  VARCHAR2(4000);

    tbl_exists_val      PLS_INTEGER;
    
BEGIN

    create_tbl_sql_str:='CREATE TABLE ' || tbl_name || ' (';
    
    
    --analyse query
    dbms_sql.parse(select_cursor,sqlstmt,dbms_sql.native);
    
    dbms_sql.describe_columns2(select_cursor,colCount,tbl_desc);
    
    For I In 1..tbl_desc.Count Loop
--        DBMS_OUTPUT.PUT_LINE ('exec_dsql ::: COLNAME->' || tbl_desc(i).col_name || ' COLTYPE->' || tbl_desc(i).col_type || ' COL LEN->' || tbl_desc(i).col_max_len);
        
        
        CASE tbl_desc(i).col_type
            WHEN 1  THEN --varchar2
                    dbms_sql.define_column(select_cursor,i,'a',32);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' VARCHAR2(' || tbl_desc(i).col_max_len ||') ' || CHR(10);
            WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor,i,1);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' NUMBER ' || CHR(10);
            WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor,i,SYSDATE);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' DATE ' || CHR(10);
            WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor,i,'a',32);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' VARCHAR2(' || tbl_desc(i).col_max_len || ')' || CHR(10);
            ELSE DBMS_OUTPUT.PUT_LINE('Undefined type');
        END CASE;
        IF i<tbl_desc.LAST THEN
            create_tbl_sql_str:=create_tbl_sql_str || ',';
        ELSE
            create_tbl_sql_str:=create_tbl_sql_str || ')';
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('SQL SYNTAX  -> ' || create_tbl_sql_str );
    
   
    
    
    --Create Table
    SELECT COUNT(*) INTO tbl_exists_val FROM user_tables WHERE table_name = UPPER(tbl_name);
    IF tbl_exists_val>0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name ;
    END IF;
    EXECUTE IMMEDIATE create_tbl_sql_str;
    
    --Assemble insert statement
    insert_tbl_sql_str := 'INSERT INTO ' || tbl_name || ' VALUES(';
    FOR i IN 1..tbl_desc.COUNT LOOP
        insert_tbl_sql_str := insert_tbl_sql_str || ':' || tbl_desc(i).col_name; 
        IF i<tbl_desc.COUNT THEN
            insert_tbl_sql_str:=insert_tbl_sql_str || ', ';
        END IF;
    END LOOP;
    insert_tbl_sql_str:=insert_tbl_sql_str || ')';
    
DBMS_OUTPUT.PUT_LINE('INSERT STATEMENT ->' || CHR(10) || insert_tbl_sql_str);
    
    status:=dbms_sql.EXECUTE(select_cursor);
    
    --copy each column to array
    FOR i IN 1..tbl_desc.COUNT LOOP
         

         CASE tbl_desc(i).col_type
            WHEN 1  THEN --varchar2
                    dbms_sql.define_column(select_cursor,i,'a',32);
                    
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' VARCHAR2(' || tbl_desc(i).col_max_len ||') ' || CHR(10);
            WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor,i,1);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' NUMBER ' || CHR(10);
            WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor,i,SYSDATE);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' DATE ' || CHR(10);
            WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor,i,'a',32);
                    create_tbl_sql_str:=create_tbl_sql_str || tbl_desc(i).col_name || ' VARCHAR2(' || tbl_desc(i).col_max_len || ')' || CHR(10);
            ELSE DBMS_OUTPUT.PUT_LINE('Undefined type');
        END CASE;
    END LOOP;

    LOOP
    
        fetched_rows:=dbms_sql.fetch_rows(select_cursor);
        EXIT WHEN fetched_rows=0;
        
        i:=tbl_desc.FIRST;
        
    
        dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);
        
        WHILE (i IS NOT NULL) LOOP
            CASE tbl_desc(i).col_type
                WHEN 1  THEN --varchar2
                        dbms_sql.column_value(select_cursor,i,typ01_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || tbl_desc(i).col_name, typ01_val); 
                        
                WHEN 2 THEN --number
                        dbms_sql.column_value(select_cursor,i,typ02_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || tbl_desc(i).col_name, typ02_val); 
                WHEN 12 THEN --date
                        dbms_sql.column_value(select_cursor,i,typ12_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || tbl_desc(i).col_name, typ12_val); 
                WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor,i,typ96_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || tbl_desc(i).col_name, typ96_val); 
                ELSE DBMS_OUTPUT.PUT_LINE('Undefined type');
            END CASE;
        i:=tbl_desc.NEXT(i);
        END LOOP;
        
        status:=dbms_sql.execute(insert_cursor);
    END LOOP;
    dbms_sql.close_cursor(insert_cursor);
    dbms_sql.close_cursor(select_cursor);
END exec_dsql;

BEGIN
s:='WITH CTE000 AS (SELECT EID FROM EADV GROUP BY EID),CTE001 AS (SELECT EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID ORDER BY EID,DT DESC) AS rank  FROM EADV WHERE (ATT = ''eGFR'')),
CTE002 AS (SELECT EID,VAL AS egfrlv FROM CTE001 WHERE rank=3),
CTE003 AS (SELECT EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID ORDER BY EID,DT DESC) AS rank  FROM EADV WHERE (ATT = ''ACR'')),
CTE004 AS (SELECT EID,VAL AS acrlv FROM CTE003 WHERE rank=1),
CTE005 AS (SELECT EADV.EID,MAX(DT) AS egfrld  FROM EADV WHERE (ATT = ''eGFR'') GROUP BY EADV.EID),
CTE006 AS (SELECT EADV.EID,MAX(DT) AS acrld  FROM EADV WHERE (ATT = ''ACR'') GROUP BY EADV.EID),
CTE007 AS (SELECT EADV.EID,COUNT(DT) AS egfr_count_6m  FROM EADV LEFT OUTER JOIN CTE005 ON CTE005.EID=EADV.EID  WHERE (ATT = ''eGFR'') AND DT>egfrld-180 GROUP BY EADV.EID),
CTE008 AS (SELECT EADV.EID,COUNT(DT) AS egfr_count  FROM EADV WHERE (ATT = ''eGFR'') GROUP BY EADV.EID),
CTE009 AS (SELECT EADV.EID,COUNT(VAL) AS sbp140cnt  FROM EADV WHERE (ATT = ''SYSTOLIC'') AND VAL>140 GROUP BY EADV.EID),
CTE010 AS (SELECT EADV.EID,MAX(DT) AS hd_icd  FROM EADV WHERE (ATT = ''icd_Z49_1'') GROUP BY EADV.EID),
CTE011 AS (SELECT EADV.EID,MAX(DT) AS hd_icpc  FROM EADV WHERE (ATT = ''U59001'') OR (ATT = ''U59008'') GROUP BY EADV.EID),
CTE012 AS (SELECT EADV.EID,MAX(DT) AS hd_proc  FROM EADV WHERE (ATT = ''1310000'') GROUP BY EADV.EID),
CTE013 AS (SELECT EADV.EID,MAX(DT) AS hdld  FROM EADV WHERE (ATT = ''1310000'') OR (ATT = ''U59001'') OR (ATT = ''U59008'') OR (ATT = ''icd_Z49_1'') GROUP BY EADV.EID),
CTE014 AS (SELECT EADV.EID,MAX(DT) AS pd_icpc  FROM EADV WHERE (ATT = ''U59007'') OR (ATT = ''U59009'') GROUP BY EADV.EID),
CTE015 AS (SELECT EADV.EID,MAX(DT) AS pd_icd  FROM EADV WHERE (ATT = ''icd_Z49_2'') GROUP BY EADV.EID),
CTE016 AS (SELECT EADV.EID,MAX(DT) AS pd_proc  FROM EADV WHERE (ATT = ''1310006'') OR (ATT = ''1310007'') OR (ATT = ''1310008'') GROUP BY EADV.EID),
CTE017 AS (SELECT EADV.EID,MAX(DT) AS pdld  FROM EADV WHERE (ATT = ''1310006'') OR (ATT = ''1310007'') OR (ATT = ''1310008'') OR (ATT = ''U59007'') OR (ATT = ''U59009'') OR (ATT = ''icd_Z49_2'') GROUP BY EADV.EID),
CTE018 AS (SELECT EADV.EID,MAX(DT) AS tx_icpc  FROM EADV WHERE (ATT = ''U28001'') GROUP BY EADV.EID),
CTE019 AS (SELECT EADV.EID,MAX(DT) AS tx_icd  FROM EADV WHERE (ATT LIKE ''icd_Z94%'') GROUP BY EADV.EID),
CTE020 AS (SELECT EADV.EID,MAX(DT) AS tx_proc  FROM EADV WHERE (ATT = ''1310006'') OR (ATT = ''1310007'') OR (ATT = ''1310008'') GROUP BY EADV.EID),
CTE021 AS (SELECT EADV.EID,MAX(DT) AS txld  FROM EADV WHERE (ATT = ''U28001'') OR (ATT LIKE ''icd_Z94%'') GROUP BY EADV.EID),
CTE022 AS (SELECT EADV.EID,MAX(DT) AS hhd  FROM EADV WHERE (ATT = ''U59J99'') GROUP BY EADV.EID),
CTE023 AS (SELECT EADV.EID,MAX(DT) AS hhdld  FROM EADV WHERE (ATT = ''U59J99'') GROUP BY EADV.EID),
CTE024 AS (SELECT EID,1 AS dmfdex  FROM EADV WHERE (ATT LIKE ''icd_E08%'') OR (ATT LIKE ''icd_E09%'') OR (ATT LIKE ''icd_E10%'') OR (ATT LIKE ''icd_E11%'') OR (ATT LIKE ''icd_E14%'') OR (ATT LIKE ''T89%'') OR (ATT LIKE ''T90%'') GROUP BY EID,ATT),
CTE025 AS (SELECT EADV.EID,MIN(DT) AS dmfd  FROM EADV WHERE (ATT LIKE ''icd_E08%'') OR (ATT LIKE ''icd_E09%'') OR (ATT LIKE ''icd_E10%'') OR (ATT LIKE ''icd_E11%'') OR (ATT LIKE ''icd_E14%'') OR (ATT LIKE ''T89%'') OR (ATT LIKE ''T90%'') GROUP BY EADV.EID),
CTE026 AS (SELECT EADV.EID,MIN(DT) AS htnfd  FROM EADV WHERE (ATT LIKE ''icd_T89%'') OR (ATT LIKE ''K85%'') OR (ATT LIKE ''K86%'') OR (ATT LIKE ''K87%'') GROUP BY EADV.EID),
CTE027 AS (SELECT EADV.EID,MIN(DT) AS cabgfd  FROM EADV WHERE (ATT LIKE ''icd_Z95_1%'') OR (ATT = ''K54007'') GROUP BY EADV.EID),
CTE028 AS (SELECT EADV.EID,MIN(DT) AS cadfd  FROM EADV WHERE (ATT LIKE ''icd_I20%'') OR (ATT LIKE ''icd_I21%'') OR (ATT LIKE ''icd_I22%'') OR (ATT LIKE ''icd_I23%'') OR (ATT LIKE ''icd_I24%'') OR (ATT LIKE ''icd_I25%'') OR (ATT LIKE ''K74%'') OR (ATT LIKE ''K75%'') OR (ATT LIKE ''K76%'') GROUP BY EADV.EID),
CTE029 AS (SELECT EADV.EID,MIN(DT) AS cvafd  FROM EADV WHERE (ATT LIKE ''icd_G46%'') OR (ATT LIKE ''K89%'') OR (ATT LIKE ''K90%'') OR (ATT LIKE ''K91%'') GROUP BY EADV.EID),
CTE030 AS (SELECT EADV.EID,MIN(DT) AS pvdfd  FROM EADV WHERE (ATT LIKE ''icd_I70%'') OR (ATT LIKE ''icd_I71%'') OR (ATT LIKE ''icd_I72%'') OR (ATT LIKE ''icd_I73%'') OR (ATT LIKE ''K92%'') GROUP BY EADV.EID),
CTE031 AS (SELECT EADV.EID,MIN(DT) AS vhdfd  FROM EADV WHERE (ATT LIKE ''K83%'') GROUP BY EADV.EID),
CTE032 AS (SELECT EADV.EID,MIN(DT) AS obst  FROM EADV WHERE (ATT LIKE ''icd_E66%'') OR (ATT LIKE ''T82%'') GROUP BY EADV.EID),
CTE033 AS (SELECT EID,DT,ROW_NUMBER() OVER(PARTITION BY EID ORDER BY EID,DT DESC) AS rank  FROM EADV WHERE (ATT = ''U99034'') OR (ATT = ''U99035'') OR (ATT = ''U99036'') OR (ATT = ''U99037'') OR (ATT = ''U99038'') OR (ATT = ''U99039'') OR (ATT LIKE ''icd_N18%'')),
CTE034 AS (SELECT EID,DT AS ckd FROM CTE033 WHERE rank=1),
CTE035 AS (SELECT EID,DT,ROW_NUMBER() OVER(PARTITION BY EID ORDER BY EID,DT DESC) AS rank  FROM EADV WHERE (ATT LIKE ''icd_N20%'') OR (ATT LIKE ''U95%'')),
CTE036 AS (SELECT EID,DT AS lit FROM CTE035 WHERE rank=1),
CTE037 AS (SELECT EADV.EID,MIN(DT) AS ctifd  FROM EADV WHERE (ATT LIKE ''icd_L00%'') OR (ATT LIKE ''icd_L01%'') OR (ATT LIKE ''icd_L02%'') OR (ATT LIKE ''icd_L03%'') OR (ATT LIKE ''icd_L04%'') OR (ATT LIKE ''icd_L05%'') OR (ATT LIKE ''icd_L06%'') OR (ATT LIKE ''icd_L07%'') OR (ATT LIKE ''icd_L08%'') OR (ATT LIKE ''icd_L09%'') OR (ATT LIKE ''icd_M86%'') OR (ATT LIKE ''S76%'') GROUP BY EADV.EID),
CTE038 AS (SELECT CASE WHEN egfrlv>=90 THEN ''G1'' WHEN egfrlv<90 AND egfrlv>=60 THEN ''G2'' WHEN egfrlv<60 AND egfrlv>=45 THEN ''G3A'' WHEN egfrlv<45 AND egfrlv>=30 THEN ''G3B'' WHEN egfrlv<30 AND egfrlv>=15 THEN ''G4'' WHEN egfrlv<15 THEN ''G5'' ELSE ''NA'' END AS CGA_G,CTE000.EID  FROM CTE000 LEFT OUTER JOIN CTE002 ON CTE002.EID=CTE000.EID  LEFT OUTER JOIN CTE004 ON CTE004.EID=CTE000.EID ),
CTE039 AS (SELECT CASE WHEN acrlv<3 THEN ''A1'' WHEN acrlv<30 AND acrlv>=3 THEN ''A2'' WHEN acrlv<300 AND acrlv>=30 THEN ''A3'' WHEN acrlv>300 THEN ''A4'' ELSE ''NA'' END AS CGA_A,CTE000.EID  FROM CTE000 LEFT OUTER JOIN CTE004 ON CTE004.EID=CTE000.EID )
 SELECT CTE000.EID, CTE002.egfrlv 
,CTE004.acrlv 
,CTE005.egfrld 
,CTE006.acrld 
,CTE007.egfr_count_6m 
,CTE008.egfr_count 
,CTE009.sbp140cnt 
,CTE010.hd_icd 
,CTE011.hd_icpc 
,CTE012.hd_proc 
,CTE013.hdld 
,CTE014.pd_icpc 
,CTE015.pd_icd 
,CTE016.pd_proc 
,CTE017.pdld 
,CTE018.tx_icpc 
,CTE019.tx_icd 
,CTE020.tx_proc 
,CTE021.txld 
,CTE022.hhd 
,CTE023.hhdld 
,CTE024.dmfdex 
,CTE025.dmfd 
,CTE026.htnfd 
,CTE027.cabgfd 
,CTE028.cadfd 
,CTE029.cvafd 
,CTE030.pvdfd 
,CTE031.vhdfd 
,CTE032.obst 
,CTE034.ckd 
,CTE036.lit 
,CTE037.ctifd 
,CTE038.cga_g 
,CTE039.cga_a 
FROM CTE000 LEFT OUTER JOIN CTE002 ON CTE002.EID=CTE000.EID 
 LEFT OUTER JOIN CTE004 ON CTE004.EID=CTE000.EID 
 LEFT OUTER JOIN CTE005 ON CTE005.EID=CTE000.EID 
 LEFT OUTER JOIN CTE006 ON CTE006.EID=CTE000.EID 
 LEFT OUTER JOIN CTE007 ON CTE007.EID=CTE000.EID 
 LEFT OUTER JOIN CTE008 ON CTE008.EID=CTE000.EID 
 LEFT OUTER JOIN CTE009 ON CTE009.EID=CTE000.EID 
 LEFT OUTER JOIN CTE010 ON CTE010.EID=CTE000.EID 
 LEFT OUTER JOIN CTE011 ON CTE011.EID=CTE000.EID 
 LEFT OUTER JOIN CTE012 ON CTE012.EID=CTE000.EID 
 LEFT OUTER JOIN CTE013 ON CTE013.EID=CTE000.EID 
 LEFT OUTER JOIN CTE014 ON CTE014.EID=CTE000.EID 
 LEFT OUTER JOIN CTE015 ON CTE015.EID=CTE000.EID 
 LEFT OUTER JOIN CTE016 ON CTE016.EID=CTE000.EID 
 LEFT OUTER JOIN CTE017 ON CTE017.EID=CTE000.EID 
 LEFT OUTER JOIN CTE018 ON CTE018.EID=CTE000.EID 
 LEFT OUTER JOIN CTE019 ON CTE019.EID=CTE000.EID 
 LEFT OUTER JOIN CTE020 ON CTE020.EID=CTE000.EID 
 LEFT OUTER JOIN CTE021 ON CTE021.EID=CTE000.EID 
 LEFT OUTER JOIN CTE022 ON CTE022.EID=CTE000.EID 
 LEFT OUTER JOIN CTE023 ON CTE023.EID=CTE000.EID 
 LEFT OUTER JOIN CTE024 ON CTE024.EID=CTE000.EID 
 LEFT OUTER JOIN CTE025 ON CTE025.EID=CTE000.EID 
 LEFT OUTER JOIN CTE026 ON CTE026.EID=CTE000.EID 
 LEFT OUTER JOIN CTE027 ON CTE027.EID=CTE000.EID 
 LEFT OUTER JOIN CTE028 ON CTE028.EID=CTE000.EID 
 LEFT OUTER JOIN CTE029 ON CTE029.EID=CTE000.EID 
 LEFT OUTER JOIN CTE030 ON CTE030.EID=CTE000.EID 
 LEFT OUTER JOIN CTE031 ON CTE031.EID=CTE000.EID 
 LEFT OUTER JOIN CTE032 ON CTE032.EID=CTE000.EID 
 LEFT OUTER JOIN CTE034 ON CTE034.EID=CTE000.EID 
 LEFT OUTER JOIN CTE036 ON CTE036.EID=CTE000.EID 
 LEFT OUTER JOIN CTE037 ON CTE037.EID=CTE000.EID 
 LEFT OUTER JOIN CTE038 ON CTE038.EID=CTE000.EID 
 LEFT OUTER JOIN CTE039 ON CTE039.EID=CTE000.EID 
';
exec_dsql(s,'derived_tier1');

END;



