set serveroutput on;
clear screen;
declare
    composition clob;
    eid         integer;


begin
--    eid:=6811;

    eid:=4565;
    composition:=rman_pckg.get_composition_by_eid(eid,'neph001');
    
    
    DBMS_OUTPUT.put_line('EID:' || eid);

    DBMS_OUTPUT.put_line(composition);
end;









    