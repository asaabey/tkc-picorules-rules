CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    DELETE FROM rman_ruleblocks;
    
    
    rb.blockid:='ckd-1-2';
    rb.target_table:='rout_ckd';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.picoruleblock:='
    
        egfrlv => eGFR;
        egfrld => EADV.eGFR.DT.MAX();
        
        egfr_count_6m(egfrld) => EADV.eGFR.DT.COUNT().WHERE(DT>egfrld-180);
        egfr_count => EADV.eGFR.DT.COUNT();
        
        rrt => ROUT_RRT.RRT.VAL.BIND();
        
        acrlv => ACR;
        
        cga_g(egfrlv,acrlv,rrt):
            {egfrlv>=90 AND rrt=0 => `G1`},
            {egfrlv<90 AND egfrlv>=60  AND rrt=0 => `G2`},
            {egfrlv<60 AND egfrlv>=45  AND rrt=0 => `G3A`},
            {egfrlv<45 AND egfrlv>=30  AND rrt=0 => `G3B`},
            {egfrlv<30 AND egfrlv>=15  AND rrt=0 => `G4`},
            {egfrlv<15 OR rrt=1 => `G5`},
            {=>`NA`};
            
        cga_a(acrlv):
            {acrlv<3 => `A1`},
            {acrlv<30 AND acrlv>=3 => `A2`},
            {acrlv<300 AND acrlv>=30 => `A3`},
            {acrlv>300 => `A4`},{=>`NA`};
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);
    
    rb.blockid:='comorb-1-1';
    rb.target_table:='rout_comorb';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.picoruleblock:='
    
        
            dmfdex => EADV.[icd_E08%,icd_E09%,icd_E10%,icd_E11%,icd_E14%,T89%,T90%].DT.EXISTS();
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
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);
    
    rb.blockid:='rrt-1-1';
    rb.target_table:='rout_rrt';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.picoruleblock:='
    
        
            hd_icd => EADV.[icd_Z49_1].DT.MAX();
            hd_icpc => EADV.[U59001,U59008].DT.MAX();
            hd_proc => EADV.[13100-00].DT.MAX();
            
            hd_dt => EADV.[13100-00,U59001,U59008,icd_Z49_1].DT.MAX();
                       
            
            pd_icpc => EADV.[U59007,U59009].DT.MAX();
            pd_icd => EADV.[icd_Z49_2].DT.MAX();
            pd_proc => EADV.[13100-06,13100-07,13100-08].DT.MAX();
            
            pd_dt => EADV.[13100-06,13100-07,13100-08,U59007,U59009,icd_Z49_2].DT.MAX();
             
            tx_icpc => EADV.[U28001].DT.MAX();
            tx_icd => EADV.[icd_Z94%].DT.MAX();
            tx_proc => EADV.[13100-06,13100-07,13100-08].DT.MAX();
            
            tx_dt => EADV.[U28001,icd_Z94%].DT.MAX();
            
            hhd => EADV.[U59J99].DT.MAX();
            
            hhd_dt => EADV.[U59J99].DT.MAX();
            
            rrt(hd_dt,pd_dt,tx_dt,hhd_dt):{COALESCE(hd_dt,pd_dt,tx_dt,hhd_dt) IS NULL=>0},
                                            {=>1};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);
        
    rb.blockid:='ckd-qa-dx-iq-1-1';
    rb.target_table:='rout_ckd_qa_dx_iq';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.picoruleblock:='
    
        /* Rule block to calculate dx information quantity*/

        egfr2_c => EADV.eGFR.VAL.COUNT().WHERE(DT>SYSDATE-365*2);
        
        egfr2_1_dt => EADV.eGFR.DT.MIN().WHERE(DT>SYSDATE-365*2);
        
        egfr2_2_dt => EADV.eGFR.DT.MAX().WHERE(DT>SYSDATE-365*2);
        
        hba1c_c => EADV.[HBA1C_DFCC].VAL.COUNT().WHERE(DT>SYSDATE-365*5);
        
        sbp_c => EADV.[SYSTOLIC].VAL.COUNT().WHERE(DT>SYSDATE-365*5);
        
        lab_ua_rbc_c => EADV.[lab_ua_rbc].DT.COUNT();
        
        icd_n18_c => EADV.[U99034,U99035,U99036,U99037,U99038,U99039,icd_N18%].DT.COUNT();
        
        /* gap between first and last at least 6 months */
        
        egfr6m_gap(egfr2_1_dt,egfr2_2_dt):{(egfr2_2_dt-egfr2_1_dt>182)=>1};
        
        uacr2 => EADV.ACR.VAL.COUNT().WHERE(DT>SYSDATE-365*2);
        
        tier1_grade(egfr2_c,uacr2,egfr6m_gap):{egfr2_c>2 AND uacr2>1 AND egfr6m_gap=1 => 3},
                        {egfr2_c>1 AND uacr2>1 => 2},
                        {egfr2_c>0 OR uacr2>0 => 1};
                        
        tier2_grade(sbp_c,hba1c_c):{sbp_c>2 AND hba1c_c>0 => 3},
                        {sbp_c>1 AND hba1c_c>0 => 2},
                        {sbp_c>0 OR hba1c_c>0=> 1};
              
                    
        tier3_grade(lab_ua_rbc_c,icd_n18_c):{lab_ua_rbc_c>0 OR icd_n18_c>0 => 1};
                        
                        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

  
    
    
    
END;



