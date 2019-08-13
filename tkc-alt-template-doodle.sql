CLEAR SCREEN;

DECLARE
    s     VARCHAR2(32767);
    rep   VARCHAR2(5);
    i     NUMBER;
    rbt   tbl_type := tbl_type('ckd', 'dm', 'htn', 'cad');
    pat1   varchar2(100);
    pat2   varchar2(100);
BEGIN
    s := '
    Diagnoses
    [ckd_n]. CKD stage 2
        [ckd_n.n] Glomerular stage G2
        [ckd_n.n] Albuminuria stage A2
        [ckd_n.n] Bland sediment
        [ckd_n.n] Renal Imaging
        [ckd_n.n] Likely cause
        [ckd_n.n] Trajectory
    [dm_n]. DM 2
        [dm_n.n] diagnosed 2011
        [dm_n.n] suboptimal control
        [dm_n.n] microvascular disease
    [htn_n]. Hypertension
        [htn_n.n] diagnosed 1998
    [cad_n]. Coronary artery disease   
        
    '
    ;
    FOR r IN 1..rbt.count LOOP 
        pat1:='\[' || rbt(r) ||'_n\]';
        FOR j1 IN 1..regexp_count(s,pat1 ) LOOP
            rep := r;
            s := regexp_replace(s, pat1, rep, 1, 1, 'x');
            pat2:='\[' || rbt(r) ||'_n\.n\]';
            FOR j2 IN 1..regexp_count(s, pat2) LOOP
                rep := r
                       || '.'
                       || j2;
                s := regexp_replace(s, pat2, rep, 1, 1, 'x');
            END LOOP;
    
        END LOOP;
    END LOOP;

    dbms_output.put_line('text  :' || s);
    dbms_output.put_line('occ   :' || i);
END;