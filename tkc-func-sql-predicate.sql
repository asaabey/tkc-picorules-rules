SET SERVEROUTPUT ON;
CLEAR SCREEN;

DECLARE

t VARCHAR2(100);

FUNCTION sql_predicate(att_str VARCHAR2) RETURN VARCHAR2
AS
att_tbl tbl_type;
eq_op VARCHAR2(6);
s VARCHAR2(5000);
att_col CONSTANT VARCHAR2(30):='ATT';
BEGIN
    IF INSTR(att_str,',')>0 THEN
        att_tbl:=rman_pckg.splitstr(att_str,',','','');
        FOR i in 1..att_tbl.COUNT LOOP
            IF INSTR(att_tbl(i),'%')>0 THEN
                eq_op:=' LIKE ';
            ELSE 
                eq_op:=' = ';
            END IF;
            s:=s || '(' || att_col || eq_op || '`' || att_tbl(i) || '`)';  
            IF i<att_tbl.COUNT THEN
                s:=s || ' OR ';
            END IF;
        END LOOP;
    ELSIF INSTR(att_str,',')=0 THEN
        IF INSTR(att_str,'%')>0 THEN
                eq_op:=' LIKE ';
            ELSE 
                eq_op:=' = ';
            END IF;
            s:=s || '(' || att_col || eq_op || '`' || att_str || '`)';  
    END IF;
    
    return s;
END sql_predicate;

BEGIN
    t:='U99034,U99035,U9903%,U99037,U99038,U990%';
    t:='U99034';
    DBMS_OUTPUT.put_line('t=' || t);
    DBMS_OUTPUT.put_line('s=' || sql_predicate(t));
END;