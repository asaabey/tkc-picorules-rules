CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
    rb.blockid:='comorb-1-1';
    rb.target_table:='rout_comorb';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        
            dmfdex => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%,icpc_t89%,icpc_t90%].dt.exists();
            
            dmfd => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%,icpc_t89%,icpc_t90%].dt.min();
            
            htnfd => eadv.[icd_t89%,icpc_k85%,icpc_k86%,icpc_k87%].dt.min();
            cabgfd => eadv.[icd_z95_1%,icpc_k54007].dt.MIN();
            
            cadfd => eadv.[icd_i20%,icd_i21%,icd_i22%,icd_i23%,icd_i24%,icd_i25%,icpc_k74%,icpc_k75%,icpc_k76%].dt.min();
            
            cvafd => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min();
            pvdfd => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.MIN();
            vhdfd => eadv.[icpc_k83%].dt.min();
            obst => eadv.[icd_e66%,icpc_t82%].dt.min();
            ckd => eadv.[icpc_u99034,icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99038,icpc_u99039,icd_n18%].dt.last();
            lit => eadv.[icd_n20%,icpc_u95%].dt.last();
            /*
            ctifd => eadv.[icd_l00%,icd_l01%,icd_l02%,icd_l03%,icd_l04%,icd_l05%,icd_l06%,icd_l07%,icd_l08%,icd_l09%,icd_m86%,icpc_s76%].dt.min();
            */
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);
        
    -- END OF RULEBLOCK --
    

    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd-qa-dx-iq-1-1';
    rb.target_table:='rout_ckd_qa_dx_iq';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
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

    -- END OF RULEBLOCK --
    
 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4410';
    rb.target_table:='rout_tg4410';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephrotic syndrome */
        
        /*  Calculate information quotient */
        
        iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-365);
        iq_egfr => eadv.lab_bld_egfr.val.count(0).where(dt>sysdate-365);
        iq_alb => eadv.lab_bld_albumin.val.count(0).where(dt>sysdate-365);
        iq_chol => eadv.lab_bld_cholesterol_total.val.count(0).where(dt>sysdate-365);
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-365);
        iq_ana => eadv.lab_bld_ana.val.count(0).where(dt>sysdate-(365*5));
        iq_spep => eadv.lab_bld_ana.val.count(0).where(dt>sysdate-(365*5));
        
        iq_tier :
                {iq_uacr>=2 and least(iq_egfr,iq_alb,iq_chol,iq_sbp,iq_ana,iq_spep)>1 => 4},
                {iq_uacr>=2 and least(iq_egfr,iq_alb,iq_chol,iq_sbp,0)>1 => 3},
                {iq_uacr>=2 and least(iq_egfr,iq_alb)>1 => 2},
                {iq_uacr>=2 and iq_alb>1 => 1},
                {=>0};
        
        
        /*  Exclusions */
        /*  Exclude rrt */
        
        hd_dt => eadv.[caresys_13100_00,icpc_u59001,icpc_u59008,icd_z49_1].dt.max(); 
        pd_dt => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.max();
        tx_dt => eadv.[icpc_u28001,icd_z94%].dt.max();
        hhd_dt => eadv.[icpc_u59j99].dt.max();
        
        egfr => eadv.lab_bld_egfr.val.last().where(dt>sysdate-365);
        
        rrt : {coalesce(hd_dt,pd_dt,tx_dt,hhd_dt) is null=>0},{=>1};
        
        /*  Exclude dm */
        
        
        
        dm => rout_cd_dm.dm.val.bind();
        
        /*  Exclude previously diagnosed nephrotic syndromes from coding */
        
        dx_nephrotic => eadv.[icd_n04%].dt.count(0);
        
        /*  Exclude if renal encounters present */
        
        enc_ren => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
                
        ex_flag :{greatest(rrt,dm,enc_ren,dx_nephrotic)>0 => 1},{=>0};
        
        /*  Inclusion   */
        
        uacr_n => eadv.lab_ua_acr.dt.count(0).where(val>300 and dt>sysdate-365);
        
        uacr1 => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        uacr2 => eadv.lab_ua_acr.val.last(1).where(dt>sysdate-365);
        
        uacr_log_delta : {uacr1>0 and uacr2>0 => round(log(10,uacr1)-log(10,uacr2),1)};
        
        alb1 => eadv.lab_bld_albumin.val.last().where(dt>sysdate-365);
        
        alb2 => eadv.lab_bld_albumin.val.last(1).where(dt>sysdate-365);
        
        chol1 => eadv.lab_bld_cholesterol_total.val.last(1).where(dt>sysdate-365);
        
        /*alb_delta(alb1,alb2):{}*/
        
        low_alb : {nvl(alb1,0)<30=>1},{=>0};
        high_chol : {nvl(chol1,0)>7=>1},{=>0};
        
        
                
        tg4410 : {ex_flag=0 and uacr1>300 and uacr2>300 and uacr_log_delta>-0.1 => 1 };
        
        
        pl_para1 : {uacr1>300 and uacr2>300 and uacr_log_delta>-0.1=>1},{=>0};
        
        
        pl_para2:
                {pl_para1=1 and low_alb=1 and high_chol=0 => 1},
                {pl_para1=1 and low_alb=1 and high_chol=1 => 2},
                {=>0};
        
        pl_para3 :{pl_para1=1 and iq_tier>=3 => 2},{pl_para1=1 and iq_tier>=2 => 1},{=>0};
        
        
        tg4100_code :
                    {pl_para1=1 and pl_para2=1 and pl_para3=1 => `de31001.de31011.de31031`},
                    {pl_para1=1 and pl_para2=2 and pl_para3=1 => `de31001.de31012.de31031`},
                    {pl_para1=1 and pl_para2=1 and pl_para3=2 => `de31001.de31011.de31032` },
                    {pl_para1=1 and pl_para2=2 and pl_para3=2 => `de31001.de31012.de31032` };
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dx_egfr';
    rb.target_table:='rout_dx_egfr';
    rb.environment:='TEST';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
       
        egfr_old => eadv.lab_bld_egfr.val.last();
        
        egfr_old_dt => eadv.lab_bld_egfr.dt.max();
        
        creat =>eadv.lab_bld_creatinine.val.last();
        creat_dt =>eadv.lab_bld_creatinine.dt.max();
        
        egfr_new => eadv.lab_bld_egfr_c.val.last();
        
        egfr_new_dt => eadv.lab_bld_egfr_c.dt.max();
        
        qt(egfr_old,egfr_new):{egfr_new>0 => egfr_old/egfr_new};
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt-2-1';
    rb.target_table:='rout_rrt';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to calculate dx information quantity*/

        hd_dt => eadv.[caresys_13100_00,icpc_u59001,icpc_u59008,icd_z49_1].dt.max(); 
        pd_dt => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.max();
        tx_dt => eadv.[icpc_u28001,icd_z94%].dt.max();
        hhd_dt => eadv.[icpc_u59j99].dt.max();
        
        rrt:{coalesce(hd_dt,pd_dt,tx_dt,hhd_dt) is null=>0},{=>1};
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd-2-1';
    rb.target_table:='rout_ckd';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to stage CKD */

        /*  External bindings    */
        rrt => rout_rrt.rrt.val.bind();
        
        /* calculate dx information quantity*/
        iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-730);
        iq_egfr => eadv.lab_bld_egfr_c.val.count(0).where(dt>sysdate-730);
        iq_coding => eadv.[icd_%,icpc_%].dt.count(0);
        
        iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4},
                {least(iq_egfr,iq_uacr)>=2 => 3},
                {least(iq_egfr,iq_uacr)>=1 => 2},
                {iq_egfr>0 or iq_uacr>0 => 1},
                {=>0};
        
        
        /*  egfr  uacr metrics */
        egfrlv => eadv.lab_bld_egfr_c.val.last().where(dt>sysdate-730);
        egfrld => eadv.lab_bld_egfr_c.dt.max().where(dt>sysdate-730);
        
        acrlv => eadv.lab_ua_acr.val.last().where(dt>sysdate-730);
        acrld => eadv.lab_ua_acr.dt.max().where(dt>sysdate-730);
        
        
        /*  Check for persistence*/
        
        egfr_3m_n => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfrld-90 and val<60);
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt>acrld-90 and val>3);
        
        pers : {least(egfr_3m_n,acr_3m_n)>0 => 1};
        
        
        
        /*  check for egfr assumption violation */
        egfr_3m_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt>egfrld-30);
        
        egfr_3m_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfrld-30);
        
        egfr_3m_qt : {egfr_3m_n>2 => round(egfrlv/egfr_3m_mu,2)};
        
        egfrfv => eadv.lab_bld_egfr_c.val.first();
        egfrfd => eadv.lab_bld_egfr_c.dt.min();
        
        /* egfr slope */
        egfr_max_v => eadv.lab_bld_egfr_c.val.max();
        egfr_max_fd => eadv.lab_bld_egfr_c.dt.min().where(val=egfr_max_v);
        
        
        egfr_slope : {egfrld-egfrfd>=365 => round((egfrlv-egfrfv)/((egfrld-egfrfd)/365),2)};
        
       
        
                
        /*  Apply KDIGO 2012 staging    */
        
        cga_g:  {egfrlv>=90 AND rrt=0 => `G1`},
                {egfrlv<90 AND egfrlv>=60  AND rrt=0 => `G2`},
                {egfrlv<60 AND egfrlv>=45  AND rrt=0 => `G3A`},
                {egfrlv<45 AND egfrlv>=30  AND rrt=0 => `G3B`},
                {egfrlv<30 AND egfrlv>=15  AND rrt=0 => `G4`},
                {egfrlv<15 AND rrt=0 => `G5`},
                {=>`NA`};
            
        cga_a: {acrlv<3 => `A1`},
                {acrlv<30 AND acrlv>=3 => `A2`},
                {acrlv<300 AND acrlv>=30 => `A3`},
                {acrlv>300 => `A4`},{=>`NA`};
        
        asm_viol_3m_n : {egfr_3m_n>2 => 1},{=> 0};
        
        ckd_stage :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => `1`},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => `2`},
                {cga_g=`G3A` => `3A`},
                {cga_g=`G3B` => `3B`},
                {cga_g=`G4` => `4`},
                {cga_g=`G5` => `5`},
                {=> null};
        ckd_b: {ckd_stage is null => false},{=> true};
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4420';
    rb.target_table:='rout_tg4420';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect nephritic syndrome */
        
        /*  Calculate information quotient */
        
        iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-365);
        iq_egfr => eadv.lab_bld_egfr.val.count(0).where(dt>sysdate-365);
        iq_urbc => eadv.lab_ua_rbc.val.count(0).where(dt>sysdate-365);
        iq_uleu => eadv.lab_ua_leucocytes.val.count(0).where(dt>sysdate-365);
        
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-365);
        
        iq_ana => eadv.lab_bld_ana.val.count().where(dt>sysdate-(365*5));
        iq_anca => eadv.[lab_bld_anca_pr3,lab_bld_anca_mpo].val.count(0).where(dt>sysdate-(365*5));
        iq_comp => eadv.[lab_bld_complement_c3,lab_bld_complement_c4].val.count(0).where(dt>sysdate-(365*5));
        
        /*  Exclusions */
         /*  External bindings    */
        rrt => rout_rrt.rrt.val.bind();
        
        
        /*  Exclude previously diagnosed nephrotic syndromes from coding */
        
        dx_nephritic => eadv.[icd_n0%].dt.count(0);
        
        /*  Exclude if renal encounters present */
        
        enc_ren => eadv.enc_op_renal.dt.count(0).where(dt>sysdate-365);
        
                
        ex_flag:{greatest(rrt,enc_ren,dx_nephritic)>0 => 1},{=>0};
        
        /*  Inclusion   */
        
        /*  Urine analysis */        
        
        ua_rbc => eadv.lab_ua_rbc.val.last().where(dt>sysdate-365);
        
        ua_leu => eadv.lab_ua_leucocytes.val.last().where(dt>sysdate-365);
        
        ua_acr => eadv.lab_ua_acr.val.last().where(dt>sysdate-365);
        
        
        
        t4420_code : {ua_rbc>100 and ua_leu<40 and ua_acr>30 => 2},
                    {ua_rbc>100 and ua_leu<40 => 1},    
                    {=>0};
        
        t4410 : {t4420_code>=2 => 1},{=>0};            
        
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm_2';
    rb.target_table:='rout_cd_dm';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect chronic disease entities */
        
        /*  Calculate iq    */
        iq_hba1c => eadv.lab_bld_hba1c_ngsp.val.count(0).where(dt>sysdate-730);
        
        iq_tier : {iq_hba1c>1 => 2},{iq_hba1c>0 => 1},{=>0};
        
        /*  Diabetes diagnosis*/
        /*  Code criteria   */
        dm_icd => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%].dt.count(0);
        
        dm_icpc => eadv.[icpc_t89%,icpc_t90%].dt.count(0);
        
        dm_code_fd => eadv.[icd_e08%,icd_e09%,icd_e10%,icd_e11%,icd_e14%,icpc_t89%,icpc_t90%].dt.min();
        
        
        /*  Lab criteria   */
        dm_lab => eadv.lab_bld_hba1c_ngsp.val.count(0).where(val>65/10);
        dm_lab_fd => eadv.lab_bld_hba1c_ngsp.dt.min().where(val>65/10);
        
        /*  Rxn cirteria   */
        dm_rxn => eadv.[rxn_cls_atc_a10%].dt.count(0).where(val=1);
        
        
        
        dm_fd :{coalesce(dm_code_fd,dm_lab_fd) is not null => 
                    (least(nvl(dm_code_fd,to_date(`29991231`,`YYYYMMDD`)),
                    nvl(dm_lab_fd,to_date(`29991231`,`YYYYMMDD`))))};
        
        dm_fd_t :{ 1=1 => to_char(dm_fd,`YYYY`)};

        dm_type_1 => eadv.[icpc_t89%].dt.count(0);
        
        /*  Diabetic complications */
        /* Diabetic retinopathy */
        dm_micvas_retino_ => eadv.[icd_e11_3%,icpc_f83002].dt.count(0);
        
        /* Diabetic neuropathy,includes ulcer */
        dm_micvas_neuro_ => eadv.[icd_e11_4%,icpc_n94012,icpc_s97013].dt.count(0);
        
        dm_micvas :{ greatest(dm_micvas_neuro_,dm_micvas_retino_)>0 => 1},{=>0};
        
        dm_micvas_t :{ dm_micvas=0 => `no`},{dm_micvas=1=>`documented`};
        
        dm_vintage_yr_ : { dm_fd is not null => round((sysdate-dm_fd)/365,0)},{=>0};
        
        dm_vintage_cat : { dm_vintage_yr_>=0 and dm_vintage_yr_ <10 => 1 },
                            { dm_vintage_yr_>=10 and dm_vintage_yr_ <20 => 2 },
                            { dm_vintage_yr_>=20=> 3 },{=>0};
        
        dm_longstanding_t : {dm_vintage_cat>=2 => `longstanding`},{=>` `};   
        
        
        
        dm : {greatest(dm_icd,dm_icpc,dm_lab,dm_rxn)>0 =>1},{=>0};
        
        dm_dx_code_flag : {dm >=1 and greatest(dm_icd,dm_icpc)>=1 => 1},{dm >=1 and greatest(dm_lab,dm_rxn)>0 =>0};
        
        dm_dx_code_t : {dm_dx_code_flag=1 => `Diagnosed`},{dm_dx_code_flag=0 =>`Undiagnosed`};
        
        dm_type : {dm=1 and dm_type_1>0 => 1},{dm=1 and dm_type_1=0 => 2},{=>0};
        
        dm_dx_code : {dm=1 => (dm*1000 + dm_type*100 + dm_vintage_cat*10 + dm_micvas)},{=>0};
        
        /*  Diabetic glycaemic control */
        hba1c_n_tot => eadv.lab_bld_hba1c_ngsp.dt.count(0);
        hba1c_n_opt => eadv.lab_bld_hba1c_ngsp.dt.count(0).where(val>=6 and val<8);
        
        n_opt_qt :{hba1c_n_tot>0 => round((hba1c_n_opt/hba1c_n_tot),2)*100};
        
        hba1c_n0 => eadv.lab_bld_hba1c_ngsp.val.last();
        hba1c_n0_dt => eadv.lab_bld_hba1c_ngsp.dt.max();
        
        /*hba1c_n1 => eadv.lab_bld_hba1c_ngsp.val.last(1);*/
        
        n0_st : { hba1c_n0 <6 => 1},
                            { hba1c_n0 >=6 and hba1c_n0 <8 => 2},
                            { hba1c_n0 >=8 and hba1c_n0 <10 => 3},
                            { hba1c_n0 >=10 4};
                            
        n0_st_t : { n0_st=1 => `too tight (<6)`},
                            { n0_st=2 => `optimal (6-8)`},
                            { n0_st=3 => `sub-optimal (8-10)`},
                            { n0_st=4 => `very sub-optimal (>10)`};
                            
        /*hba1c_trend :{nvl(hba1c_n0,0)>nvl(hba1c_n1,0)=> 1},{nvl(hba1c_n0,0)<nvl(hba1c_n1,0)=> -1},{=>0};*/
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK 
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_htn_2';
    rb.target_table:='rout_cd_htn';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect hypertension  */
        
        /*  Calculate iq    */
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-730);
        
        iq_tier : {iq_sbp>1 => 2},{iq_sbp>0 => 1},{=>0};
        
        /*  Hypertension diagnosis*/
        /*  Code criteria   */
        htn_icd => eadv.[icd_i10_%,icd_i15_%].dt.count(0);
        htn_icpc => eadv.[icpc_k85%,icpc_k86%,icpc_k87%].dt.count(0);
        
        /*  Observation criteria    */
        htn_obs => eadv.obs_bp_systolic.val.count(0).where(val>140);
        
        /*  Rxn cirteria   */
        htn_rxn_acei => eadv.[rxn_cls_atc_c09%].dt.count(0).where(val=1);
        htn_rxn_bb => eadv.[rxn_cls_atc_c07%].dt.count(0).where(val=1);
        htn_rxn_ccb => eadv.[rxn_cls_atc_c08%].dt.count(0).where(val=1);
        htn_rxn_c02 => eadv.[rxn_cls_atc_c02%].dt.count(0).where(val=1);
        
        htn_rxn : { least(htn_rxn_acei,htn_rxn_bb,htn_rxn_ccb,htn_rxn_c02)>0 =>1 },{=>0};
        
        /*  Vintage */
        htn_fd => eadv.[icd_i10_%,icd_i15_%,icpc_k85%,icpc_k86%,icpc_k87%].dt.min();
        
        htn_type_2 => eadv.[icd_i15_%].dt.count(0);
        
        
        /*  Hypertension complications */
        
        htn_vintage_yr_ : { htn_fd is not null => round((sysdate-htn_fd)/365,0)},{=>0};
        
        htn_vintage_cat : { htn_vintage_yr_>=0 and htn_vintage_yr_ <10 => 1 },
                            { htn_vintage_yr_>=10 and htn_vintage_yr_ <20 => 2 },
                            { htn_vintage_yr_>=20=> 3 },{=>0};
        
        htn : {greatest(htn_icd,htn_icpc,htn_obs,htn_rxn)>0 =>1},{=>0};
        
        htn_type : {htn=1 and htn_type_2>0 => 1},{htn=1 and htn_type_2=0 => 2},{=>0};
        
        htn_dx_code : {htn=1 => (htn*1000 + htn_type*100 + htn_vintage_cat*10 )},{=>0};
        
        /*  Bp control */
        sigma_2 => eadv.obs_bp_systolic.val.count(0).where(dt>=sysdate-730 and dt<sysdate-365); 
        slice140_2_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        
        sigma_1 => eadv.obs_bp_systolic.val.count(0).where(dt>=sysdate-365); 
        slice140_1_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-365);
        slice140_1_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-365);
        
        n_qt_2 : {sigma_2>0 => round(slice140_2_n/sigma_2,1)};
        n_qt_1 : {sigma_1>0 => round(slice140_1_n/sigma_1,1)};
        
        mu_qt : {slice140_2_mu>0 =>round(slice140_1_mu/slice140_2_mu,2)};
        
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4100';
    rb.target_table:='rout_tg4100';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI trigger   */
        
        /*  Exclusions  */  
          rrt => rout_rrt.rrt.val.bind(); 
          
          
          cr_n => eadv.lab_bld_creatinine.dt.count(); 
          cr_fd => eadv.lab_bld_creatinine.dt.min(); 
          cr_ld => eadv.lab_bld_creatinine.dt.max(); 
          cr_span_days : {1=1 => cr_ld-cr_fd}; 
          cr_tail_days : {1=1 => ROUND(SYSDATE-cr_ld,0)}; 
          
          
          /* Minima, Maxima and last */
          cr_lv => eadv.lab_bld_creatinine.val.last().where(dt>sysdate-365); 
          cr_max_1y => eadv.lab_bld_creatinine.val.max().where(dt>sysdate-365); 
          cr_min_1y => eadv.lab_bld_creatinine.val.min().where(dt>sysdate-365);
          
          
          /* Date of event and window */
          cr_max_ld_1y => eadv.lab_bld_creatinine.dt.max().where(val=cr_max_1y and dt>sysdate-365); 
          win_lb : {1=1 => cr_max_ld_1y-30 };
          win_ub : {1=1 => cr_max_ld_1y+30 };
          
          
          /* Determine true baseline */
          cr_avg_2y => eadv.lab_bld_creatinine.val.avg().where(val<cr_max_1y and val>cr_min_1y and dt>sysdate-730);
          cr_avg_min_1y_qt : {cr_avg_2y is not null => round(cr_min_1y/cr_avg_2y,1) };
          cr_base : {cr_avg_min_1y_qt<0.5 => cr_avg_2y},{=>cr_min_1y};
          
          
          /* Calculate proportion */
          cr_base_max_1y_qt : {cr_base is not null => round(cr_max_1y/cr_base,1) };
          cr_base_lv_1y_qt : {cr_base is not null => round(cr_lv/cr_base,1) };
          cr_max_lv_1y_qt : {cr_lv is not null => round(cr_max_1y/cr_lv,1) };
          
          
          akin_stage : {cr_base_max_1y_qt>2 => 3 },{cr_base_max_1y_qt>1.5 => 2 };
          
          aki_outcome : {akin_stage>=1 and cr_max_lv_1y_qt>=1 and cr_max_lv_1y_qt<1.2 => 3 },
                        {akin_stage>=1 and cr_max_lv_1y_qt>=1.2 and cr_max_lv_1y_qt<1.7 => 2},
                        {akin_stage>=1 and cr_max_lv_1y_qt>=1.7 => 1};  
          
          tg4100 : {akin_stage>=2 and aki_outcome>=2 => 1},{=>0};
          
          tg4100_code : {tg4100=1 => (akin_stage*1000)+(aki_outcome*100)};
                        
          
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4110';
    rb.target_table:='rout_tg4110';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate AKI from coding   */
        
        aki_icd => eadv.[icd_n17%].dt.count(0).where(dt>sysdate-180);
          
          
          
        tg4110 : {aki_icd>0 => 1},{=>0};
          
        tg4110_code : {1=1=> 1};
                        
          
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4610';
    rb.target_table:='rout_tg4610';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD23 10 pa   */
        
        ckd_stage => rout_ckd.cga_g.val.bind();
        
        eb => rout_ckd.egfr_slope.val.bind();
          
        
          
        tg4610 : {ckd_stage in (`G2`,`G1`) and nvl(eb,0)<-5 => 1},{=>0};
          
        tg4610_code : {1=1=> 0};
                        
          
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='tg4620';
    rb.target_table:='rout_tg4620';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to generate CKD45 10 pa   */
        
        ckd_stage => rout_ckd.cga_g.val.bind();
        
        eb => rout_ckd.egfr_slope.val.bind();
          
        
          
        tg4620 : {ckd_stage in (`G3b`,`G4`,`G5`) and nvl(eb,0)<-5 => 1},{=>0};
          
        tg4620_code : {1=1=> 0};
                        
          
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock);

    -- END OF RULEBLOCK --
END;





