CLEAR SCREEN;


CREATE OR REPLACE PACKAGE rman_pckg AS
--Package		rman_pckg
--Version		1.0.0.0
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


--Conditional declaration
--varname(dependent var,..): { sql_case_when_expr => sql_case_then_expr},..,{=> sq_case_else_then_expr}

    TYPE rman_tbl_type IS TABLE OF rman%ROWTYPE;
    
    TYPE rpipe_tbl_type IS TABLE OF RPIPE%ROWTYPE;
    
    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    vstack  vstack_type;
    
    cmpstat NVARCHAR2(4000);
    
    rman_index PLS_INTEGER:=0;
    
    assn_op CONSTANT VARCHAR2(2):='=>';
    like_op CONSTANT CHAR:='%';
    
    entity_id_col       CONSTANT VARCHAR2(32):='EID';
    att_col             CONSTANT VARCHAR2(32):='ATT';
    val_col             CONSTANT VARCHAR2(32):='VAL';
    dt_col              CONSTANT VARCHAR2(32):='DT';
    def_tbl_name        CONSTANT VARCHAR2(32):='EADV';
    
    PROCEDURE parse_rpipe (sqlout OUT varchar2);
    
    PROCEDURE getcomposite(cmpstat OUT NVARCHAR2); 
    
    FUNCTION sql_predicate(att_str VARCHAR2) RETURN VARCHAR2;
    
    FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2;
    
    --FUNCTION splitstr(list in varchar2,delimiter in varchar2 default ',') return tbl_type;
    FUNCTION splitstr(list in varchar2,delimiter in varchar2 default ',',ignore_left in CHAR DEFAULT '[',  ignore_right in CHAR DEFAULT ']') return tbl_type;
    
    FUNCTION get_cte_name (indx BINARY_INTEGER) return NVARCHAR2; 
    
    PROCEDURE InsertIntoRman
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
    indx        IN INT,
    txtin       varchar2,
    sqlstat     OUT VARCHAR2,
    rows_added OUT PLS_INTEGER
    ) ;
    
--    PROCEDURE build_scalar_sql_exp(
--    indx PLS_INTEGER,txtin IN varchar2,sqlstat OUT varchar2,rows_added OUT PLS_INTEGER
--    );
    
    PROCEDURE build_cond_sql_exp(indx PLS_INTEGER,txtin IN varchar2,sqlstat OUT varchar2,rows_added OUT PLS_INTEGER);   
END;
/


CREATE OR REPLACE PACKAGE BODY rman_pckg AS

--https://stackoverflow.com/questions/3710589/is-there-a-function-to-split-a-string-in-pl-sql/3710619#3710619
--FUNCTION splitstr(
--  list in varchar2,
--  delimiter in varchar2 default ','
--) return tbl_type as
--  splitted tbl_type := tbl_type();
--  i pls_integer := 0;
--  list_ varchar2(32767) := list;
--begin
--  loop
--    i := instr(list_, delimiter);
--    if i > 0 then
--      splitted.extend(1);
--      splitted(splitted.last) := substr(list_, 1, i - 1);
--      list_ := substr(list_, i + length(delimiter));
--    else
--      splitted.extend(1);
--      splitted(splitted.last) := trim(list_);
--      return splitted;
--    end if;
--  end loop;
--end splitstr;
FUNCTION sql_predicate(att_str VARCHAR2) RETURN VARCHAR2
AS
att_tbl tbl_type;
eq_op VARCHAR2(6);
escape_stat VARCHAR(20):=' ESCAPE ''!''';
s VARCHAR2(5000);
att_col CONSTANT VARCHAR2(30):='ATT';
BEGIN
    IF INSTR(att_str,',')>0 THEN
        att_tbl:=rman_pckg.splitstr(att_str,',','','');
        FOR i in 1..att_tbl.COUNT LOOP
            IF INSTR(att_tbl(i),'%')>0 THEN
                eq_op:=' LIKE ';
            ELSE 
                eq_op:=' = ';
            END IF;
            s:=s || '(' || att_col || eq_op || '`' || sanitise_varname(att_tbl(i)) || '`)';
--            IF eq=' LIKE ' AND INSTR(sanitise_varname(att_tbl(i)),'_') THEN
--                  
--            ELSE
--                s:=s || '(' || att_col || eq_op || '`' || sanitise_varname(att_tbl(i)) || '`)';  
--            END IF;
            IF i<att_tbl.COUNT THEN
                s:=s || ' OR ';
            END IF;
        END LOOP;
    ELSIF INSTR(att_str,',')=0 THEN
        IF INSTR(att_str,'%')>0 THEN
                eq_op:=' LIKE ';
            ELSE 
                eq_op:=' = ';
            END IF;
            s:=s || '(' || att_col || eq_op || '`' || sanitise_varname(att_str) || '`)';  
    END IF;
    
    return s;
END sql_predicate;

FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2
AS
    s VARCHAR2(100); 
BEGIN
    -- trim bounding parantheses
    s:= TRANSLATE(varname, '1-+{}[] ', '1');
    -- surround with double quotes if full stop and spaces found in var from varnames
    IF instr(varname,'.')>0 OR instr(varname,' ')>0 THEN 
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

FUNCTION get_cte_name (indx BINARY_INTEGER) return NVARCHAR2 
AS
BEGIN
    RETURN 'CTE' || lpad(indx,3,0); 
END get_cte_name;


PROCEDURE getcomposite (cmpstat OUT NVARCHAR2) IS
    rmanobj rman_tbl_type;
    ctename nvarchar2(20);
BEGIN
    SELECT ID, where_clause, from_clause, select_clause, groupby_clause,varid, is_sub
    BULK COLLECT INTO rmanobj
    FROM rman;
    
    
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
    

    cmpstat :=cmpstat || ' SELECT '|| get_cte_name(0) || '.' || entity_id_col || ', ';
    
   
    
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP
        ctename:=get_cte_name(i);
        IF rmanobj(I).is_sub=0 THEN

            cmpstat := cmpstat || ctename || '.' || rmanobj(i).varid || ' ';
                    
            --line break for readability
            
            cmpstat:=cmpstat || chr(10);
        END IF;
        
        IF I<rmanobj.LAST AND rmanobj(i).is_sub=0 THEN
            cmpstat :=cmpstat || ',';
        END IF;

    END LOOP;
    
    cmpstat := cmpstat || 'FROM ' || get_cte_name(0);

    
    FOR I IN rmanobj.FIRST..rmanobj.LAST
    LOOP

        ctename:=get_cte_name(i);
        IF rmanobj(I).is_sub=0 THEN
            cmpstat := cmpstat || ' LEFT OUTER JOIN ' || ctename || ' ON ' || ctename || '.' || entity_id_col || '=' || get_cte_name(0)||'.' || entity_id_col || ' ';
            --line break for readability
            cmpstat:=cmpstat || chr(10);
        END IF;
        IF I=rmanobj.LAST THEN
            cmpstat :=cmpstat || ';';
        END IF;
        
        
    END LOOP;
    
    
END getcomposite;




PROCEDURE InsertIntoRman(
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
    INSERT INTO rman (ID, where_clause,from_clause, select_clause,groupby_clause, varid, is_sub)
            VALUES (indx,where_clause,from_clause,select_clause,groupby_clause,varid,is_sub);
            sqlstat:='rows added :' || SQL%ROWCOUNT;
END InsertIntoRman;

PROCEDURE build_func_sql_exp
(
    indx        IN INT,
    txtin       varchar2,
    sqlstat     OUT VARCHAR2,
    rows_added OUT PLS_INTEGER
) 
IS
    func        varchar2(32);
    funcparam   PLS_INTEGER;
    att         varchar2(4000);
    att_str     varchar2(256);
    tbl         varchar2(100);
    prop         varchar2(100);
    assnvar     varchar2(100);
    
    equality_cmd  varchar2(5):='=';
    where_txt VARCHAR(2000);
    from_txt VARCHAR(2000);
    select_txt VARCHAR(2000);
    groupby_txt VARCHAR(2000);
    is_sub_val INT:=0;
    varr tbl_type;
    att_tbl tbl_type;
    ude_function_undefined EXCEPTION;
BEGIN
    
    
    -- parse txt string
    assnvar:=trim(substr(txtin,1,instr(txtin,assn_op)-1));
    
    assnvar:=sanitise_varname(assnvar);
--DBMS_OUTPUT.PUT_LINE('func :::: ' || trim(substr(txtin,instr(txtin,assn_op)+length(assn_op))));
    --varr:=rman_pckg.splitstr(trim(substr(txtin,instr(txtin,'=>',1,1)+2,length(txtin))),'.','[',']');
    varr:=rman_pckg.splitstr(trim(substr(txtin,instr(txtin,assn_op)+length(assn_op))),'.','[',']');
--    for i in 1..varr.LAST LOOP
--        DBMS_OUTPUT.PUT_LINE ('func :::: ' || i || ')' || varr(i));
--    
--    END LOOP;
    
     IF varr.COUNT=4 THEN
        tbl:=UPPER(varr(1));
        att:=varr(2);
        prop:=varr(3);
        func:=UPPER(SUBSTR(varr(4), 1, INSTR(varr(4),'(',1,1)-1));
        funcparam:=NVL(REGEXP_SUBSTR(varr(4), '\((.*)?\)', 1, 1, 'i', 1),0);
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
        tbl:=def_tbl_name;
        att:=varr(1);
        prop:=val_col;
        func:='LAST';
        funcparam:=0;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Syntax error');
    END IF;
    
    --att:=sanitise_varname(sql_predicate(att));
    
    att:=sql_predicate(att);
    
    
    CASE 
        
        
        WHEN FUNC IN ('MAX','MIN','COUNT','SUM','AVG','MEDIAN') THEN
            
            where_txt:=att;
            
            from_txt:= tbl;
            select_txt:=  entity_id_col || ',' || func || '(' || prop || ') AS ' || assnvar || ' ';
            --groupby_txt:=att_col ||',' || entity_id_col;
            groupby_txt:=entity_id_col;
            InsertIntoRman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
            
            rows_added:= 1;
            
            IF assnvar IS NOT NULL THEN
                vstack(assnvar):=indx;
            END IF;
            
        WHEN FUNC='LAST' OR FUNC='FIRST' THEN
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
                where_txt:=att;
                from_txt:= tbl;
                
                --select_txt:= entity_id_col || ',' || prop || ',ROW_NUMBER() OVER(PARTITION BY ' || entity_id_col || ',' || att_col ||' ORDER BY ' || entity_id_col || ',DT ' || sortdirection ||') AS rank ';
                select_txt:= entity_id_col || ',' || prop || ',ROW_NUMBER() OVER(PARTITION BY ' || entity_id_col || ' ORDER BY ' || entity_id_col || ',DT ' || sortdirection ||') AS rank ';
                groupby_txt:='';
                is_sub_val:=1;
                
                
                InsertIntoRman(indx,where_txt,from_txt,select_txt,groupby_txt,NULL, is_sub_val,sqlstat);
                
                where_txt:= 'rank=' || rankindx;
                from_txt:= ctename;
                
                select_txt:= entity_id_col || ',' || prop || ' AS ' || assnvar;
                groupby_txt:='';
                is_sub_val:=0;   
                
                InsertIntoRman(indx+1,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
                
                rows_added:= 2;
                
                IF assnvar IS NOT NULL THEN
                    vstack(assnvar):=indx+1;
            END IF;
            END;
        WHEN FUNC='EXISTS' THEN
            DECLARE 
            BEGIN
                where_txt:=att;
                
                from_txt:= def_tbl_name;
                select_txt:= entity_id_col || ',1 AS ' || assnvar || ' ';
                groupby_txt:=entity_id_col || ',' || att_col;
                is_sub_val:=0;
            
                InsertIntoRman(indx,where_txt,from_txt,select_txt,groupby_txt,assnvar,is_sub_val,sqlstat);
            
                rows_added:= 1;
            
                IF assnvar IS NOT NULL THEN
                    vstack(assnvar):=indx;
                END IF;
            END;
        ELSE 
            RAISE ude_function_undefined;
            
    END CASE;    
EXCEPTION
    WHEN ude_function_undefined THEN
        DBMS_OUTPUT.PUT_LINE('RMAN EXCEPTION: PROC build_func_sql_exp : Undefined function');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('RMAN EXCEPTION: PROC build_func_sql_exp :Undefined error');
END build_func_sql_exp;

PROCEDURE build_cond_sql_exp(
    indx PLS_INTEGER,txtin IN varchar2,sqlstat OUT varchar2,rows_added OUT PLS_INTEGER
)   
IS

    t1 tbl_type;
    
    avn varchar2(50);
    expr varchar2(32767);
    used_vars varchar2(100);
    
    
    
    expr_tbl tbl_type;
    used_vars_tbl tbl_type;
    expr_elem tbl_type;
    
    expr_then varchar2(32767);
    expr_when varchar2(32767);
    from_clause varchar2(2000);
    op_delim varchar2(3):='|';
    txt  VARCHAR2(32767);
    
    select_text varchar2(32767);

BEGIN
    from_clause:='';
    select_text:='CASE ';
    
    --split initial statement into assigned var (avn) and expr at :
    -- found form of avn() :
    
    
    IF INSTR(txtin,':')>0  AND INSTR(txtin,'(',1,1)>0 THEN
        avn:=SUBSTR(txtin, 1, INSTR(txtin,'(',1,1)-1);
    END IF;

    -- split at major assignment
    
    IF avn IS NOT NULL THEN
        --major assignment should be of function () type
       
            
            used_vars:=REGEXP_SUBSTR(SUBSTR(txtin,1,INSTR(txtin,':')-1), '\((.*)?\)', 1, 1, 'i', 1);
--DBMS_OUTPUT.PUT_LINE('-----------------------'|| avn || '--- '|| used_vars);
            used_vars_tbl:=rman_pckg.splitstr(used_vars,',');
            
            expr:= TRIM(SUBSTR(txtin,INSTR(txtin,':')+1));
            
            IF INSTR(expr,'1=1 ')>0 THEN

                    IF used_vars_tbl.COUNT=1 THEN
                        from_clause :=from_clause || get_cte_name(0);
                    ELSIF used_vars_tbl.COUNT>1 THEN
                        from_clause :=from_clause || get_cte_name(0);
                        for i IN 1..used_vars_tbl.LAST LOOP
                  
                            from_clause:=from_clause || ' LEFT OUTER JOIN ' || get_cte_name(vstack(used_vars_tbl(i)))
                                    || ' ON ' || get_cte_name(vstack(used_vars_tbl(i))) || '.' || entity_id_col || '=' 
                                    || get_cte_name(0) || '.' || entity_id_col || ' ';
                        END LOOP;
                        
                    ELSE
                        -- RAISE EXCEPTION
                        DBMS_OUTPUT.PUT(', ');
                    END IF;

            ELSE
            --build from clause using cte joins
                    IF used_vars_tbl.COUNT=1 THEN
                        from_clause :=from_clause || get_cte_name(vstack(used_vars_tbl(1)));
                    ELSIF used_vars_tbl.COUNT>1 THEN
                        from_clause :=from_clause || get_cte_name(vstack(used_vars_tbl(1)));
                        for i IN 2..used_vars_tbl.LAST LOOP
                  
                            from_clause:=from_clause || ' INNER JOIN ' || get_cte_name(vstack(used_vars_tbl(i)))
                                    || ' ON ' || get_cte_name(vstack(used_vars_tbl(i))) || '.' || entity_id_col || '=' 
                                    || get_cte_name(vstack(used_vars_tbl(1))) || '.' || entity_id_col || ' ';
                        END LOOP;
                        
                    ELSE
                        -- RAISE EXCEPTION
                        DBMS_OUTPUT.PUT(', ');
                    END IF;
            END IF;
            
            
                       
            expr:= TRIM(SUBSTR(txtin,INSTR(txtin,':')+1));
            
--dbms_output.put_line('......expr..-> '|| avn || ' --> ' ||expr);
            
            expr_tbl:=rman_pckg.splitstr(expr,',','{','}');
            
            
            --split to expression array
            for i in 1..expr_tbl.COUNT loop
                --check if properly formed by curly brackets
--dbms_output.put_line('............-> ' || '--> ' || i ||' --> ' || avn || '--> expr_tbl(i) ' || expr_tbl(i));
                expr:=regexp_substr(expr_tbl(i), '\{([^}]+)\}', 1,1,NULL,1);
                
--dbms_output.put_line('............-> ' || '--> ' || i ||' --> ' || avn || ' --> ' ||expr);

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
            
            select_text:=select_text || 'END AS ' || UPPER(avn) || ',' || get_cte_name(0) ||'.' || entity_id_col || ' ';
            vstack(avn):=indx;
            

            InsertIntoRman(indx,'',from_clause,select_text,'',avn,0,sqlstat);
        
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
    SELECT ruleid, rulebody 
    BULK COLLECT INTO rpipe_col
    FROM RPIPE;
    
    DELETE FROM rman;
    
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
                        build_func_sql_exp(indx,ss,sqlout,rows_added);
                        indx:=indx+rows_added;
                        
                    -- conditional form
                    ELSE
                        rows_added:=0;
                        build_cond_sql_exp(indx,ss,sqlout,rows_added);
                        indx:=indx+rows_added;
        
                    END IF;
            
                
                END IF;
                    
            END LOOP;
            
            
            
           
        
        
        END IF;
        
     
    
        
        
    end loop;
    getcomposite(sqlout);
    
    indxtmp:=vstack.FIRST;
    
    WHILE (indxtmp is not null)
    LOOP
        dbms_output.put_line('--- >>' || indxtmp);
        indxtmp:=vstack.next(indxtmp);
    END LOOP;
    
    
    
    
    
END parse_rpipe;

END;





