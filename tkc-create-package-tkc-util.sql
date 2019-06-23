clear screen;
set serveroutput on;

CREATE OR REPLACE PACKAGE tkc_util
AUTHID CURRENT_USER
AS
function transform_h9_careplantxt(txt_in varchar2) return integer; 
function transform_h2_smokingstatus(txt_in varchar2) return integer;
function transform_h2_ua_cells(txt_in varchar2) return integer;
function transform_h2_education(txt_in varchar2) return integer;
END;
/



CREATE OR REPLACE PACKAGE BODY tkc_util
AS


function transform_h9_careplantxt(txt_in varchar2) return integer 
as
ret integer:=1000000000;
c   pls_integer:=0;
--
-- slot 9 [1]-0-0-0-0-0-0-0-0-0  composite version
-- slot 8 1-[0]-0-0-0-0-0-0-0-0  reserved
-- slot 7 1-0-[0]-0-0-0-0-0-0-0  hicvr
-- slot 6 1-0-0-[0]-0-0-0-0-0-0  cvd
-- slot 5 1-0-0-0-[0]-0-0-0-0-0  dm
-- slot 4 1-0-0-0-0-[0]-0-0-0-0  ckd
-- slot 3 1-0-0-0-0-0-[0]-0-0-0  unallocated
-- slot 2 1-0-0-0-0-0-0-[0]-0-0  unallocated
-- slot 1 1-0-0-0-0-0-0-0-[0]-0  unallocated
-- slot 0 1-0-0-0-0-0-0-0-0-[0]  checksum
begin
    
    
    if instr(lower(txt_in),'hicvr')>0 then ret:=ret+(power(10,7)*1);c:=c+1;end if;
    
    if instr(lower(txt_in),'cvd')>0 then ret:=ret+(power(10,6)*1);c:=c+1;end if;
    
    if instr(lower(txt_in),'diab')>0 then ret:=ret+(power(10,5)*1);c:=c+1;end if;
    
    
    
    if instr(lower(txt_in),lower('CKD 1-3a Mild Risk'))>0 then ret:=ret+(power(10,4)*1);c:=c+1;end if;
    
    if instr(lower(txt_in),lower('CKD 1-3a Moderate-Severe Risk'))>0 then ret:=ret+(power(10,4)*3);c:=c+1;end if;
    
    if instr(lower(txt_in),lower('CKD 3b-4 High-Severe Risk'))>0 then ret:=ret+(power(10,4)*4);c:=c+1;end if;
    
    if instr(lower(txt_in),lower('CKD 5 Severe Risk'))>0 then ret:=ret+(power(10,4)*5);c:=c+1;end if;
    
    if instr(lower(txt_in),lower('Renal3'))>0 then ret:=ret+(power(10,4)*3);c:=c+1;end if;
    
    if instr(lower(txt_in),lower('Renal4'))>0 then ret:=ret+(power(10,4)*4);c:=c+1;end if;
    
    if instr(lower(txt_in),lower('Renal5'))>0 then ret:=ret+(power(10,4)*5);c:=c+1;end if;
    
    ret:=ret+c;
    
    return ret;
    
end transform_h9_careplantxt;


function transform_h2_smokingstatus(txt_in varchar2) return integer
as
ret integer:=0;


begin
    case (txt_in)
    when 'Current smoker - intends to quit later' then ret:=30;

    when 'Current smoker - intends to quit later' then ret:=30;
    
    when 'Current smoker - no intention to quit' then ret:=30;
    
    when 'Current smoker - wants to quit now' then ret:=30;
    
    when 'Tobacco Smoking Status : Current (Less than 10 smokes a day)' then ret:=30;
    
    when 'Tobacco Smoking Status : Current (More than 10 smokes a day)' then ret:=30;
    
    when 'Ex-smoker' then ret:=20;
    
    when 'Ex-smoker quit 12 months or more ago' then ret:=20;
    
    when 'Ex-smoker quit less than 12 months ago' then ret:=29;
    
    when 'Tobacco Smoking Status : Ex-Smoker (Less than 1 year)' then ret:=29;
    
    when 'Tobacco Smoking Status : Ex-Smoker (More than 1 year)' then ret:=20;
    
    when 'Non-smoker (never smoked)' then ret:=10;
    
    when 'Tobacco Smoking Status : Never Smoked' then ret:=10;
    
    else ret:=0;
    end case;
    
    return ret;
end transform_h2_smokingstatus;

function transform_h2_ua_cells(txt_in varchar2) return integer
as
ret integer:=0;
txt_in_num integer:=0;

--  Maps from 
--  patient_results_text.[Urinalysis: Blood]                    id:71
--  patient_results_text.[Urinalysis: Leukocytes]               id:72
--  patient_results_text.[Leucocytes in Urine]                  id:37
--  patient_results_numeric.[Erythrocytes in Urine sediment]    id:58
--  patient_results_numeric.[Leucocytes in Urine]               id:37

--  Maps to 
--  eadv.lab_ua_rbc
--  eadv.lab_ua_leucocytes


begin
    
    txt_in_num := to_number(regexp_substr(txt_in,'^\d+'));
    case (txt_in)
    when 'Moderate' then ret:=30;

    when 'Moderate non-haemolyzed' then ret:=30;
    
    when 'Trace non-haemolyzed' then ret:=22;
    
    when 'Trace haemolyzed' then ret:=21;
    
    when 'Trace' then ret:=20;
    
    when 'Small' then ret:=20;
    
    when 'Negative' then ret:=0;
    
    when 'Large' then ret:=40;
    
    when '+' then ret:=20;
    
    when '++' then ret:=20;
    
    when '+++' then ret:=30;
    
    when '++++' then ret:=40;
    
    when '10-40' then ret:=30;
    when '20 - 100 /uL' then ret:=30;
    when '40-100' then ret:=30;
    when 'N' then ret:=0;
    
    
    
    
    else 
        case
        when txt_in_num=0 then ret:=0;
        
        when txt_in_num>0 and txt_in_num<=10 then ret:=20;
        
        when txt_in_num>10 and txt_in_num<=100 then ret:=30;
        
        when txt_in_num>100 then ret:=40;
        
        else ret:=0;
        end case;
        
    end case;
    
    return ret;
end transform_h2_ua_cells;

function transform_h2_education(txt_in varchar2) return integer
as
ret integer:=0;


begin
    case (txt_in)
    when 'Advice/Education;Nutritional' then ret:=61;

    when 'NT Renal Services - CKD Education' then ret:=31;
    
    when 'NT Renal Services - CKD Education Review' then ret:=32;
    
    when 'NT Renal Services - CKD Plan' then ret:=35;
    
    when 'NT Renal Services - CKD Referrals' then ret:=38;
    
    when 'Social Work Consult (Renal)' then ret:=51;
    
    else ret:=0;
    end case;
    
    return ret;
end transform_h2_education;

END;
/

