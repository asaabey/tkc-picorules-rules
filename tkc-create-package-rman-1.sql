CLEAR SCREEN;

CREATE OR REPLACE PACKAGE rman_pckg AUTHID current_user AS

/*

Package		    rman_pckg
Version		    1.0.0.4
Creation date	07/04/2019
update on date  31/08/2019
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

Compiler directive
#define_attribute(att_name, json_object);
#define_ruleblock(ruleblock, json_object); TBI

Data cube generator
Usage:
rman_pckg.gen_cube_from_ruleblock('cd_dm.dm,ckd.ckd_stage','01032019,01032018','rep123');
parameters

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
17/07/2019  Gen Datacubes can accept multiple rules
20/07/2019  Added compiler directive with build_compiler_exp 
23/07/2019  Added serialize function
27/07/2019  added define_ruleblock function
29/07/2019  template compiler added to ensure integrity of attribute coupling to the view
01/08/2019  fixed rpipe sorting bug
01/08/2019  changed listagg to xmlagg, to overcome string buffer 4000 overflow
06/08/2019  datacube generator improvements
07/08/2019  init_global_vstack bug fixes
08/08/2019  dependency_walker bug fixes,gen cube optimizations
13/08/2019  gen_cube sysdate injection
14/08/2019  build_func predicate chain bug fixed. applies extra parantheses
21/08/2019  dbms_sql handles type 112 clob type
23/08/2019  templates handles medication lists 
27/08/2019  template handling of tabs and line feeds
28/08/2019  fixed serializedv function to take two param for transformation
            fixed build_func for funcparam_str
            fixed regex for funcparam
            fixed map_to_tmplt for interecept graph
            added ascii_graph_dv function
            dsql_single_col fixed for varchar2(4000)
31/08/2019  map to template fixes
*/
    TYPE rman_tbl_type IS
        TABLE OF rman_stack%rowtype;
    TYPE rpipe_tbl_type IS
        TABLE OF rman_rpipe%rowtype;
    TYPE rman_ruleblocks_type IS
        TABLE OF rman_ruleblocks%rowtype;
    TYPE vstack_type IS
        TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    vstack vstack_type;
    vstack_empty vstack_type;
    global_vstack_selected tbl_type := tbl_type();
    global_vstack_selected_empty tbl_type := tbl_type();
    TYPE vstack_func_type IS
        TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    vstack_func vstack_func_type;
    TYPE vstack_func_param_type IS
        TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    vstack_func_param vstack_func_param_type;
    TYPE tstack_type IS
        TABLE OF VARCHAR2(30);
    tstack tstack_type := tstack_type();
    tstack_empty tstack_type := tstack_type();
    cmpstat NVARCHAR2(4000);
    rman_index PLS_INTEGER := 0;
    assn_op CONSTANT VARCHAR2(2) := '=>';
    like_op CONSTANT CHAR := '%';
    comment_open_chars CONSTANT VARCHAR(2) := '/*';
    comment_close_chars CONSTANT VARCHAR(2) := '*/';
    entity_id_col CONSTANT VARCHAR2(32) := 'EID';
    att_col CONSTANT VARCHAR2(32) := 'ATT';
    val_col CONSTANT VARCHAR2(32) := 'VAL';
    dt_col CONSTANT VARCHAR2(32) := 'DT';
    def_tbl_name CONSTANT VARCHAR2(32) := 'EADV';
    PROCEDURE parse_rpipe (
        sqlout OUT VARCHAR2
    );

    PROCEDURE get_composite_sql (
        cmpstat OUT NVARCHAR2
    );

    FUNCTION sql_predicate (
        att_str VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION sanitise_varname (
        varname VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION splitstr (
        list           IN             VARCHAR2,
        delimiter      IN             VARCHAR2 DEFAULT ',',
        ignore_left    IN             CHAR DEFAULT '[',
        ignore_right   IN             CHAR DEFAULT ']'
    ) RETURN tbl_type;

    FUNCTION splitclob (
        list           IN             CLOB,
        delimiter      IN             VARCHAR2 DEFAULT ',',
        ignore_left    IN             CHAR DEFAULT '[',
        ignore_right   IN             CHAR DEFAULT ']'
    ) RETURN tbl_type2;
    
    
    

    FUNCTION sanitise_clob (
        clbin CLOB
    ) RETURN CLOB;


    FUNCTION tbl_type_to_string (
        t IN tbl_type
    ) RETURN VARCHAR2;
    
    FUNCTION get_cte_name (
        indx BINARY_INTEGER
    ) RETURN NVARCHAR2;

    FUNCTION trim_comments (
        txtin CLOB
    ) RETURN CLOB;

    FUNCTION modify_ps_on_funcparam (
        txtin VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION ascii_graph_dv (
        dts VARCHAR2,
        vals VARCHAR2,
        param   varchar2 default null 
    ) RETURN VARCHAR2;

    FUNCTION map_to_tmplt (
        jstr VARCHAR2,
        tmplt VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION get_composition_by_eid (
        eid_in INT,
        nlc_id VARCHAR2
    ) RETURN CLOB;

    FUNCTION is_not_last_selected_var (
        txtin VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION is_selected_var (
        txtin VARCHAR2,
        sub PLS_INTEGER
    ) RETURN BOOLEAN;

    PROCEDURE insert_rman (
        indx             INT,
        where_clause     NVARCHAR2,
        from_clause      NVARCHAR2,
        select_clause    NVARCHAR2,
        groupby_clause   NVARCHAR2,
        varid            NVARCHAR2,
        is_sub           INT,
        sqlstat          OUT              NVARCHAR2,
        agg_func         VARCHAR2,
        func_param       VARCHAR2
    );

    PROCEDURE build_func_sql_exp (
        blockid      IN           VARCHAR2,
        indx         IN           INT,
        txtin        VARCHAR2,
        sqlstat      OUT          VARCHAR2,
        rows_added   OUT          PLS_INTEGER
    );

    PROCEDURE build_cond_sql_exp (
        blockid      IN           VARCHAR2,
        indx         PLS_INTEGER,
        txtin        IN           VARCHAR2,
        sqlstat      OUT          VARCHAR2,
        rows_added   OUT          PLS_INTEGER
    );

    PROCEDURE parse_ruleblocks (
        blockid VARCHAR2
    );

    PROCEDURE init_global_vstack (
        bid_in IN VARCHAR2
    );

    PROCEDURE exec_dsql (
        sqlstmt CLOB,
        tbl_name VARCHAR2
    );

    PROCEDURE exec_dsql_dstore2 (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    );

    PROCEDURE exec_dsql_dstore_multicol (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    );

    PROCEDURE exec_dsql_dstore_singlecol (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    );

    PROCEDURE check_sql_syntax (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    );

    PROCEDURE exec_ndsql (
        sqlstmt CLOB,
        tbl_name VARCHAR2
    );

    PROCEDURE compile_ruleblock (
        bid_in IN VARCHAR2,
        return_code OUT pls_integer
    );

    PROCEDURE compile_active_ruleblocks;

    PROCEDURE execute_ruleblock (
        bid_in              IN                  VARCHAR2,
        create_wide_tbl     IN                  PLS_INTEGER,
        push_to_long_tbl    IN                  PLS_INTEGER,
        push_to_long_tbl2   IN                  PLS_INTEGER,
        recompile           IN                  PLS_INTEGER,
        return_code OUT pls_integer
    );

    PROCEDURE execute_active_ruleblocks;

    PROCEDURE drop_rout_tables;

    PROCEDURE commit_log (
        moduleid   IN         VARCHAR2,
        blockid    IN         VARCHAR2,
        log_msg    IN         VARCHAR2
    );



    PROCEDURE dependency_walker (
        rb_in_str    IN           VARCHAR2,
        dep_rb_str   OUT          VARCHAR2
    );

    PROCEDURE gen_cube_from_ruleblock (
        rb_att_str     IN             VARCHAR2,
        slices_str     IN             VARCHAR2,
        ret_tbl_name   IN             VARCHAR2
    );

    PROCEDURE build_compiler_exp (
        ruleblockid   IN            VARCHAR2,
        indx          IN            INT,
        txtin         VARCHAR2
    );

    /* Truncates and populates the contens of EADV, the primary data source for RMAN */

    PROCEDURE populate_eadv_tables;

    PROCEDURE compile_templates;

END;
/

CREATE OR REPLACE PACKAGE BODY rman_pckg AS





    FUNCTION sql_predicate (
        att_str VARCHAR2
    ) RETURN VARCHAR2 AS

        att_tbl       tbl_type;
        eq_op         VARCHAR2(6);
        att_str0      VARCHAR2(4000);
        escape_stat   VARCHAR(20) := ' ESCAPE ''!''';
        s             VARCHAR2(5000);
        att_col       CONSTANT VARCHAR2(30) := 'ATT';
    BEGIN
        att_str0 := att_str;
        IF instr(att_str0, '[') > 0 AND instr(att_str0, ']') > 0 THEN
            att_str0 := substr(att_str0, instr(att_str0, '[') + 1, instr(att_str0, ']') - 2);

        END IF;
        
        

        IF instr(att_str0, ',') > 0 THEN
            att_tbl := rman_pckg.splitstr(att_str0, ',', '', '');
            
            s:=s || ' (';
            
            FOR i IN 1..att_tbl.count LOOP
                IF instr(att_tbl(i), '%') > 0 THEN
                    eq_op := ' LIKE ';
                ELSE
                    eq_op := ' = ';
                END IF;

                s := s
                     || '('
                     || att_col
                     || eq_op
                     || '`'
                     || att_tbl(i)
                     || '`)';

                IF i < att_tbl.count THEN
                    s := s || ' OR ';
                END IF;
            END LOOP;
            
            s:=s || ') ';

        ELSIF instr(att_str0, ',') = 0 THEN
            IF instr(att_str0, '%') > 0 THEN
                eq_op := ' LIKE ';
            ELSE
                eq_op := ' = ';
            END IF;

            s := s
                 || '('
                 || att_col
                 || eq_op
                 || '`'
                 || att_str0
                 || '`)';

        END IF;

        
        RETURN s;
    END sql_predicate;

    FUNCTION sanitise_varname (
        varname VARCHAR2
    ) RETURN VARCHAR2 AS
        s VARCHAR2(100);
    BEGIN
    -- trim bounding parantheses
        s := translate(varname, '1-+{}[] ', '1');
    -- surround with double quotes if full stop and spaces found in var from varnames if not already there
        IF instr(varname, '"') <> 1 AND instr(varname, '.') > 0 OR instr(varname, ' ') > 0 THEN
            s := '"'
                 || s
                 || '"';
        END IF;

        RETURN s;
    END sanitise_varname;

    FUNCTION splitstr (
        list           IN             VARCHAR2,
        delimiter      IN             VARCHAR2 DEFAULT ',',
        ignore_left    IN             CHAR DEFAULT '[',
        ignore_right   IN             CHAR DEFAULT ']'
    ) RETURN tbl_type AS

        splitted           tbl_type := tbl_type();
        i                  PLS_INTEGER := 0;
        list_              VARCHAR2(32767) := trim(list);
        ignore_right_pos   PLS_INTEGER;
        ignore_left_pos    PLS_INTEGER;
        ignore_length      PLS_INTEGER;
    BEGIN
        LOOP       
            -- find next delimiter
            i := instr(list_, delimiter);
            splitted.extend(1);
            IF i > 0 THEN 
                -- find ignore bouding region
                ignore_left_pos := instr(list_, ignore_left);
                ignore_right_pos := instr(list_, ignore_right);
                       
                -- when bounding region defined and delimiter found inside bounding region
                IF ignore_left_pos > 0 AND ignore_right_pos > ignore_left_pos AND i > ignore_left_pos AND i < ignore_right_pos THEN
                    splitted(splitted.last) := trim(substr(list_, 1,(ignore_right_pos - ignore_left_pos) + 1));

                    list_ := trim(substr(list_, ignore_right_pos + 2));
                ELSE
                    splitted(splitted.last) := trim(substr(list_, 1, i - 1));

                    list_ := trim(substr(list_, i + length(delimiter)));
                END IF;

            ELSE
                splitted(splitted.last) := trim(list_);
                RETURN splitted;
            END IF;

        END LOOP;
    END splitstr;

    FUNCTION splitclob (
        list           IN             CLOB,
        delimiter      IN             VARCHAR2 DEFAULT ',',
        ignore_left    IN             CHAR DEFAULT '[',
        ignore_right   IN             CHAR DEFAULT ']'
    ) RETURN tbl_type2 AS

        splitted           tbl_type2 := tbl_type2();
        i                  PLS_INTEGER := 0;
        list_              CLOB := trim(list);
        ignore_right_pos   PLS_INTEGER;
        ignore_left_pos    PLS_INTEGER;
        ignore_length      PLS_INTEGER;
    BEGIN
        LOOP       
            -- find next delimiter
            i := dbms_lob.instr(list_, delimiter);
            splitted.extend(1);
            IF i > 0 THEN 
                -- find ignore bouding region
                ignore_left_pos := dbms_lob.instr(list_, ignore_left);
                ignore_right_pos := dbms_lob.instr(list_, ignore_right);
                       
                -- when bounding region defined and delimiter found inside bounding region
                IF ignore_left_pos > 0 AND ignore_right_pos > ignore_left_pos AND i > ignore_left_pos AND i < ignore_right_pos THEN
                    splitted(splitted.last) := trim(dbms_lob.substr(list_,(ignore_right_pos - ignore_left_pos) + 1, 1));

                    list_ := dbms_lob.substr(list_, 32767, ignore_right_pos + 2);
                ELSE
                    splitted(splitted.last) := trim(dbms_lob.substr(list_, i - 1, 1));

                    list_ := dbms_lob.substr(list_, 32767, i + length(delimiter));

                END IF;

            ELSE
                splitted(splitted.last) := list_;
                RETURN splitted;
            END IF;

        END LOOP;
    END splitclob;
    
    FUNCTION tbl_type_to_string (
        t IN tbl_type
    ) RETURN VARCHAR2 AS
        ret VARCHAR2(4000) := '';
    BEGIN
        FOR i IN 1..t.count LOOP ret := ret
                                        || t(i)
                                        || ',';
        END LOOP;

        ret := trim(TRAILING ',' FROM ret);
        RETURN ret;
    END tbl_type_to_string;
    
    FUNCTION sanitise_clob (
        clbin CLOB
    ) RETURN CLOB AS
        clb CLOB := clbin;
    BEGIN
        clb := replace(clb, chr(13), ' ');
        clb := replace(clb, chr(10), ' ');
        clb := regexp_replace(clb, '[[:space:]]+', ' ');
        RETURN clb;
    END sanitise_clob;

    FUNCTION get_cte_name (
        indx BINARY_INTEGER
    ) RETURN NVARCHAR2 AS
    BEGIN
        RETURN 'CTE'
               || lpad(indx, 3, 0);
    END get_cte_name;

    FUNCTION trim_comments (
        txtin CLOB
    ) RETURN CLOB AS
        txtout              CLOB;
        comment_open_pos    PLS_INTEGER;
        comment_close_pos   PLS_INTEGER;
        replace_txt         CLOB;
    BEGIN
        txtout := txtin;
        comment_open_pos := dbms_lob.instr(txtout, comment_open_chars);
        comment_close_pos := dbms_lob.instr(txtout, comment_close_chars);
        IF comment_open_pos > 0 THEN
            IF comment_close_pos > 0 THEN
                WHILE ( comment_open_pos > 0 AND comment_close_pos > 0 AND comment_open_pos < comment_close_pos ) LOOP
                    replace_txt := substr(txtout, comment_open_pos, comment_close_pos - comment_open_pos + length(comment_close_chars
                    ));

                    txtout := replace(txtout, replace_txt, '');
                    comment_open_pos := dbms_lob.instr(txtout, comment_open_chars);
                    comment_close_pos := dbms_lob.instr(txtout, comment_close_chars);
                END LOOP;

            ELSE
                txtout := '';
            END IF;
        END IF;

        RETURN txtout;
    END trim_comments;

    FUNCTION format_column_name (
        txtin VARCHAR2
    ) RETURN VARCHAR2 AS
        txtout VARCHAR2(100) := txtin;
    BEGIN
        IF length(txtout) > 30 THEN
            txtout := substr(txtout, 1, 30);
        END IF;

        IF instr(txtout, '.') > 0 OR instr(txtout, ' ') > 0 THEN
            txtout := '"'
                      || txtout
                      || '"';
        END IF;

        RETURN txtout;
    END;

    FUNCTION format_bindvar_name (
        txtin VARCHAR2
    ) RETURN VARCHAR2 AS
        txtout VARCHAR2(100) := txtin;
    BEGIN
        IF length(txtout) > 30 THEN
            txtout := substr(txtout, 1, 30);
        END IF;

        IF instr(txtout, '.') > 0 OR instr(txtout, ' ') > 0 THEN
            txtout := translate(txtout, '. ', '_');
        END IF;

        RETURN lower(txtout);
    END;

    FUNCTION is_tempvar (
        txtin VARCHAR2
    ) RETURN BOOLEAN AS
        retval         BOOLEAN := false;
        tempvar_char   VARCHAR2(1) := '_';
    BEGIN
        IF substr(trim(LEADING '"' FROM txtin), -1 *(length(tempvar_char))) = tempvar_char THEN
            retval := true;
        END IF;

        RETURN retval;
    END is_tempvar;

    FUNCTION is_not_last_selected_var (
        txtin VARCHAR2
    ) RETURN BOOLEAN AS
        retval BOOLEAN := false;
    BEGIN
        IF global_vstack_selected.count = 0 THEN
            retval := true;
        ELSIF global_vstack_selected(global_vstack_selected.last) <> txtin THEN
            retval := true;
        END IF;
--Bypass        

        retval := true;
        RETURN retval;
    END is_not_last_selected_var;

    FUNCTION is_selected_var (
        txtin VARCHAR2,
        sub PLS_INTEGER
    ) RETURN BOOLEAN AS
        txt_tmp   VARCHAR2(100);
        retval    BOOLEAN := false;
    BEGIN
        IF global_vstack_selected.count = 0 THEN
            retval := true;
        END IF;
        FOR i IN 1..global_vstack_selected.last LOOP IF sub = 0 THEN
            IF global_vstack_selected(i) = txtin THEN
                retval := true;
            END IF;
        ELSIF sub = 2 THEN
            IF global_vstack_selected(i) = txtin || '_dt' OR global_vstack_selected(i) = txtin || '_val' THEN
                retval := true;
            END IF;
        END IF;
        END LOOP;

        
        
        --Bypass

        retval := true;
        RETURN retval;
    END is_selected_var;

    FUNCTION match_varname (
        txtbody VARCHAR2,
        elem VARCHAR2
    ) RETURN BOOLEAN AS
        ret   BOOLEAN := false;
        rgx   VARCHAR2(100);
    BEGIN
        rgx := '\W'
               || elem
               || '\W';
        IF regexp_instr(txtbody, rgx, 1, 1) > 0 THEN
            ret := true;
        END IF;

        RETURN ret;
    END match_varname;

    FUNCTION get_hash (
        inclob CLOB
    ) RETURN VARCHAR2 AS
        ret VARCHAR2(32);
    BEGIN
        IF length(inclob) > 0 THEN 
        --ret:=dbms_crypto.hash(inclob, dbms_crypto.HASH_MD5 );
            ret := dbms_obfuscation_toolkit.md5(input => utl_i18n.string_to_raw(inclob, 'AL32UTF8'));
        END IF;

        RETURN ret;
    END get_hash;

    PROCEDURE get_composite_sql (
        cmpstat OUT NVARCHAR2
    ) IS
        rmanobj   rman_tbl_type;
        ctename   NVARCHAR2(20);
    BEGIN
        SELECT
            id,
            where_clause,
            from_clause,
            select_clause,
            groupby_clause,
            varid,
            is_sub,
            agg_func,
            func_param
        BULK COLLECT
        INTO rmanobj
        FROM
            rman_stack
        ORDER BY
            id;

        cmpstat := 'WITH '
                   || get_cte_name(0)
                   || ' AS (SELECT '
                   || entity_id_col
                   || ' FROM EADV GROUP BY '
                   || entity_id_col
                   || '),';

    -- assemble CTE's

        FOR i IN rmanobj.first..rmanobj.last LOOP
            ctename := get_cte_name(i);
            cmpstat := cmpstat
                       || ctename
                       || ' AS (SELECT '
                       || replace(rmanobj(i).select_clause, '`', '''')
                       || ' FROM '
                       || replace(rmanobj(i).from_clause, '`', '''');

            IF rmanobj(i).where_clause IS NOT NULL THEN
                cmpstat := cmpstat
                           || ' WHERE '
                           || replace(rmanobj(i).where_clause, '`', '''');
            END IF;

            IF rmanobj(i).groupby_clause IS NOT NULL THEN
                cmpstat := cmpstat
                           || ' GROUP BY '
                           || rmanobj(i).groupby_clause;
            END IF;

            cmpstat := cmpstat || ')';
            IF i < rmanobj.last THEN
                cmpstat := cmpstat || ',';
            END IF;
        
        --line break for readability
            cmpstat := cmpstat || chr(10);
        END LOOP;
    
    --Add select 

        cmpstat := cmpstat
                   || ' SELECT '
                   || get_cte_name(0)
                   || '.'
                   || entity_id_col
                   || ', ';

        FOR i IN rmanobj.first..rmanobj.last LOOP
            ctename := get_cte_name(i);
            IF rmanobj(i).is_sub = 0 THEN
                IF is_tempvar(rmanobj(i).varid) = false AND is_selected_var(rmanobj(i).varid, rmanobj(i).is_sub) = true THEN
                    cmpstat := cmpstat
                               || ctename
                               || '.'
                               || sanitise_varname(rmanobj(i).varid)
                               || ' ';                        
                --line break for readability

                    cmpstat := cmpstat || chr(10);
                    IF i < rmanobj.last AND rmanobj(i).is_sub = 0 THEN
                        cmpstat := cmpstat || ',';
                    END IF;

                END IF;

            ELSIF rmanobj(i).is_sub = 2 THEN
                IF is_tempvar(rmanobj(i).varid) = false AND is_selected_var(rmanobj(i).varid, rmanobj(i).is_sub) = true THEN
                    cmpstat := cmpstat
                               || ctename
                               || '.'
                               || sanitise_varname(rmanobj(i).varid)
                               || '_DT';

                    cmpstat := cmpstat || chr(10);
                    cmpstat := cmpstat || ',';
                    cmpstat := cmpstat
                               || ctename
                               || '.'
                               || sanitise_varname(rmanobj(i).varid)
                               || '_VAL';

                    cmpstat := cmpstat || chr(10);
                    IF i < rmanobj.last AND is_not_last_selected_var(rmanobj(i).varid) THEN
                        cmpstat := cmpstat || ',';
                    END IF;

                END IF;
            END IF;

        END LOOP;

        cmpstat := trim(TRAILING ',' FROM cmpstat);
        cmpstat := cmpstat
                   || 'FROM '
                   || get_cte_name(0);

    -- Add the left outer joins
        FOR i IN rmanobj.first..rmanobj.last LOOP
            ctename := get_cte_name(i);
            IF rmanobj(i).is_sub = 0 OR rmanobj(i).is_sub = 2 THEN
                IF is_tempvar(rmanobj(i).varid) = false AND is_selected_var(rmanobj(i).varid, rmanobj(i).is_sub) = true THEN
                    cmpstat := cmpstat
                               || ' LEFT OUTER JOIN '
                               || ctename
                               || ' ON '
                               || ctename
                               || '.'
                               || entity_id_col
                               || '='
                               || get_cte_name(0)
                               || '.'
                               || entity_id_col
                               || ' ';
                    --line break for readability

                    cmpstat := cmpstat || chr(10);
                END IF;

            END IF;

        END LOOP;

    END get_composite_sql;

    PROCEDURE insert_rman (
        indx             INT,
        where_clause     NVARCHAR2,
        from_clause      NVARCHAR2,
        select_clause    NVARCHAR2,
        groupby_clause   NVARCHAR2,
        varid            NVARCHAR2,
        is_sub           INT,
        sqlstat          OUT              NVARCHAR2,
        agg_func         VARCHAR2,
        func_param       VARCHAR2
    ) IS
    BEGIN
        INSERT INTO rman_stack (
            id,
            where_clause,
            from_clause,
            select_clause,
            groupby_clause,
            varid,
            is_sub,
            agg_func,
            func_param
        ) VALUES (
            indx,
            where_clause,
            from_clause,
            select_clause,
            groupby_clause,
            varid,
            is_sub,
            agg_func,
            func_param
        );

        sqlstat := 'rows added :' || SQL%rowcount;
    END insert_rman;

    PROCEDURE insert_ruleblocks_dep (
        blockid_s      IN             VARCHAR2,
        dep_table_s    IN             VARCHAR2,
        dep_column_s   IN             VARCHAR2,
        dep_att_s      IN             VARCHAR2,
        dep_func_s     IN             VARCHAR2,
        att_name_s     IN             VARCHAR2
    ) IS
    BEGIN
        DELETE FROM rman_ruleblocks_dep
        WHERE
            blockid = blockid_s
            AND att_name = att_name_s;

        INSERT INTO rman_ruleblocks_dep (
            blockid,
            dep_table,
            dep_column,
            dep_att,
            dep_func,
            att_name
        ) VALUES (
            blockid_s,
            dep_table_s,
            dep_column_s,
            dep_att_s,
            dep_func_s,
            att_name_s
        );

    END insert_ruleblocks_dep;

    FUNCTION modify_ps_on_funcparam (
        txtin VARCHAR2
    ) RETURN VARCHAR2 AS
        vsi       VARCHAR2(100);
        txtout    VARCHAR2(32767);
        rep_str   VARCHAR2(100);
    BEGIN
        txtout := txtin;
--loop through vstack
        vsi := vstack.first;
        WHILE vsi IS NOT NULL LOOP   
                
                --find vstack param and func
            IF vstack_func.EXISTS(vsi) AND vstack_func_param.EXISTS(vsi) AND match_varname(txtout, vsi) THEN
                IF vstack_func(vsi) IS NOT NULL AND vstack_func_param(vsi) IS NOT NULL THEN

                
                    CASE
                        WHEN vstack_func(vsi) IN (
                            'COUNT',
                            'LAST',
                            'FIRST'
                        ) AND vstack_func_param(vsi) = '0' THEN
                            rep_str := 'NVL('
                                       || vsi
                                       || ',0)';
                            txtout := replace(txtout, vsi, rep_str);    
                            
                        WHEN vstack_func(vsi) IN (
                            'MIN',
                            'MAX',
                            'FIRST',
                            'LAST'
                        ) AND vstack_func_param(vsi) = '1900' THEN
                        
                            rep_str := 'NVL('
                                       || vsi
                                       || ',TO_DATE(''19000101'',''YYYYMMDD''))';
                            txtout := replace(txtout, vsi, rep_str);
                        ELSE
                            txtout := txtout;
                    END CASE;

                END IF;
            END IF;

            vsi := vstack.next(vsi);
        END LOOP;

        RETURN txtout;
    END modify_ps_on_funcparam;

    FUNCTION ascii_graph_dv (
        dts VARCHAR2,
        vals VARCHAR2,
        param   varchar2 default null 
    ) RETURN VARCHAR2 AS
    y pls_integer:=120;
    x pls_integer:=1;
    x_pixels pls_integer:=36;
    y_pixels pls_integer:=12;
    x_min pls_integer:=1;
    
    str varchar2(4000):='';
    dot char(1):=' ';
    dt_tbl  tbl_type;
    val_tbl tbl_type;
    dt_x    pls_integer;
    val_y   number;
    mspan   number;
    yspan   number;
    span    number;
    span_unit   varchar(10);
    xscale  number;
    BEGIN
        dt_tbl:=rman_pckg.splitstr(dts,' ');
        val_tbl:=rman_pckg.splitstr(vals,' ');
    

        
        mspan :=(CEIL((SYSDATE-(TO_DATE(dt_tbl(dt_tbl.COUNT), 'dd/mm/yy')))/30.43))+2;
        
        xscale:=x_pixels/mspan;
        WHILE y>0
        LOOP
            str:=str ||chr(9) ||  lpad(y,3,' ') || ' | ';
            WHILE x<x_pixels
            LOOP
                FOR i IN 1..dt_tbl.COUNT
                LOOP
                    dt_x:=round(x_pixels-(ceil((SYSDATE-TO_DATE(dt_tbl(i), 'dd/mm/yy'))/30.43)*xscale),0); 
                    
                    val_y:=to_number(val_tbl(i));
                    
                    
                    IF dt_x=x THEN
                        IF val_y<y and val_y>(y-10) THEN
                            dot:='*';
                        ELSE
                            dot:=' ';
                        END IF;

                    EXIT;
                    END IF;

                END LOOP;
                str:=str || dot;
                dot:=' ';
            
                x:=x+1;
            END LOOP;
            y:=y-10;
            str:=str || chr(10);
            x:=1;
        END LOOP;  
        
        if mspan>24 then
            span:=round(mspan/12,1);
            span_unit:=' years ';
        elsif mspan<=24 and mspan>3 then
            span:=mspan;
            span_unit:=' months ';
        else
            span:=round(mspan*30.4,0);
            span_unit:=' days ';
        end if ;   
        str:=str || chr(9) || rpad('    |',x_pixels+2,'_') || chr(10);
        str:=str || chr(9) || dt_tbl(dt_tbl.count) || rpad(' ',x_pixels-12,' ') || sysdate || chr(10);
        str:=str || chr(9) || chr(9) || rpad('[-',(x_pixels-12)/2,'-') || span || span_unit || lpad('-]',(x_pixels-12)/2,'-') || chr(10);
        return str;
    end ascii_graph_dv;

    FUNCTION map_to_tmplt (
        jstr VARCHAR2,
        tmplt VARCHAR2
    ) RETURN VARCHAR2 AS

        key_tbl        tbl_type;
        t              VARCHAR2(4000);
        tkey           VARCHAR2(100);
--        tval           VARCHAR2(100);
        tval           VARCHAR2(4000);
--        html_tkey      VARCHAR2(100);
        html_tkey      VARCHAR2(4000);
        tag_param      VARCHAR2(100);
        tag_operator   VARCHAR(2);
        ret_tmplt      VARCHAR2(32767) := tmplt;
        x_vals          VARCHAR2(1000):='';
        y_vals          VARCHAR2(1000):='';
        xygraph         VARCHAR(1000);
--        ret_tmplt      CLOB := tmplt;
    BEGIN
--jstr into collection
        t := regexp_substr(jstr, '\{(.*?)\}', 1, 1, 'i', 1);
        key_tbl := rman_pckg.splitstr(t, ',');
        FOR i IN 1..key_tbl.count LOOP
            tkey := lower(regexp_substr(substr(key_tbl(i), 1, instr(key_tbl(i), ':')), '\"(.*?)\"', 1, 1, 'i', 1));

            tval := regexp_substr(substr(key_tbl(i), instr(key_tbl(i), ':')), '\"(.*?)\"', 1, 1, 'i', 1);

            if instr(tkey,'_graph_dt')>0 then
                x_vals:=tval;
            end if;
            if instr(tkey,'_graph_val')>0 then
                y_vals:=tval;
            end if;
            if length(x_vals)>0 and length(y_vals)>0 then
                xygraph:=ascii_graph_dv(x_vals,y_vals);
                
            end if;
            
            -- insertions
            
            

            html_tkey := tkey || '>';
            ret_tmplt := regexp_replace(ret_tmplt, '<'
                                                   || html_tkey
                                                   || '</'
                                                   || html_tkey, tval);
            -- add graphs
            if length(xygraph)>0 then 

                
                ret_tmplt := regexp_replace(ret_tmplt, '<xygraph></xygraph>', xygraph);                                       
            end if;                                       
            
            -- toggle on

            IF nvl(length(tval), 0) > 0 AND nvl(length(tval), 0) < 13 AND nvl(tval, '0') <> '0' THEN
                -- without tag param
                html_tkey := tkey || '>';
                ret_tmplt := regexp_replace(ret_tmplt, '<' || html_tkey, '', 1, 0, 'i');

                ret_tmplt := regexp_replace(ret_tmplt, '</' || html_tkey, '', 1, 0, 'i');

                html_tkey := tkey
                             || '='
                             || tval
                             || '>';
                ret_tmplt := regexp_replace(ret_tmplt, '<' || html_tkey, '', 1, 0, 'i');

                ret_tmplt := regexp_replace(ret_tmplt, '</' || html_tkey, '', 1, 0, 'i');

                html_tkey := tkey
                             || '(=[a-z0-9]+)?'
                             || '>';
                ret_tmplt := regexp_replace(ret_tmplt, '<'
                                                       || html_tkey
                                                       || '(.*?)'
                                                       || '</'
                                                       || html_tkey, '');

            ELSE
                
                -- tval null or 0
                 
                -- if param is 0 then toggle text on 
                html_tkey := tkey
                             || '=0'
                             || '>';
                ret_tmplt := regexp_replace(ret_tmplt, '<' || html_tkey, '', 1, 0, 'i');

                ret_tmplt := regexp_replace(ret_tmplt, '</' || html_tkey, '', 1, 0, 'i');
                
                -- if param<>0 then toggle text off 

                html_tkey := tkey
                             || '(=[a-z0-9]+)?'
                             || '>';
                ret_tmplt := regexp_replace(ret_tmplt, '<'
                                                       || html_tkey
                                                       || '(.*?)'
                                                       || '</'
                                                       || html_tkey, '');
                
                -- if no parameter toggle off other tags

                html_tkey := tkey || '>';
                ret_tmplt := regexp_replace(ret_tmplt, '<'
                                                       || html_tkey
                                                       || '(.*?)'
                                                       || '</'
                                                       || html_tkey, '');

            END IF;

        END LOOP;
        
        -- remove remaining tags and content

        ret_tmplt := regexp_replace(ret_tmplt, '<(.*?)>'
                                               || '</'
                                               || html_tkey, '');
    -- if param is 0 then toggle text on 
        html_tkey := '\w+=0' || '>';
        ret_tmplt := regexp_replace(ret_tmplt, '<' || html_tkey, '', 1, 0, 'i');

        ret_tmplt := regexp_replace(ret_tmplt, '</' || html_tkey, '', 1, 0, 'i');
    
    --if no param specified text is toggled off

        html_tkey := '\w+' || '>';
        ret_tmplt := regexp_replace(ret_tmplt, '<'
                                               || html_tkey
                                               || '(.*?)'
                                               || '</'
                                               || html_tkey, '');

    
                                                
    -- remove unattended html segments

        ret_tmplt := regexp_replace(ret_tmplt, '<[a-z0-9_\=]+>(.*?)<\/[a-z0-9_\=]+>', '*');
    
    -- remove excess space and line feeds
        ret_tmplt := regexp_replace(regexp_replace(ret_tmplt, '^[[:space:][:cntrl:]]+$', NULL, 1, 0, 'm'), chr(10)
                                                                                                           || '{2,}', chr(10));
    -- add line breaks
        ret_tmplt := regexp_replace(ret_tmplt, '<br>', chr(10));

        ret_tmplt := regexp_replace(ret_tmplt, '\\n', chr(10));
        
        ret_tmplt := regexp_replace(ret_tmplt, ';', chr(10) || chr(9));
        
    -- add tabs
        
        ret_tmplt := regexp_replace(ret_tmplt, '\\t', chr(9));
    
        
    
        RETURN ret_tmplt;
    END map_to_tmplt;

    FUNCTION get_composition_by_eid (
        eid_in INT,
        nlc_id VARCHAR2
    ) RETURN CLOB AS

        composition        CLOB; 
        compositionid_in    varchar2(100):=nlc_id;
--        compositionid_in   VARCHAR2(100) := 'neph001';
        eid_not_found EXCEPTION;
        PRAGMA exception_init ( eid_not_found, 100 );
    BEGIN
        WITH cte1 AS (
            SELECT
                eid,
                att,
                dt,
                map_to_tmplt(t0.valc, tmp.templatehtml) AS body,
                tmp.placementid
            FROM
                (
                    SELECT
                        eid,
                        dt,
                        att,
                        valc,
                        src,
                        ROW_NUMBER() OVER(
                            PARTITION BY eid, att
                            ORDER BY
                                dt DESC
                        ) AS rn
                    FROM
                        eadvx
                ) t0
                JOIN rman_rpt_templates tmp ON tmp.ruleblockid = t0.src
            WHERE
                t0.rn = 1
                AND eid = eid_in
                AND tmp.compositionid = compositionid_in
        )
        SELECT
            rtrim(XMLAGG(xmlelement(e, body, ' ').extract('//text()')
                ORDER BY
                    placementid
            ).getclobval(), ',')
        INTO composition
        FROM
            cte1
        GROUP BY
            eid;

        RETURN composition;
--    EXCEPTION
--        WHEN eid_not_found THEN
--            dbms_output.put_line('Error: eid not found');
--            RETURN '';
--        WHEN OTHERS THEN
--            commit_log('get_composition_by_eid', '', 'Error:');
--            dbms_output.put_line('FAILED:: and errors logged to rman_ruleblocks_log !');
--            RETURN '';
    END get_composition_by_eid;

    PROCEDURE build_assn_var2 (
        txtin           IN              VARCHAR2,
        delim           IN              VARCHAR2,
        left_tbl_name   IN              VARCHAR2,
        from_clause     OUT             VARCHAR2,
        avn             OUT             VARCHAR2
    ) IS

        txt              VARCHAR2(4000);
        vsi              VARCHAR2(100);
        already_joined   VARCHAR2(100) := '.';
    BEGIN
        txt := substr(txtin, instr(txtin, delim) + length(delim), length(txtin));

        from_clause := from_clause || left_tbl_name;
        vsi := vstack.first;
        WHILE vsi IS NOT NULL LOOP
            IF match_varname(txt, vsi) AND vsi IS NOT NULL AND already_joined != get_cte_name(vstack(vsi)) THEN
                from_clause := from_clause
                               || ' LEFT OUTER JOIN '
                               || get_cte_name(vstack(vsi))
                               || ' ON '
                               || get_cte_name(vstack(vsi))
                               || '.'
                               || entity_id_col
                               || '='
                               || left_tbl_name
                               || '.'
                               || entity_id_col
                               || ' ';

                already_joined := get_cte_name(vstack(vsi));
            END IF;

            vsi := vstack.next(vsi);
        END LOOP;

        avn := trim(substr(txtin, 1, instr(txtin, delim, 1, 1) - length(delim)));

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;
    END build_assn_var2;

    PROCEDURE push_vstack (
        varname          IN               VARCHAR2,
        indx             IN               INTEGER,
        calling_proc     IN               INTEGER,
        var_func         IN               VARCHAR2,
        var_func_param   IN               VARCHAR2
    ) AS
    BEGIN
        IF varname IS NOT NULL THEN
            vstack(varname) := indx;
            IF var_func IS NOT NULL THEN
                vstack_func(varname) := var_func;
            END IF;
            IF var_func_param IS NOT NULL THEN
                vstack_func_param(varname) := var_func_param;
            END IF;
        END IF;
    END push_vstack;

    PROCEDURE build_func_sql_exp (
        blockid      IN           VARCHAR2,
        indx         IN           INT,
        txtin        VARCHAR2,
        sqlstat      OUT          VARCHAR2,
        rows_added   OUT          PLS_INTEGER
    ) IS

        idx_                   NUMBER;
        func                   VARCHAR2(32);
        funcparam              PLS_INTEGER;
        funcparam_str          VARCHAR2(400);
        att                    VARCHAR2(4000);
        att0                   VARCHAR2(4000);
        att_str                VARCHAR2(256);
        tbl                    VARCHAR2(100);
        prop                   VARCHAR2(100);
        assnvar                VARCHAR2(100);
        avn                    VARCHAR2(100);
        predicate              VARCHAR2(4000);
        constparam             VARCHAR2(4000);
        left_tbl_name          VARCHAR2(100);
        ext_col_name           VARCHAR2(4000);
        equality_cmd           VARCHAR2(5) := '=';
        where_txt              VARCHAR(4000);
        from_txt               VARCHAR(2000);
        from_clause            VARCHAR(2000);
        select_txt             VARCHAR(2000);
        groupby_txt            VARCHAR(2000);
        orderby_windfunc_txt   VARCHAR2(100);
        is_sub_val             INT := 0;
        varr                   tbl_type;
        att_tbl                tbl_type;
        
        val_trans              VARCHAR2(400):=val_col;
        dt_trans               VARCHAR2(400):=dt_col;
        ude_function_undefined EXCEPTION;
    BEGIN
    
    
    -- parse txt string
        varr := rman_pckg.splitstr(trim(substr(txtin, instr(txtin, assn_op) + length(assn_op))), '.', '[', ']');

        IF varr.count = 5 THEN
            tbl := upper(varr(1));
            att := varr(2);
            prop := varr(3);
            func := upper(substr(varr(4), 1, instr(varr(4), '(', 1, 1) - 1));

--            funcparam := nvl(regexp_substr(varr(4), '\((.*)?\)', 1, 1, 'i', 1), 0);
            funcparam := nvl(regexp_substr(varr(4), '\(([0-9]+)?\)', 1, 1, 'i', 1), 0);
            funcparam_str := nvl(regexp_substr(varr(4), '\((.*)?\)', 1, 1, 'i', 1), '');
            IF upper(substr(varr(5), 1, 5)) = 'WHERE' THEN
                predicate := ' AND '
                             || regexp_substr(varr(5), '\((.*)?\)', 1, 1, 'i', 1);
            END IF;

        ELSIF varr.count = 4 THEN
            tbl := upper(varr(1));
            att := varr(2);
            prop := varr(3);
            func := upper(substr(varr(4), 1, instr(varr(4), '(', 1, 1) - 1));

--            funcparam := nvl(regexp_substr(varr(4), '\((.*)?\)', 1, 1, 'i', 1), 0);
            funcparam := nvl(regexp_substr(varr(4), '\(([0-9]+)?\)', 1, 1, 'i', 1), 0);
            funcparam_str := nvl(regexp_substr(varr(4), '\((.*)?\)', 1, 1, 'i', 1), '');
            ext_col_name := varr(2);
        ELSIF varr.count = 3 THEN
            tbl := upper(varr(1));
            att := varr(2);
            prop := varr(3);
            func := 'LAST';
            funcparam := 0;
        ELSIF varr.count = 2 THEN
            tbl := upper(varr(1));
            att := varr(2);
            prop := val_col;
            func := 'LAST';
            funcparam := 0;
        ELSIF varr.count = 1 THEN
            IF upper(substr(varr(1), 1, 5)) = 'CONST' THEN
                tbl := def_tbl_name;
                func := 'CONST';
                constparam := regexp_substr(varr(1), '\((.*)?\)', 1, 1, 'i', 1);

            ELSE
                tbl := def_tbl_name;
                att := varr(1);
                prop := val_col;
                func := 'LAST';
                funcparam := 0;
            END IF;
        END IF;
        
        att0 := att;
        att := sql_predicate(att);
        left_tbl_name := tbl;
        build_assn_var2(txtin, '=>', left_tbl_name, from_clause, avn);
        assnvar := sanitise_varname(avn);
        
        dbms_output.put_line('func_build -> '|| assnvar ||' funcparam_str:' || funcparam_str || ' funcparam:' || funcparam);
        
        IF substr(tbl, 1, 5) = 'ROUT_' AND func = 'BIND' THEN
            where_txt := '';
            from_txt := tbl;
            select_txt := entity_id_col
                          || ','
                          || ext_col_name
                          || ' AS '
                          || assnvar
                          || ' ';

            groupby_txt := '';
            insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam);

            insert_ruleblocks_dep(blockid, tbl, ext_col_name, NULL, func, assnvar);
            rows_added := 1;
            push_vstack(assnvar, indx, 2, NULL, NULL);
        ELSE
            CASE
                WHEN func IN (
                    'MAX',
                    'MIN',
                    'COUNT',
                    'SUM',
                    'AVG',
                    'MEDIAN',
                    'STATS_MODE'
                ) THEN
                    where_txt := att || predicate;
                    from_txt := from_clause;
                    select_txt := tbl
                                  || '.'
                                  || entity_id_col
                                  || ','
                                  || func
                                  || '('
                                  || prop
                                  || ') AS '
                                  || assnvar
                                  || ' ';

                    groupby_txt := tbl
                                   || '.'
                                   || entity_id_col;
                    insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                    );

                    insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar);
                    rows_added := 1;
                    push_vstack(assnvar, indx, 2, func, TO_CHAR(funcparam));
                WHEN func = 'LAST' OR func = 'FIRST' OR func = 'EXISTS' THEN
                    DECLARE
                        rankindx        NUMBER;
                        sortdirection   NVARCHAR2(4) := 'DESC';
                        ctename         NVARCHAR2(20);
                    BEGIN
                        IF funcparam = 0 THEN
                            rankindx := 1;
                        ELSE
                            rankindx := funcparam + 1;
                        END IF;

                        IF func = 'FIRST' THEN
                            sortdirection := '';
                        END IF;
                        ctename := get_cte_name(indx);
                        where_txt := att || predicate;
                        from_txt := from_clause;
                        select_txt := entity_id_col
                                      || ','
                                      || prop
                                      || ',ROW_NUMBER() OVER(PARTITION BY '
                                      || entity_id_col
                                      || ' ORDER BY '
                                      || entity_id_col
                                      || ',DT '
                                      || sortdirection
                                      || ') AS rank ';

                        groupby_txt := '';
                        is_sub_val := 1;
                        insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, NULL, is_sub_val, sqlstat, func, funcparam
                        );

                        insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar);
                        where_txt := 'rank=' || rankindx;
                        from_txt := ctename;
                        IF func = 'EXISTS' THEN
                            select_txt := entity_id_col
                                          || ','
                                          || ' 1 AS '
                                          || assnvar;
                        ELSE
                            select_txt := entity_id_col
                                          || ','
                                          || prop
                                          || ' AS '
                                          || assnvar;
                        END IF;

                        groupby_txt := '';
                        is_sub_val := 0;
                        insert_rman(indx + 1, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                        );

                        rows_added := 2;
                        push_vstack(assnvar, indx + 1, 2, NULL, NULL);
                    END;
                WHEN func IN (
                    'LASTDV',
                    'FIRSTDV',
                    'MAXLDV',
                    'MAXFDV',
                    'MINLDV',
                    'MINFDV'
                ) THEN
                    DECLARE
                        rankindx   NUMBER;
                        ctename    NVARCHAR2(20);
                    BEGIN
                        CASE func
                            WHEN 'FIRSTDV' THEN
                                orderby_windfunc_txt := dt_col || ' ASC';
                            WHEN 'LASTDV' THEN
                                orderby_windfunc_txt := dt_col || ' DESC';
                            WHEN 'MAXLDV' THEN
                                orderby_windfunc_txt := val_col
                                                        || ' DESC, '
                                                        || dt_col
                                                        || ' DESC';
                            WHEN 'MAXFDV' THEN
                                orderby_windfunc_txt := val_col
                                                        || ' DESC, '
                                                        || dt_col
                                                        || ' ASC';
                            WHEN 'MINLDV' THEN
                                orderby_windfunc_txt := val_col
                                                        || ' ASC, '
                                                        || dt_col
                                                        || ' DESC';
                            WHEN 'MINFDV' THEN
                                orderby_windfunc_txt := val_col
                                                        || ' ASC, '
                                                        || dt_col
                                                        || ' ASC';
                        END CASE;

                        IF funcparam = 0 THEN
                            rankindx := 1;
                        ELSE
                            rankindx := funcparam + 1;
                        END IF;
--                IF func='FIRSTDV' THEN sortdirection:='';END IF;  

                        ctename := get_cte_name(indx);
                        where_txt := ' RANK=' || rankindx;
                        from_txt := '(SELECT '
                                    || entity_id_col
                                    || ','
                                    || val_col
                                    || ','
                                    || dt_col
                                    || ',ROW_NUMBER() OVER(PARTITION BY '
                                    || entity_id_col
                                    || ' ORDER BY '
                                    || orderby_windfunc_txt
                                    || ') AS rank '
                                    || ' FROM '
                                    || from_clause
                                    || ' WHERE '
                                    || att
                                    || predicate
                                    || ')';

                        select_txt := entity_id_col
                                      || ','
                                      || val_col
                                      || ' AS '
                                      || assnvar
                                      || '_VAL ,'
                                      || dt_col
                                      || ' AS '
                                      || assnvar
                                      || '_DT ';

                        groupby_txt := '';
                        is_sub_val := 2;
                        insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                        );

                        rows_added := 1;
                        push_vstack(assnvar || '_val', indx, 2, NULL, NULL);
                        push_vstack(assnvar || '_dt', indx, 2, NULL, NULL);
                        insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar || '_val');
                        insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar || '_dt');
                    END;
                WHEN func = 'CONST' THEN
                    DECLARE BEGIN
                        where_txt := '1=1';
                        from_txt := from_clause;
                        select_txt := entity_id_col
                                      || ','
                                      || constparam
                                      || ' AS '
                                      || assnvar
                                      || ' ';

                        groupby_txt := entity_id_col;
                        is_sub_val := 0;
                        insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                        );

                        rows_added := 1;
                        push_vstack(assnvar, indx, 2, NULL, NULL);
                    END;
                WHEN func IN (
                    'REGR_SLOPE',
                    'REGR_INTERCEPT',
                    'REGR_COUNT',
                    'REGR_R2',
                    'REGR_AVGX',
                    'REGR_AVGY',
                    'REGR_SXX',
                    'REGR_SYY',
                    'REGR_SXY'
                ) THEN
                    where_txt := att || predicate;
                    from_txt := from_clause;
                    select_txt := tbl
                                  || '.'
                                  || entity_id_col
                                  || ','
                                  || func
                                  || '('
                                  || prop
                                  || ', SYSDATE-'
                                  || dt_col
                                  || ') AS '
                                  || assnvar
                                  || ' ';

                    groupby_txt := tbl
                                   || '.'
                                   || entity_id_col;
                    insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                    );

                    insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar);
                    rows_added := 1;
                    push_vstack(assnvar, indx, 2, func, TO_CHAR(funcparam));
                WHEN func IN (
                    'SERIALIZE'
                ) THEN

                    where_txt := att || predicate;
                    from_txt := from_clause;
--                    select_txt := tbl
--                                  || '.'
--                                  || entity_id_col
--                                  || ', LISTAGG('
--                                  || prop
--                                  || ','','') WITHIN GROUP (ORDER BY DT DESC) AS '
--                                  || assnvar
--                                  || ' ';
                    select_txt := tbl
                                  || '.'
                                  || entity_id_col
                                  || ', RTRIM(XMLAGG(XMLELEMENT(e,'
                                  || prop
                                  || ','';'').EXTRACT(''//text()'') ORDER BY DT DESC).GETCLOBVAL(),'','') AS '
                                  || assnvar
                                  || ' ';

                    groupby_txt := tbl
                                   || '.'
                                   || entity_id_col;
                    insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                    );

                    insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar);
                    rows_added := 1;
                    push_vstack(assnvar, indx, 2, func, TO_CHAR(funcparam));
                    
                    WHEN func IN (
                    'SERIALIZEDV'
                ) THEN
                    IF length(funcparam_str)>0 THEN
                        val_trans:=substr(funcparam_str,1,instr(funcparam_str,'~')-1);
                        dt_trans:=substr(funcparam_str,instr(funcparam_str,'~')+1);
                        
                        dbms_output.put_line('build_func ->'|| assnvar ||' serializedv-> val_trans: ' || val_trans );
                        dbms_output.put_line('build_func ->'|| assnvar ||' serializedv-> dt_trans: ' || dt_trans );
                    END IF;
                    where_txt := att || predicate;
                    from_txt := from_clause;
                    select_txt := tbl
                                  || '.'
                                  || entity_id_col
                                  || ', LISTAGG('
                                  || val_trans
                                  || ','' '') WITHIN GROUP (ORDER BY DT DESC) AS '
                                  || assnvar
                                  || '_VAL '
                                  || ', LISTAGG('
                                  || dt_trans
                                  || ','' '') WITHIN GROUP (ORDER BY DT DESC) AS '
                                  || assnvar
                                  || '_DT ';


                    groupby_txt := tbl
                                   || '.'
                                   || entity_id_col;
                    is_sub_val := 2;
                        insert_rman(indx, where_txt, from_txt, select_txt, groupby_txt, assnvar, is_sub_val, sqlstat, func, funcparam
                        );

                        rows_added := 1;
                        push_vstack(assnvar || '_dt', indx, 2, NULL, NULL);
                        push_vstack(assnvar || '_val', indx, 2, NULL, NULL);
                        insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar || '_val');
                        insert_ruleblocks_dep(blockid, tbl, att_col, att0, func, assnvar || '_dt');
                ELSE
                    RAISE ude_function_undefined;
            END CASE;
        END IF;

    EXCEPTION
        WHEN ude_function_undefined THEN
            commit_log('build_func_sql_exp_undef', blockid, 'Error:');
            dbms_output.put_line(dbms_utility.format_error_stack);
        WHEN OTHERS THEN
            commit_log('build_func_sql_exp', blockid, 'Error:');
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;
    END build_func_sql_exp;

    PROCEDURE build_cond_sql_exp (
        blockid      IN           VARCHAR2,
        indx         PLS_INTEGER,
        txtin        IN           VARCHAR2,
        sqlstat      OUT          VARCHAR2,
        rows_added   OUT          PLS_INTEGER
    ) IS

        t1              tbl_type;
        avn             VARCHAR2(5000);
        expr            VARCHAR2(32767);
        used_vars       VARCHAR2(5000);
        left_tbl_name   VARCHAR2(100);
        expr_tbl        tbl_type;
        used_vars_tbl   tbl_type;
        expr_elem       tbl_type;
        expr_then       VARCHAR2(32767);
        expr_when       VARCHAR2(32767);
        from_clause     VARCHAR2(32767);
        op_delim        VARCHAR2(3) := '|';
        txt             VARCHAR2(32767);
        txtin2          VARCHAR2(32767);
        select_text     VARCHAR2(32767);
    BEGIN
        from_clause := '';
        select_text := 'CASE ';
    
    --split initial statement into assigned var (avn) and expr at :
    -- found form of avn() :
        left_tbl_name := get_cte_name(0);
        build_assn_var2(txtin, ':', left_tbl_name, from_clause, avn);
        txtin2 := modify_ps_on_funcparam(txtin);
        --avn:=sanitise_varname(avn);
    
    -- split at major assignment
        IF avn IS NOT NULL THEN
            expr := trim(substr(txtin2, instr(txtin2, ':') + 1));

            expr_tbl := rman_pckg.splitstr(expr, ',', '{', '}');
            
            
            --split to expression array
            FOR i IN 1..expr_tbl.count LOOP
                --check if properly formed by curly brackets
                expr := regexp_substr(expr_tbl(i), '\{([^}]+)\}', 1, 1, NULL, 1);
                

                --split minor assignment

                expr_elem := rman_pckg.splitstr(expr, '=>', '', '');
                IF expr_elem.EXISTS(2) THEN
                    IF expr_elem(1) IS NOT NULL THEN
                        expr_then := expr_elem(2);
                        expr_when := trim(expr_elem(1));
                        select_text := select_text
                                       || 'WHEN '
                                       || expr_when
                                       || ' THEN '
                                       || expr_then
                                       || ' ';

                    ELSE
                        expr_then := expr_elem(2);
                        select_text := select_text
                                       || 'ELSE '
                                       || expr_then
                                       || ' ';
                    END IF;
                END IF;

            END LOOP;

            select_text := select_text
                           || 'END AS '
                           || sanitise_varname(avn)
                           || ','
                           || left_tbl_name
                           || '.'
                           || entity_id_col
                           || ' ';

            push_vstack(avn, indx, 1, NULL, NULL);
            insert_rman(indx, '', from_clause, select_text, '', avn, 0, sqlstat, '', '');

            insert_ruleblocks_dep(blockid, NULL, NULL, NULL, NULL, avn);
            rows_added := 1;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;
    END build_cond_sql_exp;

    PROCEDURE build_compiler_exp (
        ruleblockid   IN            VARCHAR2,
        indx          IN            INT,
        txtin         VARCHAR2
    ) AS

        func_name        VARCHAR2(30);
        func_param       VARCHAR2(4000);
        func_param_tbl   tbl_type;
        param_key        VARCHAR2(100);
        param_value      VARCHAR2(4000);
        label            VARCHAR2(4000);
        rb_dep           rman_ruleblocks_dep%rowtype;
        rb               rman_ruleblocks%rowtype;
    BEGIN
        func_name := upper(regexp_substr(txtin, '(#)(\w+)(\(([^)]+)\))', 1, 1, 'i', 2));

        func_param := regexp_substr(txtin, '(\()([^)]+)', 1, 1, 'i', 2);
        param_key := lower(trim(substr(func_param, 1, instr(func_param, ',') - 1)));

        param_value := substr(func_param, instr(func_param, ',') + 1);
        CASE func_name
            WHEN 'DEFINE_ATTRIBUTE' THEN

--            rb_dep.att_label:=json_value(param_value,'$.label' RETURNING VARCHAR2);
--          not working on 12.1.0.2 as a plsql statement
                SELECT
                    JSON_VALUE(param_value, '$.label' RETURNING VARCHAR2)
                INTO
                    rb_dep
                .att_label
                FROM
                    dual;

                
                UPDATE rman_ruleblocks_dep
                SET
                    att_label = rb_dep.att_label,
                    att_meta = param_value
                WHERE
                    att_name = param_key
                    AND blockid = ruleblockid;

            WHEN 'DEFINE_RULEBLOCK' THEN
                SELECT
                    JSON_VALUE(param_value, '$.blockid' RETURNING VARCHAR2)
                INTO
                    rb
                .blockid
                FROM
                    dual;
            
--            select json_value(param_value,'$.description' RETURNING VARCHAR2) into rb.description from dual;

                SELECT
                    upper(JSON_VALUE(param_value, '$.target_table' RETURNING VARCHAR2))
                INTO
                    rb
                .target_table
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.environment' RETURNING VARCHAR2)
                INTO
                    rb
                .environment
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.rule_owner' RETURNING VARCHAR2)
                INTO
                    rb
                .rule_owner
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.is_active' RETURNING VARCHAR2)
                INTO
                    rb
                .is_active
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.def_exit_prop' RETURNING VARCHAR2)
                INTO
                    rb
                .def_exit_prop
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.def_predicate' RETURNING VARCHAR2)
                INTO
                    rb
                .def_predicate
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.exec_order' RETURNING VARCHAR2)
                INTO
                    rb
                .exec_order
                FROM
                    dual;

                SELECT
                    JSON_VALUE(param_value, '$.out_att' RETURNING VARCHAR2)
                INTO
                    rb
                .out_att
                FROM
                    dual;

                UPDATE rman_ruleblocks
                SET
                    target_table = rb.target_table,
                    environment = rb.environment,
                    rule_owner = rb.rule_owner,
                    is_active = rb.is_active,
                    def_exit_prop = rb.def_exit_prop,
                    def_predicate = rb.def_predicate,
                    exec_order = rb.exec_order,
                    out_att = rb.out_att
--                    DESCRIPTION=rb.description
                WHERE
                    blockid = ruleblockid;

            ELSE
                dbms_output.put_line('compiler in tba :');
        END CASE;

    EXCEPTION
        WHEN OTHERS THEN
            commit_log('compile_ruleblocks', ruleblockid, 'Error:');
        -- Trap bad JSON error 
            IF sqlcode = -2290 THEN
                NULL;
            ELSE
                RAISE;
            END IF;
    END;

    PROCEDURE parse_rpipe (
        sqlout OUT VARCHAR2
    ) IS

        rpipe_col        rpipe_tbl_type;
        indx             PLS_INTEGER;
        indxtmp          VARCHAR2(100);
        rows_added       PLS_INTEGER;
        statements_tbl   tbl_type;
        rs               VARCHAR2(4000);
        ss               VARCHAR2(4000);
    BEGIN
        SELECT
            ruleid,
            rulebody,
            blockid
        BULK COLLECT
        INTO rpipe_col
        FROM
            rman_rpipe
        ORDER BY
            ruleid;

        DELETE FROM rman_stack;

        indx := 1;
        vstack := vstack_empty;
    
    -- loop though each line
        FOR i IN 1..rpipe_col.count LOOP
        --split at semi colon
            rs := rpipe_col(i).rulebody;
        
        
        -- implied semi colon terminator added
            IF instr(rs, ';') = 0 THEN
                rs := rs || ';';
            END IF;

            IF instr(rs, ';') > 0 THEN
                statements_tbl := rman_pckg.splitstr(rs, ';');
            -- loop through each statement in rule line
                FOR j IN 1..statements_tbl.count LOOP
                    ss := statements_tbl(j);
                    IF length(trim(ss)) > 0 THEN
                    --aggregate declaration
                    --identified by :
                        IF instr(ss, ':') = 0 AND instr(ss, '=>') > 0 THEN
                        -- functional form
                            rows_added := 0;
                            build_func_sql_exp(rpipe_col(i).blockid, indx, ss, sqlout, rows_added);
                            indx := indx + rows_added;
                        ELSIF instr(ss, '#') = 1 THEN
                        -- Compiler directive
                            build_compiler_exp(rpipe_col(i).blockid, indx, ss);
                        ELSIF instr(ss, ':') > 0 THEN
                        -- Conditional form
                            rows_added := 0;
                            build_cond_sql_exp(rpipe_col(i).blockid, indx, ss, sqlout, rows_added);
                            indx := indx + rows_added;
                        END IF;

                    END IF;

                END LOOP;

            END IF;

        END LOOP;

        indxtmp := vstack.first;
        compile_templates;
        init_global_vstack(rpipe_col(1).blockid);
        get_composite_sql(sqlout);
        dbms_output.put_line('sqlout '
                             || rpipe_col(rpipe_col.first).blockid
                             || '->'
                             || chr(10)
                             || sqlout);

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;
    END parse_rpipe;

    PROCEDURE parse_ruleblocks (
        blockid VARCHAR2
    ) IS

        rbt                 rman_ruleblocks%rowtype;
        rbtbl               tbl_type2;
        comment_open_pos    PLS_INTEGER;
        comment_close_pos   PLS_INTEGER;
        rb                  CLOB;
        blockid_predicate   rman_ruleblocks.blockid%TYPE := blockid;
    BEGIN
        SELECT
            blockid,
            picoruleblock
        INTO
                rbt
            .blockid,
            rbt.picoruleblock
        FROM
            rman_ruleblocks
        WHERE
            blockid = blockid_predicate;

        DELETE FROM rman_rpipe;

        DELETE FROM rman_ruleblocks_dep
        WHERE
            blockid = blockid_predicate;

    --split at semicolon except when commented
        
        rbtbl := splitclob(rbt.picoruleblock, ';', comment_open_chars, comment_close_chars);
        FOR i IN 1..rbtbl.count LOOP
            rb := trim_comments(trim(rbtbl(i)));
            IF length(rb) > 0 THEN
        
--dbms_output.put_line('block '|| i || '-- ' || rb);
                INSERT INTO rman_rpipe VALUES (
                    blockid
                    || lpad(i, 5, 0),
                    rb,
                    blockid
                );

                COMMIT;
            END IF;

        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;
    END parse_ruleblocks;

    PROCEDURE exec_dsql (
        sqlstmt CLOB,
        tbl_name VARCHAR2
    ) IS

        colcount             PLS_INTEGER;
        colvalue             VARCHAR2(4000);
        tbl_desc             dbms_sql.desc_tab2;
        select_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        insert_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        status               PLS_INTEGER;
        fetched_rows         PLS_INTEGER;
        i                    PLS_INTEGER;
        typ01_val            VARCHAR2(4000);
        typ02_val            NUMBER;
        typ12_val            DATE;
        typ96_val            VARCHAR2(4);
        typ00_val            VARCHAR2(4000);
        create_tbl_sql_str   VARCHAR2(4000);
        insert_tbl_sql_str   VARCHAR2(4000);
        tbl_exists_val       PLS_INTEGER;
    BEGIN
        create_tbl_sql_str := 'CREATE TABLE '
                              || tbl_name
                              || ' (';
    
    
    --analyse query
        dbms_sql.parse(select_cursor, sqlstmt, dbms_sql.native);
        dbms_sql.describe_columns2(select_cursor, colcount, tbl_desc);
        FOR i IN 1..tbl_desc.count LOOP
--        DBMS_OUTPUT.PUT_LINE ('exec_dsql ::: COLNAME->' || tbl_desc(i).col_name || ' COLTYPE->' || tbl_desc(i).col_type || ' COL LEN->' || tbl_desc(i).col_max_len);
            CASE tbl_desc(i).col_type
                WHEN 1 THEN --varchar2
                    dbms_sql.define_column(select_cursor, i, 'a', 32);
                    create_tbl_sql_str := create_tbl_sql_str
                                          || format_column_name(tbl_desc(i).col_name)
                                          || ' VARCHAR2('
                                          || tbl_desc(i).col_max_len
                                          || ') '
                                          || chr(10);

                WHEN 2 THEN --number
                    dbms_sql.define_column(select_cursor, i, 1);
                    create_tbl_sql_str := create_tbl_sql_str
                                          || format_column_name(tbl_desc(i).col_name)
                                          || ' NUMBER '
                                          || chr(10);

                WHEN 12 THEN --date
                    dbms_sql.define_column(select_cursor, i, SYSDATE);
                    create_tbl_sql_str := create_tbl_sql_str
                                          || format_column_name(tbl_desc(i).col_name)
                                          || ' DATE '
                                          || chr(10);

                WHEN 96 THEN --char
                    dbms_sql.define_column(select_cursor, i, 'a', 32);
                    create_tbl_sql_str := create_tbl_sql_str
                                          || format_column_name(tbl_desc(i).col_name)
                                          || ' VARCHAR2('
                                          || tbl_desc(i).col_max_len
                                          || ')'
                                          || chr(10);

                ELSE
                    dbms_output.put_line('Undefined type');
            END CASE;

            IF i < tbl_desc.last THEN
                create_tbl_sql_str := create_tbl_sql_str || ',';
            ELSE
                create_tbl_sql_str := create_tbl_sql_str || ')';
            END IF;

        END LOOP;
    
    --DBMS_OUTPUT.PUT_LINE('SQL SYNTAX  -> ' || create_tbl_sql_str );
    
   
    
    
    --Create Table

        SELECT
            COUNT(*)
        INTO tbl_exists_val
        FROM
            user_tables
        WHERE
            table_name = upper(tbl_name);

        IF tbl_exists_val > 0 THEN
            EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
        END IF;
        EXECUTE IMMEDIATE create_tbl_sql_str;
    
    --Assemble insert statement
        insert_tbl_sql_str := 'INSERT INTO '
                              || tbl_name
                              || ' VALUES(';
        FOR i IN 1..tbl_desc.count LOOP
            insert_tbl_sql_str := insert_tbl_sql_str
                                  || ':'
                                  || format_bindvar_name(tbl_desc(i).col_name);

            IF i < tbl_desc.count THEN
                insert_tbl_sql_str := insert_tbl_sql_str || ', ';
            END IF;
        END LOOP;

        insert_tbl_sql_str := insert_tbl_sql_str || ')';
    
--DBMS_OUTPUT.PUT_LINE('INSERT STATEMENT ->' || CHR(10) || insert_tbl_sql_str);
        status := dbms_sql.execute(select_cursor);
    
    --Binding
        LOOP
            fetched_rows := dbms_sql.fetch_rows(select_cursor);
            EXIT WHEN fetched_rows = 0;
            i := tbl_desc.first;
            dbms_sql.parse(insert_cursor, insert_tbl_sql_str, dbms_sql.native);
            WHILE ( i IS NOT NULL ) LOOP
                CASE tbl_desc(i).col_type
                    WHEN 1 THEN --varchar2
                        dbms_sql.column_value(select_cursor, i, typ01_val);
                        dbms_sql.bind_variable(insert_cursor, ':'
                                                              || format_bindvar_name(tbl_desc(i).col_name), typ01_val);

                    WHEN 2 THEN --number
                        dbms_sql.column_value(select_cursor, i, typ02_val);
                        dbms_sql.bind_variable(insert_cursor, ':'
                                                              || format_bindvar_name(tbl_desc(i).col_name), typ02_val);

                    WHEN 12 THEN --date
                        dbms_sql.column_value(select_cursor, i, typ12_val);
                        dbms_sql.bind_variable(insert_cursor, ':'
                                                              || format_bindvar_name(tbl_desc(i).col_name), typ12_val);

                    WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor, i, typ96_val);
                        dbms_sql.bind_variable(insert_cursor, ':'
                                                              || format_bindvar_name(tbl_desc(i).col_name), typ96_val);

                    ELSE
                        dbms_output.put_line('Undefined type');
                END CASE;

                i := tbl_desc.next(i);
            END LOOP;

            status := dbms_sql.execute(insert_cursor);
        END LOOP;

        dbms_sql.close_cursor(insert_cursor);
        dbms_sql.close_cursor(select_cursor);
    END exec_dsql;

    PROCEDURE exec_dsql_dstore2 (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    ) IS

        colcount             PLS_INTEGER;
        colvalue             VARCHAR2(4000);
        tbl_desc             dbms_sql.desc_tab2;
        select_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        insert_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        status               PLS_INTEGER;
        fetched_rows         PLS_INTEGER;
        i                    PLS_INTEGER;
        typ01_val            VARCHAR2(4000);
        typ02_val            NUMBER(15, 2);
        typ12_val            DATE;
        typ96_val            VARCHAR2(4);
        typ00_val            VARCHAR2(4000);
        row_eid              NUMBER(12, 0);
        select_tbl_sql_str   VARCHAR2(32767) := sqlstmt;
        create_tbl_sql_str   VARCHAR2(4000);
        att                  VARCHAR2(100);
        dt                   VARCHAR2(30);
        insert_tbl_sql_str   CLOB;
        tbl_exists_val       PLS_INTEGER;
        src_id               VARCHAR2(32) := blockid;
    BEGIN
        IF src_id IS NULL THEN
            src_id := 'undefined';
        END IF;
    --analyse query
        IF disc_col IS NOT NULL AND predicate IS NOT NULL THEN
            select_tbl_sql_str := select_tbl_sql_str
                                  || ' WHERE '
                                  || upper(disc_col)
                                  || ' '
                                  || predicate;

        END IF;

        dbms_sql.parse(select_cursor, select_tbl_sql_str, dbms_sql.native);
        dbms_sql.describe_columns2(select_cursor, colcount, tbl_desc);
        FOR i IN 1..tbl_desc.count LOOP CASE tbl_desc(i).col_type
            WHEN 1 THEN --varchar2
                dbms_sql.define_column(select_cursor, i, 'a', 32);
            WHEN 2 THEN --number
                dbms_sql.define_column(select_cursor, i, 1);
            WHEN 12 THEN --date
                dbms_sql.define_column(select_cursor, i, SYSDATE);
            WHEN 96 THEN --char
                dbms_sql.define_column(select_cursor, i, 'a', 32);
            ELSE
                NULL;
        END CASE;
        END LOOP;

        status := dbms_sql.execute(select_cursor);
    
    --Binding
--    insert_tbl_sql_str:='BEGIN' || chr(13);
    
    --for each row loop
        LOOP
            fetched_rows := dbms_sql.fetch_rows(select_cursor);
            EXIT WHEN fetched_rows = 0;
            i := tbl_desc.first;

        

        --for each col loop
            WHILE ( i IS NOT NULL ) LOOP
                IF lower(tbl_desc(i).col_name) = 'eid' THEN
                    dbms_sql.column_value(select_cursor, i, row_eid);
                END IF;

                CASE
                    WHEN tbl_desc(i).col_type = 2 AND lower(tbl_desc(i).col_name) = lower(disc_col) THEN -- number
                        dbms_sql.column_value(select_cursor, i, typ02_val);
                        IF typ02_val IS NOT NULL THEN
                            att := format_bindvar_name(src_id
                                                       || '_'
                                                       || tbl_desc(i).col_name);

                            dt := 'TO_DATE('''
                                  || SYSDATE
                                  || ''')';
                            
                                            
--                            insert_tbl_sql_str := insert_tbl_sql_str || ' INSERT INTO ' || tbl_name || '(eid, att, dt, val) VALUES('
--                                            || TO_CHAR(row_eid) || ', ''' || att ||''','
--                                            || dt || ',' 
--                                            || TO_CHAR(typ02_val) 
--                                            || ');' || chr(13);                
                            insert_tbl_sql_str := ' INSERT INTO '
                                                  || tbl_name
                                                  || '(eid, att, dt, val) VALUES('
                                                  || TO_CHAR(row_eid)
                                                  || ', '''
                                                  || att
                                                  || ''','
                                                  || dt
                                                  || ','
                                                  || TO_CHAR(typ02_val)
                                                  || ');'
                                                  || chr(13);

                        END IF;

                    ELSE
                        NULL;
                END CASE;

                i := tbl_desc.next(i);
            END LOOP;

            dbms_sql.parse(insert_cursor, insert_tbl_sql_str, dbms_sql.native);
            status := dbms_sql.execute(insert_cursor);
        END LOOP;
    
--    insert_tbl_sql_str := insert_tbl_sql_str || 'COMMIT;END;' || chr(13);
    
    
    
--    dbms_sql.parse(insert_cursor,insert_tbl_sql_str,dbms_sql.native);
--    status:=dbms_sql.execute(insert_cursor);

        dbms_sql.close_cursor(insert_cursor);
        dbms_sql.close_cursor(select_cursor);
    END exec_dsql_dstore2;

    PROCEDURE exec_dsql_dstore_multicol (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    ) IS

        colcount             PLS_INTEGER;
        colvalue             VARCHAR2(4000);
        tbl_desc             dbms_sql.desc_tab2;
        select_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        insert_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        status               PLS_INTEGER;
        fetched_rows         PLS_INTEGER;
        i                    PLS_INTEGER;
        typ01_val            VARCHAR2(4000);
        typ02_val            NUMBER;
        typ12_val            DATE;
        typ96_val            VARCHAR2(4);
        typ00_val            VARCHAR2(4000);
        row_eid              NUMBER;
        select_tbl_sql_str   VARCHAR2(4000) := sqlstmt;
        create_tbl_sql_str   VARCHAR2(4000);
        insert_tbl_sql_str   VARCHAR2(4000);
        insert_jstr          VARCHAR2(4000);
        insert_sql_jstr      VARCHAR2(4000);
        tbl_exists_val       PLS_INTEGER;
        src_id               VARCHAR2(32) := blockid;
    BEGIN
        IF src_id IS NULL THEN
            src_id := 'undefined';
        END IF;
    --analyse query
        IF disc_col IS NOT NULL AND predicate IS NOT NULL THEN
            select_tbl_sql_str := select_tbl_sql_str
                                  || ' WHERE '
                                  || upper(disc_col)
                                  || ' '
                                  || predicate;

        END IF;

--        dbms_output.put_line('-->' || select_tbl_sql_str);
        dbms_sql.parse(select_cursor, select_tbl_sql_str, dbms_sql.native);
    
    --dbms_sql.parse(select_cursor,sqlstmt,dbms_sql.native);
        dbms_sql.describe_columns2(select_cursor, colcount, tbl_desc);
        FOR i IN 1..tbl_desc.count LOOP CASE tbl_desc(i).col_type
            WHEN 1 THEN --varchar2
                dbms_sql.define_column(select_cursor, i, 'a', 32);
            WHEN 2 THEN --number
                dbms_sql.define_column(select_cursor, i, 1);
            WHEN 12 THEN --date
                dbms_sql.define_column(select_cursor, i, SYSDATE);
            WHEN 96 THEN --char
                dbms_sql.define_column(select_cursor, i, 'a', 32);
            ELSE
                dbms_output.put_line('Undefined type ->' || tbl_desc(i).col_type);
        END CASE;
        END LOOP;

        status := dbms_sql.execute(select_cursor);
    
    --Binding
    
    --for each row loop
        LOOP
            fetched_rows := dbms_sql.fetch_rows(select_cursor);
            EXIT WHEN fetched_rows = 0;
            i := tbl_desc.first;
            insert_jstr := '{';

        --for each col loop
            WHILE ( i IS NOT NULL ) LOOP
                IF lower(tbl_desc(i).col_name) = 'eid' THEN
                    dbms_sql.column_value(select_cursor, i, row_eid);
                END IF;

                CASE tbl_desc(i).col_type
                    WHEN 1 THEN --varchar2
                        dbms_sql.column_value(select_cursor, i, typ01_val);
                        IF typ01_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO '
                                                  || tbl_name
                                                  || '(eid, att, dt, valc,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(typ01_val)
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                            dbms_sql.parse(insert_cursor, insert_tbl_sql_str, dbms_sql.native);
                            dbms_sql.bind_variable(insert_cursor, ':eid', row_eid);
                            dbms_sql.bind_variable(insert_cursor, ':att', format_bindvar_name(tbl_desc(i).col_name));

                            dbms_sql.bind_variable(insert_cursor, ':dt', SYSDATE);
                            dbms_sql.bind_variable(insert_cursor, ':val', typ01_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 1);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                        END IF;

                    WHEN 2 THEN -- number
                        dbms_sql.column_value(select_cursor, i, typ02_val);
                        IF typ02_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO '
                                                  || tbl_name
                                                  || '(eid, att, dt, valn,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            
--                            insert_jstr:=insert_jstr || '"' || format_bindvar_name(tbl_desc(i).col_name) || '":"' || TO_CHAR(typ02_val)|| '"'; 
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(round(typ02_val, 2))
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                            dbms_sql.parse(insert_cursor, insert_tbl_sql_str, dbms_sql.native);
                            dbms_sql.bind_variable(insert_cursor, ':eid', row_eid);
                            dbms_sql.bind_variable(insert_cursor, ':att', format_bindvar_name(tbl_desc(i).col_name));

                            dbms_sql.bind_variable(insert_cursor, ':dt', SYSDATE);
                            dbms_sql.bind_variable(insert_cursor, ':val', typ02_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 2);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                        END IF;

                    WHEN 12 THEN --date
                        dbms_sql.column_value(select_cursor, i, typ12_val);
                        IF typ12_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO '
                                                  || tbl_name
                                                  || '(eid, att, dt, vald,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(typ12_val, 'DD/MM/YYYY')
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                            dbms_sql.parse(insert_cursor, insert_tbl_sql_str, dbms_sql.native);
                            dbms_sql.bind_variable(insert_cursor, ':eid', row_eid);
                            dbms_sql.bind_variable(insert_cursor, ':att', format_bindvar_name(tbl_desc(i).col_name));

                            dbms_sql.bind_variable(insert_cursor, ':dt', SYSDATE);
                            dbms_sql.bind_variable(insert_cursor, ':val', typ12_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 12);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                        END IF;

                    WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor, i, typ96_val);
                        IF typ96_val IS NOT NULL THEN
                            insert_tbl_sql_str := 'INSERT INTO '
                                                  || tbl_name
                                                  || '(eid, att, dt, valc,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(typ96_val)
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                            dbms_sql.parse(insert_cursor, insert_tbl_sql_str, dbms_sql.native);
                            dbms_sql.bind_variable(insert_cursor, ':eid', row_eid);
                            dbms_sql.bind_variable(insert_cursor, ':att', format_bindvar_name(tbl_desc(i).col_name));

                            dbms_sql.bind_variable(insert_cursor, ':dt', SYSDATE);
                            dbms_sql.bind_variable(insert_cursor, ':val', typ96_val);
                            dbms_sql.bind_variable(insert_cursor, ':typ', 96);
                            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
                        END IF;

                    ELSE
                        dbms_output.put_line('Undefined type ' || tbl_desc(i).col_type);
                END CASE;

                i := tbl_desc.next(i);
            END LOOP;

            insert_jstr := insert_jstr || '}';
            status := dbms_sql.execute(insert_cursor);
            insert_sql_jstr := 'INSERT INTO '
                               || tbl_name
                               || '(eid, att, dt, valc,typ,src) VALUES(:eid, :att, :dt, :val,:typ,:src)';
            dbms_sql.parse(insert_cursor, insert_sql_jstr, dbms_sql.native);
            dbms_sql.bind_variable(insert_cursor, ':eid', row_eid);
            dbms_sql.bind_variable(insert_cursor, ':att', 'META');
            dbms_sql.bind_variable(insert_cursor, ':dt', SYSDATE);
            dbms_sql.bind_variable(insert_cursor, ':val', insert_jstr);
            dbms_sql.bind_variable(insert_cursor, ':typ', 2);
            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
            status := dbms_sql.execute(insert_cursor);
            insert_sql_jstr := '';
            insert_jstr := '';
        END LOOP;

        dbms_sql.close_cursor(insert_cursor);
        dbms_sql.close_cursor(select_cursor);
    END exec_dsql_dstore_multicol;

    PROCEDURE exec_dsql_dstore_singlecol (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    ) IS

        colcount             PLS_INTEGER;
        colvalue             VARCHAR2(4000);
        tbl_desc             dbms_sql.desc_tab2;
        select_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        insert_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        status               PLS_INTEGER;
        fetched_rows         PLS_INTEGER;
        i                    PLS_INTEGER;
        typ01_val            VARCHAR2(4000);
        typ02_val            NUMBER;
        typ12_val            DATE;
        typ96_val            VARCHAR2(4);
        typ00_val            VARCHAR2(4000);
        typ112_val           CLOB;
        row_eid              NUMBER;
        select_tbl_sql_str   CLOB := sqlstmt;
        create_tbl_sql_str   VARCHAR2(4000);
        insert_tbl_sql_str   VARCHAR2(4000);
        insert_jstr          CLOB;
        insert_sql_jstr      VARCHAR2(4000);
        tbl_exists_val       PLS_INTEGER;
        src_id               VARCHAR2(32) := blockid;
    BEGIN
        IF src_id IS NULL THEN
            src_id := 'undefined';
        END IF;
    --analyse query
        IF disc_col IS NOT NULL AND predicate IS NOT NULL THEN
            select_tbl_sql_str := select_tbl_sql_str
                                  || ' WHERE '
                                  || upper(disc_col)
                                  || ' '
                                  || predicate;

        END IF;

        dbms_sql.parse(select_cursor, select_tbl_sql_str, dbms_sql.native);
        dbms_sql.describe_columns2(select_cursor, colcount, tbl_desc);
        FOR i IN 1..tbl_desc.count LOOP CASE tbl_desc(i).col_type
            WHEN 1 THEN --varchar2
                dbms_sql.define_column(select_cursor, i,'a',4000);
            WHEN 2 THEN --number
                dbms_sql.define_column(select_cursor, i, 1);
            WHEN 12 THEN --date
                dbms_sql.define_column(select_cursor, i, SYSDATE);
            WHEN 112 THEN --date
                dbms_sql.define_column(select_cursor, i,typ112_val);
            WHEN 96 THEN --char
                dbms_sql.define_column(select_cursor, i, 'a', 32);
            ELSE
                dbms_output.put_line('Undefined type ->' || tbl_desc(i).col_type);
        END CASE;
        END LOOP;

        status := dbms_sql.execute(select_cursor);
    
    --Binding
    
    --for each row loop
        LOOP
            fetched_rows := dbms_sql.fetch_rows(select_cursor);
            EXIT WHEN fetched_rows = 0;
            i := tbl_desc.first;
            insert_jstr := '{';

        --for each col loop
            WHILE ( i IS NOT NULL ) LOOP
                IF lower(tbl_desc(i).col_name) = 'eid' THEN
                    dbms_sql.column_value(select_cursor, i, row_eid);
                END IF;

                CASE tbl_desc(i).col_type
                    WHEN 1 THEN --varchar2
                        dbms_sql.column_value(select_cursor, i, typ01_val);
                        IF typ01_val IS NOT NULL THEN
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(typ01_val)
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                        END IF;

                    WHEN 2 THEN -- number
                        dbms_sql.column_value(select_cursor, i, typ02_val);
                        IF typ02_val IS NOT NULL THEN
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(round(typ02_val, 2))
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                        END IF;

                    WHEN 12 THEN --date
                        dbms_sql.column_value(select_cursor, i, typ12_val);
                        IF typ12_val IS NOT NULL THEN
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(typ12_val, 'DD/MM/YYYY')
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                            

--                                
                        END IF;
                    WHEN 112 THEN --clob
                        dbms_sql.column_value(select_cursor, i, typ112_val);
                        IF typ112_val IS NOT NULL THEN
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || translate(dbms_lob.substr(typ112_val,3500,1),',',' ')
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                        END IF;
                    WHEN 96 THEN --char
                        dbms_sql.column_value(select_cursor, i, typ96_val);
                        IF typ96_val IS NOT NULL THEN
                            insert_jstr := insert_jstr
                                           || '"'
                                           || format_bindvar_name(tbl_desc(i).col_name)
                                           || '":"'
                                           || TO_CHAR(typ96_val)
                                           || '"';

                            IF i < tbl_desc.count THEN
                                insert_jstr := insert_jstr || ',';
                            END IF;
                        END IF;

                    ELSE
                        dbms_output.put_line('Undefined type ' || tbl_desc(i).col_type);
                END CASE;

                i := tbl_desc.next(i);
            END LOOP;

            insert_jstr := insert_jstr || '}';
            insert_sql_jstr := 'INSERT /*+ ignore_row_on_dupkey_index(eadvx,EADVX_UC) */ INTO '
                               || tbl_name
                               || '(eid, att, dt, valc,typ,src,evhash) VALUES(:eid, :att, :dt, :val,:typ,:src,:evhash)';
            dbms_sql.parse(insert_cursor, insert_sql_jstr, dbms_sql.native);
            dbms_sql.bind_variable(insert_cursor, ':eid', row_eid);
            dbms_sql.bind_variable(insert_cursor, ':att', disc_col);
            dbms_sql.bind_variable(insert_cursor, ':dt', SYSDATE);
            dbms_sql.bind_variable(insert_cursor, ':val', insert_jstr);
            dbms_sql.bind_variable(insert_cursor, ':typ', 2);
            dbms_sql.bind_variable(insert_cursor, ':src', src_id);
            dbms_sql.bind_variable(insert_cursor, ':evhash', get_hash(insert_jstr));
            status := dbms_sql.execute(insert_cursor);
            insert_sql_jstr := '';
            insert_jstr := '';
        END LOOP;

        dbms_sql.close_cursor(insert_cursor);
        dbms_sql.close_cursor(select_cursor);
    END exec_dsql_dstore_singlecol;

    PROCEDURE check_sql_syntax (
        blockid     VARCHAR2,
        sqlstmt     CLOB,
        tbl_name    VARCHAR2,
        disc_col    VARCHAR2,
        predicate   VARCHAR2
    ) IS

        select_cursor        PLS_INTEGER := dbms_sql.open_cursor;
        select_tbl_sql_str   CLOB := sqlstmt;
        tbl_exists_val       PLS_INTEGER;
        src_id               VARCHAR2(32) := blockid;
    BEGIN
        IF src_id IS NULL THEN
            src_id := 'undefined';
        END IF;
    --analyse query
        IF disc_col IS NOT NULL AND predicate IS NOT NULL THEN
            select_tbl_sql_str := select_tbl_sql_str
                                  || ' WHERE '
                                  || upper(disc_col)
                                  || ' '
                                  || predicate;

        END IF;

        dbms_output.put_line('Checking syntax -->' || src_id);
        EXECUTE IMMEDIATE 'alter session set cursor_sharing=force';
        dbms_sql.parse(select_cursor, select_tbl_sql_str, dbms_sql.native);
        EXECUTE IMMEDIATE 'alter session set cursor_sharing=exact';
        dbms_sql.close_cursor(select_cursor);
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('SQL syntax error -->' || src_id);
            EXECUTE IMMEDIATE 'alter session set cursor_sharing=exact';
            dbms_sql.close_cursor(select_cursor);
            RAISE;
    END check_sql_syntax;

    PROCEDURE exec_ndsql (
        sqlstmt CLOB,
        tbl_name VARCHAR2
    ) IS
        status               PLS_INTEGER;
        create_tbl_sql_str   CLOB;
        tbl_exists_val       PLS_INTEGER;
    BEGIN
        create_tbl_sql_str := 'CREATE TABLE '
                              || tbl_name
                              || ' AS '
                              || sqlstmt;
        
    --DROP CREATE Table
        SELECT
            COUNT(*)
        INTO tbl_exists_val
        FROM
            user_tables
        WHERE
            table_name = upper(tbl_name);

        IF tbl_exists_val > 0 THEN
            EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
        END IF;
        EXECUTE IMMEDIATE create_tbl_sql_str;
        COMMIT;
        tstack.extend;
        tstack(tstack.count) := tbl_name;
    END exec_ndsql;

    PROCEDURE init_global_vstack (
        bid_in IN VARCHAR2
    ) AS
        out_att_s rman_ruleblocks.out_att%TYPE;
    BEGIN
        SELECT
            out_att
        INTO out_att_s
        FROM
            rman_ruleblocks
        WHERE
            blockid = bid_in;

        global_vstack_selected := global_vstack_selected_empty;
        IF length(trim(out_att_s)) > 0 THEN
            global_vstack_selected := splitstr(out_att_s, ',');


        END IF;

    END init_global_vstack;

    PROCEDURE compile_ruleblock (
        bid_in IN VARCHAR2,
        return_code OUT PLS_INTEGER
    ) IS

        strsql   CLOB;
        t0       INTEGER := dbms_utility.get_time;
        rb       rman_ruleblocks%rowtype;
        bid      rman_ruleblocks.blockid%TYPE;
    BEGIN
        commit_log('Compile ruleblock', bid_in, 'compiling');
        DELETE FROM rman_rpipe;

        DELETE FROM rman_stack;

        COMMIT;
        vstack := vstack_empty;
        global_vstack_selected := global_vstack_selected_empty;
        SELECT
            *
        INTO rb
        FROM
            rman_ruleblocks
        WHERE
            blockid = bid_in;
      -- process out_att if specified

--        
--        IF length(trim(rb.out_att)) > 0 THEN
--            global_vstack_selected := splitstr(rb.out_att, ',');
--            FOR i IN 1..global_vstack_selected.count LOOP dbms_output.put_line('* GVS *-> ' || global_vstack_selected(i));
--            END LOOP;
--
--        END IF;

        parse_ruleblocks(bid_in);
        parse_rpipe(strsql);
        UPDATE rman_ruleblocks
        SET
            sqlblock = strsql
        WHERE
            blockid = bid_in;

--        check_sql_syntax(rb.blockid,rb.sqlblock,rb.target_table,rb.def_exit_prop,rb.def_predicate);

        commit_log('Compile ruleblock', bid_in, 'compiled to sql');
        return_code:=0;
    EXCEPTION
        WHEN OTHERS THEN
            commit_log('compile_ruleblocks', bid_in, 'Error:');
            commit_log('compile_ruleblocks', bid_in, 'FAILED');
            dbms_output.put_line('FAILED::'
                                 || bid
                                 || ' and errors logged to rman_ruleblocks_log !');
            return_code:=1;
    END compile_ruleblock;

    PROCEDURE compile_ruleblock_ext (
        bid_in        IN            VARCHAR2,
        out_att_str   IN            VARCHAR2,
        sqlstmt       OUT           CLOB
    ) IS
        
        strsql   CLOB;
        t0       INTEGER := dbms_utility.get_time;
        rb       rman_ruleblocks%rowtype;
        bid      rman_ruleblocks.blockid%TYPE;
    BEGIN
        commit_log('Compile ruleblock ext', bid_in, 'compiling');
        DELETE FROM rman_rpipe;

        DELETE FROM rman_stack;

        COMMIT;
        vstack := vstack_empty;
        global_vstack_selected := global_vstack_selected_empty;
        SELECT
            *
        INTO rb
        FROM
            rman_ruleblocks
        WHERE
            blockid = bid_in;
      -- process out_att if specified

        IF length(trim(out_att_str)) > 0 THEN
            global_vstack_selected := splitstr(out_att_str, ',');
        ELSIF length(trim(rb.out_att)) > 0 THEN
            global_vstack_selected := splitstr(rb.out_att, ',');
--            FOR i IN 1..global_vstack_selected.count LOOP
--                dbms_output.put_line('**-> ' || global_vstack_selected(i) );
--            END LOOP;
        END IF;

        parse_ruleblocks(bid_in);
        parse_rpipe(strsql);
        sqlstmt := strsql;
        
--        
--        
--        UPDATE rman_ruleblocks
--        SET
--            sqlblock = strsql
--        WHERE
--            blockid = bid_in;

--        check_sql_syntax(rb.blockid,rb.sqlblock,rb.target_table,rb.def_exit_prop,rb.def_predicate);
        commit_log('Compile ruleblock ext', bid_in, 'compiled to sql');
    EXCEPTION
        WHEN OTHERS THEN
            commit_log('compile_ruleblocks ext', bid_in, 'Error:');
            commit_log('compile_ruleblocks ext', bid_in, 'FAILED');
            dbms_output.put_line('FAILED::'
                                 || bid
                                 || ' and errors logged to rman_ruleblocks_log !');
    END compile_ruleblock_ext;

    PROCEDURE compile_active_ruleblocks IS
        rbs   rman_ruleblocks_type;
        bid   VARCHAR2(100);
        compile_return_code PLS_INTEGER;
    BEGIN
        commit_log('compile_active_ruleblocks', '', 'Started');
        DELETE FROM rman_ruleblocks_dep;

        COMMIT;
        SELECT
            *
        BULK COLLECT
        INTO rbs
        FROM
            rman_ruleblocks;

        IF rbs.count > 0 THEN
            commit_log('compile_active_ruleblocks', '', rbs.count || ' Ruleblocks added to stack');
            FOR i IN rbs.first..rbs.last LOOP
                bid := rbs(i).blockid;
                compile_ruleblock(bid,compile_return_code);
                dbms_output.put_line('rb: ' || bid);
            END LOOP;

        ELSE
            commit_log('compile_active_ruleblocks', '', 'Exiting with NULL Ruleblocks');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            RAISE;
    END compile_active_ruleblocks;

    PROCEDURE execute_ruleblock (
        bid_in              IN                  VARCHAR2,
        create_wide_tbl     IN                  PLS_INTEGER,
        push_to_long_tbl    IN                  PLS_INTEGER,
        push_to_long_tbl2   IN                  PLS_INTEGER,
        recompile           IN                  PLS_INTEGER,
        return_code OUT pls_integer
    ) IS
        compile_return_code PLS_INTEGER;
        strsql   CLOB;
        t0       INTEGER := dbms_utility.get_time;
        rb       rman_ruleblocks%rowtype;
        bid      rman_ruleblocks.blockid%TYPE;
    BEGIN
        IF recompile = 1 THEN
            compile_ruleblock(bid_in,compile_return_code);
        END IF;
        SELECT
            *
        INTO rb
        FROM
            rman_ruleblocks
        WHERE
            blockid = bid_in;

        commit_log('Execute ruleblock', rb.blockid, 'initialised');
        IF create_wide_tbl = 1 THEN
            commit_log('Execute ruleblock', rb.blockid, 'exec_ndsql');
            exec_ndsql(rb.sqlblock, rb.target_table);
        END IF;

        COMMIT;
        IF push_to_long_tbl = 1 THEN
            commit_log('Execute ruleblock', rb.blockid, 'exec_dsql_dstore');
            exec_dsql_dstore_singlecol(rb.blockid, 'SELECT * FROM ' || rb.target_table, 'eadvx', rb.def_exit_prop, rb.def_predicate
            );

        END IF;

        COMMIT;
    
    -- Needs more work, do not use
--    IF push_to_long_tbl2=1 THEN  
--        commit_log('Execute ruleblock',rb.blockid,'exec_dsql_dstore2');
--        rman_pckg.exec_dsql_dstore2(rb.blockid,rb.sqlblock,'eadv2', rb.def_exit_prop,rb.def_predicate) ;
--    END IF;
        COMMIT;
        commit_log('Execute ruleblock', rb.blockid, 'Succeded');
        return_code:=0;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(dbms_utility.format_error_stack);
            return_code:=1;
            RAISE;
    END execute_ruleblock;

    PROCEDURE execute_active_ruleblocks IS
        rbs   rman_ruleblocks_type;
        bid   VARCHAR2(100);
        execute_return_code pls_integer;
    BEGIN
        tstack := tstack_empty;
        commit_log('execute_active_ruleblocks', '', 'Started');
        compile_active_ruleblocks;
        COMMIT;
        SELECT
            *
        BULK COLLECT
        INTO rbs
        FROM
            rman_ruleblocks
        WHERE
            is_active = 2
        ORDER BY
            exec_order;

        IF rbs.count > 0 THEN
            commit_log('execute_active_ruleblocks', '', rbs.count || ' Ruleblocks added to stack');
            FOR i IN rbs.first..rbs.last LOOP
                BEGIN
                    bid := rbs(i).blockid;
                    execute_ruleblock(bid, 1, 1, 0, 0,execute_return_code);
                    dbms_output.put_line('rb: ' || bid);
                    EXCEPTION
                    WHEN OTHERS THEN
                        commit_log('execute_active_ruleblocks', bid, 'Error:');
                        commit_log('execute_active_ruleblocks', bid, 'FAILED');
                        dbms_output.put_line('FAILED::'
                                             || bid
                                             || ' and errors logged to rman_ruleblocks_log !');
                END;
            END LOOP;

--            drop_rout_tables;
        ELSE
            commit_log('execute_active_ruleblocks', '', 'Exiting with NULL Ruleblocks');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            commit_log('execute_active_ruleblocks', bid, 'Error:');
            commit_log('execute_active_ruleblocks', bid, 'FAILED');
            dbms_output.put_line('FAILED::'
                                 || bid
                                 || ' and errors logged to rman_ruleblocks_log !');
    END execute_active_ruleblocks;

    PROCEDURE drop_rout_tables IS
        status           PLS_INTEGER;
        tbl_exists_val   PLS_INTEGER;
    BEGIN
        FOR i IN tstack.first..tstack.last LOOP
            dbms_output.put_line('ROUT TABLE->' || tstack(i));
            
             --DROP CREATE Table
            SELECT
                COUNT(*)
            INTO tbl_exists_val
            FROM
                user_tables
            WHERE
                table_name = upper(tstack(i));

            IF tbl_exists_val > 0 THEN
                EXECUTE IMMEDIATE 'DROP TABLE ' || tstack(i);
            END IF;
        END LOOP;
    END drop_rout_tables;

    PROCEDURE commit_log (
        moduleid   IN         VARCHAR2,
        blockid    IN         VARCHAR2,
        log_msg    IN         VARCHAR2
    ) IS
        msg VARCHAR2(100) := log_msg;
        PRAGMA autonomous_transaction;
    BEGIN
        IF msg = 'Error:' THEN
            msg := substr(msg || dbms_utility.format_error_stack, 1, 99);
        END IF;

        INSERT INTO rman_ruleblocks_log (
            moduleid,
            blockid,
            log_msg,
            log_time
        ) VALUES (
            moduleid,
            blockid,
            msg,
            current_timestamp
        );

        COMMIT;
    END commit_log;

    PROCEDURE dependency_walker (
        rb_in_str    IN           VARCHAR2,
        dep_rb_str   OUT          VARCHAR2
    ) AS

        TYPE blockid_tbl_t IS
            TABLE OF rman_ruleblocks.blockid%TYPE;
        TYPE exec_order_tbl_t IS
            TABLE OF rman_ruleblocks.exec_order%TYPE;
        TYPE uq_blockid_tbl_t IS
            TABLE OF INTEGER(1) INDEX BY VARCHAR2(100);
        uq_blockid_tbl         uq_blockid_tbl_t;
        uq_blockid_tbl_empty   uq_blockid_tbl_t;
        pre_str                VARCHAR2(4000);
        post_str               VARCHAR2(4000);
        rb_out_str             VARCHAR2(4000);

        PROCEDURE get_dep_blockids (
            bid_in VARCHAR2
        ) AS
            tmp_str          VARCHAR2(100);
            blockid_tbl      blockid_tbl_t;
            exec_order_tbl   exec_order_tbl_t;
        BEGIN
            SELECT
                r.blockid,
                r.exec_order
            BULK COLLECT
            INTO
                blockid_tbl,
                exec_order_tbl
            FROM
                rman_ruleblocks_dep   d
                JOIN rman_ruleblocks       r ON r.target_table = d.dep_table
            WHERE
                d.blockid = bid_in
                AND nvl(d.dep_table, '') <> 'EADV';

            FOR i IN 1..blockid_tbl.count LOOP uq_blockid_tbl(blockid_tbl(i)) := exec_order_tbl(i);
            END LOOP;

        END get_dep_blockids;

        FUNCTION serialize_stack RETURN VARCHAR2 AS
            idx   VARCHAR2(100);
            ret   VARCHAR2(4000) := '';
        BEGIN
            idx := uq_blockid_tbl.first;
            WHILE ( idx IS NOT NULL ) LOOP
                ret := ret
                       || ','
                       || idx;
                idx := uq_blockid_tbl.next(idx);
            END LOOP;

            ret := trim(BOTH ',' FROM ret);
            RETURN ret;
        END serialize_stack;

        PROCEDURE process_stack AS
            idx VARCHAR2(100);
        BEGIN
            idx := uq_blockid_tbl.first;
            WHILE ( idx IS NOT NULL ) LOOP
                get_dep_blockids(idx);
                idx := uq_blockid_tbl.next(idx);
            END LOOP;

        END process_stack;

        PROCEDURE fetch_rb (
            rb_in_tbl        IN               tbl_type,
            blockid_tbl      OUT              blockid_tbl_t,
            exec_order_tbl   OUT              exec_order_tbl_t
        ) AS
        BEGIN
            SELECT
                r.blockid,
                r.exec_order
            BULK COLLECT
            INTO
                blockid_tbl,
                exec_order_tbl
            FROM
                rman_ruleblocks r
            WHERE
                r.blockid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( rb_in_tbl )
                )
            ORDER BY
                r.exec_order;

        END fetch_rb;

        PROCEDURE init_stack (
            rb_in_str    IN           VARCHAR2,
            rb_out_str   OUT          VARCHAR2
        ) AS
            blockid_tbl      blockid_tbl_t;
            exec_order_tbl   exec_order_tbl_t;
            rb_in_tbl        tbl_type;
            rb_fetch_tbl     tbl_type := tbl_type();
        BEGIN
            rb_in_tbl := rman_pckg.splitstr(rb_in_str, ',');
            FOR i IN 1..rb_in_tbl.count LOOP IF rb_in_tbl(i) IS NOT NULL THEN
                rb_fetch_tbl.extend(1);
                rb_fetch_tbl(i) := rb_in_tbl(i);
            END IF;
            END LOOP;

            IF rb_fetch_tbl.count > 0 THEN
                fetch_rb(rb_fetch_tbl, blockid_tbl, exec_order_tbl);
                uq_blockid_tbl := uq_blockid_tbl_empty;
                FOR i IN 1..blockid_tbl.count LOOP
                    uq_blockid_tbl(blockid_tbl(i)) := exec_order_tbl(i);
                    rb_out_str := rb_out_str
                                  || ','
                                  || blockid_tbl(i);
                END LOOP;

                rb_out_str := trim(BOTH ',' FROM rb_out_str);
            END IF;

        END init_stack;

    BEGIN
        init_stack(rb_in_str, rb_out_str);
        LOOP
            pre_str := serialize_stack;
            process_stack;
            post_str := serialize_stack;
            IF pre_str IS NULL OR ( pre_str = post_str ) THEN
                EXIT;
            END IF;
        END LOOP;

        init_stack(post_str, rb_out_str);
        dep_rb_str := rb_out_str;
    END dependency_walker;

    PROCEDURE get_min_dep_att_str (
        rb                IN                VARCHAR2,
        rb_add_tbl        IN                tbl_type,
        min_dep_att_str   OUT               VARCHAR2
    ) AS
    BEGIN
        WITH t1 AS (
            SELECT
                d.blockid,
                att_name AS att
            FROM
                rman_ruleblocks_dep d
            WHERE
                d.dep_exists = 1
                OR d.blockid
                   || '.'
                   || d.att_name IN (
                    SELECT
                        *
                    FROM
                        TABLE ( rb_add_tbl )
                )
            UNION
            SELECT
                r.blockid,
                r.def_exit_prop AS att
            FROM
                rman_ruleblocks r
        )
        SELECT
            LISTAGG(att, ',') WITHIN GROUP(
                ORDER BY
                    t1.blockid
            )
        INTO min_dep_att_str
        FROM
            t1
        WHERE
            t1.blockid = rb
        GROUP BY
            t1.blockid;

    END get_min_dep_att_str;

    PROCEDURE gen_cube_from_ruleblock (
        rb_att_str     IN             VARCHAR2,
        slices_str     IN             VARCHAR2,
        ret_tbl_name   IN             VARCHAR2
    ) AS

        slice_tbl        tbl_type;
        obj_tbl          tbl_type;
        ruleblock_tbl    tbl_type := tbl_type();
        rb_att_str_tbl   tbl_type := tbl_type();
        att_init_tbl     tbl_type := tbl_type();
        col_stack        vstack_type;
        mock_mode        BOOLEAN := false;

        FUNCTION get_object_name (
            prefix        VARCHAR2,
            ruleblockid   VARCHAR2,
            slice         VARCHAR2
        ) RETURN VARCHAR2 AS
        BEGIN
            RETURN prefix
                   || '_'
                   || substr(ruleblockid, 1, 15)
                   || '_'
                   || slice;
        END get_object_name;

        FUNCTION get_sql_stmt_from_ruleblock (
            ruleblockid VARCHAR2
        ) RETURN VARCHAR2 AS
            sql_stmt VARCHAR2(32767) := '';
            compile_return_code pls_integer;
        BEGIN
            compile_ruleblock(ruleblockid,compile_return_code);
            SELECT
                sqlblock
            INTO sql_stmt
            FROM
                rman_ruleblocks
            WHERE
                blockid = ruleblockid;

            RETURN sql_stmt;
        END get_sql_stmt_from_ruleblock;

        FUNCTION get_target_tbl_from_ruleblock (
            ruleblockid VARCHAR2
        ) RETURN VARCHAR2 AS
            ret VARCHAR2(128) := '';
        BEGIN
            SELECT
                target_table
            INTO ret
            FROM
                rman_ruleblocks
            WHERE
                blockid = ruleblockid;

            RETURN ret;
        END get_target_tbl_from_ruleblock;

        PROCEDURE get_slices (
            slices_str VARCHAR2
        ) AS
        BEGIN
            slice_tbl := rman_pckg.splitstr(slices_str, ',');
        END get_slices;

        PROCEDURE create_temp_eadv_views AS
            vw_name      VARCHAR2(30);
            obj_exists   BINARY_INTEGER;
        BEGIN
            FOR i IN 1..slice_tbl.count LOOP
                vw_name := get_object_name('vw', 'eadv', slice_tbl(i));
                SELECT
                    COUNT(*)
                INTO obj_exists
                FROM
                    user_views
                WHERE
                    upper(view_name) = upper(vw_name);

                IF obj_exists > 0 THEN
                    IF mock_mode = false THEN
                        EXECUTE IMMEDIATE 'DROP VIEW ' || vw_name;
                    END IF;
                    dbms_output.put_line('create_view-> dropping view ' || vw_name);
                END IF;

                IF mock_mode = false THEN
                    EXECUTE IMMEDIATE 'CREATE VIEW '
                                      || vw_name
                                      || ' AS ('
                                      || 'SELECT * FROM EADV WHERE DT<TO_DATE('''
                                      || slice_tbl(i)
                                      || ''',''ddmmyyyy''))';
                END IF;

            END LOOP;
        END create_temp_eadv_views;

        FUNCTION modify_dep_tbls (
            sql_in        CLOB,
            ruleblockid   VARCHAR2,
            slice         VARCHAR2
        ) RETURN CLOB AS
            dep_tbls   tbl_type := NULL;
            ret        CLOB := sql_in;
            tbl_name   VARCHAR2(30);
        BEGIN
            SELECT
                dep_table
            BULK COLLECT
            INTO dep_tbls
            FROM
                rman_ruleblocks_dep
            WHERE
                dep_table != 'EADV'
                AND blockid = ruleblockid;

            FOR i IN 1..dep_tbls.count LOOP
                tbl_name := replace(get_object_name('rt', dep_tbls(i), slice), 'ROUT_', '');

                ret := replace(ret, dep_tbls(i), tbl_name);
            END LOOP;

            RETURN ret;
        END modify_dep_tbls;

        PROCEDURE cube_in_rbstack AS

            rb_att_str_in   VARCHAR2(4000);
            rb_att_tbl      tbl_type;
            rb_full_tbl     tbl_type;
            rb_str          VARCHAR2(4000);
            rb_str2         VARCHAR2(4000);
            sql_stmt        CLOB;
            tbl_name        VARCHAR2(30);
            vw_name         VARCHAR2(30);
            sql_stmt_mod    CLOB;
            obj_exists      BINARY_INTEGER;
        BEGIN
            rb_att_str_in := regexp_substr(regexp_replace(rb_att_str, '\s', ''), '[a-z0-9_.,]+');
            dbms_output.put_line('phase 0->'
                                 || replace(rb_att_str_in, ' ', '.'));
            rb_att_tbl := rman_pckg.splitstr(rb_att_str_in, ',');
            FOR i IN 1..rb_att_tbl.count LOOP
                rb_str := rb_str
                          || ','
                          || trim(substr(rb_att_tbl(i), 1, instr(rb_att_tbl(i), '.') - 1));

                att_init_tbl.extend(1);
                att_init_tbl(i) := trim(upper(substr(rb_att_tbl(i), instr(rb_att_tbl(i), '.') + 1)));

            END LOOP;

            rb_str := trim(LEADING ',' FROM rb_str);
            dbms_output.put_line('pass 1 -> ' || rb_str);
            dependency_walker(rb_str, rb_str2);
            dbms_output.put_line('pass 2 -> ' || rb_str2);
            rb_full_tbl := rman_pckg.splitstr(rb_str2, ',');
            FOR j IN 1..rb_full_tbl.count LOOP
                get_min_dep_att_str(rb_full_tbl(j), rb_att_tbl, rb_str);
                dbms_output.put_line('pass 3 -> '
                                     || '('
                                     || j
                                     || ') -> '
                                     || rb_full_tbl(j)
                                     || ' -> '
                                     || rb_str);

                ruleblock_tbl.extend(1);
                ruleblock_tbl(j) := rb_full_tbl(j);
                rb_att_str_tbl.extend(1);
                rb_att_str_tbl(j) := rb_str;
                dbms_output.put_line('********** ->' || rb_str);
            END LOOP;

        END cube_in_rbstack;

        PROCEDURE execute_ndsql_temp_tbls AS

            tbl_name       VARCHAR2(30);
            vw_name        VARCHAR2(30);
            sql_stmt       CLOB;
            sql_stmt_mod   CLOB;
            obj_exists     BINARY_INTEGER;
        BEGIN
            FOR j IN 1..ruleblock_tbl.count LOOP
                dbms_output.put_line('ruleblock_tbl(j)->' || ruleblock_tbl(j));
                compile_ruleblock_ext(ruleblock_tbl(j), rb_att_str_tbl(j), sql_stmt);
                dbms_output.put_line('sql_stmt->' || sql_stmt);
                FOR i IN 1..slice_tbl.count LOOP
                    tbl_name := get_object_name('rt', ruleblock_tbl(j), slice_tbl(i));
                    SELECT
                        COUNT(*)
                    INTO obj_exists
                    FROM
                        user_tables
                    WHERE
                        upper(table_name) = upper(tbl_name);

                    IF obj_exists > 0 THEN
                        IF mock_mode = false THEN
                            EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
                        END IF;
                        dbms_output.put_line('create_tbl-> dropping tbl ' || tbl_name);
                    END IF;

                    vw_name := get_object_name('vw', 'eadv', slice_tbl(i));
                    dbms_output.put_line(i
                                         || '->'
                                         || vw_name);
                    sql_stmt_mod := replace(sql_stmt, 'EADV', upper(vw_name));
                    
                    
                    
                    sql_stmt_mod := replace(sql_stmt_mod, 'sysdate', 'to_date(''' || slice_tbl(i) || ''',''ddmmyyyy'')');
--                    dbms_output.put_line('GEN CUBE sysdate replace ->' || 'to_date(''' || slice_tbl(i) || ''',''ddmmyyyy'')');
                    
                    sql_stmt_mod := modify_dep_tbls(sql_stmt_mod, ruleblock_tbl(j), slice_tbl(i));
                    dbms_output.put_line(i
                                         || '->'
                                         || sql_stmt_mod);
                    IF mock_mode = false THEN
                        EXECUTE IMMEDIATE 'CREATE TABLE '
                                          || tbl_name
                                          || ' AS '
                                          || sql_stmt_mod
                                          || '';
                    END IF;

                END LOOP;

            END LOOP;
        END execute_ndsql_temp_tbls;

        PROCEDURE union_temp_tbls AS
            union_sql_stmt   CLOB := '';
            obj_exists       BINARY_INTEGER := 0;
            tbl_name         VARCHAR2(30);
        BEGIN
            FOR j IN 1..ruleblock_tbl.count LOOP
                FOR i IN 1..slice_tbl.count LOOP IF i < slice_tbl.count THEN
                    union_sql_stmt := union_sql_stmt
                                      || ' SELECT * FROM '
                                      || get_object_name('rt', ruleblock_tbl(j), slice_tbl(i))
                                      || ' UNION ';

                ELSE
                    union_sql_stmt := union_sql_stmt
                                      || ' SELECT * FROM '
                                      || get_object_name('rt', ruleblock_tbl(j), slice_tbl(i));
                END IF;
                END LOOP;

                tbl_name := get_object_name('rt_cube', ruleblock_tbl(j), '0');
                SELECT
                    COUNT(*)
                INTO obj_exists
                FROM
                    user_tables
                WHERE
                    upper(table_name) = upper(tbl_name);

                IF obj_exists > 0 THEN
                    IF mock_mode = false THEN
                        EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
                    END IF;
                    dbms_output.put_line('union -> dropping tbl '
                                         || 'DROP TABLE '
                                         || tbl_name);
                    dbms_output.put_line('union -> dropping tbl '
                                         || get_object_name('rt', ruleblock_tbl(j), '0'));

                END IF;

                dbms_output.put_line('union -> creating tbl '
                                     || 'CREATE TABLE '
                                     || tbl_name
                                     || ' AS ('
                                     || union_sql_stmt
                                     || ')');

                IF mock_mode = false THEN
                    EXECUTE IMMEDIATE 'CREATE TABLE '
                                      || tbl_name
                                      || ' AS ('
                                      || union_sql_stmt
                                      || ')';
                END IF;

                dbms_output.put_line('union -> creating tbl '
                                     || get_object_name('rt', ruleblock_tbl(j), '0'));

                union_sql_stmt := '';
            END LOOP;
        END;

        FUNCTION get_col_list (
            tmp_tbl VARCHAR2
        ) RETURN VARCHAR2 AS
            ret       VARCHAR2(4000) := '';
            col_tbl   tbl_type;
        BEGIN
            SELECT
                column_name
            BULK COLLECT
            INTO col_tbl
            FROM
                all_tab_columns
            WHERE
                table_name = upper(tmp_tbl)
                AND column_name NOT IN (
                    'EID',
                    'DIM_COL'
                )
                AND column_name IN (
                    SELECT
                        *
                    FROM
                        TABLE ( att_init_tbl )
                );

            FOR i IN 1..col_tbl.count LOOP IF col_stack.EXISTS(col_tbl(i)) = false THEN
                
                IF i < col_tbl.count THEN
                    ret := ret
                           || upper(tmp_tbl)
                           || '.'
                           || col_tbl(i)
                           || ', ';
                ELSE
                    ret := ret
                           || upper(tmp_tbl)
                           || '.'
                           || col_tbl(i)
                           || ' ';
                END IF;
                col_stack(col_tbl(i)) := i;

                
            END IF;
            END LOOP;
            
            RETURN ret;
        END get_col_list;

        PROCEDURE join_temp_tbls AS

            join_sql_stmt   CLOB := '';
            obj_exists      BINARY_INTEGER := 0;
            tbl_name        VARCHAR2(30);
            col_list_str    VARCHAR2(4000);
        BEGIN
            tbl_name := get_object_name('rt_cube', ruleblock_tbl(1), '0');
            join_sql_stmt := 'SELECT '
                             || tbl_name
                             || '.EID, '
                             || tbl_name
                             || '.DIM_COL,';
            FOR j IN 1..ruleblock_tbl.count LOOP
                tbl_name := get_object_name('rt_cube', ruleblock_tbl(j), '0');
                col_list_str := get_col_list(tbl_name);
                
                
                if col_list_str is not null then
                join_sql_stmt := join_sql_stmt || col_list_str || ',';
                end if;
                


            END LOOP;

            join_sql_stmt := trim(TRAILING ',' FROM trim(join_sql_stmt));
            join_sql_stmt := join_sql_stmt
                             || ' FROM '
                             || get_object_name('rt_cube', ruleblock_tbl(1), '0')
                             || ' ';

            IF ruleblock_tbl.count > 1 THEN
                FOR j IN 2..ruleblock_tbl.count LOOP
                    tbl_name := get_object_name('rt_cube', ruleblock_tbl(j), '0');
                    join_sql_stmt := join_sql_stmt
                                     || ' INNER JOIN '
                                     || tbl_name
                                     || ' ON '
                                     || tbl_name
                                     || '.EID='
                                     || get_object_name('rt_cube', ruleblock_tbl(1), '0')
                                     || '.EID '
                                     || ' AND '
                                     || tbl_name
                                     || '.DIM_COL='
                                     || get_object_name('rt_cube', ruleblock_tbl(1), '0')
                                     || '.DIM_COL ';

                END LOOP;
            END IF;

            tbl_name := ret_tbl_name;
            SELECT
                COUNT(*)
            INTO obj_exists
            FROM
                user_tables
            WHERE
                upper(table_name) = upper(tbl_name);

            IF obj_exists > 0 THEN
                IF mock_mode = false THEN
                    EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
                END IF;
            END IF;

            dbms_output.put_line('join-> creating '
                                 || 'CREATE TABLE '
                                 || tbl_name
                                 || ' AS ('
                                 || join_sql_stmt
                                 || ')');

            IF mock_mode = false THEN
                EXECUTE IMMEDIATE 'CREATE TABLE '
                                  || tbl_name
                                  || ' AS ('
                                  || join_sql_stmt
                                  || ')';
            END IF;

            dbms_output.put_line('join-> creating ' || tbl_name);
        END;

        PROCEDURE cleanup_objects AS
            tbl_name     VARCHAR2(30);
            vw_name      VARCHAR2(30);
            obj_exists   BINARY_INTEGER := 0;
        BEGIN
            FOR j IN 1..ruleblock_tbl.count LOOP
                FOR i IN 1..slice_tbl.count LOOP
                    tbl_name := get_object_name('rt', ruleblock_tbl(j), slice_tbl(i));
                    SELECT
                        COUNT(*)
                    INTO obj_exists
                    FROM
                        user_tables
                    WHERE
                        upper(table_name) = upper(tbl_name);

                    IF obj_exists > 0 THEN
                        IF mock_mode = false THEN
                            EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
                        END IF;
                        dbms_output.put_line('cleanup-> dropping tbl ' || tbl_name);
                    END IF;

                    obj_exists := 0;
                    tbl_name := get_object_name('rt_cube', ruleblock_tbl(j), '0');
                    SELECT
                        COUNT(*)
                    INTO obj_exists
                    FROM
                        user_tables
                    WHERE
                        upper(table_name) = upper(tbl_name);

                    IF obj_exists > 0 THEN
                        IF mock_mode = false THEN
                            EXECUTE IMMEDIATE 'DROP TABLE ' || tbl_name;
                        END IF;
                        dbms_output.put_line('cleanup-> dropping tbl ' || tbl_name);
                    END IF;

                    obj_exists := 0;
                    vw_name := get_object_name('vw', 'eadv', slice_tbl(i));
                    SELECT
                        COUNT(*)
                    INTO obj_exists
                    FROM
                        user_views
                    WHERE
                        upper(view_name) = upper(vw_name);

                    IF obj_exists > 0 THEN
                        IF mock_mode = false THEN
                            EXECUTE IMMEDIATE 'DROP VIEW ' || vw_name;
                        END IF;
                        dbms_output.put_line('cleanup-> dropping view ' || vw_name);
                    END IF;

                END LOOP;
            END LOOP;
        END cleanup_objects;

        PROCEDURE modify_temp_tbls AS
            tbl_name     VARCHAR2(30);
            obj_exists   BINARY_INTEGER := 0;
        BEGIN
            FOR j IN 1..ruleblock_tbl.count LOOP
                FOR i IN 1..slice_tbl.count LOOP
                    tbl_name := get_object_name('rt', ruleblock_tbl(j), slice_tbl(i));
                    SELECT
                        COUNT(*)
                    INTO obj_exists
                    FROM
                        user_tables
                    WHERE
                        upper(table_name) = upper(tbl_name);

                    IF obj_exists > 0 THEN
                        IF mock_mode = false THEN
                            EXECUTE IMMEDIATE 'ALTER TABLE '
                                              || tbl_name
                                              || ' ADD DIM_COL CHAR(30) DEFAULT ''SLC'
                                              || slice_tbl(i)
                                              || ''' NOT NULL';
                        END IF;

                        dbms_output.put_line('modifying -> alter tbl tbl ' || tbl_name);
                    END IF;

                END LOOP;
            END LOOP;
        END modify_temp_tbls;

    BEGIN
        mock_mode := false;
        -- get time slices into collection
        get_slices(slices_str);
        cube_in_rbstack;
        create_temp_eadv_views;
        execute_ndsql_temp_tbls;
        modify_temp_tbls;
        union_temp_tbls;
        join_temp_tbls;
        cleanup_objects;
    END gen_cube_from_ruleblock;



/* Truncates and populates the contens of EADV, the primary data source for RMAN */

    PROCEDURE populate_eadv_tables IS
        table_exist   INT;
        schemaname    NVARCHAR2(100);
    BEGIN
        SELECT
            user
        INTO schemaname
        FROM
            dual;

    --1: Create EADV table if not exists

        SELECT
            COUNT(*)
        INTO table_exist
        FROM
            all_tables
        WHERE
            owner = schemaname
            AND table_name = 'EADV';

        commit_log('populate_eadv_tables', '', 'Create EADV table if not exisiting');
        IF table_exist = 0 THEN
            dbms_output.put_line('creating table: EADV');
            BEGIN
                EXECUTE IMMEDIATE '  CREATE TABLE "EADV" (
                "EID" NUMBER(12,0)      NOT NULL, 
                "ATT" VARCHAR2(32 BYTE) NOT NULL, 
                "DT" DATE               NOT NULL,
                "VAL" NUMBER(15,2)
           ) '
                ;

            --Developement oracle is version 10
                IF ( ora_database_name = 'XE' ) THEN
                    EXECUTE IMMEDIATE 'CREATE INDEX "EADV_ATT_IDX" ON "EADV" ("ATT")';
                    EXECUTE IMMEDIATE 'CREATE INDEX "EADV_EID_IDX" ON "EADV" ("EID")';
                ELSE
                    EXECUTE IMMEDIATE 'CREATE BITMAP INDEX "EADV_ATT_IDX" ON "EADV" ("ATT")';
                    EXECUTE IMMEDIATE 'CREATE BITMAP INDEX "EADV_EID_IDX" ON "EADV" ("EID")';
                END IF;

            END;

        END IF;

        SELECT
            COUNT(*)
        INTO table_exist
        FROM
            all_views
        WHERE
            owner = schemaname
            AND lower(view_name) = 'vw_eadv_locality';

        commit_log('populate_eadv_tables', '', 'Create Supporting Views if not exisiting');
        IF table_exist = 0 THEN
            BEGIN
                dbms_output.put_line('creating view: vw_eadv_locality');
                EXECUTE IMMEDIATE '
            CREATE VIEW vw_eadv_locality AS (
                select distinct
                        lr.linked_registrations_id as eid,   
                        ''dmg_location'' as att,
                        date_recorded as dt,
                        initcap(shcm.reference_location) as val
                FROM    patient_results_numeric prn
                JOIN    patient_registrations pr on pr.id=prn.patient_registration_id
                JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
                JOIN    system_health_centre_metadata shcm on shcm.health_centre_name=prn.location
                )'
                ;
            END;
        END IF;
    
    
    --2: Disable Indexs

        dbms_output.put_line('dropping EADV index');
        BEGIN
            EXECUTE IMMEDIATE 'DROP INDEX "EADV_ATT_IDX"';
            EXECUTE IMMEDIATE 'DROP INDEX "EADV_EID_IDX"';
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        commit_log('populate_eadv_tables', '', 'Merge patient result numeric');
    --3: truncate for repopulation
        dbms_output.put_line('truncating EADV');
        EXECUTE IMMEDIATE 'truncate table EADV';
    
    --4: Merge patient result numeric
        dbms_output.put_line('Merge patient result numeric');
        EXECUTE IMMEDIATE '    MERGE INTO eadv t1
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
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient result coded');
    --5: Insert patient result coded, icpc,icd, caresys
        dbms_output.put_line('Merge patient result coded');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient derived');
    --6: insert  Derived results
        dbms_output.put_line('Merge derived results');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
    USING (
    SELECT
        lr.linked_registrations_id as eid,
        rcm.ncomp  as att,
        date_recorded as dt,
        round(result,0) as val
    FROM
        patient_results_derived prd
    JOIN    patient_registrations pr on pr.id=prd.patient_registration_id
    JOIN    linked_registrations lr on lr.patient_registration_id=pr.id
    JOIN    rman_comp_map rcm on rcm.key=prd.derivedresultname
    WHERE   prd.derivedresultname in (''eGFR KDIGO'',''BMI'')
    ) t2
    ON (t1.eid=t2.eid and t1.att=t2.att and t1.dt=t2.dt)
    WHEN NOT MATCHED THEN
    INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient outpatient encounters');
    --7: OP encounters
        dbms_output.put_line('Merge OP encounters');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient rxclass');
    --8: RxClass
        dbms_output.put_line('Merge RxClass');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient other misc');
    --9: care plan
        dbms_output.put_line('Merge Care Plans');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
     
    
    --10: smoking status
        dbms_output.put_line('Merge Smoking Status');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
    
    --11: Urine sediment
        dbms_output.put_line('Merge Urine sediment');
        EXECUTE IMMEDIATE 'delete from eadv where att=''lab_ua_rbc''';
        EXECUTE IMMEDIATE 'delete from eadv where att=''lab_ua_leucocytes''';
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
    
    --12: Pcis service items
        dbms_output.put_line('Merge Pcis service items');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient RIS encounters');
    --13: Ris encounters
        dbms_output.put_line('Merge RIS Encounters');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient CSU actions');
    --13.5: csu actions
        dbms_output.put_line('Merge CSU actions');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)
    '
        ;
    
    --14: CVRA
        dbms_output.put_line('Merge CVRA ');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
    
    --15: Remove duplicates
        dbms_output.put_line('Remove duplicates');
        EXECUTE IMMEDIATE 'delete from eadv
    where rowid in (select rowid from
       (select
         rowid,
         row_number()  over(partition by eid,att,dt order by null) dup
        from eadv
        )
      where dup > 1
    )'
        ;
        commit_log('populate_eadv_tables', '', 'Merge patient demographics');
    --16: Expose demographics from patient_registrations as eadv
        dbms_output.put_line('Merge demographics');
        EXECUTE IMMEDIATE 'MERGE INTO eadv t1
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
        INSERT (EID,ATT,DT,VAL) VALUES (t2.eid, t2.att,t2.dt,t2.val)'
        ;
        commit_log('populate_eadv_tables', '', 'Applying Bitmap indexing and compute statistics');
    --17: Re-create indexs
        dbms_output.put_line('Recreate indexs');
        BEGIN
            IF ( ora_database_name = 'XE' ) THEN
                EXECUTE IMMEDIATE 'CREATE INDEX "EADV_ATT_IDX" ON "EADV" ("ATT")';
                EXECUTE IMMEDIATE 'CREATE INDEX "EADV_EID_IDX" ON "EADV" ("EID")';
            ELSE
                EXECUTE IMMEDIATE 'CREATE BITMAP INDEX "EADV_ATT_IDX" ON "EADV" ("ATT")';
                EXECUTE IMMEDIATE 'CREATE BITMAP INDEX "EADV_EID_IDX" ON "EADV" ("EID")';
            END IF;
        END;
     
    --18: rebuild stats

        EXECUTE IMMEDIATE 'ANALYZE TABLE EADV COMPUTE STATISTICS';
    END populate_eadv_tables;

    PROCEDURE compile_templates AS

        TYPE tp_type IS
            TABLE OF rman_rpt_templates%rowtype;
        TYPE rb_type IS
            TABLE OF rman_ruleblocks%rowtype;
        tp tp_type;

        PROCEDURE read_templates AS
        BEGIN
            SELECT
                *
            BULK COLLECT
            INTO tp
            FROM
                rman_rpt_templates;

        END;

        PROCEDURE update_dependent_att AS
            rbt rb_type;
        BEGIN
            UPDATE rman_ruleblocks_dep
            SET
                dep_exists = 1
            WHERE
                EXISTS (
                    SELECT
                        NULL
                    FROM
                        (
                            SELECT
                                rman_ruleblocks_dep.blockid,
                                rman_ruleblocks_dep.att_name,
                                rman_ruleblocks.blockid          dep_blockid,
                                rman_ruleblocks_dep.dep_column   dep_column
                            FROM
                                rman_ruleblocks_dep
                                INNER JOIN rman_ruleblocks ON dep_table = target_table
                        ) dependantattributes
                    WHERE
                        rman_ruleblocks_dep.blockid = dep_blockid
                        AND rman_ruleblocks_dep.att_name = dep_column
                );

        END;

        PROCEDURE update_dep_view_exists AS

            k              VARCHAR2(100);
            k_tbl          tbl_type;
            TYPE used_var_type IS
                TABLE OF INTEGER INDEX BY VARCHAR2(100);
            used_var       used_var_type;
            used_var_0     used_var_type;
            idx            VARCHAR2(100);
            used_var_agg   VARCHAR2(4000);
        BEGIN
            FOR i IN tp.first..tp.last LOOP
                k_tbl := rman_pckg.splitstr(tp(i).templatehtml, '>');
                FOR j IN 1..k_tbl.count LOOP
                    k := regexp_substr(k_tbl(j), '(<)([a-z0-9_]+)', 1, 1, 'i', 2);

                    IF length(k) > 0 THEN
--                        dbms_output.put_line('***-> ' || k);
                        used_var(k) := j;
                    END IF;

                END LOOP;

                used_var_agg := '';
                idx := used_var.first;
                WHILE idx IS NOT NULL LOOP
                    used_var_agg := used_var_agg
                                    || idx
                                    || ',';
                    UPDATE rman_ruleblocks_dep
                    SET
                        view_exists = 1
                    WHERE
                        blockid = tp(i).ruleblockid
                        AND att_name = idx;

                    idx := used_var.next(idx);
                END LOOP;

            

                used_var := used_var_0;
            END LOOP;
        END;

        PROCEDURE update_out_att IS
        BEGIN
            UPDATE rman_ruleblocks r
            SET
                r.out_att = (
                    SELECT
                        LISTAGG(d.att_name, ',') WITHIN GROUP(
                            ORDER BY
                                NULL
                        )
                    FROM
                        rman_ruleblocks_dep d
                    WHERE
--                        d.view_exists = 1
--                        AND d.blockid = r.blockid
                        d.blockid = r.blockid
                        AND ( d.view_exists = 1
                              OR d.dep_exists = 1 )
                    GROUP BY
                        d.blockid
                );

        END update_out_att;

        PROCEDURE concat_exit_prop IS
        BEGIN
            UPDATE rman_ruleblocks d
            SET
                d.out_att = TRIM(BOTH ',' FROM d.out_att
                            || ','
                            || d.def_exit_prop);
--            WHERE
--                instr(nvl(d.out_att, ''), d.def_exit_prop) = 0;

            UPDATE rman_ruleblocks d
            SET
                d.out_att = d.def_exit_prop
            WHERE
                d.out_att IS NULL;

        END concat_exit_prop;
        
    
    
    --- Main procedure

    BEGIN
        read_templates;
        update_dep_view_exists;
        update_dependent_att;
        update_out_att;
        concat_exit_prop;
    END compile_templates;

END;