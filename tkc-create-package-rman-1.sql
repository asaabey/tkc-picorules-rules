CLEAR SCREEN;


CREATE OR REPLACE PACKAGE rman_pckg 
AUTHID CURRENT_USER
AS

/*

Package		    rman_pckg
Version		    0.0.1.9
Creation date	07/04/2019
update on date  05/07/2019
Author		    asaabey@gmail.com

Purpose		
Dynamic rules engine, which converts 'picorules' script to ANSI SQL script. Source table needs to conform to EADV format (entity,attribute,date,value).
Rules are inserted into RPIPE table which is parsed by PARSE_RPIPE procedure to create RMAN table. The get_composite_sql procedure forms the SQL statement with recursive CTE's.

The SQL statement can be dynamically executed using exec_dsql (Method 4 dynamic SQL using the dbms_sql package) or exec_NDS (native dynamic SQL using) 
creating wide tables. Long tables /Datastore (EADV) are generated using exec_dsql_dstore_multi/singlecol functions using dbms_sql.


*/
/*
    +-------------+
    |  ruleblock  |
    +------+------+
           |
           |  execute_active_ruleblocks()
           |  
           |  execute_ruleblock()
           |
           |  parse_ruleblocks()
           |
           v
    +------+------+
    |    rpipe    +------------+-----------+
    +-------------+            |           |
                               |           |
              parse_rpipe()    |           |
                               |           |
                               |           |
         +-----------------+   |  +--------v--------+
         | func_expression +<--+  | cond_expression |
         +-----------------+      +-----------------+
                    |                       |
  build_func_sql()  +----+        +---------+    build_cond_sql()                   
                         |        | 
                    +----v--------v-+
                    |      rstack   |
                    +---------------+
                             +
                             |
                             |   get_composite_sql()
                             |
                             v
                     +-------+--------+
           +---------+  SQL statement +--------+
           |         +------------+---+        |
           |                      |            |
           |                      |            |
           |  exec_dsql() /       |            |   exec_dsql_dstore_multicol()
           |                      |            |
           |  exec_ndsql()        |            |
           |                      |   exec_dsql_dstore_singlecol()
           |                      |            |
           v                      |            v
    +------+-------+              |   +--------+-------+
    |  wide table  |              +-->+    long table  |
    +--------------+                  |      EADV      |
                                      +----------------+

     
     
     
*/
/*
Functional declaration, is a aggregate/analytic function which returns a single row for each entitiy
This creates a handle/pointer to another table (default is eadv). The declaration is defined by the '=>' operator.


varname => object.attribute.property.function(param);

[varname]=> object.[attribute].property.function(param)
[varname]=> object.[attribute%].property.function(param)

Shorthand
LAST() implied
varname=> object.attribute.property

VAL.LAST() implied
varname=> object.attribute

EADV.[att].VAL.LAST() implied
varname=> attribute

Attribute predicates
 [att1,att2,att3%]
 is compiled to
 (ATT = 'att1') OR (ATT = 'att2') OR (ATT LIKE 'att3%')
*/

--Commenting
-- /* comment */

/*
Intermediate variables
 if the assigned name is terminated with an underscore , it will not be displayed in the final ROUT table
  var_

Emplicit variable use
Prior to rman 0.0.0.9 variables had to be passed. Now variables can be used implicitly as they detected by the parser

NVL injection
COUNT aggregate function returned null due to grouping. Now a func param can be passed to inject NVL
 var1 => eadv.att_name.val.count(0)



Conditional declaration
varname(dependent var,..): { sql_case_when_expr => sql_case_then_expr},..,{=> sq_case_else_then_expr}
This can be used to derive any SQL scalar function
varname(dependent var,..):{1=1 => sql_scalar_func()}

External table binding
tbl.att.val.bind()
should only be used were eid->att is 1:1

Change Log
----------
22/06/2019  Implemented Template engine
23/06/2019  Added execute_ruleblock
05/07/2019  Added execute_active_ruleblocks
05/07/2019  Added Exception handling 
07/07/2019  Added Logging
08/07/2019  Performance boosts using rout tables
09/07/2019  Added Gen Datacubes
10/07/2019  Bug fix: dv functions introduced multiple variable return, which caused multiple same name cte joins. this is fixed now


*/
    TYPE rman_tbl_type IS TABLE OF rman_stack%ROWTYPE;
    
    TYPE rpipe_tbl_type IS TABLE OF rman_rpipe%ROWTYPE;
    
    TYPE rman_ruleblocks_type IS TABLE OF rman_ruleblocks%ROWTYPE;
    
    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    vstack          vstack_type;
    vstack_empty    vstack_type;
    
    TYPE vstack_func_type IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    vstack_func      vstack_func_type;
    
    TYPE vstack_func_param_type IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    vstack_func_param      vstack_func_param_type;
    
    TYPE tstack_type IS TABLE OF VARCHAR2(30);
    tstack          tstack_type:=tstack_type();
    tstack_empty    tstack_type:=tstack_type();
    
    cmpstat NVARCHAR2(4000);
    
    rman_index PLS_INTEGER:=0;
    
    assn_op CONSTANT VARCHAR2(2):='=>';
    like_op CONSTANT CHAR:='%';
    comment_open_chars      CONSTANT VARCHAR(2):='/*';
    comment_close_chars     CONSTANT VARCHAR(2):='*/';
    
    entity_id_col       CONSTANT VARCHAR2(32):='EID';
    att_col             CONSTANT VARCHAR2(32):='ATT';
    val_col             CONSTANT VARCHAR2(32):='VAL';
    dt_col              CONSTANT VARCHAR2(32):='DT';
    def_tbl_name        CONSTANT VARCHAR2(32):='EADV';
    
    
    PROCEDURE parse_rpipe (sqlout OUT varchar2);
    
    PROCEDURE get_composite_sql(cmpstat OUT NVARCHAR2); 
    
    FUNCTION sql_predicate(att_str VARCHAR2) RETURN VARCHAR2;
    
    FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2;
    
    
    FUNCTION splitstr(list in varchar2,delimiter in varchar2 default ',',ignore_left in CHAR DEFAULT '[',  ignore_right in CHAR DEFAULT ']') return tbl_type;
    
    FUNCTION splitclob(list in clob,delimiter in varchar2 default ',', ignore_left in CHAR DEFAULT '[', ignore_right in CHAR DEFAULT ']') return tbl_type2;
    
    FUNCTION sanitise_clob(clbin CLOB) RETURN CLOB;
    
    FUNCTION get_cte_name (indx BINARY_INTEGER) return NVARCHAR2; 
    
    FUNCTION trim_comments(txtin clob) RETURN clob;
    
    FUNCTION modify_ps_on_funcparam(txtin varchar2) return varchar2;
    
    FUNCTION map_to_tmplt(jstr varchar2,tmplt varchar2 ) RETURN VARCHAR2;
    
    FUNCTION get_composition_by_eid(eid_in int,nlc_id varchar2) RETURN CLOB;
    
    PROCEDURE insert_rman
    (
     indx INT,
    where_clause NVARCHAR2,
    from_clause  NVARCHAR2,
    select_clause NVARCHAR2,
    groupby_clause  NVARCHAR2,
    varid NVARCHAR2,
    is_sub INT,
    sqlstat OUT NVARCHAR2,
    agg_func VARCHAR2,
    func_param VARCHAR2
    
    );
    
    PROCEDURE build_func_sql_exp
    (
    blockid     in varchar2,
    indx        IN INT,
    txtin       varchar2,
    sqlstat     OUT VARCHAR2,
    rows_added OUT PLS_INTEGER
    ) ;
    
    
    PROCEDURE build_cond_sql_exp(indx PLS_INTEGER,txtin IN varchar2,sqlstat OUT varchar2,rows_added OUT PLS_INTEGER);  
    
    PROCEDURE parse_ruleblocks(blockid varchar2);
    
    PROCEDURE exec_dsql(sqlstmt clob,tbl_name varchar2) ;
    
    PROCEDURE exec_dsql_dstore2(blockid varchar2,sqlstmt clob,tbl_name varchar2,disc_col varchar2, predicate varchar2);
    
    PROCEDURE exec_dsql_dstore_multicol(blockid varchar2,sqlstmt clob,tbl_name varchar2,disc_col varchar2, predicate varchar2); 
    
    PROCEDURE exec_dsql_dstore_singlecol(blockid varchar2,sqlstmt clob,tbl_name varchar2,disc_col varchar2, predicate varchar2);
    
    PROCEDURE exec_ndsql(sqlstmt clob,tbl_name varchar2) ;
    
    PROCEDURE compile_ruleblock(bid_in IN varchar2);
    
    PROCEDURE compile_active_ruleblocks;
    
    
    PROCEDURE execute_ruleblock(bid_in IN varchar2, create_wide_tbl IN PLS_INTEGER, push_to_long_tbl IN PLS_INTEGER,push_to_long_tbl2 IN PLS_INTEGER,recompile IN PLS_INTEGER);
    
    PROCEDURE execute_active_ruleblocks(recompile IN NUMBER);
    
    PROCEDURE drop_rout_tables;
    
    PROCEDURE commit_log(moduleid  in varchar2,blockid   in varchar2,log_msg   in varchar2);
    
    PROCEDURE gen_cube_from_ruleblock(ruleblockid varchar2,slices_str  varchar2);
END;
/


CREATE OR REPLACE PACKAGE BODY rman_pckg AS

--https://stackoverflow.com/questions/3710589/is-there-a-function-to-split-a-string-in-pl-sql/3710619#3710619

FUNCTION sql_predicate(att_str VARCHAR2) RETURN VARCHAR2
AS
att_tbl tbl_type;
eq_op VARCHAR2(6);
att_str0    VARCHAR2(4000);
escape_stat VARCHAR(20):=' ESCAPE ''!''';
s VARCHAR2(5000);
att_col CONSTANT VARCHAR2(30):='ATT';
BEGIN
    att_str0:=att_str;
    IF INSTR(att_str0,'[')>0 AND INSTR(att_str0,']')>0 THEN
        att_str0:=SUBSTR(att_str0,INSTR(att_str0,'[')+1,INSTR(att_str0,']')-2);
    END IF;
    IF INSTR(att_str0,',')>0 THEN
        att_tbl:=rman_pckg.splitstr(att_str0,',','','');
        FOR i in 1..att_tbl.COUNT LOOP
            IF INSTR(att_tbl(i),'%')>0 THEN
                eq_op:=' LIKE ';
            ELSE 
                eq_op:=' = ';
            END IF;
            
            s:=s || '(' || att_col || eq_op || '`' || att_tbl(i) || '`)';
            IF i<att_tbl.COUNT THEN
                s:=s || ' OR ';
            END IF;
        END LOOP;
    ELSIF INSTR(att_str0,',')=0 THEN
        IF INSTR(att_str0,'%')>0 THEN
                eq_op:=' LIKE ';
            ELSE 
                eq_op:=' = ';
            END IF;
            s:=s || '(' || att_col || eq_op || '`' || att_str0 || '`)';  
    END IF;
    
    return s;
END sql_predicate;

FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2
AS
    s VARCHAR2(100); 
BEGIN
    -- trim bounding parantheses
    s:= TRANSLATE(varname, '1-+{}[] ', '1');
    -- surround with double quotes if full stop and spaces found in var from varnames if not already there
    IF instr(varname,'"')<>1 AND instr(varname,'.')>0 OR instr(varname,' ')>0 THEN 
        s:= '"' || s || '"';
    END IF;
    return s;

END sanitise_varname;

FUNCTION splitstr(
  list in varchar2,
  delimiter in varchar2 default ',',
  ignore_left in CHAR DEFAULT '[',
  ignore_right in CHAR DEFAULT ']'
) return tbl_type as  splitted tbl_type := tbl_type();
  i pls_integer := 0;
  list_ varchar2(32767) := trim(list);
  ignore_right_pos PLS_INTEGER;
  ignore_left_pos PLS_INTEGER;
  ignore_length PLS_INTEGER;
begin
        loop       
            -- find next delimiter
            i := instr(list_, delimiter);
            splitted.extend(1);
            if i > 0 THEN 
                -- find ignore bouding region
                ignore_left_pos:=INSTR(list_,ignore_left);
                ignore_right_pos:=INSTR(list_,ignore_right);
                       
                -- when bounding region defined and delimiter found inside bounding region
                if ignore_left_pos>0 AND ignore_right_pos>ignore_left_pos AND i>ignore_left_pos AND i<ignore_right_pos THEN
                        
                            splitted(splitted.last) := trim(substr(list_,1,(ignore_right_pos-ignore_left_pos)+1));
                            list_ := trim(substr(list_, ignore_right_pos+2));
                        
                else
                            splitted(splitted.last) := trim(substr(list_, 1, i - 1));
                            list_ := trim(substr(list_, i + length(delimiter)));
                        
                end if;
            else
                    
                    splitted(splitted.last) := trim(list_);
                    return splitted;
            end if;
          end loop;
end splitstr;

FUNCTION splitclob(
  list in clob,
  delimiter in varchar2 default ',',
  ignore_left in CHAR DEFAULT '[',
  ignore_right in CHAR DEFAULT ']'
) return tbl_type2 as  splitted tbl_type2 := tbl_type2();
  i pls_integer := 0;
  list_ clob := trim(list);
  ignore_right_pos PLS_INTEGER;
  ignore_left_pos PLS_INTEGER;
  ignore_length PLS_INTEGER;
begin
        loop       
            -- find next delimiter
            i := dbms_lob.instr(list_, delimiter);
            splitted.extend(1);
            
            
            if i > 0 THEN 
                -- find ignore bouding region
                ignore_left_pos:=dbms_lob.instr(list_,ignore_left);
                ignore_right_pos:=dbms_lob.instr(list_,ignore_right);
                       
                -- when bounding region defined and delimiter found inside bounding region
                if ignore_left_pos>0 AND ignore_right_pos>ignore_left_pos AND i>ignore_left_pos AND i<ignore_right_pos THEN
                        
                            splitted(splitted.last) := trim(dbms_lob.substr(list_,(ignore_right_pos-ignore_left_pos)+1,1));
                            list_ := dbms_lob.substr(list_,32767,ignore_right_pos+2);
                        
                else
                            splitted(splitted.last) := trim(dbms_lob.substr(list_, i - 1,1));
                            list_ := dbms_lob.substr(list_,32767,i + length(delimiter));
                        
                end if;
            else
                    
                    splitted(splitted.last) := list_;
                    return splitted;
                    
            end if;
          end loop;
end splitclob;

FUNCTION sanitise_clob(clbin CLOB) RETURN CLOB AS
    clb CLOB:=clbin;
BEGIN
    clb:=replace(clb,chr(13),' ');
    clb:=replace(clb,chr(10),' ');
    clb:=regexp_replace(clb, '[[:space:]]+',' '); 
    return clb;
END sanitise_clob;

FUNCTION get_cte_name (indx BINARY_INTEGER) return NVARCHAR2 
AS
BEGIN
    RETURN 'CTE' || lpad(indx,3,0); 
END get_cte_name;

FUNCTION trim_comments(txtin clob) RETURN clob
AS
txtout                  CLOB;
comment_open_pos        PLS_INTEGER;
comment_close_pos       PLS_INTEGER;
replace_txt             CLOB;

BEGIN
    txtout:=txtin;
    
    comment_open_pos:=dbms_lob.instr(txtout,comment_open_chars);
    comment_close_pos:=dbms_lob.instr(txtout,comment_close_chars);
    
    IF comment_open_pos>0 THEN
        IF comment_close_pos>0 THEN
            WHILE (comment_open_pos>0 AND comment_close_pos>0 AND comment_open_pos<comment_close_pos) LOOP
        
                replace_txt:=substr(txtout,comment_open_pos,comment_close_pos-comment_open_pos+length(comment_close_chars));
                
                txtout:=REPLACE(txtout,replace_txt,'');
                
                comment_open_pos:=dbms_lob.instr(txtout,comment_open_chars);
                comment_close_pos:=dbms_lob.instr(txtout,comment_close_chars);
        
            END LOOP;
        ELSE
            txtout:='';
        END IF;
    END IF;
    return txtout;
    
END trim_comments;

FUNCTION format_column_name(txtin VARCHAR2) RETURN VARCHAR2
AS
txtout VARCHAR2(100):=txtin;
BEGIN
    IF LENGTH(txtout)>30 THEN
        txtout:=substr(txtout,1,30);
    END IF;
    IF INSTR(txtout,'.')>0  OR INSTR(txtout,' ')>0 THEN
        txtout:='"' || txtout || '"';
    END IF;
    RETURN txtout;
END;

FUNCTION format_bindvar_name(txtin VARCHAR2) RETURN VARCHAR2
AS
txtout VARCHAR2(100):=txtin;
BEGIN
    IF LENGTH(txtout)>30 THEN
        txtout:=substr(txtout,1,30);
    END IF;
    IF INSTR(txtout,'.')>0  OR INSTR(txtout,' ')>0 THEN
        txtout:=TRANSLATE(txtout,'. ','_');
    END IF;
    RETURN lower(txtout);
END;

FUNCTION is_tempvar(txtin varchar2) RETURN BOOLEAN
AS
retval              BOOLEAN:=false;
tempvar_char        VARCHAR2(1):='_';    
BEGIN
IF SUBSTR(TRIM(LEADING '"' FROM txtin),-1*(LENGTH(tempvar_char)))=tempvar_char THEN 
    retval:=true;
END IF;
RETURN retval;

END  is_tempvar;

FUNCTION match_varname(txtbody varchar2,elem varchar2) RETURN BOOLEAN
AS
ret BOOLEAN:=false;
rgx varchar2(100);
BEGIN
    
     rgx:= '\W' || elem || '\W';   
     IF REGEXP_INSTR(txtbody,rgx,1,1)>0 THEN
        ret:=true;
    END IF;
    RETURN ret;
END match_varname;

FUNCTION get_hash(inclob clob) RETURN VARCHAR2
AS
ret VARCHAR2(32);
BEGIN
    IF length(inclob)>0 THEN 
        --ret:=dbms_crypto.hash(inclob, dbms_crypto.HASH_MD5 );
        ret:=DBMS_OBFUSCATION_TOOLKIT.md5(input => UTL_I18N.STRING_TO_RAW (inclob, 'AL32UTF8'));
    END IF; 
    RETURN ret;
END get_hash;





PROCEDURE get_composite_sql (cmpstat OUT NVARCHAR2) IS
    rmanobj rman_tbl_type;
    ctename nvarchar2(20);
BEGIN
    SELECT ID, where_clause, from_clause, select_clause, groupby_clause,varid, is_sub, agg_func,func_param
    BULK COLLECT INTO rmanobj
    FROM rman_stack ORDER BY ID;
    
    cmpstat := 'WITH ' ||  get_cte_name(0) || ' AS (SELECT ' || entity_id_col || ' FROM EADV GROUP BY ' || entity_id_col || '),';

    -- assemble CTE's
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP
     
        ctename:=get_cte_name(i);        
        
        cmpstat := cmpstat || ctename || ' AS (SELECT ' || REPLACE(rmanobj(I).select_clause,'`','''') || ' FROM ' || REPLACE(rmanobj(I).from_clause,'`','''') ;
                
        IF rmanobj(I).where_clause IS NOT NULL THEN cmpstat:=cmpstat ||' WHERE ' || REPLACE(rmanobj(I).where_clause,'`',''''); END IF;
        
        IF rmanobj(I).groupby_clause IS NOT NULL THEN cmpstat:=cmpstat || ' GROUP BY ' || rmanobj(I).groupby_clause;END IF;
        
        cmpstat := cmpstat || ')';
        
        IF I<rmanobj.LAST THEN cmpstat := cmpstat || ',';END IF;
        
        --line break for readability
        
        cmpstat:=cmpstat || chr(10);
    END LOOP;
    
    --Add select 
    cmpstat :=cmpstat || ' SELECT '|| get_cte_name(0) || '.' || entity_id_col || ', ';
    
    
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP
        ctename:=get_cte_name(i);
        IF rmanobj(I).is_sub=0 THEN
            IF is_tempvar(rmanobj(I).varid)=FALSE THEN
                cmpstat := cmpstat || ctename || '.' || sanitise_varname(rmanobj(i).varid) || ' ';                        
                --line break for readability
                cmpstat:=cmpstat || chr(10);
                
                IF I<rmanobj.LAST AND rmanobj(i).is_sub=0 THEN
                    cmpstat :=cmpstat || ',';
                END IF;
            END IF;
        ELSIF rmanobj(I).is_sub=2 THEN
            IF is_tempvar(rmanobj(I).varid)=FALSE THEN
                cmpstat := cmpstat || ctename || '.' || sanitise_varname(rmanobj(i).varid) || '_DT';                        
                cmpstat:=cmpstat || chr(10);
                cmpstat := cmpstat || ',';
                cmpstat := cmpstat || ctename || '.' || sanitise_varname(rmanobj(i).varid) || '_VAL';                        
                cmpstat:=cmpstat || chr(10);
                
                IF I<rmanobj.LAST THEN
                    cmpstat :=cmpstat || ',';
                END IF;
            END IF;
        END IF;
        


    END LOOP;
    
    cmpstat := cmpstat || 'FROM ' || get_cte_name(0);

    -- Add the left outer joins
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP

        ctename:=get_cte_name(i);
        IF rmanobj(I).is_sub=0 OR rmanobj(I).is_sub=2 THEN
                IF is_tempvar(rmanobj(I).varid)=FALSE THEN
                    cmpstat := cmpstat || ' LEFT OUTER JOIN ' || ctename || ' ON ' || ctename || '.' || entity_id_col || '=' || get_cte_name(0)||'.' || entity_id_col || ' ';
                    --line break for readability
                    cmpstat:=cmpstat || chr(10);
                END IF;
        END IF;
    END LOOP;
    
    
END get_composite_sql;




PROCEDURE insert_rman(
    indx INT,
    where_clause NVARCHAR2,
    from_clause  NVARCHAR2,
    select_clause NVARCHAR2,
    groupby_clause  NVARCHAR2,
    varid NVARCHAR2,
    is_sub INT,
    sqlstat OUT NVARCHAR2,
    agg_func VARCHAR2,
    func_param VARCHAR2
)
IS
BEGIN
    INSERT INTO rman_stack (ID, where_clause,from_clause, select_clause,groupby_clause, varid, is_sub,agg_func,func_param)
            VALUES (indx,where_clause,from_clause,select_clause,groupby_clause,varid,is_sub,agg_func,func_param);
            sqlstat:='rows added :' || SQL%ROWCOUNT;
END insert_rman;

PROCEDURE insert_ruleblocks_dep(
    blockid_s     in    varchar2, 
    dep_table_s   in    varchar2,
    dep_column_s  in    varchar2,
    dep_att_s     in    varchar2,
    dep_func_s    in    varchar2
)
IS
BEGIN
    INSERT INTO rman_ruleblocks_dep (blockid, dep_table,dep_column,dep_att,dep_func)
            VALUES (blockid_s, dep_table_s,dep_column_s,dep_att_s,dep_func_s);
            
END insert_ruleblocks_dep;

PROCEDURE build_assn_var
(
    txtin IN VARCHAR2,
    delim IN VARCHAR2,
    left_tbl_name IN VARCHAR2,
    from_clause OUT VARCHAR2,
    avn OUT VARCHAR2

) IS
    used_vars VARCHAR2(4000);
    used_vars_tbl tbl_type;
    txt VARCHAR2(4000);
BEGIN
            
            txt:=SUBSTR(txtin,1,INSTR(txtin,delim)-LENGTH(delim)); 
            

            IF INSTR(txt,'(',1,1)>0 THEN
                avn:=TRIM(SUBSTR(txt, 1, INSTR(txt,'(',1,1)-1));

                used_vars:=REGEXP_SUBSTR(txt, '\((.*)?\)', 1, 1, 'i', 1);
                
                used_vars_tbl:=rman_pckg.splitstr(used_vars,','); 
                
                IF used_vars_tbl.COUNT>0 THEN
                            from_clause :=from_clause || left_tbl_name;                    
                            for i IN 1..used_vars_tbl.LAST LOOP
                      
                                from_clause:=from_clause || ' LEFT OUTER JOIN ' || get_cte_name(vstack(used_vars_tbl(i)))
                                        || ' ON ' || get_cte_name(vstack(used_vars_tbl(i))) || '.' || entity_id_col || '=' 
                                        || left_tbl_name || '.' || entity_id_col || ' ';
                            END LOOP;
                            
                ELSE
                            -- RAISE EXCEPTION
                            DBMS_OUTPUT.PUT('BUILD :: no vars!' );
                END IF;
            ELSE
                avn:=TRIM(SUBSTR(txtin, 1, INSTR(txtin,delim,1,1)-1));
                from_clause :=from_clause || left_tbl_name; 
            END IF;
            


END build_assn_var;

FUNCTION modify_ps_on_funcparam(txtin varchar2) return varchar2
AS
    vsi varchar2(100);
    txtout  varchar2(32767);
    rep_str varchar2(100);
BEGIN
    txtout:=txtin;
--loop through vstack
    vsi:=vstack.FIRST;
    
    
    WHILE vsi IS NOT NULL LOOP   
                
                --find vstack param and func
                
                IF vstack_func.exists(vsi) AND vstack_func_param.exists(vsi) AND match_varname(txtout,vsi) THEN
                    IF vstack_func(vsi) IS NOT NULL AND vstack_func_param(vsi) IS NOT NULL  THEN
--                        DBMS_OUTPUT.PUT_LINE('MODIFY_PS -> ENTERED LOOP ' || vstack_func(vsi) || ' --> ' || vstack_func_param(vsi));
                --case select
                        CASE
                            WHEN vstack_func(vsi) IN ('COUNT','LAST','FIRST') AND vstack_func_param(vsi)='0' THEN
                        --DBMS_OUTPUT.PUT_LINE('MODIFY_PS -> ENTERED CASE');
                                rep_str:='NVL(' || vsi || ',0)';
                                txtout:=REPLACE(txtout,vsi,rep_str);    
                            --    DBMS_OUTPUT.PUT_LINE('MODIFY_PS -> VSI : ' || vsi || ' REP_STR :' || rep_str || chr(10) || 'TXTOUT : ' || txtout);
                            WHEN vstack_func(vsi) IN ('MIN','MAX','FIRST','LAST') AND vstack_func_param(vsi)='1900' THEN
                        --DBMS_OUTPUT.PUT_LINE('MODIFY_PS -> ENTERED CASE');
                                rep_str:='NVL(' || vsi || ',TO_DATE(''19000101'',''YYYYMMDD''))';
                                txtout:=REPLACE(txtout,vsi,rep_str);    
                            ELSE
                                txtout:=txtout;
                        END CASE;
                
                    END IF;

                END IF;
                
                vsi := vstack.NEXT(vsi);
    END LOOP; 
    
    RETURN txtout;

END modify_ps_on_funcparam;

FUNCTION map_to_tmplt(jstr varchar2,tmplt varchar2 ) RETURN VARCHAR2
AS
key_tbl tbl_type;
t varchar2(4000);
tkey varchar2(100);
tval varchar2(100);
html_tkey varchar2(100);

tag_param   varchar2(100);
tag_operator       varchar(2);
ret_tmplt varchar2(4000):=tmplt;
BEGIN
--jstr into collection
    
    t:=regexp_substr(jstr,'\{(.*?)\}', 1, 1, 'i', 1);
    key_tbl:=rman_pckg.splitstr(t,',');
    FOR i IN 1..key_tbl.COUNT LOOP
    
            
            tkey:=lower(regexp_substr(substr(key_tbl(i),1,instr(key_tbl(i),':')),'\"(.*?)\"', 1, 1, 'i', 1));
            tval:=regexp_substr(substr(key_tbl(i),instr(key_tbl(i),':')),'\"(.*?)\"', 1, 1, 'i', 1);

            -- insertions

            html_tkey :=  tkey || '>';

            ret_tmplt:=regexp_replace(ret_tmplt,'<' ||  html_tkey || '</' || html_tkey,tval);
            
            -- toggle on
            IF nvl(length(tval),0)>0 AND nvl(tval,'0')<>'0' THEN
                -- without tag param
                
                
                html_tkey:=tkey || '>';
                ret_tmplt:=regexp_replace(ret_tmplt,'<' ||  html_tkey,'',1,0,'i');
                
                        
                ret_tmplt:=regexp_replace(ret_tmplt,'</' ||  html_tkey,'',1,0,'i');
                
                
                html_tkey:=tkey || '='|| tval ||'>';
                
                ret_tmplt:=regexp_replace(ret_tmplt,'<' ||  html_tkey,'',1,0,'i');
                
                ret_tmplt:=regexp_replace(ret_tmplt,'</' ||  html_tkey,'',1,0,'i');
                
                
                html_tkey:= tkey || '(=[a-z0-9]+)?' ||'>';


                ret_tmplt:=regexp_replace(ret_tmplt,'<' || html_tkey || '(.*?)' || '</' || html_tkey,'');

            ELSE
                
                -- tval null or 0
                 
                -- if param is 0 then toggle text on 
                html_tkey:= tkey || '=0' ||'>';
                
                ret_tmplt:=regexp_replace(ret_tmplt,'<' ||  html_tkey,'',1,0,'i');
                
                ret_tmplt:=regexp_replace(ret_tmplt,'</' ||  html_tkey,'',1,0,'i');
                
                -- if param<>0 then toggle text off 
                html_tkey:= tkey || '(=[a-z0-9]+)?' ||'>';
                
                ret_tmplt:=regexp_replace(ret_tmplt,'<' || html_tkey || '(.*?)' || '</' || html_tkey,'');
                
                -- if no parameter toggle off other tags
                
                html_tkey:=tkey || '>';
                                
                ret_tmplt:=regexp_replace(ret_tmplt,'<' || html_tkey || '(.*?)' || '</' || html_tkey,'');
                        
            END IF;
                   
    END LOOP;
    -- if param is 0 then toggle text on 
    html_tkey:= '\w+=0' ||'>';
                
    ret_tmplt:=regexp_replace(ret_tmplt,'<' ||  html_tkey,'',1,0,'i');
                
    ret_tmplt:=regexp_replace(ret_tmplt,'</' ||  html_tkey,'',1,0,'i');
    
    --if no param specified text is toggled off
    
    html_tkey:= '\w+' ||'>';
    
    ret_tmplt:=regexp_replace(ret_tmplt,'<' || html_tkey || '(.*?)' || '</' || html_tkey,'');
    
    -- remove excess space and line feeds
    ret_tmplt:=regexp_replace(regexp_replace(ret_tmplt, '^[[:space:][:cntrl:]]+$', null, 1, 0, 'm'),chr(10)||'{2,}',chr(10));
    
    RETURN ret_tmplt;

END map_to_tmplt;

function get_composition_by_eid(eid_in int,nlc_id varchar2) return clob
as
composition         clob; 
--compositionid_in    varchar2(100):=nlc_id;
compositionid_in    varchar2(100):='neph001';
eid_not_found       exception;
PRAGMA  EXCEPTION_INIT(eid_not_found,100);

begin
with cte1 as (
SELECT eid, att, dt,rman_pckg.map_to_tmplt(t0.valc,tmp.templatehtml) as body,tmp.placementid
FROM(
    SELECT
        eid,dt,att,valc,src,ROW_NUMBER() OVER (PARTITION BY eid,att ORDER BY dt) AS rn
    FROM eadvx
) t0
JOIN rman_rpt_templates tmp on tmp.ruleblockid=t0.src
WHERE t0.rn=1 and eid=eid_in 
and tmp.compositionid=compositionid_in
)
select LISTAGG(body, '') WITHIN GROUP(ORDER BY placementid) into composition
FROM cte1
GROUP BY eid;

return composition;
EXCEPTION  
    WHEN eid_not_found  THEN
        dbms_output.put_line('Error: eid not found');
        RETURN '';
    WHEN OTHERS THEN
        commit_log('get_composition_by_eid','','Error:');
        DBMS_OUTPUT.put_line('FAILED:: and errors logged to rman_ruleblocks_log !');
        RETURN '';

end get_composition_by_eid;

PROCEDURE build_assn_var2
(
    txtin IN VARCHAR2,
    delim IN VARCHAR2,
    left_tbl_name IN VARCHAR2,
    from_clause OUT VARCHAR2,
    avn OUT VARCHAR2

) IS
    
    txt VARCHAR2(4000);
    vsi VARCHAR2(100);
    already_joined varchar2(100):='.';
BEGIN
            

            txt:=SUBSTR(txtin,INSTR(txtin,delim)+LENGTH(delim),LENGTH(txtin)); 
            
            from_clause :=from_clause || left_tbl_name;  
            
            vsi:=vstack.FIRST;
            
            WHILE vsi IS NOT NULL LOOP   
                
                IF match_varname(txt,vsi) AND vsi is not null and already_joined != get_cte_name(vstack(vsi)) THEN
                     from_clause:=from_clause || ' LEFT OUTER JOIN ' || get_cte_name(vstack(vsi))
                                        || ' ON ' || get_cte_name(vstack(vsi)) || '.' || entity_id_col || '=' 
                                        || left_tbl_name || '.' || entity_id_col || ' ';
                     already_joined:=get_cte_name(vstack(vsi));
                              
                END IF;
                
                vsi := vstack.NEXT(vsi);
            END LOOP; 
            
            
            avn:=TRIM(SUBSTR(txtin, 1, INSTR(txtin,delim,1,1)-LENGTH(delim)));            



END build_assn_var2;

PROCEDURE push_vstack(
    varname          IN  VARCHAR2,
    indx             IN  INTEGER,
    calling_proc     IN  INTEGER,
    var_func        IN VARCHAR2,
    var_func_param  IN VARCHAR2
)
AS
BEGIN
    IF varname IS NOT NULL THEN
        vstack(varname):=indx;   
        
        IF var_func IS NOT NULL THEN
            vstack_func(varname):=var_func;       
        END IF;
        
        IF var_func_param IS NOT NULL THEN
            vstack_func_param(varname):=var_func_param;       
        END IF;
        
    END IF;
    
    
    
END push_vstack;


PROCEDURE build_func_sql_exp
(
    blockid     in varchar2,
    indx        IN INT,
    txtin       varchar2,
    sqlstat     OUT VARCHAR2,
    rows_added  OUT PLS_INTEGER
) 
IS
    func        varchar2(32);
    funcparam   PLS_INTEGER;

    att         varchar2(4000);
    att0        varchar2(4000);
    att_str     varchar2(256);
    tbl         varchar2(100);
    prop        varchar2(100);
    assnvar     varchar2(100);
    avn         varchar2(100);
    predicate   varchar2(4000);
    constparam  varchar2(4000);
    left_tbl_name varchar2(100);
    ext_col_name    varchar2(100);    
    
    equality_cmd  varchar2(5):='=';
    where_txt VARCHAR(2000);
    from_txt VARCHAR(2000);
    from_clause VARCHAR(2000);
    select_txt VARCHAR(2000);
    groupby_txt VARCHAR(2000);
    orderby_windfunc_txt    VARCHAR2(100);
    is_sub_val INT:=0;
    varr tbl_type;
    att_tbl tbl_type;
    
    ude_function_undefined EXCEPTION;
    
    
BEGIN
    
    
    -- parse txt string
   
    varr:=rman_pckg.splitstr(trim(substr(txtin,instr(txtin,assn_op)+length(assn_op))),'.','[',']');
    
    IF varr.COUNT=5 THEN
        tbl:=UPPER(varr(1));
        att:=varr(2);
        prop:=varr(3);
        func:=UPPER(SUBSTR(varr(4), 1, INSTR(varr(4),'(',1,1)-1));
        funcparam:=NVL(REGEXP_SUBSTR(varr(4), '\((.*)?\)', 1, 1, 'i', 1),0);
        IF UPPER(SUBSTR(varr(5),1,5))='WHERE' THEN
            predicate:=' AND '|| REGEXP_SUBSTR(varr(5), '\((.*)?\)', 1, 1, 'i', 1);
        END IF;
    ELSIF varr.COUNT=4 THEN
        tbl:=UPPER(varr(1));
        att:=varr(2);
        prop:=varr(3);
        func:=UPPER(SUBSTR(varr(4), 1, INSTR(varr(4),'(',1,1)-1));
        funcparam:=NVL(REGEXP_SUBSTR(varr(4), '\((.*)?\)', 1, 1, 'i', 1),0);
        ext_col_name:=varr(2);
    ELSIF varr.COUNT=3 THEN
        tbl:=UPPER(varr(1));
        att:=varr(2);
        prop:=varr(3);
        func:='LAST';
        funcparam:=0;
    ELSIF varr.COUNT=2 THEN
        tbl:=UPPER(varr(1));
        att:=varr(2);
        prop:=val_col;
        func:='LAST';
        funcparam:=0;
    ELSIF varr.COUNT=1 THEN
        IF UPPER(SUBSTR(varr(1),1,5))='CONST' THEN
            tbl:=def_tbl_name;
            func:='CONST';

            constparam:=REGEXP_SUBSTR(varr(1), '\((.*)?\)', 1, 1, 'i', 1);
        ELSE
            tbl:=def_tbl_name;
            att:=varr(1);
            prop:=val_col;
            func:='LAST';
            funcparam:=0;
        END IF;
        
   
    END IF;
    
    att0:=att;
    
    att:=sql_predicate(att);
    
    
    
    left_tbl_name := tbl;
    
    build_assn_var2(txtin,'=>',left_tbl_name,from_clause,avn);
    
    
    
    assnvar:=sanitise_varname(avn);
    
    IF SUBSTR(tbl,1,5)='ROUT_' AND FUNC='BIND' THEN 
            where_txt:='';
            from_txt:= tbl;
            select_txt:=  entity_id_col || ',' || ext_col_name || ' AS ' || assnvar || ' ';
            groupby_txt:='';
            insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat,func,funcparam);
            
            insert_ruleblocks_dep(blockid,tbl,ext_col_name,NULL,func);
            
            rows_added:= 1;
            
            push_vstack(assnvar,indx,2,null,null);
            

    
    ELSE
    
    CASE 
        
        
        WHEN FUNC IN ('MAX','MIN','COUNT','SUM','AVG','MEDIAN','STATS_MODE') THEN
            
            where_txt:=att || predicate;
            
            from_txt:= from_clause;
            select_txt:=  tbl || '.' || entity_id_col || ',' || func || '(' || prop || ') AS ' || assnvar || ' ';
            groupby_txt:=tbl || '.' || entity_id_col;
            insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat,func,funcparam);
            
            insert_ruleblocks_dep(blockid,tbl,att_col,att0,func);
            
            rows_added:= 1;
            
            push_vstack(assnvar,indx,2,func,to_char(funcparam));

            
        WHEN FUNC='LAST' OR FUNC='FIRST' OR FUNC='EXISTS' THEN
            DECLARE
                rankindx NUMBER;
                sortdirection NVARCHAR2(4):='DESC';
                ctename nvarchar2(20);
            BEGIN
                
                IF funcparam=0 THEN rankindx:=1;
                ELSE rankindx := funcparam + 1;
                END IF;
                IF func='FIRST' THEN sortdirection:='';END IF;  
                ctename:=get_cte_name(indx); 
                where_txt:=att || predicate;
                from_txt:= from_clause;
                
                select_txt:= entity_id_col || ',' || prop || ',ROW_NUMBER() OVER(PARTITION BY ' || entity_id_col || ' ORDER BY ' || entity_id_col || ',DT ' || sortdirection ||') AS rank ';
                groupby_txt:='';
                is_sub_val:=1;
                
                
                insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,NULL, is_sub_val,sqlstat,func,funcparam);
                
                insert_ruleblocks_dep(blockid,tbl,att_col,att0,func);
                
                where_txt:= 'rank=' || rankindx;
                from_txt:= ctename;
                
                IF FUNC='EXISTS' THEN
                    select_txt:= entity_id_col || ',' || ' 1 AS ' || assnvar;
                ELSE
                    select_txt:= entity_id_col || ',' || prop || ' AS ' || assnvar;
                END IF;
                
                groupby_txt:='';
                is_sub_val:=0;   
                
                insert_rman(indx+1,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat,func,funcparam);
                
                rows_added:= 2;
                
                push_vstack(assnvar,indx+1,2,null,null);
                

            END;
        WHEN FUNC IN ('LASTDV','FIRSTDV','MAXLDV','MAXFDV','MINLDV','MINFDV') THEN
            DECLARE
                rankindx NUMBER;
                ctename nvarchar2(20);
            BEGIN
                CASE FUNC
                WHEN 'FIRSTDV' THEN
                    orderby_windfunc_txt := dt_col ||  ' ASC';
                WHEN 'LASTDV' THEN
                    orderby_windfunc_txt := dt_col ||  ' DESC';
                WHEN 'MAXLDV' THEN
                    orderby_windfunc_txt := val_col ||  ' DESC, ' || dt_col ||  ' DESC';
                WHEN 'MAXFDV' THEN
                    orderby_windfunc_txt := val_col ||  ' DESC, ' || dt_col ||  ' ASC';
                WHEN 'MINLDV' THEN
                    orderby_windfunc_txt := val_col ||  ' ASC, ' || dt_col ||  ' DESC';
                WHEN 'MINFDV' THEN
                    orderby_windfunc_txt := val_col ||  ' ASC, ' || dt_col ||  ' ASC';    
                END CASE;
                
                IF funcparam=0 THEN rankindx:=1;
                ELSE rankindx := funcparam + 1;
                END IF;
--                IF func='FIRSTDV' THEN sortdirection:='';END IF;  
                ctename:=get_cte_name(indx); 
                where_txt:=' RANK=' || rankindx;
                from_txt:= '(SELECT ' || entity_id_col || ',' || val_col || ',' || dt_col ||
                                ',ROW_NUMBER() OVER(PARTITION BY ' || entity_id_col || ' ORDER BY ' || orderby_windfunc_txt ||') AS rank ' ||
                                ' FROM ' || from_clause || ' WHERE ' || att || predicate || ')';
                select_txt:= entity_id_col || ',' || val_col || ' AS ' || assnvar ||'_VAL ,' || dt_col || ' AS ' || assnvar ||'_DT ' ;
                groupby_txt:='';
                is_sub_val:=2;
                
                
                insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar, is_sub_val,sqlstat,func,funcparam);
                
                insert_ruleblocks_dep(blockid,tbl,att_col,att0,func);
                
                rows_added:= 1;
                
                push_vstack(assnvar || '_val',indx,2,null,null);
                push_vstack(assnvar || '_dt',indx,2,null,null);

            END;

        WHEN FUNC='CONST' THEN
            DECLARE
            BEGIN
                where_txt:='1=1';
                
                from_txt:= from_clause;
                select_txt:= entity_id_col || ',' || constparam || ' AS ' || assnvar || ' ';
                groupby_txt:=entity_id_col;
                
                is_sub_val:=0;
            
                insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat,func,funcparam);
            
                rows_added:= 1;
            
                push_vstack(assnvar,indx,2,null,null);
                

            END;
        WHEN FUNC IN ('REGR_SLOPE','REGR_INTERCEPT','REGR_COUNT','REGR_R2','REGR_AVGX','REGR_AVGY','REGR_SXX','REGR_SYY','REGR_SXY') THEN
            where_txt:=att || predicate;
            
            from_txt:= from_clause;
            select_txt:=  tbl || '.' || entity_id_col || ',' || func || '(' || prop || ', SYSDATE-' || dt_col || ') AS ' || assnvar || ' ';
            groupby_txt:=tbl || '.' || entity_id_col;
            insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat,func,funcparam);
            
            insert_ruleblocks_dep(blockid,tbl,att_col,att0,func);
            
            rows_added:= 1;
            
            push_vstack(assnvar,indx,2,func,to_char(funcparam));
        ELSE 
            RAISE ude_function_undefined;
            
    END CASE; 
    
    END IF;
      
       
END build_func_sql_exp;

PROCEDURE build_cond_sql_exp(
    indx PLS_INTEGER,txtin IN varchar2,sqlstat OUT varchar2,rows_added OUT PLS_INTEGER
)   
IS

    t1 tbl_type;
    
    avn varchar2(5000);
    expr varchar2(32767);
    used_vars varchar2(5000);
    left_tbl_name varchar2(100);
    
    
    
    expr_tbl tbl_type;
    used_vars_tbl tbl_type;
    expr_elem tbl_type;
    
    expr_then varchar2(32767);
    expr_when varchar2(32767);
    from_clause varchar2(32767);
    op_delim varchar2(3):='|';
    txt  VARCHAR2(32767);
    txtin2  VARCHAR2(32767);
    select_text varchar2(32767);

BEGIN
    from_clause:='';
    select_text:='CASE ';
    
    --split initial statement into assigned var (avn) and expr at :
    -- found form of avn() :
    left_tbl_name := get_cte_name(0);
    
    
    
    build_assn_var2(txtin,':',left_tbl_name,from_clause,avn);
    
    txtin2:=modify_ps_on_funcparam(txtin);
    
    --avn:=sanitise_varname(avn);
    
    -- split at major assignment
    
    IF avn IS NOT NULL THEN
                       
            expr:= TRIM(SUBSTR(txtin2,INSTR(txtin2,':')+1));
            
            expr_tbl:=rman_pckg.splitstr(expr,',','{','}');
            
            
            --split to expression array
            for i in 1..expr_tbl.COUNT loop
                --check if properly formed by curly brackets
                expr:=regexp_substr(expr_tbl(i), '\{([^}]+)\}', 1,1,NULL,1);
                

                --split minor assignment
                expr_elem:=rman_pckg.splitstr(expr,'=>','','');
                if expr_elem.EXISTS(2) THEN
                    if expr_elem(1) IS NOT NULL THEN
                        expr_then:=expr_elem(2);
                        expr_when:=trim(expr_elem(1));
                        select_text:=select_text || 'WHEN '|| expr_when || ' THEN ' || expr_then || ' ';  
                    ELSE 
                        expr_then:=expr_elem(2);
                        select_text:=select_text || 'ELSE '|| expr_then || ' ';
                    end if;             
                end if;
            end loop;
            
            select_text:=select_text || 'END AS ' || sanitise_varname(avn) || ',' || left_tbl_name ||'.' || entity_id_col || ' ';
            
            push_vstack(avn,indx,1,null,null);

            

            insert_rman(indx,'',from_clause,select_text,'',avn,0,sqlstat,'','');
        
            rows_added:= 1;
        
       
    END IF;
    

END build_cond_sql_exp;



PROCEDURE parse_rpipe (sqlout OUT varchar2) IS
    rpipe_col rpipe_tbl_type;
    indx PLS_INTEGER;
    
    indxtmp VARCHAR2(100);
    
    rows_added PLS_INTEGER;
    statements_tbl tbl_type;
    rs VARCHAR2(4000);
    ss VARCHAR2(4000);
BEGIN
    SELECT ruleid, rulebody,blockid 
    BULK COLLECT INTO rpipe_col
    FROM rman_rpipe;
    
    DELETE FROM rman_stack;
    
    indx:=1;
    
    vstack:=vstack_empty;
    
    -- loop though each line
    for i in 1..rpipe_col.COUNT loop
        --split at semi colon
        rs := rpipe_col(i).rulebody;
        
        
        -- implied semi colon terminator added
        IF INSTR(rs, ';')=0 THEN
            rs:=rs || ';';
        END IF;
        
        
        IF INSTR(rs, ';')>0 THEN
            statements_tbl:=rman_pckg.splitstr(rs,';');
            -- loop through each statement in rule line
            FOR j IN 1..statements_tbl.COUNT LOOP
                ss:=statements_tbl(j);
                IF LENGTH(trim(ss))>0 THEN
                    --aggregate declaration
                    --identified by :
                
                    IF INSTR(ss, ':')=0 THEN
                        rows_added:=0;
                        build_func_sql_exp(rpipe_col(i).blockid,indx,ss,sqlout,rows_added);
                        indx:=indx+rows_added;
                        
                    ELSE
                        rows_added:=0;
                        build_cond_sql_exp(indx,ss,sqlout,rows_added);
                        indx:=indx+rows_added;
        
                    END IF;
            
                
                END IF;
            END LOOP;
        END IF;
    END LOOP;
    
   
    
    indxtmp := vstack.FIRST; 
   
    WHILE indxtmp IS NOT NULL LOOP   
--        DBMS_Output.PUT_LINE('index -> ' || indxtmp || ' is ' || vstack(indxtmp));   
        indxtmp := vstack.NEXT(indxtmp); 
    END LOOP; 
    get_composite_sql(sqlout);
    
END parse_rpipe;

PROCEDURE parse_ruleblocks(blockid varchar2) IS
rbt                 rman_ruleblocks%ROWTYPE;
rbtbl               tbl_type2;
comment_open_pos    PLS_INTEGER;
comment_close_pos   PLS_INTEGER;
rb                  CLOB;
blockid_predicate   RMAN_RULEBLOCKS.blockid%TYPE:=blockid;
BEGIN
    
    SELECT blockid,picoruleblock 
    INTO rbt.blockid, rbt.picoruleblock
    FROM rman_ruleblocks
    WHERE blockid = blockid_predicate;
    

    
    DELETE FROM rman_rpipe;
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=blockid_predicate ;

    --split at semicolon except when commented
    rbtbl:=splitclob(rbt.picoruleblock,';',comment_open_chars,comment_close_chars);
    FOR i in 1..rbtbl.COUNT LOOP
        
        rb:=trim_comments(trim(rbtbl(i)));
        
        IF LENGTH(rb)>0 THEN
        
--dbms_output.put_line('block '|| i || '-- ' || rb);

            INSERT INTO rman_rpipe VALUES(blockid || lpad(i,5,0), rb,blockid);
        END IF;
    END LOOP;

--dbms_output.put_line('FUNC-AARAY VSTACK : ' || vstack.COUNT);


END parse_ruleblocks;

PROCEDURE exec_dsql(sqlstmt clob,tbl_name varchar2) 
IS
    colCount            PLS_INTEGER;
    colValue            VARCHAR2(4000);
    tbl_desc            dbms_sql.desc_tab2;
    select_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    insert_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    status              PLS_INTEGER;
    fetched_rows        PLS_INTEGER;
    i                   PLS_INTEGER;
    typ01_val           VARCHAR2(4000); 
    typ02_val           NUMBER;
    typ12_val           DATE;
    typ96_val           VARCHAR2(4);
    typ00_val           VARCHAR2(4000);
    
   

    create_tbl_sql_str  VARCHAR2(4000);
    insert_tbl_sql_str  VARCHAR2(4000);

    tbl_exists_val      PLS_INTEGER;
    
BEGIN

    create_tbl_sql_str:='CREATE TABLE ' || tbl_name || ' (';
    
    
    --analyse query
    dbms_sql.parse(select_cursor,sqlstmt,dbms_sql.native);
    
    dbms_sql.describe_columns2(select_cursor,colCount,tbl_desc);
    
    For I In 1..tbl_desc.Count Loop
--        DBMS_OUTPUT.PUT_LINE ('exec_dsql ::: COLNAME->' || tbl_desc(i).col_name || ' COLTYPE->' || tbl_desc(i).col_type || ' COL LEN->' || tbl_desc(i).col_max_len);
        
        
        CASE tbl_desc(i).col_type
            WHEN 1  THEN --varchar2
                    dbms_sql.define_column(select_cursor,i,'a',32);
                    create_tbl_sql_str:=create_tbl_sql_str || format_column_name(tbl_desc(i).col_name) || ' VARCHAR2(' || tbl_desc(i).col_max_len ||') ' || CHR(10);
            WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor,i,1);
                    create_tbl_sql_str:=create_tbl_sql_str || format_column_name(tbl_desc(i).col_name) || ' NUMBER ' || CHR(10);
            WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor,i,SYSDATE);
                    create_tbl_sql_str:=create_tbl_sql_str || format_column_name(tbl_desc(i).col_name) || ' DATE ' || CHR(10);
            WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor,i,'a',32);
                    create_tbl_sql_str:=create_tbl_sql_str || format_column_name(tbl_desc(i).col_name) || ' VARCHAR2(' || tbl_desc(i).col_max_len || ')' || CHR(10);
            ELSE DBMS_OUTPUT.PUT_LINE('Undefined type');
        END CASE;
        IF i<tbl_desc.LAST THEN
            create_tbl_sql_str:=create_tbl_sql_str || ',';
        ELSE
            create_tbl_sql_str:=create_tbl_sql_str || ')';
        END IF;
    END LOOP;
    
    --DBMS_OUTPUT.PUT_LINE('SQL SYNTAX  -> ' || create_tbl_sql_str );
    
   
    
    
    --Create Table
    SELECT COUNT(*) INTO tbl_exists_val FROM user_tables WHERE table_name = UPPER(tbl_name);
    IF tbl_exists_val>0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name ;
    END IF;
    EXECUTE IMMEDIATE create_tbl_sql_str;
    
    --Assemble insert statement
    insert_tbl_sql_str := 'INSERT INTO ' || tbl_name || ' VALUES(';
    FOR i IN 1..tbl_desc.COUNT LOOP
        insert_tbl_sql_str := insert_tbl_sql_str || ':' || format_bindvar_name(tbl_desc(i).col_name); 
        IF i<tbl_desc.COUNT THEN
            insert_tbl_sql_str:=insert_tbl_sql_str || ', ';
        END IF;
    END LOOP;
    insert_tbl_sql_str:=insert_tbl_sql_str || ')';
    
--DBMS_OUTPUT.PUT_LINE('INSERT STATEMENT ->' || CHR(10) || insert_tbl_sql_str);
    
    status:=dbms_sql.EXECUTE(select_cursor);
    
    --Binding
    LOOP
    
        fetched_rows:=dbms_sql.fetch_rows(select_cursor);
        EXIT WHEN fetched_rows=0;
        
        i:=tbl_desc.FIRST;
        
    
        dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);
        
        WHILE (i IS NOT NULL) LOOP
            CASE tbl_desc(i).col_type
                WHEN 1  THEN --varchar2
                        dbms_sql.column_value(select_cursor,i,typ01_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || format_bindvar_name(tbl_desc(i).col_name), typ01_val);                                                 
                WHEN 2 THEN --number
                        dbms_sql.column_value(select_cursor,i,typ02_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || format_bindvar_name(tbl_desc(i).col_name), typ02_val); 
                WHEN 12 THEN --date
                        dbms_sql.column_value(select_cursor,i,typ12_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || format_bindvar_name(tbl_desc(i).col_name), typ12_val); 
                WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor,i,typ96_val);
                        dbms_sql.bind_variable(insert_cursor, ':' || format_bindvar_name(tbl_desc(i).col_name), typ96_val); 
                ELSE DBMS_OUTPUT.PUT_LINE('Undefined type');
            END CASE;
        i:=tbl_desc.NEXT(i);
        END LOOP;
        
        status:=dbms_sql.execute(insert_cursor);
    END LOOP;
    dbms_sql.close_cursor(insert_cursor);
    dbms_sql.close_cursor(select_cursor);
END exec_dsql;

PROCEDURE exec_dsql_dstore2(blockid varchar2,sqlstmt clob,tbl_name varchar2,disc_col varchar2, predicate varchar2) 
IS
    colCount            PLS_INTEGER;
    colValue            VARCHAR2(4000);
    tbl_desc            dbms_sql.desc_tab2;
    select_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    insert_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    status              PLS_INTEGER;
    fetched_rows        PLS_INTEGER;
    i                   PLS_INTEGER;
    
    
    typ01_val           VARCHAR2(4000); 
    typ02_val           NUMBER(15,2);
    typ12_val           DATE;
    typ96_val           VARCHAR2(4);
    typ00_val           VARCHAR2(4000);
    row_eid             NUMBER(12,0);
    
   
    select_tbl_sql_str  VARCHAR2(32767):=sqlstmt;
    create_tbl_sql_str  VARCHAR2(4000);

    
    att                 VARCHAR2(100);
    dt                  VARCHAR2(30);
    
    insert_tbl_sql_str  CLOB;
    tbl_exists_val      PLS_INTEGER;
    
    
    src_id                 VARCHAR2(32):=blockid;
        
BEGIN
    
    IF src_id is null then
        src_id:='undefined';
    END IF;
    --analyse query
    IF disc_col is not null and predicate is not null then
        select_tbl_sql_str:=select_tbl_sql_str || ' WHERE ' || UPPER(disc_col) || ' ' || predicate;
    end if;
    
        
    dbms_sql.parse(select_cursor,select_tbl_sql_str,dbms_sql.native);
    
    
    
    dbms_sql.describe_columns2(select_cursor,colCount,tbl_desc);
    
    For I In 1..tbl_desc.Count Loop
        
        
        CASE tbl_desc(i).col_type
            WHEN 1  THEN --varchar2
                    dbms_sql.define_column(select_cursor,i,'a',32);

            WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor,i,1); 

            WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor,i,SYSDATE);

            WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor,i,'a',32);
            ELSE NULL;
        END CASE;
    END LOOP;

    
    status:=dbms_sql.EXECUTE(select_cursor);
    
    --Binding
--    insert_tbl_sql_str:='BEGIN' || chr(13);
    
    --for each row loop
    LOOP
    
        fetched_rows:=dbms_sql.fetch_rows(select_cursor);
        EXIT WHEN fetched_rows=0;
        
        i:=tbl_desc.FIRST;

        

        --for each col loop
        WHILE (i IS NOT NULL) LOOP
        
        IF lower(tbl_desc(i).col_name)='eid' THEN
            dbms_sql.column_value(select_cursor,i,row_eid);

        END IF;
        
            CASE 
                                           
                WHEN tbl_desc(i).col_type=2 and lower(tbl_desc(i).col_name)=lower(disc_col) THEN -- number

                        dbms_sql.column_value(select_cursor,i,typ02_val);
                        
                        IF typ02_val IS NOT NULL THEN
                            
                            att:=format_bindvar_name(src_id || '_' || tbl_desc(i).col_name);
                            dt :='TO_DATE(''' || sysdate || ''')';
                            
                                            
--                            insert_tbl_sql_str := insert_tbl_sql_str || ' INSERT INTO ' || tbl_name || '(eid, att, dt, val) VALUES('
--                                            || TO_CHAR(row_eid) || ', ''' || att ||''','
--                                            || dt || ',' 
--                                            || TO_CHAR(typ02_val) 
--                                            || ');' || chr(13);                

                            insert_tbl_sql_str :=  ' INSERT INTO ' || tbl_name || '(eid, att, dt, val) VALUES('
                                            || TO_CHAR(row_eid) || ', ''' || att ||''','
                                            || dt || ',' 
                                            || TO_CHAR(typ02_val) 
                                            || ');' || chr(13);  
                        END iF;
                ELSE NULL;        

            END CASE;
        i:=tbl_desc.NEXT(i);
        
        
      
        
        END LOOP;
        
            dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);
            status:=dbms_sql.execute(insert_cursor);
    END LOOP;
    
--    insert_tbl_sql_str := insert_tbl_sql_str || 'COMMIT;END;' || chr(13);
    
    
    
--    dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);
--    status:=dbms_sql.execute(insert_cursor);
        
    dbms_sql.close_cursor(insert_cursor);
    dbms_sql.close_cursor(select_cursor);
END exec_dsql_dstore2;

PROCEDURE exec_dsql_dstore_multicol(blockid varchar2,sqlstmt clob,tbl_name varchar2,disc_col varchar2, predicate varchar2) 
IS
    colCount            PLS_INTEGER;
    colValue            VARCHAR2(4000);
    tbl_desc            dbms_sql.desc_tab2;
    select_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    insert_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    status              PLS_INTEGER;
    fetched_rows        PLS_INTEGER;
    i                   PLS_INTEGER;
    typ01_val           VARCHAR2(4000); 
    typ02_val           NUMBER;
    typ12_val           DATE;
    typ96_val           VARCHAR2(4);
    typ00_val           VARCHAR2(4000);
    row_eid             NUMBER;
    
   
    select_tbl_sql_str  VARCHAR2(4000):=sqlstmt;
    create_tbl_sql_str  VARCHAR2(4000);
    insert_tbl_sql_str  VARCHAR2(4000);
    insert_jstr         VARCHAR2(4000);
    insert_sql_jstr     VARCHAR2(4000);
    tbl_exists_val      PLS_INTEGER;
    
    
    src_id                 VARCHAR2(32):=blockid;
        
BEGIN
    
    IF src_id is null then
        src_id:='undefined';
    END IF;
    --analyse query
    IF disc_col is not null and predicate is not null then
        select_tbl_sql_str:=select_tbl_sql_str || ' WHERE ' || UPPER(disc_col) || ' ' || predicate;
    end if;
    
    
    dbms_output.put_line('-->'  || select_tbl_sql_str);
        
    dbms_sql.parse(select_cursor,select_tbl_sql_str,dbms_sql.native);
    
    --dbms_sql.parse(select_cursor,sqlstmt,dbms_sql.native);
    
    dbms_sql.describe_columns2(select_cursor,colCount,tbl_desc);
    
    For I In 1..tbl_desc.Count Loop
        
        
        CASE tbl_desc(i).col_type
            WHEN 1  THEN --varchar2
                    dbms_sql.define_column(select_cursor,i,'a',32);

            WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor,i,1);

            WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor,i,SYSDATE);

            WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor,i,'a',32);

            ELSE DBMS_OUTPUT.PUT_LINE('Undefined type ->' || tbl_desc(i).col_type);
        END CASE;
    END LOOP;

    
    status:=dbms_sql.EXECUTE(select_cursor);
    
    --Binding
    
    --for each row loop
    LOOP
    
        fetched_rows:=dbms_sql.fetch_rows(select_cursor);
        EXIT WHEN fetched_rows=0;
        
        i:=tbl_desc.FIRST;

        insert_jstr:='{';

        --for each col loop
        WHILE (i IS NOT NULL) LOOP
        IF lower(tbl_desc(i).col_name)='eid' THEN
            dbms_sql.column_value(select_cursor,i,row_eid);

        END IF;
        
            CASE tbl_desc(i).col_type
                WHEN 1  THEN --varchar2
                        dbms_sql.column_value(select_cursor,i,typ01_val);
                        
                        IF typ01_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO ' || tbl_name || '(eid, att, dt, valc,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ01_val)|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                insert_jstr:=insert_jstr || ',';    
                            END IF;
                            
                            dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);                
                            

                            dbms_sql.bind_variable(insert_cursor, ':eid' ,row_eid); 
                            dbms_sql.bind_variable(insert_cursor, ':att' ,format_bindvar_name(tbl_desc(i).col_name)); 
                            dbms_sql.bind_variable(insert_cursor, ':dt' ,sysdate); 
                            dbms_sql.bind_variable(insert_cursor, ':val', typ01_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 1);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                            
                        END iF;                                                
                WHEN 2 THEN -- number
                
                        
                        dbms_sql.column_value(select_cursor,i,typ02_val);
                        
                        IF typ02_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO ' || tbl_name || '(eid, att, dt, valn,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            
--                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ02_val)|| '"'; 
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(ROUND(typ02_val,2))|| '"';
                            IF i<tbl_desc.COUNT THEN
                                insert_jstr:=insert_jstr || ',';    
                            END IF;
                        
                            dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);                
                            

                            dbms_sql.bind_variable(insert_cursor, ':eid' ,row_eid); 
                            dbms_sql.bind_variable(insert_cursor, ':att' ,format_bindvar_name(tbl_desc(i).col_name)); 
                            dbms_sql.bind_variable(insert_cursor, ':dt' ,sysdate); 
                            dbms_sql.bind_variable(insert_cursor, ':val', typ02_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 2);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                            
                        END iF;
                        
                WHEN 12 THEN --date
                         dbms_sql.column_value(select_cursor,i,typ12_val);
                        
                        IF typ12_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO ' || tbl_name || '(eid, att, dt, vald,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ12_val,'DD/MM/YYYY')|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                    insert_jstr:=insert_jstr || ',';    
                            END IF;
                            
                            dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);                
                                
    
                                dbms_sql.bind_variable(insert_cursor, ':eid' ,row_eid); 
                                dbms_sql.bind_variable(insert_cursor, ':att' ,format_bindvar_name(tbl_desc(i).col_name)); 
                                dbms_sql.bind_variable(insert_cursor, ':dt' ,sysdate); 
                                dbms_sql.bind_variable(insert_cursor, ':val', typ12_val);
                                dbms_sql.bind_variable(insert_cursor, ':typ', 12);
                                dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                                
                        END iF;
                        
                WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor,i,typ96_val);
                        
                        IF typ96_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO ' || tbl_name || '(eid, att, dt, valc,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ96_val)|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                insert_jstr:=insert_jstr || ',';    
                            END IF;
                        
                            dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);                
                            

                            dbms_sql.bind_variable(insert_cursor, ':eid' ,row_eid); 
                            dbms_sql.bind_variable(insert_cursor, ':att' ,format_bindvar_name(tbl_desc(i).col_name)); 
                            dbms_sql.bind_variable(insert_cursor, ':dt' ,sysdate); 
                            dbms_sql.bind_variable(insert_cursor, ':val', typ96_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 96);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                            
                        END iF;
                ELSE DBMS_OUTPUT.PUT_LINE('Undefined type ' || tbl_desc(i).col_type);
            END CASE;
        i:=tbl_desc.NEXT(i);
        
      
        
        END LOOP;
        insert_jstr:=insert_jstr || '}';
        
        status:=dbms_sql.execute(insert_cursor);
        
        insert_sql_jstr:='INSERT INTO ' || tbl_name || '(eid, att, dt, valc,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
        
        
        
        dbms_sql.parse(insert_cursor,insert_sql_jstr,dbms_sql.native);   
                            dbms_sql.bind_variable(insert_cursor, ':eid' ,row_eid); 
                            dbms_sql.bind_variable(insert_cursor, ':att' ,'META'); 
                            dbms_sql.bind_variable(insert_cursor, ':dt' ,sysdate); 
                            dbms_sql.bind_variable(insert_cursor, ':val', insert_jstr);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 2);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
        
        status:=dbms_sql.execute(insert_cursor);
        
        
        
        insert_sql_jstr:='';
        insert_jstr:='';
        
    END LOOP;
    dbms_sql.close_cursor(insert_cursor);
    dbms_sql.close_cursor(select_cursor);
END exec_dsql_dstore_multicol;

PROCEDURE exec_dsql_dstore_singlecol(blockid varchar2,sqlstmt clob,tbl_name varchar2,disc_col varchar2, predicate varchar2) 
IS
    colCount            PLS_INTEGER;
    colValue            VARCHAR2(4000);
    tbl_desc            dbms_sql.desc_tab2;
    select_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    insert_cursor       PLS_INTEGER:=dbms_sql.open_cursor;
    status              PLS_INTEGER;
    fetched_rows        PLS_INTEGER;
    i                   PLS_INTEGER;
    typ01_val           VARCHAR2(4000); 
    typ02_val           NUMBER;
    typ12_val           DATE;
    typ96_val           VARCHAR2(4);
    typ00_val           VARCHAR2(4000);
    row_eid             NUMBER;
    
   
    select_tbl_sql_str  CLOB:=sqlstmt;
    create_tbl_sql_str  VARCHAR2(4000);
    insert_tbl_sql_str  VARCHAR2(4000);
    insert_jstr         CLOB;
    insert_sql_jstr     VARCHAR2(4000);
    tbl_exists_val      PLS_INTEGER;
    
    
    src_id                 VARCHAR2(32):=blockid;
        
BEGIN
    
    IF src_id is null then
        src_id:='undefined';
    END IF;
    --analyse query
    IF disc_col is not null and predicate is not null then
        select_tbl_sql_str:=select_tbl_sql_str || ' WHERE ' || UPPER(disc_col) || ' ' || predicate;
    end if;
    
   
        
    dbms_sql.parse(select_cursor,select_tbl_sql_str,dbms_sql.native);
    
   
    
    dbms_sql.describe_columns2(select_cursor,colCount,tbl_desc);
    
    For I In 1..tbl_desc.Count Loop
        
        
        CASE tbl_desc(i).col_type
            WHEN 1  THEN --varchar2
                    dbms_sql.define_column(select_cursor,i,'a',32);

            WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor,i,1);

            WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor,i,SYSDATE);

            WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor,i,'a',32);

            ELSE DBMS_OUTPUT.PUT_LINE('Undefined type ->' || tbl_desc(i).col_type);
        END CASE;
    END LOOP;

    
    status:=dbms_sql.EXECUTE(select_cursor);
    
    --Binding
    
    --for each row loop
    LOOP
    
        fetched_rows:=dbms_sql.fetch_rows(select_cursor);
        EXIT WHEN fetched_rows=0;
        
        i:=tbl_desc.FIRST;

        insert_jstr:='{';

        --for each col loop
        WHILE (i IS NOT NULL) LOOP
        IF lower(tbl_desc(i).col_name)='eid' THEN
            dbms_sql.column_value(select_cursor,i,row_eid);

        END IF;
        
            CASE tbl_desc(i).col_type
                WHEN 1  THEN --varchar2
                        dbms_sql.column_value(select_cursor,i,typ01_val);
                        
                        IF typ01_val IS NOT NULL THEN

                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ01_val)|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                insert_jstr:=insert_jstr || ',';    
                            END IF;
                            

                            
                        END iF;                                                
                WHEN 2 THEN -- number
                
                        
                        dbms_sql.column_value(select_cursor,i,typ02_val);
                        
                        IF typ02_val IS NOT NULL THEN

                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(ROUND(typ02_val,2))|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                insert_jstr:=insert_jstr || ',';    
                            END IF;
                        
                        END iF;
                        
                WHEN 12 THEN --date
                         dbms_sql.column_value(select_cursor,i,typ12_val);
                        
                        IF typ12_val IS NOT NULL THEN

                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ12_val,'DD/MM/YYYY')|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                    insert_jstr:=insert_jstr || ',';    
                            END IF;
                            

--                                
                        END iF;
                        
                WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor,i,typ96_val);
                        
                        IF typ96_val IS NOT NULL THEN

                            
                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ96_val)|| '"'; 
                            
                            IF i<tbl_desc.COUNT THEN
                                insert_jstr:=insert_jstr || ',';    
                            END IF;
                        
                         
                        END iF;
                ELSE DBMS_OUTPUT.PUT_LINE('Undefined type ' || tbl_desc(i).col_type);
            END CASE;
        i:=tbl_desc.NEXT(i);
        
      
        
        END LOOP;
        insert_jstr:=insert_jstr || '}';
        

        
        insert_sql_jstr:='INSERT /*+ ignore_row_on_dupkey_index(eadvx,EADVX_UC) */ INTO ' || tbl_name || '(eid, att, dt, valc,typ,src,evhash) VALUES(:eid, :att, :dt, :val,:typ,:src,:evhash)';
        
        
        
        dbms_sql.parse(insert_cursor,insert_sql_jstr,dbms_sql.native);   
        
                            dbms_sql.bind_variable(insert_cursor, ':eid' ,row_eid); 
                            dbms_sql.bind_variable(insert_cursor, ':att' ,disc_col); 
                            dbms_sql.bind_variable(insert_cursor, ':dt' ,sysdate); 
                            dbms_sql.bind_variable(insert_cursor, ':val', insert_jstr);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 2);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                            dbms_sql.bind_variable(insert_cursor, ':evhash',get_hash(insert_jstr));
        status:=dbms_sql.execute(insert_cursor);
        
        
        
        insert_sql_jstr:='';
        insert_jstr:='';
        
    END LOOP;
    dbms_sql.close_cursor(insert_cursor);
    dbms_sql.close_cursor(select_cursor);

END exec_dsql_dstore_singlecol;




PROCEDURE exec_ndsql(sqlstmt clob,tbl_name varchar2) 
IS
    status              PLS_INTEGER;
  
    create_tbl_sql_str  CLOB;
    
    tbl_exists_val      PLS_INTEGER;
    
BEGIN

    create_tbl_sql_str:='CREATE TABLE ' || tbl_name || ' AS ' || sqlstmt ;
        
    --DROP CREATE Table
    SELECT COUNT(*) INTO tbl_exists_val FROM user_tables WHERE table_name = UPPER(tbl_name);
    IF tbl_exists_val>0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name ;
    END IF;
    
    EXECUTE IMMEDIATE create_tbl_sql_str;
    
    tstack.EXTEND;
    
    tstack(tstack.COUNT):=tbl_name;

    
   
END exec_ndsql;

PROCEDURE compile_ruleblock(bid_in IN varchar2)
IS   
    strsql      CLOB;
    t0          INTEGER:=dbms_utility.get_time;
    
    
    rb          RMAN_RULEBLOCKS%ROWTYPE;
    
    bid         RMAN_RULEBLOCKS.blockid%TYPE;


BEGIN
   
    commit_log('Compile ruleblock',bid_in,'compiling');
    DELETE FROM rman_rpipe;
    DELETE FROM rman_stack;
    
    vstack:=vstack_empty;
    
    rman_pckg.parse_ruleblocks(bid_in);
    
    rman_pckg.parse_rpipe(strsql);
    
    UPDATE rman_ruleblocks SET sqlblock=strsql WHERE blockid=bid_in;
    
    SELECT * INTO rb FROM rman_ruleblocks WHERE blockid=bid_in;
   
    commit_log('Compile ruleblock',rb.blockid,'compiled to sql');
    
    
EXCEPTION
    WHEN OTHERS
        
        THEN 
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;

END compile_ruleblock;

PROCEDURE compile_active_ruleblocks
IS      
    rbs rman_ruleblocks_type;
    bid     varchar2(100);


BEGIN
    commit_log('compile_active_ruleblocks','','Started');
    SELECT * BULK COLLECT INTO rbs 
    FROM rman_ruleblocks WHERE IS_ACTIVE=2 ORDER BY exec_order;
    
    IF rbs.COUNT>0 THEN 
        commit_log('compile_active_ruleblocks','',rbs.COUNT || ' Ruleblocks added to stack');
    
        FOR i IN rbs.FIRST..rbs.LAST LOOP
            bid:=rbs(i).blockid;
            compile_ruleblock(bid);
            DBMS_OUTPUT.put_line('rb: ' || bid);
        END LOOP;
    ELSE
        commit_log('compile_active_ruleblocks','','Exiting with NULL Ruleblocks');
    END IF;
    
    
    
EXCEPTION
    WHEN OTHERS
        
        THEN 
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;

END compile_active_ruleblocks;

PROCEDURE execute_ruleblock(
    bid_in              IN varchar2, 
    create_wide_tbl     IN PLS_INTEGER, 
    push_to_long_tbl    IN PLS_INTEGER,
    push_to_long_tbl2   IN PLS_INTEGER,
    recompile           IN PLS_INTEGER
)
IS   
    strsql      CLOB;
    t0          INTEGER:=dbms_utility.get_time;
    
    
    rb          RMAN_RULEBLOCKS%ROWTYPE;
    
    bid         RMAN_RULEBLOCKS.blockid%TYPE;


BEGIN

    IF recompile=1 THEN
        compile_ruleblock(bid_in);
    END IF;
    
    
    SELECT * INTO rb FROM rman_ruleblocks WHERE blockid=bid_in;
   
    commit_log('Execute ruleblock',rb.blockid,'initialised');
    
    
    
    IF create_wide_tbl=1 THEN  
        commit_log('Execute ruleblock',rb.blockid,'exec_ndsql');
        rman_pckg.exec_ndsql(rb.sqlblock,rb.target_table);
    END IF;
    

    COMMIT;
    
    IF push_to_long_tbl=1 THEN  
        commit_log('Execute ruleblock',rb.blockid,'exec_dsql_dstore');
        
--        rman_pckg.exec_dsql_dstore_singlecol(rb.blockid,rb.sqlblock,'eadvx', rb.def_exit_prop,rb.def_predicate) ;
        
        rman_pckg.exec_dsql_dstore_singlecol(rb.blockid,'SELECT * FROM ' || rb.target_table ,'eadvx', rb.def_exit_prop,rb.def_predicate) ;
    END IF;
    
    COMMIT;
    
    -- Needs more work, do not use
--    IF push_to_long_tbl2=1 THEN  
--        commit_log('Execute ruleblock',rb.blockid,'exec_dsql_dstore2');
--        rman_pckg.exec_dsql_dstore2(rb.blockid,rb.sqlblock,'eadv2', rb.def_exit_prop,rb.def_predicate) ;
--    END IF;
    
    COMMIT;
    commit_log('Execute ruleblock',rb.blockid,'Succeded');
    
EXCEPTION
    WHEN OTHERS
        
        THEN 
            dbms_output.put_line(dbms_utility.format_error_stack);

            RAISE;

END execute_ruleblock;

PROCEDURE execute_active_ruleblocks(recompile IN NUMBER)
IS
    rbs rman_ruleblocks_type;
    bid     varchar2(100);
BEGIN
    tstack:=tstack_empty;
    
    commit_log('execute_active_ruleblocks','','Started');
    
    SELECT * BULK COLLECT INTO rbs 
    FROM rman_ruleblocks WHERE IS_ACTIVE=2 ORDER BY exec_order;
    
    IF rbs.COUNT>0 THEN 
        commit_log('execute_active_ruleblocks','',rbs.COUNT || ' Ruleblocks added to stack');
    
        FOR i IN rbs.FIRST..rbs.LAST LOOP
            bid:=rbs(i).blockid;
            IF recompile=1 THEN
                compile_ruleblock(bid);
            END IF;
            execute_ruleblock(bid,1,1,0,recompile);
            DBMS_OUTPUT.put_line('rb: ' || bid);
        END LOOP;
        
        drop_rout_tables;
    ELSE
        commit_log('execute_active_ruleblocks','','Exiting with NULL Ruleblocks');
    END IF;
    
EXCEPTION
    WHEN OTHERS
        THEN 
        commit_log('execute_active_ruleblocks',bid,'Error:');
        commit_log('execute_active_ruleblocks',bid,'FAILED');
        DBMS_OUTPUT.put_line('FAILED::' || bid || ' and errors logged to rman_ruleblocks_log !');
END execute_active_ruleblocks;


procedure drop_rout_tables is
status              PLS_INTEGER;
tbl_exists_val      PLS_INTEGER;
    
BEGIN

        FOR i IN tstack.FIRST..tstack.LAST LOOP
            dbms_output.put_line('ROUT TABLE->' || tstack(i));
            
             --DROP CREATE Table
            SELECT COUNT(*) INTO tbl_exists_val FROM user_tables WHERE table_name = UPPER(tstack(i));
            IF tbl_exists_val>0 THEN
                EXECUTE IMMEDIATE 'DROP TABLE ' || tstack(i) ;
            END IF;
                    
        END LOOP;
end drop_rout_tables;

procedure commit_log(moduleid  in varchar2,blockid   in varchar2,log_msg   in varchar2)
is
    msg     varchar2(100):=log_msg;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    
    IF msg='Error:' THEN
        msg:=msg || dbms_utility.format_error_stack;
    END IF;
    
    insert into rman_ruleblocks_log(moduleid,blockid,log_msg,log_time) values (moduleid, blockid,msg,current_timestamp);
    COMMIT;
end commit_log;

procedure gen_cube_from_ruleblock(ruleblockid varchar2,slices_str  varchar2)
as
    
--    ruleblockid varchar2(100):='rrt';
--    slices_str  varchar2(400):='01012019,01122018,01112018';
    slice_tbl   tbl_type;
    obj_tbl     tbl_type;

    function get_object_name(prefix varchar2, ruleblockid varchar2, slice varchar2) return varchar2
    as
    begin
        return prefix || '_' || substr(ruleblockid,1,15) || '_' || slice;
    end get_object_name;
    
    
    function get_sql_stmt_from_ruleblock(ruleblockid varchar2) return varchar2
    as
    sql_stmt    varchar2(32767):='';
    begin
        select sqlblock into sql_stmt from rman_ruleblocks where blockid=ruleblockid;
        return sql_stmt;
    end get_sql_stmt_from_ruleblock;
    
    procedure get_slices(slices_str varchar2)
    as
    begin
            slice_tbl:=rman_pckg.splitstr(slices_str,',');
    end get_slices;
    
    procedure create_temp_views
    as
    vw_name varchar2(30);
    obj_exists  binary_integer;
    begin
        for i in 1..slice_tbl.count loop
            vw_name:=get_object_name('vw',ruleblockid,slice_tbl(i));
            
            select count(*) into obj_exists from user_views where upper(view_name)=upper(vw_name);
            
            if obj_exists > 0 then 
                execute immediate 'DROP VIEW ' || vw_name;
                DBMS_OUTPUT.PUT_LINE('create_view-> dropping view ' || vw_name);
            end if;
                                
            execute immediate 'CREATE VIEW ' || vw_name || ' AS (' ||
                                'SELECT * FROM EADV WHERE DT<TO_DATE(''' || slice_tbl(i) || ''',''ddmmyyyy''))';  
            
            
        end loop;
    end create_temp_views; 
    
    procedure execute_ndsql_temp_tbls
    as
    tbl_name    varchar2(30);
    vw_name     varchar2(30);
    sql_stmt    clob;
    sql_stmt_mod clob;
    obj_exists  binary_integer;
    begin
        sql_stmt:=get_sql_stmt_from_ruleblock(ruleblockid);
        
        for i in 1..slice_tbl.count loop
            tbl_name:=get_object_name('rt',ruleblockid,slice_tbl(i));
            
            select count(*) into obj_exists from user_tables where upper(table_name)=upper(tbl_name);
            
            if obj_exists>0 then 
                execute immediate 'DROP TABLE ' || tbl_name;
                DBMS_OUTPUT.PUT_LINE('create_tbl-> dropping tbl ' || tbl_name);
            end if;
            
            vw_name:=get_object_name('vw',ruleblockid,slice_tbl(i));
            
            dbms_output.put_line(i || '->' || vw_name);
                       
            sql_stmt_mod:=replace(sql_stmt,'EADV',UPPER(vw_name));
            
            dbms_output.put_line(i || '->' || sql_stmt_mod);
            
            execute immediate 'CREATE TABLE ' || tbl_name || ' AS ' || sql_stmt_mod || '';  
            
            
        end loop;
    end execute_ndsql_temp_tbls;
    
    procedure union_temp_tbls
    as
    union_sql_stmt  clob:='';
    obj_exists      binary_integer:=0;
    tbl_name    varchar2(30);
    begin
        
        for i in 1..slice_tbl.count loop
            
            if i < slice_tbl.count then
            
                union_sql_stmt:= union_sql_stmt || ' SELECT * FROM ' || get_object_name('rt',ruleblockid,slice_tbl(i)) || ' UNION ';
            else
                union_sql_stmt:= union_sql_stmt || ' SELECT * FROM ' || get_object_name('rt',ruleblockid,slice_tbl(i));
                
            end if;
            
        end loop;
        
        tbl_name:=get_object_name('rt_cube',ruleblockid,'0');
        
        select count(*) into obj_exists from user_tables where upper(table_name)=upper(tbl_name);
            
        if obj_exists>0 then 
                execute immediate 'DROP TABLE ' || tbl_name;
                DBMS_OUTPUT.PUT_LINE('union -> dropping tbl ' || get_object_name('rt',ruleblockid,'0'));
        end if;
        
        execute immediate 'CREATE TABLE ' || tbl_name || ' AS (' || union_sql_stmt || ')';  
        DBMS_OUTPUT.PUT_LINE('union -> creating tbl ' || get_object_name('rt',ruleblockid,'0'));
    end;
    
    procedure cleanup_objects
    as
    tbl_name    varchar2(30);
    vw_name    varchar2(30);
    obj_exists  binary_integer:=0;
    
    begin
        for i in 1..slice_tbl.count loop
            tbl_name:=get_object_name('rt',ruleblockid,slice_tbl(i));
            
            select count(*) into obj_exists from user_tables where upper(table_name)=upper(tbl_name);
            
            if obj_exists>0 then 
                execute immediate 'DROP TABLE ' || tbl_name;
                DBMS_OUTPUT.PUT_LINE('cleanup-> dropping tbl ' || tbl_name);
            end if;
            
            obj_exists:=0;
            
            vw_name:=get_object_name('vw',ruleblockid,slice_tbl(i));
            
            select count(*) into obj_exists from user_views where upper(view_name)=upper(vw_name);
            
            if obj_exists > 0 then 
                execute immediate 'DROP VIEW ' || vw_name;
                DBMS_OUTPUT.PUT_LINE('cleanup-> dropping view ' || vw_name);
            end if;
            
        end loop;
    end cleanup_objects;
    
    procedure modify_temp_tbls
    as
    tbl_name    varchar2(30);
    obj_exists  binary_integer:=0;
    begin
        for i in 1..slice_tbl.count loop
            tbl_name:=get_object_name('rt',ruleblockid,slice_tbl(i));
            
            select count(*) into obj_exists from user_tables where upper(table_name)=upper(tbl_name);
            
            if obj_exists>0 then 
                execute immediate 'ALTER TABLE ' || tbl_name || ' ADD DIM_COL CHAR(30) DEFAULT ''SLC' || slice_tbl(i) || ''' NOT NULL';
                DBMS_OUTPUT.PUT_LINE('modifying -> alter tbl tbl ' || tbl_name);
            end if;
            
            
        end loop;
    end modify_temp_tbls;
begin
    
    get_slices(slices_str);
    
    create_temp_views;
    
    execute_ndsql_temp_tbls;

    modify_temp_tbls;
    
    union_temp_tbls;

    cleanup_objects;

end gen_cube_from_ruleblock;

END;




