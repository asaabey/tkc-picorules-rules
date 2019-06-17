clear screen
declare
    composition clob;
    eid         integer;

function get_composition_by_eid(eid_in int,nlc_id varchar2) return clob
as
composition clob;    
begin
with cte1 as (
SELECT eid, att, dt,rman_pckg.map_to_tmplt(t0.valc,tmp.templatehtml) as body,tmp.placementid
FROM(
    SELECT
        eid,dt,att,valc,src,ROW_NUMBER() OVER (PARTITION BY eid,att ORDER BY dt) AS rn
    FROM eadvx
) t0
JOIN rman_rpt_templates tmp on tmp.ruleblockid=t0.src
WHERE t0.rn=1
and eid=eid_in)
select LISTAGG(body, '') WITHIN GROUP(ORDER BY placementid) into composition
FROM cte1
GROUP BY eid;

return composition;

end get_composition_by_eid;

begin
    eid:=6053;
    composition:=get_composition_by_eid(eid,'neph001');
    DBMS_OUTPUT.put_line('EID:' || eid);

    DBMS_OUTPUT.put_line(composition);
end;









    