SET SERVEROUTPUT ON;
CLEAR SCREEN;

DECLARE
    --s varchar2(100):='eq(var1, var2):{1=1 => UPPERvar},{1=2 => LOWERvar}';
    s varchar2(100):='eq(var1, var2 ) :{1=1 => UPPER(var)},{1=2 => LOWER(var)}';
    
    x varchar2(100);
    y varchar2(100);
    o varchar2(100);
    t tbl_type;
    t2 tbl_type;
    
BEGIN
    x:=SUBSTR(s,1,INSTR(s,':')-1);
    y:=TRIM(SUBSTR(s,INSTR(s,':')+1));
    DBMS_OUTPUT.put_line('x :::>> ' || x);
    DBMS_OUTPUT.put_line('y :::>> ' || y);
    DBMS_OUTPUT.PUT_LINE('old method:: ' || REGEXP_SUBSTR(x, '\((.*)?\)', 1, 1, 'i', 1));
    DBMS_OUTPUT.PUT_LINE('new method:: ' || TRIM(SUBSTR(TRIM(SUBSTR(s,1,INSTR(s,':')-1)),INSTR(s,'(')+1,INSTR(s,')')-4)));
    t:=rman_pckg.splitstr(s, ',','{','}');
    FOR i IN 1..t.COUNT LOOP
      --  DBMS_OUTPUT.PUT_LINE ('t-> (' || i || ') ' || t(i));
        o:= regexp_substr(t(i), '\{([^}]+)\}', 1,1,NULL,1);
    --DBMS_OUTPUT.PUT_LINE('print--> ' || o);
        t2:=rman_pckg.splitstr(o, '=>');
        IF t2.EXISTS(2) THEN
            IF t2(1) IS NOT NULL THEN 
                DBMS_OUTPUT.PUT_LINE('print2-THEN-> ' || t2(2));  
                DBMS_OUTPUT.PUT_LINE('print2-WHEN -> ' || trim(t2(1)));  
            END IF;

        END IF;
      END LOOP;
--    o:= regexp_substr(s, '\{([^}]+)\}', 1,1,NULL,1);
--    DBMS_OUTPUT.PUT_LINE('print--> ' || o);
END;