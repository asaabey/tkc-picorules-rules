clear screen
declare
    composition nvarchar2(4000);
    eid         integer;

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
and eid=701)
select eid
,LISTAGG(body, '') WITHIN GROUP(ORDER BY placementid) into eid,composition
FROM cte1
GROUP BY eid
;

DBMS_OUTPUT.put_line('EID:' || eid);

DBMS_OUTPUT.put_line(composition);
end;








    