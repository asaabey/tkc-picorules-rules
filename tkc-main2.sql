CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK OFF;

DECLARE
--    sqlout      VARCHAR2(32767);
    strsql      VARCHAR2(32767);
    clb         CLOB;
    blockid     varchar2(100);


BEGIN
    DELETE FROM rman_ruleblocks;
    
    clb:='
    
        egfrlv => eGFR;
        acrlv => ACR;
        
        cga_g(egfrlv,acrlv):
            {egfrlv>=90 => `G1`},
            {egfrlv<90 AND egfrlv>=60 => `G2`},
            {egfrlv<60 AND egfrlv>=45 => `G3A`},
            {egfrlv<45 AND egfrlv>=30 => `G3B`},
            {egfrlv<30 AND egfrlv>=15 => `G4`},
            {egfrlv<15=> `G5`},
            {=>`NA`};
            
        cga_a(acrlv):
            {acrlv<3 => `A1`},
            {acrlv<30 AND acrlv>=3 => `A2`},
            {acrlv<300 AND acrlv>=30 => `A3`},
            {acrlv>300 => `A4`},{=>`NA`};
        
    ';
    
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
            
            dmfd => EADV.[icd_E08%,icd_E09%,icd_E10%,icd_E11%,icd_E14%,T89%,T90%].DT.EXISTS();
            dmfd => EADV.[icd_E08%,icd_E09%,icd_E10%,icd_E11%,icd_E14%,T89%,T90%].DT.MIN();
            htnfd => EADV.[icd_T89%,K85%,K86%,K87%].DT.MIN();
            cabgfd => EADV.[icd_Z95_1%,K54007].DT.MIN();
            cadfd => EADV.[icd_I20%,icd_I21%,icd_I22%,icd_I23%,icd_I24%,icd_I25%,K74%,K75%,K76%].DT.MIN();
            cvafd => EADV.[icd_G46%,K89%,K90%,K91%].DT.MIN();
            pvdfd => EADV.[icd_I70%,icd_I71%,icd_I72%,icd_I73%,K92%].DT.MIN();
            vhdfd => EADV.[K83%].DT.MIN();
            obst => EADV.[icd_E66%,T82%].DT.MIN();
            ckd => EADV.[U99034,U99035,U99036,U99037,U99038,U99039,icd_N18%].DT.LAST();
            lit => EADV.[icd_N20%,U95%].DT.LAST();
            ctifd => EADV.[icd_L00%,icd_L01%,icd_L02%,icd_L03%,icd_L04%,icd_L05%,icd_L06%,icd_L07%,icd_L08%,icd_L09%,icd_M86%,S76%].DT.MIN();
            
            
            cga_g(egfrlv,acrlv):{egfrlv>=90 => `G1`},{egfrlv<90 AND egfrlv>=60 => `G2`},{egfrlv<60 AND egfrlv>=45 => `G3A`},{egfrlv<45 AND egfrlv>=30 => `G3B`},{egfrlv<30 AND egfrlv>=15 => `G4`},{egfrlv<15=> `G5`},{=>`NA`};
            cga_a(acrlv):{acrlv<3 => `A1`},{acrlv<30 AND acrlv>=3 => `A2`},{acrlv<300 AND acrlv>=30 => `A3`},{acrlv>300 => `A4`},{=>`NA`};

    
    ';
    
    clb:=rman_pckg.sanitise_clob(clb);
    
    blockid:='ckd-1-2';
    
    INSERT INTO rman_ruleblocks VALUES(blockid, clb,'');
      
    
    rman_pckg.parse_ruleblocks(blockid);
    rman_pckg.parse_rpipe(strsql);
    
    UPDATE rman_ruleblocks SET sqlblock=strsql WHERE blockid=blockid;
    DBMS_OUTPUT.PUT_LINE('--sql block-->' || chr(10) || chr(10) || strsql);
    
    
    
END;



