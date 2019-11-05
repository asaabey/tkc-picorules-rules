--set serveroutput on;
clear screen;
declare
    composition clob;
    eid         integer;


begin

--        eid:=&val;
    eid:=9710;
    composition:=rman_pckg.get_composition_by_eid(eid,'neph002');
    
    
    DBMS_OUTPUT.put_line('EID:' || eid);

    DBMS_OUTPUT.put_line(composition);
end;









    