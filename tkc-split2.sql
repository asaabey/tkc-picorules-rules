SET SERVEROUTPUT ON;
CLEAR SCREEN;
DECLARE
    s VARCHAR2(1000);
    t tbl_type;
    s1 VARCHAR2(100); 
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
FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2
AS
    s VARCHAR2(100); 
    
BEGIN
    
    return TRANSLATE(varname, '1-+(){}[] ', '1');

END sanitise_varname;

BEGIN
    s:='egfrcoal(egfrlv,acrlv,egfrld) : {1=1 => TO_CHAR(egfrlv,acrlv,egfrld)},{1=2 => TO_CHAR(egfrlv,acrlv,egfrld)}';
    s1:=SUBSTR(s,1,INSTR(s,':')-1);
DBMS_OUTPUT.PUT_LINE ('step 1 :: ' || s1);  
    s1:=REGEXP_SUBSTR(s, '\((.*)?\)', 1, 1, 'i', 1);
DBMS_OUTPUT.PUT_LINE ('step 2 :: ' || s1);    
    s:=TRIM(SUBSTR(s,INSTR(s,':')+1));
DBMS_OUTPUT.PUT_LINE ('step 3 :: ' || s);  
    
    t:=splitstr(s,',','{','}');
    DBMS_OUTPUT.PUT_LINE ('split string ::' || s);
    for i in 1..t.COUNT LOOP
        --s1:=regexp_substr(t(i), '\{([^}]+)\}', 1,1,NULL,1);
        s1:=t(i);
        DBMS_OUTPUT.PUT_LINE ('split::(' || i || ')::' || s1);
    END LOOP;
    
    --DBMS_OUTPUT.PUT_LINE('sanitise : ' || sanitise_varname('[ASA12]'));

END;