with cte1 as (
SELECT eid, att, dt,rman_pckg.map_to_tmplt(t0.valc,tmp.templatehtml) as body,tmp.placementid
FROM(
    SELECT
        eid,dt,att,valc,src,ROW_NUMBER() OVER (PARTITION BY eid,att ORDER BY dt) AS rn
    FROM eadvx
) t0
JOIN rman_rpt_templates tmp on tmp.ruleblockid=t0.src
WHERE t0.rn=1)
select eid
,LISTAGG(body, '') WITHIN GROUP(ORDER BY placementid) as txt
FROM cte1
GROUP BY eid
;






    