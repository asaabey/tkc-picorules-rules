SET SERVEROUTPUT ON;
CLEAR SCREEN;

--DECLARE
--
--    t1 tbl_type;
--    
--    avn varchar2(50);
--    expr varchar2(32767);
--    expr_tbl tbl_type;
--    expr_var tbl_type;
--    expr_elem tbl_type;
--    
--    expr_then varchar2(32);
--    expr_when varchar(100);
--    from_clause varchar2(2000);
--    op_delim varchar2(3):='|';
--    txt  VARCHAR2(32767);
--    
--    sqlout varchar2(32767);
--    
--    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
--    vstack  vstack_type;
--    
--BEGIN
--    vstack('eGFRLast'):=2;
--    vstack('ACRLast'):=4;
--    
--    from_clause:=' FROM ';
--    
--    txt:='ckdstage(eGFRLast,ACRLast):{egfrl<90 AND egfrl>=60 => 2},
--            {egfrl<60 AND egfrl>=45 => 3b},
--            {egfrl<45 AND egfrl>=30 => 3a},
--            {egfrl<30 AND egfrl>=15 => 4},
--            {=> 5}';
--    sqlout:='SELECT CASE ';
--    
--    t1:=rman_pckg.splitstr(txt,':');
--    -- split at major assignment
--    IF t1.EXISTS(2) THEN
--        --major assignment should be of function () type
--        IF INSTR(t1(1),'(',1,1)>0 THEN
--            avn:=SUBSTR(t1(1), 1, INSTR(t1(1),'(',1,1)-1);
--            
--            expr_var:=rman_pckg.splitstr(REGEXP_SUBSTR(t1(1), '\((.*)?\)', 1, 1, 'i', 1),',');
--            
--            
--            for i in 1..expr_var.COUNT LOOP
--                DBMS_OUTPUT.PUT_LINE (expr_var(i));
--            END LOOP;
--            
--            expr_tbl:=rman_pckg.splitstr(t1(2),',');
--            
--            
--            
--            --split to expression array
--            for i in expr_tbl.first..expr_tbl.last loop
--                --check if properly formed by curly brackets
--                expr:=regexp_substr(expr_tbl(i), '\{([^}]+)\}', 1,1,NULL,1);
--                --DBMS_OUTPUT.put_line(i || ':' || expr);
--                --split minor assignment
--                expr_elem:=rman_pckg.splitstr(expr,'=>');
--                if expr_elem.EXISTS(2) THEN
--                    if expr_elem(1) IS NOT NULL THEN
--                        expr_then:=expr_elem(2);
--                        expr_when:=trim(expr_elem(1));
--                    
--                        sqlout:=sqlout || 'WHEN '|| expr_when || ' THEN ''' || expr_then || ''' ';  
--                    ELSE 
--                        expr_then:=expr_elem(2);
--                        
--                        sqlout:=sqlout || 'ELSE '''|| expr_then || ''' ';  
--                    end if;
--                
--                    
--                end if;
--                
--                
--            end loop;
--            
--            sqlout:=sqlout || 'END AS ' || UPPER(avn) || ',EID FROM X';
--        
--        END IF;
--        
--        DBMS_OUTPUT.PUT_LINE(sqlout);
--    END IF;
--    
--    
--    
--END;

DECLARE
    t varchar2(32767);
    o varchar2(32767);
    
BEGIN
    t:='ckdstage(eGFRLast,ACRLast):{egfrl<90 AND egfrl>=60 => 2},
            {egfrl<60 AND egfrl>=45 => 3b},
            {egfrl<45 AND egfrl>=30 => 3a},
            {egfrl<30 AND egfrl>=15 => 4},
            {=> 5}';
    rman_pckg.build_cond_sql_exp(t,o);
    DBMS_OUTPUT.PUT_LINE('sql expr : ' || o);

END;
/


