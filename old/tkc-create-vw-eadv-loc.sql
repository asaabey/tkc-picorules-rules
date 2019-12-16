--
--explain plan for 
--select 
--    lr.linked_registrations_id eid,
--    'dmg_location' as att,
--    pn.date_recorded dt,
--    coalesce(lm.sublocality_id,s.dflt_sublocality_id) val
--from patient_results_numeric pn
--inner join patient_registrations pr on pr.id=pn.patient_registration_id
--inner join linked_registrations lr on pn.patient_registration_id=lr.patient_registration_id
--inner join sources s on pr.source_id=s.id
--left join location_mappings lm on lm.result_location=upper(pn.location)
--union
--select 
--    lr.linked_registrations_id eid,
--    'dmg_location' as att,
--    pn.date_recorded dt,
--    coalesce(lm.sublocality_id,s.dflt_sublocality_id) val
--from patient_results_coded pn
--inner join patient_registrations pr on pr.id=pn.patient_registration_id
--inner join linked_registrations lr on pn.patient_registration_id=lr.patient_registration_id
--inner join sources s on pr.source_id=s.id
--left join location_mappings lm on lm.result_location=upper(pn.location)
--;
--select plan_table_output from table(dbms_xplan.display());


--explain plan for
drop view vw_eadv_loc;
/
create view vw_eadv_loc as 
with cte1 as(
    select 
    pn.patient_registration_id pid,
    pn.date_recorded dt,
    pn.location loc
    from patient_results_numeric pn
    union
    select 
    pn.patient_registration_id pid,
    pn.date_recorded dt,
    pn.location loc
    from patient_results_coded pn
    union
    select 
    pn.patient_registration_id pid,
    pn.date_recorded dt,
    pn.location loc
    from patient_results_text pn
)

select distinct
    lr.linked_registrations_id eid,
    'dmg_location' as att,
    c.dt dt,
    coalesce(lm.sublocality_id,s.dflt_sublocality_id) val
from cte1 c
inner join patient_registrations pr on pr.id=c.pid
inner join linked_registrations lr on c.pid=lr.patient_registration_id
inner join sources s on pr.source_id=s.id
left join location_mappings lm on lm.result_location=upper(c.loc);

--select plan_table_output from table(dbms_xplan.display());
create table tmp_loc_1 as
select 
    eid,
    max(dt) max_dt,
    median(dt) median_dt,
    min(dt) min_dt
from vw_eadv_loc
group by eid
order by eid;
