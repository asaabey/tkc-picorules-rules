DROP TABLE rman_admin_sqlblocks;

CREATE TABLE rman_admin_sqlblocks (
    id         NUMBER(6, 0) NOT NULL,
    sqlblock   VARCHAR2(4000),
    desc_txt    VARCHAR2(200),
    activity   VARCHAR2(1000),
    active     NUMBER(4, 0),
    chksum     VARCHAR2(32),
    CONSTRAINT pk_rman_admin_sqlblocks PRIMARY KEY (id)
);

INSERT INTO rman_admin_sqlblocks VALUES(
    100,
    'CREATE TABLE "EADV" (
                "EID" NUMBER(12,0)      NOT NULL, 
                "ATT" VARCHAR2(32 BYTE) NOT NULL, 
                "DT" DATE               NOT NULL,
                "VAL" NUMBER(15,2)
    )',
    'create eadv table',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    111,
    'DROP INDEX EADV_ATT_IDX',
    'drop index on att',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    112,
    'DROP INDEX EADV_ATT_IDX',
    'drop index on eid',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    115,
    'TRUNCATE TABLE EADV',
    'truncate eadv',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    161,
    'CREATE BITMAP INDEX EADV_ATT_IDX ON EADV(ATT)',
    'create index on att',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    162,
    'CREATE BITMAP INDEX EADV_ATT_IDX ON EADV(EID)',
    'create index on eid',
    'build eadv',
    1,
    ''    
);
INSERT INTO rman_admin_sqlblocks VALUES(
    120,
    'MERGE INTO eadv t1
        USING (
            SELECT
                lr.linked_registrations_id as eid,
                rcm.ncomp as att,
                rn.date_recorded as dt,
                rn.numeric_result as val
            FROM    patient_results_numeric rn
            JOIN    patient_registrations pr on pr.id=rn.patient_registration_id
            JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
            JOIN    rman_comp_map rcm on rcm.id=rn.component_id
            WHERE rcm.ncomp is not null
            ) t2
        ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
        WHEN NOT MATCHED THEN
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient result numeric',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    121,
    'MERGE INTO eadv t1
        USING (
        SELECT
            lr.linked_registrations_id as eid,
            REPLACE(
                CAST((lower(rc.classification) || ''_'' ||lower(translate(rc.code,''.- '',''_''))) AS VARCHAR2(30)) 
               ,''icpc-2 plus_'',''icpc_'') as att,
            rc.date_recorded as dt,
            case (CAST((lower(rc.classification) || ''_'' ||lower(translate(rc.code,''.- '',''_'')))  AS VARCHAR2(30)))
            --update value for certain icpc codes for performance
                when ''icpc_u99035'' then 1
                when ''icpc_u99036'' then 2
                when ''icpc_u99037'' then 3
                when ''icpc_u99043'' then 3
                when ''icpc_u99044'' then 4
                when ''icpc_u99038'' then 5
                when ''icpc_u99039'' then 6
                
                when ''icpc_u88j91'' then 1
                when ''icpc_u88j92'' then 2
                when ''icpc_u88j93'' then 3
                when ''icpc_u88j94'' then 4
                when ''icpc_u88j95'' then 5
                when ''icpc_u88j96'' then 6
            else 
            NULL end as val
        FROM    patient_results_coded rc
        JOIN    patient_registrations pr on pr.id=rc.patient_registration_id
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        ) t2
        ON (
            t1.eid=t2.eid 
            and t1.att=t2.att 
            and t1.dt=t2.dt)
        WHEN NOT MATCHED THEN
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient result coded',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    122,
    'MERGE INTO eadv t1
        USING (
        SELECT
            lr.linked_registrations_id   as eid,
            rcm.ncomp                    as att,
            date_recorded                as dt,
            null as                       val
        FROM
            patient_results_text prt
        JOIN    patient_registrations pr on pr.id=prt.patient_registration_id
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        JOIN    rman_comp_map rcm on rcm.id=prt.component_id
        WHERE   prt.component_id=47
        AND regexp_substr(text_result,''(TEAM: )([A-Z]{3})'',1,1,''i'',2)=''REN''
        ) t2
        ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
        WHEN NOT MATCHED THEN
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient outpatient encounters',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    123,
    'MERGE INTO eadv t1
        USING (
        with cte1 as(
        SELECT distinct
            lr.linked_registrations_id as eid,
            ''rxnc_'' || lower(rrm.rxclassid) as att,
            date_recorded as dt,
            prescription_end as enddt,
            case when prescription_end is null then 1 else 0 end val,
            row_number() over(partition by lr.linked_registrations_id,rrm.rxclassid,date_recorded order by null) as rn
        FROM
            patient_results_prescription prp
        JOIN    patient_registrations pr on pr.id=prp.patient_registration_id
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        --JOIN    rman_rxmap rmp on rmp.pres=upper(prp.prescription)
        JOIN    system_rxcui_rxclassid_map rrm on prp.RXCUI=rrm.rxcui
        WHERE prp.date_recorded> TO_DATE(''01/01/2000'',''DD/MM/YYYY'')
        )
        select * from cte1 where rn=1) t2
        ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
        WHEN MATCHED THEN
            UPDATE SET VAL=0 where t2.enddt IS NOT NULL
        WHEN NOT MATCHED THEN
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient rxclass',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    124,
    'MERGE INTO eadv t1
        USING(
        WITH CTE1 AS(
        SELECT
            lr.linked_registrations_id as eid,
            ''careplan_h9_v1''    as att,
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
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient other misc',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    125,
    'MERGE INTO eadv t1
        USING(
        WITH CTE1 AS(
        SELECT
            lr.linked_registrations_id as eid,
            ''status_smoking_h2_v1''    as att,
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
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge Smoking Status',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    126,
    'delete from eadv where att=''lab_ua_rbc''',
    'Merge Urine sediment',
    'build eadv',
    1,
    ''    
);
INSERT INTO rman_admin_sqlblocks VALUES(
    127,
    'delete from eadv where att=''lab_ua_leucocytes''',
    'Merge Urine sediment',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    128,
    'MERGE INTO eadv t1
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
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge Urine sediment',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    129,
    'MERGE INTO eadv t1
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
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge Pcis service items',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    130,
    'MERGE INTO eadv t1
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
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient RIS encounters',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    131,
    'MERGE INTO eadv t1
        USING (
        SELECT DISTINCT
         lr.linked_registrations_id   AS eid,
         ''csu_action_'' || prt.cse_block_id || ''_'' || prt.cse_att_id  AS att,
         prt.action_date              AS dt,
         prt.action_id                AS val
     FROM
         patient_cse_actions prt
         JOIN patient_registrations pr ON pr.id = prt.patient_registration_id
         JOIN linked_registrations lr ON lr.patient_registration_id = pr.id
        ) t2 
        ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
        WHEN NOT MATCHED THEN
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient CSU actions',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    132,
    'MERGE INTO eadv t1
        USING (
        SELECT
            lr.linked_registrations_id as eid,
            rcm.ncomp as att,
            date_recorded                as dt,
            tkc_util.transform_h2_cvra(prt.text_result) as val
        FROM
            patient_results_text prt
        JOIN    patient_registrations pr on pr.id=prt.patient_registration_id
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        JOIN    rman_comp_map rcm on rcm.id=prt.component_id
        WHERE prt.component_id in (11)
        ) t2
        ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
        WHEN NOT MATCHED THEN
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge CVRA',
    'build eadv',
    1,
    ''    
);


INSERT INTO rman_admin_sqlblocks VALUES(
    133,
    'MERGE INTO eadv t1
        USING (
        SELECT distinct
            lr.linked_registrations_id as eid,
            ''dmg_dob'' as att,
            date_of_birth as dt,
            NULL as val
        FROM    patient_registrations pr
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        WHERE
        date_of_birth is not null
        UNION ALL
        SELECT distinct
            lr.linked_registrations_id as eid,
            ''dmg_gender'' as att,
            date_of_birth as dt,
            case pr.sex when 1 then 1 else 0 end as val
        FROM    patient_registrations pr
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        UNION ALL
        SELECT distinct
            lr.linked_registrations_id as eid,
            ''dmg_dod'' as att,
            date_of_death as dt,
            null as val
        FROM    patient_registrations pr
        JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
        WHERE
        date_of_death is not null
        ) t2
        ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
        WHEN NOT MATCHED THEN
            INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)',
    'Merge patient demographics',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    134,
    'MERGE INTO eadv t1 USING (
                                    WITH cte1 AS (
                                        SELECT
                                            pn.patient_registration_id   pid,
                                            pn.date_recorded             dt,
                                            pn.location                  loc
                                        FROM
                                            patient_results_numeric pn
                                        UNION
                                        SELECT
                                            pn.patient_registration_id   pid,
                                            pn.date_recorded             dt,
                                            pn.location                  loc
                                        FROM
                                            patient_results_coded pn
                                        UNION
                                        SELECT
                                            pn.patient_registration_id   pid,
                                            pn.date_recorded             dt,
                                            pn.location                  loc
                                        FROM
                                            patient_results_text pn
                                    ),cte2 AS (
                                        SELECT DISTINCT
                                            lr.linked_registrations_id   eid,
                                            ''dmg_location'' AS att,
                                            c.dt                         dt,
                                            coalesce(lm.sublocality_id,s.dflt_sublocality_id) val
                                        FROM
                                            cte1 c
                                            INNER JOIN patient_registrations pr ON pr.id = c.pid
                                            INNER JOIN linked_registrations lr ON c.pid = lr.patient_registration_id
                                            INNER JOIN sources s ON pr.source_id = s.id
                                            LEFT JOIN location_mappings lm ON lm.result_location = upper(c.loc)
                                    )
                                    SELECT
                                        eid,
                                        att,
                                        dt,
                                        val
                                    FROM
                                        cte2
                                )
        t2 ON ( t1.eid = t2.eid
                AND t1.att = t2.att
                AND t1.dt = t2.dt )
        WHEN NOT MATCHED THEN INSERT (
            eid,
            att,
            dt,
            val ) VALUES (
            t2.eid,
            t2.att,
            t2.dt,
            t2.val )',
    'Merge patient demographics location history',
    'build eadv',
    1,
    ''    
);

INSERT INTO rman_admin_sqlblocks VALUES(
    150,
    'delete from eadv
        where rowid in (select rowid from
           (select
             rowid,
             row_number()  over(partition by eid,att,dt order by null) dup
            from eadv
            )
          where dup > 1
        )',
    'Remove duplicates',
    'build eadv',
    1,
    ''    
);


INSERT INTO rman_admin_sqlblocks VALUES(
    163,
    'ANALYZE TABLE EADV COMPUTE STATISTICS',
    'Compute statistics',
    'build eadv',
    1,
    ''    
);