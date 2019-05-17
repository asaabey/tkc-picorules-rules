CLEAR SCREEN;


CREATE OR REPLACE PACKAGE rman_pckg 
AUTHID CURRENT_USER
AS
--Package		rman_pckg
--Version		0.0.0.8
--Creation date	07/04/2019
--Author		ASAABEY
--
--Purpose		
--Dynamic rules engine, which converts 'picorules' script to ANSI SQL script. Source table needs to conform to EADV format (entity,attribute,date,value).
--Rules are inserted into RPIPE table which is parsed by PARSE_RPIPE procedure to create RMAN table. The GETCOMPOSITE procedure forms the final SQL statement with recursive CTE's.
--Picorules grammar

--Functional declaration, usually for aggregate function
--varname=> object.attribute.property.function(param)

--[varname]=> object.[attribute].property.function(param)
--[varname]=> object.[attribute%].property.function(param)

--Shorthand
--LAST() implied
--varname=> object.attribute.property

--VAL.LAST() implied
--varname=> object.attribute

--EADV.[att].VAL.LAST() implied
--varname=> attribute

--Attribute predicates
-- [att1,att2,att3%]
-- is compiled to
-- (ATT = 'att1') OR (ATT = 'att2') OR (ATT LIKE 'att3%')

--Commenting
-- /* comment */

--Intermediate variables
-- if the assigned name is terminated with an underscore , it will not be displayed in the final ROUT table
--  var_



--Conditional declaration
--varname(dependent var,..): { sql_case_when_expr => sql_case_then_expr},..,{=> sq_case_else_then_expr}
--This can be used to derive any SQL scalar function
--varname(dependent var,..):{1=1 => sql_scalar_func()}

--Externtal table binding
--tbl.att.val.bind()
--should only be used were eid->att is 1:1



    TYPE rman_tbl_type IS TABLE OF rman_stack%ROWTYPE;
    
    TYPE rpipe_tbl_type IS TABLE OF rman_rpipe%ROWTYPE;
    
    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    vstack          vstack_type;
    vstack_dep      vstack_type;
    
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
    
    PROCEDURE getcomposite(cmpstat OUT NVARCHAR2); 
    
    FUNCTION sql_predicate(att_str VARCHAR2) RETURN VARCHAR2;
    
    FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2;
    
    
    FUNCTION splitstr(list in varchar2,delimiter in varchar2 default ',',ignore_left in CHAR DEFAULT '[',  ignore_right in CHAR DEFAULT ']') return tbl_type;
    
    FUNCTION splitclob(list in clob,delimiter in varchar2 default ',', ignore_left in CHAR DEFAULT '[', ignore_right in CHAR DEFAULT ']') return tbl_type2;
    
    FUNCTION sanitise_clob(clbin CLOB) RETURN CLOB;
    
    FUNCTION get_cte_name (indx BINARY_INTEGER) return NVARCHAR2; 
    
    FUNCTION trim_comments(txtin clob) RETURN clob;
    
    PROCEDURE insert_rman
    (
     indx INT,
    where_clause NVARCHAR2,
    from_clause  NVARCHAR2,
    select_clause NVARCHAR2,
    groupby_clause  NVARCHAR2,
    varid NVARCHAR2,
    is_sub INT,
    sqlstat OUT NVARCHAR2
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
    PROCEDURE exec_ndsql(sqlstmt clob,tbl_name varchar2) ;
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
    RETURN txtout;
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

PROCEDURE getcomposite (cmpstat OUT NVARCHAR2) IS
    rmanobj rman_tbl_type;
    ctename nvarchar2(20);
BEGIN
    SELECT ID, where_clause, from_clause, select_clause, groupby_clause,varid, is_sub
    BULK COLLECT INTO rmanobj
    FROM rman_stack;
    
    cmpstat := 'WITH ' ||  get_cte_name(0) || ' AS (SELECT ' || entity_id_col || ' FROM EADV GROUP BY ' || entity_id_col || '),';

    
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP
     
        ctename:=get_cte_name(i);        
        
        cmpstat := cmpstat || ctename || ' AS (SELECT ' || REPLACE(rmanobj(I).select_clause,'`','''') || ' FROM ' || rmanobj(I).from_clause ;
                
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
        END IF;
        


    END LOOP;
    
    cmpstat := cmpstat || 'FROM ' || get_cte_name(0);

    -- Add the left outer joins
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP

        ctename:=get_cte_name(i);
        IF rmanobj(I).is_sub=0 THEN
                IF is_tempvar(rmanobj(I).varid)=FALSE THEN
                    cmpstat := cmpstat || ' LEFT OUTER JOIN ' || ctename || ' ON ' || ctename || '.' || entity_id_col || '=' || get_cte_name(0)||'.' || entity_id_col || ' ';
                    --line break for readability
                    cmpstat:=cmpstat || chr(10);
                END IF;
        END IF;
    END LOOP;
    
    
END getcomposite;




PROCEDURE insert_rman(
    indx INT,
    where_clause NVARCHAR2,
    from_clause  NVARCHAR2,
    select_clause NVARCHAR2,
    groupby_clause  NVARCHAR2,
    varid NVARCHAR2,
    is_sub INT,
    sqlstat OUT NVARCHAR2
)
IS
BEGIN
    INSERT INTO rman_stack (ID, where_clause,from_clause, select_clause,groupby_clause, varid, is_sub)
            VALUES (indx,where_clause,from_clause,select_clause,groupby_clause,varid,is_sub);
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
            
--EXCEPTION
--    WHEN OTHERS THEN
--    DBMS_OUTPUT.PUT_LINE('BUILD ASSN VAR FAILED ');

END build_assn_var;

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
BEGIN
            

            txt:=SUBSTR(txtin,INSTR(txtin,delim)+LENGTH(delim),LENGTH(txtin)); 
            
            from_clause :=from_clause || left_tbl_name;  
            
            vsi:=vstack.FIRST;
            
            WHILE vsi IS NOT NULL LOOP   
                
                IF match_varname(txt,vsi) AND vsi is not null THEN
                     from_clause:=from_clause || ' LEFT OUTER JOIN ' || get_cte_name(vstack(vsi))
                                        || ' ON ' || get_cte_name(vstack(vsi)) || '.' || entity_id_col || '=' 
                                        || left_tbl_name || '.' || entity_id_col || ' ';
                              
                END IF;
                
                vsi := vstack.NEXT(vsi);
            END LOOP; 
            
            
            avn:=TRIM(SUBSTR(txtin, 1, INSTR(txtin,delim,1,1)-LENGTH(delim)));            


--EXCEPTION
--    WHEN OTHERS THEN
--    DBMS_OUTPUT.PUT_LINE('BUILD ASSN VAR FAILED ');

END build_assn_var2;

PROCEDURE push_vstack(
    varname          IN  VARCHAR2,
    indx             IN  INTEGER,
    calling_proc     IN  INTEGER    
)
AS
BEGIN
    IF varname IS NOT NULL THEN
        vstack(varname):=indx;       
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

            func:='CONST';

            constparam:=REGEXP_SUBSTR(varr(1), '\((.*)?\)', 1, 1, 'i', 1);
        ELSE
            tbl:=def_tbl_name;
            att:=varr(1);
            prop:=val_col;
            func:='LAST';
            funcparam:=0;
        END IF;
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Syntax error');
    END IF;
    
    att0:=att;
    
    att:=sql_predicate(att);
    
    
    
    left_tbl_name := tbl;
    
    build_assn_var2(txtin,'=>',left_tbl_name,from_clause,avn);
    
    --assnvar:=avn;
    
    
    assnvar:=sanitise_varname(avn);
    
    IF SUBSTR(tbl,1,5)='ROUT_' AND FUNC='BIND' THEN 
            where_txt:='';
            from_txt:= tbl;
            select_txt:=  entity_id_col || ',' || ext_col_name || ' AS ' || assnvar || ' ';
            groupby_txt:='';
            insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
            
            insert_ruleblocks_dep(blockid,tbl,ext_col_name,NULL,func);
            
            rows_added:= 1;
            
            push_vstack(assnvar,indx,2);
            

    
    ELSE
    
    CASE 
        
        
        WHEN FUNC IN ('MAX','MIN','COUNT','SUM','AVG','MEDIAN') THEN
            
            where_txt:=att || predicate;
            
            from_txt:= from_clause;
            select_txt:=  tbl || '.' || entity_id_col || ',' || func || '(' || prop || ') AS ' || assnvar || ' ';
            groupby_txt:=tbl || '.' || entity_id_col;
            insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
            
            insert_ruleblocks_dep(blockid,tbl,att_col,att0,func);
            
            rows_added:= 1;
            
            push_vstack(assnvar,indx,2);

            
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
                
                
                insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,NULL, is_sub_val,sqlstat);
                
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
                
                insert_rman(indx+1,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
                
                rows_added:= 2;
                
                push_vstack(assnvar,indx+1,2);
                

            END;

        WHEN FUNC='CONST' THEN
            DECLARE
            BEGIN
                where_txt:='1=1';
                
                from_txt:= from_clause;
                select_txt:= entity_id_col || ',' || constparam || ' AS ' || assnvar || ' ';
                groupby_txt:=entity_id_col;
                
                is_sub_val:=0;
            
                insert_rman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
            
                rows_added:= 1;
            
                push_vstack(assnvar,indx,2);
                
--                IF assnvar IS NOT NULL THEN
--                    vstack(assnvar):=indx;
--                END IF;
            END;
        ELSE 
            RAISE ude_function_undefined;
            
    END CASE; 
    
    END IF;
      
       
--EXCEPTION
--    WHEN ude_function_undefined THEN
--        DBMS_OUTPUT.PUT_LINE('RMAN EXCEPTION: PROC build_func_sql_exp : Undefined function');
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('RMAN EXCEPTION: PROC build_func_sql_exp :Undefined error');
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
    
    select_text varchar2(32767);

BEGIN
    from_clause:='';
    select_text:='CASE ';
    
    --split initial statement into assigned var (avn) and expr at :
    -- found form of avn() :
    left_tbl_name := get_cte_name(0);
    
    
    
    build_assn_var2(txtin,':',left_tbl_name,from_clause,avn);
    
    --avn:=sanitise_varname(avn);
    
    -- split at major assignment
    
    IF avn IS NOT NULL THEN
                       
            expr:= TRIM(SUBSTR(txtin,INSTR(txtin,':')+1));
            
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
            
            push_vstack(avn,indx,1);
--            vstack(avn):=indx;
            

            insert_rman(indx,'',from_clause,select_text,'',avn,0,sqlstat);
        
            rows_added:= 1;
        
       
    END IF;
    
--EXCEPTION
--    WHEN NO_DATA_FOUND THEN
--          DBMS_OUTPUT.PUT_LINE ('no conditional assignment'); 
--        
--    WHEN OTHERS THEN
--        dbms_output.put_line('exc other');
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
        DBMS_Output.PUT_LINE('index -> ' || indxtmp || ' is ' || vstack(indxtmp));   
        indxtmp := vstack.NEXT(indxtmp); 
    END LOOP; 
    getcomposite(sqlout);
    
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

dbms_output.put_line('FUNC-AARAY VSTACK : ' || vstack.COUNT);


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
    
    DBMS_OUTPUT.PUT_LINE('SQL Block ->' || CHR(10) || create_tbl_sql_str);
    
   
END exec_ndsql;
END;





