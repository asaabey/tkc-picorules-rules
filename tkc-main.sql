CLEAR SCREEN;
SET SERVEROUTPUT ON;
DECLARE
    sqlout      VARCHAR2(32767);
    strsql      VARCHAR2(32767);
    t varchar2(32767);
    o varchar2(32767);
    
    TYPE vstack_type IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    
    vstack  vstack_type;

BEGIN
    DELETE FROM rpipe;
    
    INSERT INTO rpipe VALUES('r1.2.3', 'sbp_cnt => EADV.[SYSTOLIC].VAL.COUNT();');
    INSERT INTO rpipe VALUES('r1.2.4', 'sbp140_cnt => EADV.[SYSTOLIC].VAL.COUNT().WHERE(VAL>140 AND DT>TO_DATE(`01/01/2017`,`DD/MM/YYYY`));');
    INSERT INTO rpipe VALUES('r0.1.1', 'dt0=>CONST(TO_DATE(`01/01/2017`,`DD/MM/YYYY`));');
--    
--    INSERT INTO rpipe VALUES('r1.1.1', 'egfrlv => eGFR; acrlv => ACR;');
--    INSERT INTO rpipe VALUES('r1.1.2', 'egfrld => EADV.eGFR.DT.MAX(); acrld => EADV.ACR.DT.MAX();');
--    INSERT INTO rpipe VALUES('r1.2.3', 'sbp_lv => EADV.[SYSTOLIC].VAL.LAST().WHERE(VAL>140);');
--   
--    INSERT INTO rpipe VALUES('r4.1.1', 'hd_icd => EADV.[icd_Z49_1].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.1.2', 'hd_icpc => EADV.[U59001,U59008].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.1.3', 'hd_proc => EADV.[13100-00].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.1.4', 'hdld => EADV.[13100-00,U59001,U59008,icd_Z49_1].DT.MAX();');
--    
--    INSERT INTO rpipe VALUES('r4.2.1', 'pd_icpc => EADV.[U59007,U59009].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.2.2', 'pd_icd => EADV.[icd_Z49_2].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.2.3', 'pd_proc => EADV.[13100-06,13100-07,13100-08].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.2.4', 'pdld => EADV.[13100-06,13100-07,13100-08,U59007,U59009,icd_Z49_2].DT.MAX();');
--    
--    INSERT INTO rpipe VALUES('r4.3.1', 'tx_icpc => EADV.[U28001].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.3.2', 'tx_icd => EADV.[icd_Z94%].DT.MAX();');
--    --INSERT INTO rpipe VALUES('r4.3.3', 'tx_proc => EADV.[13100-06,13100-07,13100-08].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.3.4', 'txld => EADV.[U28001,icd_Z94%].DT.MAX();');
--       
--    
--    INSERT INTO rpipe VALUES('r4.4.1', 'hhd => EADV.[U59J99].DT.MAX();');
--    INSERT INTO rpipe VALUES('r4.4.2', 'hhdld => EADV.[U59J99].DT.MAX();');
--    
--    
--    INSERT INTO rpipe VALUES('r5.1.1', 'dmfd => EADV.[icd_E08%,icd_E09%,icd_E10%,icd_E11%,icd_E14%,T89%,T90%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.2', 'htnfd => EADV.[icd_T89%,K85%,K86%,K87%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.3', 'cabgfd => EADV.[icd_Z95_1%,K54007].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.4', 'cadfd => EADV.[icd_I20%,icd_I21%,icd_I22%,icd_I23%,icd_I24%,icd_I25%,K74%,K75%,K76%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.5', 'cvafd => EADV.[icd_G46%,K89%,K90%,K91%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.6', 'pvdfd => EADV.[icd_I70%,icd_I71%,icd_I72%,icd_I73%,K92%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.7', 'vhdfd => EADV.[K83%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.8', 'obst => EADV.[icd_E66%,T82%].DT.MIN();');
--    INSERT INTO rpipe VALUES('r5.1.9', 'ckd => EADV.[U99034,U99035,U99036,U99037,U99038,U99039,icd_N18%].DT.LAST();');
--    INSERT INTO rpipe VALUES('r5.1.10', 'lit => EADV.[icd_N20%,U95%].DT.LAST();');
--    INSERT INTO rpipe VALUES('r5.1.11', 'ctifd => EADV.[icd_L00%,icd_L01%,icd_L02%,icd_L03%,icd_L04%,icd_L05%,icd_L06%,icd_L07%,icd_L08%,icd_L09%,icd_M86%,S76%].DT.MIN();');
--    
----    INSERT INTO rpipe VALUES('r5.2', 'dm_icpc => EADV.[T89%,T90%].DT.MAX();');
----    INSERT INTO rpipe VALUES('r5.2.1', 'dm(dm_icd,dm_icpc):{1=1 => GREATEST(COALESCE(dm_icd,dm_icpc))} ;');
----    INSERT INTO rpipe VALUES('r5.3', 'hba1c => EADV.[HBA1C_DFCC].VAL.LAST();');
--    INSERT INTO rpipe VALUES('r6.1.1', 'cga_g(egfrlv,acrlv):{egfrlv>=90 => `G1`},{egfrlv<90 AND egfrlv>=60 => `G2`},{egfrlv<60 AND egfrlv>=45 => `G3A`},{egfrlv<45 AND egfrlv>=30 => `G3B`},{egfrlv<30 AND egfrlv>=15 => `G4`},{egfrlv<15=> `G5`},{=>`NA`};');
--    INSERT INTO rpipe VALUES('r6.1.2', 'cga_a(acrlv):{acrlv<3 => `A1`},{acrlv<30 AND acrlv>=3 => `A2`},{acrlv<300 AND acrlv>=30 => `A3`},{acrlv>300 => `A4`},{=>`NA`}');
--    
--    INSERT INTO rpipe VALUES('7.1.1','rrt_hd_ld(hd_icd,hd_icpc,hd_proc):{hd_icpc is null and hd_icd is null and hd_proc is null =>null},{hd_icpc is not null and hd_icd is not null and hd_proc is not null => greatest(hd_icpc,hd_icd,hd_proc)},{hd_icpc is not null and hd_icd is null and hd_proc is null => hd_icpc},{hd_icpc is null and hd_icd is not null and hd_proc is null => hd_icd},{hd_icpc is null and hd_icd is null and hd_proc is not null => hd_proc},{hd_icpc is null => greatest(hd_icd,hd_proc)},{hd_icd is null => greatest(hd_icpc,hd_proc)},{hd_proc is null => greatest(hd_icd,hd_icpc)},{=>NULL};');
--    INSERT INTO rpipe VALUES('7.1.2','rrt_hd(hd_icd,hd_icpc,hd_proc):{COALESCE(hd_icd,hd_icpc,hd_proc) IS NULL=>0},{=>1}');
--    
--    
--    
--    INSERT INTO rpipe VALUES('7.2.1','rrt_pd_ld(pd_icd,pd_icpc,pd_proc):{pd_icpc is null and pd_icd is null and pd_proc is null =>null},{pd_icpc is not null and pd_icd is not null and pd_proc is not null => greatest(pd_icpc,pd_icd,pd_proc)},{pd_icpc is not null and pd_icd is null and pd_proc is null => pd_icpc},{pd_icpc is null and pd_icd is not null and pd_proc is null => pd_icd},{pd_icpc is null and pd_icd is null and pd_proc is not null => pd_proc},{pd_icpc is null => greatest(pd_icd,pd_proc)},{pd_icd is null => greatest(pd_icpc,pd_proc)},{pd_proc is null => greatest(pd_icd,pd_icpc)},{=>NULL};');
--    INSERT INTO rpipe VALUES('7.2.2','rrt_pd(pd_icd,pd_icpc,pd_proc):{COALESCE(pd_icd,pd_icpc,pd_proc) IS NULL=>0},{=>1}');
--
--    INSERT INTO rpipe VALUES('8.1.1','rrt_cat(hdld,pdld,txld,hhdld):{COALESCE(hdld,pdld,txld,hhdld) IS NULL=>0},{pdld>txld AND pdld>hhdld AND pdld>hdld=>2},{txld>pdld AND txld>hhdld AND txld>hdld=>3},{hhdld>txld AND hhdld>pdld AND hhdld>hdld=>4},{=>1}');

    rman_pckg.parse_rpipe(strsql);

    DBMS_OUTPUT.PUT_LINE(strsql);
    
    DBMS_OUTPUT.PUT_LINE('LEN : ' || LENGTH(strsql));
END;



