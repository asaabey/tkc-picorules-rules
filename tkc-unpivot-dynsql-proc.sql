DECLARE
s varchar2(4000);
PROCEDURE select_into_new_table(
    colname     IN  VARCHAR2,
    new_tbl_name IN  VARCHAR2,
    source_tbl_name IN VARCHAR2,
    sql_out         OUT VARCHAR2
)
AS
    select_sql  VARCHAR2(4000);
BEGIN
    select_sql:='CREATE TABLE ' || new_tbl_name ||' AS SELECT EID,''' || colname || ''' AS ATT,SYSDATE AS DT, ' || colname || ' AS VAL FROM ' || source_tbl_name; 
    sql_out:=select_sql;
END select_into_new_table;
BEGIN
    select_into_new_table('RRT','EADV_T2','rout_rrt_1_1',s);
    EXECUTE IMMEDIATE s;
    DBMS_OUTPUT.put_line('func-> ' || s);
END;
/

