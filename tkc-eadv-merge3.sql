clear screen;

DROP TABLE EADV;
/
CREATE TABLE EADV
(
    eid NUMBER(12,0) NOT NULL,
    att VARCHAR2(32) NOT NULL,
    dt DATE NOT NULL,
    val NUMBER(15,2)
);
/

-- Insert patient result numeric
INSERT INTO EADV(EID,ATT,DT,VAL)
SELECT
    lr.linked_registrations_id as eid,
    rcm.ncomp as att,
    rn.date_recorded as dt,
    rn.numeric_result as val
FROM    patient_results_numeric rn
JOIN    patient_registrations pr on pr.id=rn.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.id=rn.component_id
WHERE rcm.ncomp is not null;
/

--Insert patient result coded, icpc,icd, caresys
INSERT INTO EADV(EID,ATT,DT,VAL)
SELECT
    lr.linked_registrations_id as eid,
    CAST((lower(rc.classification) || '_' ||lower(translate(rc.code,'.- ','_'))) AS VARCHAR2(30)) as att,
    rc.date_recorded as dt,
    NULL as val
FROM    patient_results_coded rc
JOIN    patient_registrations pr on pr.id=rc.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
/

--update value for certain icpc codes for performance
update eadv set val=1 where att = 'icpc_u99035';
update eadv set val=2 where att = 'icpc_u99036';
update eadv set val=3 where att = 'icpc_u99037';
update eadv set val=3 where att = 'icpc_u99043';
update eadv set val=4 where att = 'icpc_u99044';
update eadv set val=5 where att = 'icpc_u99038';
update eadv set val=6 where att = 'icpc_u99039';


--insert  Derived results eGFR
INSERT INTO EADV(EID,ATT,DT,VAL)
SELECT
    lr.linked_registrations_id as eid,
    'lab_bld_egfr_c' as att,
    date_recorded as dt,
    round(result,0) as val
FROM
    patient_results_derived prd
JOIN    patient_registrations pr on pr.id=prd.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
WHERE prd.derivedresultname='eGFR KDIGO';
/

--insert  Derived results bmi
INSERT INTO EADV(EID,ATT,DT,VAL)
SELECT
    lr.linked_registrations_id as eid,
    rcm.ncomp as att,
    date_recorded as dt,
    round(result,0) as val
FROM
    patient_results_derived prd
JOIN    patient_registrations pr on pr.id=prd.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.key=prd.derivedresultname
WHERE prd.derivedresultname='BMI';

--OP encounters
INSERT INTO EADV(EID,ATT,DT,VAL)
SELECT
    lr.linked_registrations_id   as eid,
    'enc_op_renal'               as att,
    date_recorded                as dt,
    null as                       val
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
WHERE prt.component_id=47
AND regexp_substr(text_result,'(TEAM: )([A-Z]{3})',1,1,'i',2)='REN'
;
/

-- RxClass
MERGE INTO eadv t1
USING (
with cte1 as(
SELECT distinct
    lr.linked_registrations_id as eid,
    'rxnc_' || lower(rrm.rxclassid) as att,
    date_recorded as dt,
    prescription_end as enddt,
    case when prescription_end is null then 1 else 0 end val,
    row_number() over(partition by lr.linked_registrations_id,rrm.rxclassid,date_recorded order by null) as rn
FROM
    patient_results_prescription prp
JOIN    patient_registrations pr on pr.id=prp.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_rxmap rmp on rmp.pres=upper(prp.prescription)
JOIN    system_rxcui_rxclassid_map rrm on rrm.rxcui=rmp.rxcui_approx
WHERE prp.date_recorded> TO_DATE('01/01/2000','DD/MM/YYYY') 
) 
select * from cte1 where rn=1) t2
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN MATCHED THEN
    UPDATE SET VAL=0 where t2.enddt IS NOT NULL
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
/





--care plan
MERGE INTO eadv t1
USING(
WITH CTE1 AS(
SELECT
    lr.linked_registrations_id as eid,
    'careplan_h9_v1'    as att,
    date_recorded                as dt,
    tkc_util.transform_h9_careplantxt(prt.text_result) as  val
    ,ROW_NUMBER() over(partition by lr.linked_registrations_id order by date_recorded desc) as rn
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
WHERE prt.component_id=15)
SELECT eid,att,dt,val from CTE1 where rn=1
) t2
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
/

--smoking status 
MERGE INTO eadv t1
USING(
WITH CTE1 AS(
SELECT
    lr.linked_registrations_id as eid,
    'status_smoking_h2_v1'    as att,
    date_recorded                as dt,
    tkc_util.transform_h2_smokingstatus (prt.text_result) as  val
    ,ROW_NUMBER() over(partition by lr.linked_registrations_id order by date_recorded desc) as rn
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
WHERE prt.component_id=62)
SELECT eid,att,dt,val from CTE1 where rn=1
) t2
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
    
    
-- Urine sediment
delete from eadv where att='lab_ua_rbc';
delete from eadv where att='lab_ua_leucocytes';

MERGE INTO eadv t1
USING (
SELECT
    lr.linked_registrations_id as           eid,
    rcm.ncomp as                            att,
    rn.date_recorded as                     dt,
    tkc_util.transform_h2_ua_cells(to_char(rn.numeric_result)) as val
FROM    patient_results_numeric rn
JOIN    patient_registrations pr on pr.id=rn.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.id=rn.component_id
WHERE rn.component_id in (58, 37)
UNION ALL
SELECT
    lr.linked_registrations_id as eid,
    rcm.ncomp as att,
    date_recorded                as dt,
    tkc_util.transform_h2_ua_cells(prt.text_result) as val
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.id=prt.component_id
WHERE prt.component_id in (37,71,72)
) t2
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
/
--Pcis service items
MERGE INTO eadv t1
USING (
SELECT
    lr.linked_registrations_id as eid,
    rcm.ncomp as att,
    date_recorded                as dt,
    tkc_util.transform_h2_education(prt.text_result) as val
    --,to_char(prt.text_result) as val0
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.id=prt.component_id
WHERE prt.component_id in (22)
) t2 
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
/

--Ris encounters
MERGE INTO eadv t1
USING (
SELECT
    lr.linked_registrations_id as eid,
    rcm.ncomp || tkc_util.transform_att_imaging(prt.text_result) as att,
    date_recorded                as dt,
    null as val
    ,prt.text_result as val0
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.id=prt.component_id
WHERE prt.component_id in (80)
) t2 
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
/

--CVRA
MERGE INTO eadv t1
USING (
SELECT
    lr.linked_registrations_id as eid,
    'asm_cvra' as att,
    date_recorded                as dt,
    tkc_util.transform_h2_cvra(prt.text_result) as val
    --,prt.text_result as val0
FROM
    patient_results_text prt
JOIN    patient_registrations pr on pr.id=prt.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    rman_comp_map rcm on rcm.id=prt.component_id
WHERE prt.component_id in (11)
) t2 
ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val);
/

-- Remove duplicates
-- 151 s
delete from eadv
where rowid in (select rowid from 
   (select 
     rowid,
     row_number()  over(partition by eid,att,dt order by null) dup
    from eadv
    )
  where dup > 1
);



-- Build Indexes


create bitmap index eadv_att_idx on eadv(att) compute STATISTICS;
create bitmap index eadv_eid_idx on eadv(eid) compute STATISTICS;

analyze table eadv compute STATISTICS;

--location
DROP VIEW vw_eadv_locality;
/
CREATE VIEW vw_eadv_locality AS (
select distinct 
        lr.linked_registrations_id as eid,    
        'dmg_location' as att,
        date_recorded as dt,
        initcap(shcm.reference_location) as val
FROM    patient_results_numeric prn
JOIN    patient_registrations pr on pr.id=prn.patient_registration_id 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
JOIN    system_health_centre_metadata shcm on shcm.health_centre_name=prn.location
);

/

DROP VIEW vw_eadv_dmg;
-- Expose demographics from patient_registrations as eadv
CREATE VIEW vw_eadv_dmg as 
(SELECT distinct
    lr.linked_registrations_id as eid,
    'dmg_dob' as att,
    date_of_birth as dt,
    NULL as val
FROM    patient_registrations pr 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
UNION ALL
SELECT distinct
    lr.linked_registrations_id as eid,
    'dmg_gender' as att,
    sysdate as dt,
    case pr.sex when 1 then 1 else 0 end as val
FROM    patient_registrations pr 
JOIN    linked_registrations lr on lr.patient_registration_id=pr.id); 




