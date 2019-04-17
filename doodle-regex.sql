CLEAR SCREEN;

DECLARE
    lhs NVARCHAR2(200):='';
--    rhs NVARCHAR2(200):='eGFRL=>eGFR(VAL.LAST)';
    rhs NVARCHAR2(200):='eGFR(VAL.LAST)';
    ext NVARCHAR2(200);
    att NVARCHAR2(20);
    assign_operator NUMBER(1,0):=0;
    lhs_assn NVARCHAR2(20);
    rhs_assn NVARCHAR2(200);
    where_clause NVARCHAR2(200);
    select_clause NVARCHAR2(200);
    from_clause NVARCHAR2(200);
    groupby_clause NVARCHAR2(200);
    
BEGIN
    IF INSTR(rhs,'=>')>0 THEN
        assign_operator:=1;
    END IF;
    
    IF assign_operator=1 THEN
        lhs_assn:=REGEXP_SUBSTR(rhs,'^([a-zA-Z0-9.-]+)[^=>]');
        rhs_assn:=REGEXP_SUBSTR(rhs,'[^=>]+$');
        DBMS_OUTPUT.PUT_LINE('rhs_assn :' || rhs_assn);
        DBMS_OUTPUT.PUT_LINE('lhs_assn :' || lhs_assn);
    END IF;
    
    
    SELECT replace(replace(regexp_substr(rhs, '\(.*\)'), '(', ''), ')', '') INTO ext FROM DUAL;
    SELECT REGEXP_SUBSTR(rhs, '^([a-zA-Z0-9.-]+)') INTO att FROM DUAL;
        
    
    DBMS_OUTPUT.PUT_LINE('LHS : ' || lhs);

    DBMS_OUTPUT.PUT_LINE('RHS : ' || rhs);
    DBMS_OUTPUT.PUT_LINE('ext : ' || ext);
    DBMS_OUTPUT.PUT_LINE('att : ' || att);
    DBMS_OUTPUT.PUT_LINE('assign operator : ' || assign_operator);
END;
/