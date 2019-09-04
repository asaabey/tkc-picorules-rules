clear screen;

declare
    dts varchar2(2000);
    vals varchar2(2000);
    
    eid_in  number:=71;
    
    graph   varchar2(4000):='No graph';
    
    egfr_max_dt varchar2(100);
    egfr_max_val integer;
begin

    select egfrs_dt,egfrs_val,egfr_max_dt,egfr_max_val 
    into dts,vals,egfr_max_dt,egfr_max_val
    from rout_egfr_fit
    where eid=eid_in;

    graph:=rman_pckg.ascii_graph_dv(dts=>dts,vals=>vals,yscale=>10);
    
    DBMS_OUTPUT.PUT_LINE(graph);
    
    DBMS_OUTPUT.PUT_LINE('max val :' || egfr_max_val);
    
    DBMS_OUTPUT.PUT_LINE('max dt :' || egfr_max_dt);
    
    DBMS_OUTPUT.PUT_LINE('vals -> ' || vals);
    DBMS_OUTPUT.PUT_LINE('dts -> ' || dts);
end;