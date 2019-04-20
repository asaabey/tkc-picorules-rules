CLEAR SCREEN;
SET SERVEROUTPUT ON;
DECLARE
    sqlout      VARCHAR2(2000);
    strsql      VARCHAR2(5000);
    t varchar2(32767);
    o varchar2(32767);
    
    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    
    vstack  vstack_type;

BEGIN
    DELETE FROM rpipe;
      
    INSERT INTO rpipe VALUES('r1.1', 'egfrlv => eGFR; acrlv => ACR;');
    INSERT INTO rpipe VALUES('r1.1', 'egfrld => EADV.eGFR.DT.MAX(); acrld => EADV.ACR.DT.MAX();');
    INSERT INTO rpipe VALUES('r2.1', 'egfr10(egfrlv,acrlv) : {1=1 => TO_CHAR(egfrlv*10)} ');
    INSERT INTO rpipe VALUES('r5.22', 'egfrcoal(egfrlv,acrlv) : {1=1 => TO_CHAR(egfrlv)}');

    INSERT INTO rpipe VALUES('r2.1', 'sbp_lv => EADV.[SYSTOLIC].VAL.LAST();');
   
    INSERT INTO rpipe VALUES('r3.1', 'LastCkdDiagICPC => EADV.[U99034,U99035,U99036,U99037,U99038,U99039].DT.LAST();');
    INSERT INTO rpipe VALUES('r3.2', 'LastCkdDiagICD => EADV.[icd_N18%].DT.MAX();');
    INSERT INTO rpipe VALUES('r4.1.1', 'hd_icd => EADV.[icd_Z49_1].DT.MAX();');
    INSERT INTO rpipe VALUES('r4.1.2', 'hd_icpc => EADV.[U59001,U59008].DT.MAX();');
    INSERT INTO rpipe VALUES('r4.1.3', 'hd_proc => EADV.[13100-00].DT.MAX();');
    INSERT INTO rpipe VALUES('r4.3', 'pd_icpc => EADV.[U59007,U59009].DT.MAX();');
    INSERT INTO rpipe VALUES('r4.5', 'tx => EADV.[icd_Z94%,U28001].DT.MAX();');
    INSERT INTO rpipe VALUES('r4.6', 'hhd => EADV.[U59J99].DT.MAX();');
    INSERT INTO rpipe VALUES('r5.1', 'dm_icd => EADV.[icd_E08%,icd_E09%,icd_E10%,icd_E11%,icd_E14%].DT.MAX();');
    INSERT INTO rpipe VALUES('r5.2', 'dm_icpc => EADV.[T89%,T90%].DT.MAX();');

    INSERT INTO rpipe VALUES('r5.3', 'hba1c => EADV.[HBA1C_DFCC].VAL.LAST();');
    INSERT INTO rpipe VALUES('r6.1', 'cga_g(egfrlv,acrlv):{egfrlv>=90 => `G1`},{egfrlv<90 AND egfrlv>=60 => `G2`},{egfrlv<60 AND egfrlv>=45 => `G3A`},{egfrlv<45 AND egfrlv>=30 => `G3B`},{egfrlv<30 AND egfrlv>=15 => `G4`},{egfrlv<15=> `G5`},{=>`NA`}');

    INSERT INTO rpipe VALUES('r6.2', 'cga_a(acrlv):{acrlv<3 => `A1`},{acrlv<30 AND acrlv>=3 => `A2`},{acrlv<300 AND acrlv>=30 => `A3`},{acrlv>300 => `A4`},{=>`NA`}');
    INSERT INTO rpipe VALUES('r6.1', 'cga_ga(cga_g,cga_a):{cga_a=},,{=>`NA`}');
     rman_pckg.parse_rpipe(strsql);

    DBMS_OUTPUT.PUT_LINE(strsql);
END;



