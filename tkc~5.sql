CLEAR SCREEN;
SET SERVEROUTPUT ON;
DECLARE 
    txt varchar2(4000);
    ext varchar2(4000);
BEGIN
    txt:='ckdstage(eGFRLast,ACRLast):{egfrl<90 AND egfrl>=60 => 2},
            {egfrl<60 AND egfrl>=45 => 3b},
            {egfrl<45 AND egfrl>=30 => 3a},
            {egfrl<30 AND egfrl>=15 => 4},
            {=> 5}';
    
    txt:='egfrl => EADV.eGFR.VAL.LAST(1)';
    
    
    nn
    ext:= regexp_coureeeeeent(txt, '\w+\((.*)?\)\:');
    
    DBMS_OUTPUT.put_line(ext);
END;
/