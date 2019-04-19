SET SERVEROUTPUT ON;
CLEAR SCREEN;
DECLARE
    s VARCHAR2(1000);
    t tbl_type;
FUNCTION splitstr(
  list in varchar2,
  delimiter in varchar2 default ',',
  ignore_left in CHAR DEFAULT '[',
  ignore_right in CHAR DEFAULT ']'
) return tbl_type as  splitted tbl_type := tbl_type();
  i pls_integer := 0;
  list_ varchar2(32767) := list;
  ignore_right_pos PLS_INTEGER;
  ignore_left_pos PLS_INTEGER;
  ignore_length PLS_INTEGER;
begin
        loop       
            -- find next delimiter
            i := instr(list_, delimiter);
             --if delimiter found
            DBMS_OUTPUT.put_line('splitstr :::' || i);
            if i > 0 THEN 
                -- find ignore bouding region
                ignore_left_pos:=INSTR(list_,ignore_left);
                ignore_right_pos:=INSTR(list_,ignore_right);
                
                --splitted.extend(1);              
                if ignore_left_pos>0 AND ignore_right_pos>ignore_left_pos AND i>ignore_left_pos AND i<ignore_right_pos THEN
                        --if trim(substr(list_, 2, ignore_right_pos-2)) IS NOT NULL THEN
                            splitted.extend(1);
                            splitted(splitted.last) := substr(list_, length(ignore_left), ignore_right_pos-length(ignore_right));
                            list_ := substr(list_, i+(ignore_right_pos-ignore_left_pos-3));
                        --end if;
                else
                        --if trim(substr(list_, 1, i - 1)) IS NOT NULL THEN
                            splitted.extend(1);
                            splitted(splitted.last) := trim(substr(list_, 1, i - 1));
                            list_ := substr(list_, i + length(delimiter));
                        --end if;
                        
                end if;
            else
                    splitted.extend(1);
                    splitted(splitted.last) := trim(list_);
                    return splitted;
            end if;
            DBMS_OUTPUT.PUT_LINE('roll::: ' || i || '() ' || list_);
          end loop;
end splitstr;
FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2
AS
    s VARCHAR2(100); 
BEGIN
    
    return TRANSLATE(varname, '1-+(){}[] ', '1');

END sanitise_varname;

BEGIN
    --s:='EADV.[egfrsaasa_knk].DT.LAST';
    
    s:='EADV.[]';
    t:=splitstr(s,'.');
    DBMS_OUTPUT.PUT_LINE ('split string ::' || s);
    for i in 1..t.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE ('split::(' || i || ')::' || t(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('sanitise : ' || sanitise_varname('[ASA12]'));

END;