SET SERVEROUTPUT ON;
CLEAR SCREEN;
DECLARE
    s VARCHAR2(32767);
    t tbl_type2;
    s1 VARCHAR2(32767); 
    clb CLOB;
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
FUNCTION sanitise_varname(varname VARCHAR2) return VARCHAR2
AS
    s VARCHAR2(100); 
    
BEGIN
    
    return TRANSLATE(varname, '1-+(){}[] ', '1');

END sanitise_varname;

BEGIN

    
    clb:='
    
        egfrlv => eGFR;
        acrlv => ACR;
        egfrld => EADV.eGFR.DT.MAX(); 
        acrld => EADV.ACR.DT.MAX();
        sbp140cnt => EADV.[SYSTOLIC].VAL.COUNT().WHERE(VAL>140);
        
        
        hd_icd => EADV.[icd_Z49_1].DT.MAX();
        hd_icpc => EADV.[U59001,U59008].DT.MAX();
        hd_proc => EADV.[13100-00].DT.MAX();
        hdld => EADV.[13100-00,U59001,U59008,icd_Z49_1].DT.MAX();
        
        pd_icpc => EADV.[U59007,U59009].DT.MAX();
        pd_icd => EADV.[icd_Z49_2].DT.MAX();
        pd_proc => EADV.[13100-06,13100-07,13100-08].DT.MAX();
        pdld => EADV.[13100-06,13100-07,13100-08,U59007,U59009,icd_Z49_2].DT.MAX();
         
        tx_icpc => EADV.[U28001].DT.MAX();
        tx_icd => EADV.[icd_Z94%].DT.MAX();
        tx_proc => EADV.[13100-06,13100-07,13100-08].DT.MAX();
        txld => EADV.[U28001,icd_Z94%].DT.MAX();
        
        
        hhd => EADV.[U59J99].DT.MAX();
        hhdld => EADV.[U59J99].DT.MAX();
        
        cga_g(egfrlv,acrlv):{egfrlv>=90 => `G1`},{egfrlv<90 AND egfrlv>=60 => `G2`},{egfrlv<60 AND egfrlv>=45 => `G3A`},{egfrlv<45 AND egfrlv>=30 => `G3B`},{egfrlv<30 AND egfrlv>=15 => `G4`},{egfrlv<15=> `G5`},{=>`NA`};
        cga_a(acrlv):{acrlv<3 => `A1`},{acrlv<30 AND acrlv>=3 => `A2`},{acrlv<300 AND acrlv>=30 => `A3`},{acrlv>300 => `A4`},{=>`NA`};
        
    ';
    
    clb:=replace(clb,chr(13),' ');
    clb:=replace(clb,chr(10),' ');
    clb:=replace(clb,'  ',' ');
    t:=splitclob(clb,';','','');

    for i in 1..t.COUNT LOOP

        s1:=t(i);
        DBMS_OUTPUT.PUT_LINE ('split::(' || i || ')::' || s1);
    END LOOP;

END;