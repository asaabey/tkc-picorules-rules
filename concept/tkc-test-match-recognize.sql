CLEAR SCREEN;

DECLARE
    s               VARCHAR2(1000);
    tbl             VARCHAR2(100):='eadv';
    entity_id_col   VARCHAR2(100) := 'eid';
    att_col         VARCHAR2(100) := 'att';
    dt_col          VARCHAR2(100) := 'dt';
    val_vol         VARCHAR2(100) := 'val';
    att             VARCHAR2(100) := 'lab_bld_egfr_c';
    pattern_str     VARCHAR2(400) := 'PATTERN (a+ b+) ';
    def_str         VARCHAR2(400) := 'DEFINE
                a AS ( val * 0.8 < prev(val) ),
                b AS ( val * 0.8 > prev(val) )';
BEGIN
    s := 'SELECT '
         || entity_id_col
         || ' ,MIN(ps_dt) AS dt,COUNT(ps_dt) AS val FROM (SELECT '
         || entity_id_col
         || ',ps_dt FROM '
         || tbl
         || ' MATCH_RECOGNIZE (PARTITION BY '
         || entity_id_col
         || ','
         || att_col
         || ' ORDER BY '
         || dt_col
         || '  MEASURES FIRST('
         || dt_col
         || ') AS ps_dt '
         || pattern_str
         || ' '
         || def_str
         || ') WHERE ' 
         || att_col
         || '='''
         || att
         || ''') GROUP BY '
         || entity_id_col
         ;
         
         
    dbms_output.put_line(s);
    EXECUTE IMMEDIATE s;
END;