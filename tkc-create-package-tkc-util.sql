clear screen;
set serveroutput on;

CREATE OR REPLACE PACKAGE tkc_util
AUTHID CURRENT_USER
AS
function careplantxt_codify(txt_in varchar2) return varchar2;
function transform_h9_careplantxt(txt_in varchar2) return integer; 
function transform_h1_smokingstatus(txt_in varchar2) return integer;
END;
/



CREATE OR REPLACE PACKAGE BODY tkc_util
AS
function careplantxt_codify(txt_in varchar2) return varchar2
as
ret varchar2(100):='CVR0CVD0DM0CKD0';
begin
    if instr(lower(txt_in),'hicvr')>0 then ret:=regexp_replace(ret,'CVR0','CVR1',1,1,'i');end if;
    
    if instr(lower(txt_in),'diab')>0 then ret:=regexp_replace(ret,'DM0','DM1',1,1,'i');end if;
    
    if instr(lower(txt_in),'cvd')>0 then ret:=regexp_replace(ret,'CVD0','CVD1',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('CKD 1-3a Mild Risk'))>0 then ret:=regexp_replace(ret,'CKD0','CKD1',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('CKD 1-3a Moderate-Severe Risk'))>0 then ret:=regexp_replace(ret,'CKD0','CKD3',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('CKD 3b-4 High-Severe Risk'))>0 then ret:=regexp_replace(ret,'CKD0','CKD4',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('CKD 5 Severe Risk'))>0 then ret:=regexp_replace(ret,'CKD0','CKD5',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('Renal3'))>0 then ret:=regexp_replace(ret,'CKD0','CKD3',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('Renal4'))>0 then ret:=regexp_replace(ret,'CKD0','CKD4',1,1,'i');end if;
    
    if instr(lower(txt_in),lower('Renal5'))>0 then ret:=regexp_replace(ret,'CKD0','CKD5',1,1,'i');end if;
    
    return ret;
    
end careplantxt_codify;

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


function transform_h1_smokingstatus(txt_in varchar2) return integer
as
ret integer:=0;


begin
    case (txt_in)
    when 'Current smoker - intends to quit later' then ret:=3;

    when 'Current smoker - intends to quit later' then ret:=3;
    
    when 'Current smoker - no intention to quit' then ret:=3;
    
    when 'Current smoker - wants to quit now' then ret:=3;
    
    when 'Tobacco Smoking Status : Current (Less than 10 smokes a day)' then ret:=3;
    
    when 'Tobacco Smoking Status : Current (More than 10 smokes a day)' then ret:=3;
    
    when 'Ex-smoker' then ret:=2;
    
    when 'Ex-smoker quit 12 months or more ago' then ret:=2;
    
    when 'Ex-smoker quit less than 12 months ago' then ret:=2;
    
    when 'Non-smoker (never smoked)' then ret:=1;
    
    when 'Tobacco Smoking Status : Never Smoked' then ret:=1;
    
    else ret:=0;
    end case;
    
    return ret;
end transform_h1_smokingstatus;
END;
/
