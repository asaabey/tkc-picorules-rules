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
        iq_uacr => eadv.lab_ua_acr.val.count(0);
        iq_egfr => eadv.lab_bld_egfr_c.val.count(0);
        iq_coding => eadv.[icd_%,icpc_%].dt.count(0);
        
        iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4},
                {least(iq_egfr,iq_uacr)>=2 => 3},
                {least(iq_egfr,iq_uacr)>=1 => 2},
                {iq_egfr>0 or iq_uacr>0 => 1},
                {=>0};
        
        
        /*  egfr metrics */
        egfrlv => eadv.lab_bld_egfr_c.val.last();
        egfrld => eadv.lab_bld_egfr_c.dt.max();
        
        egfrfv => eadv.lab_bld_egfr_c.val.first();
        egfrfd => eadv.lab_bld_egfr_c.dt.min();
        
        egfr_single:{ iq_egfr=1 =>1},{=>0};
        egfr_multiple:{ iq_egfr>1 =>1},{=>0};
        egfr_outdated:{ (sysdate-egfrld>730) =>1},{=>0};
        
        egfr_tspan : {1=1 => egfrld-egfrfd};
        
        
        /*  uacr metrics */
        acrlv => eadv.lab_ua_acr.val.last();
        acrld => eadv.lab_ua_acr.dt.max();
        acr_outdated : {sysdate-acrld > 730 =>1},{=>0};
        
        /*  Check for persistence*/
        
        egfr_3m_n => eadv.lab_bld_egfr_c.val.count(0).where(dt<egfrld-90 and val<60);
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt<acrld-30 and val>3);
        
        pers : {least(egfr_3m_n,acr_3m_n)>0 => 1},{=>0};
        
        
        
        /*  check for egfr assumption violation */
        
        egfr_3m_n2 => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfrld-30);
        egfr_3m_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfrld-30);
        
        egfr_3m_qt : {egfr_3m_n2>=2 => round(egfrlv/egfr_3m_mu,2)};
        
        
        
        /* egfr slope */
        egfr_max_v => eadv.lab_bld_egfr_c.val.max();
        egfr_max_ld => eadv.lab_bld_egfr_c.dt.max().where(val=egfr_max_v);
        egfr_ld_max_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt>egfr_max_ld and dt<egfrld);
        
        egfr_slope2 : {egfrld>egfr_max_ld => round((egfrlv-egfr_max_v)/((egfrld-egfr_max_ld)/365),2)};
        
        egfr_decline : {egfrld - egfr_max_ld>365 and egfr_ld_max_n>2 and egfr_max_v-egfrlv>=20 => 1},{=>0};
        
        egfr_rapid_decline : { egfr_decline=1 and egfr_slope2<-10 =>1},{=>0};
        
                
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
        
        asm_viol_3m : {nvl(egfr_3m_qt,1)>1.2 or nvl(egfr_3m_qt,1)<0.8  => 1},{=> 0};
        
        ckd_stage :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => `1`},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => `2`},
                {cga_g=`G3A` => `3A`},
                {cga_g=`G3B` => `3B`},
                {cga_g=`G4` => `4`},
                {cga_g=`G5` => `5`},
                {=> null};
        
        ckd :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => 1},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => 2},
                {cga_g=`G3A` => 3},
                {cga_g=`G3B` => 4},
                {cga_g=`G4` => 5},
                {cga_g=`G5` => 6},
                {=> 0};
        
        /*  ICPC2+ coding , note that val has to set to ordered rank*/
        dx_ckd0  => eadv.[icpc_u990%].val.last();
        dx_ckd : {1=1 => nvl(dx_ckd0,0)};
        
        dx_ckd_stage :{dx_ckd=1 => `1`},
                {dx_ckd=2 => `2`},
                {dx_ckd=3 => `3A`},
                {dx_ckd=4 => `3B`},
                {dx_ckd=5 => `4`},
                {dx_ckd=6 => `5`},
                {dx_ckd=0=> null};
        
        dx_ckd_diff :{abs(ckd-dx_ckd)>=2 => 1 },{=>0};
        
        
            
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
        dm_micvas_retino => eadv.[icd_e11_3%,icpc_f83002].dt.count(0);
        
        /* Diabetic neuropathy,includes ulcer */
        dm_micvas_neuro => eadv.[icd_e11_4%,icpc_n94012,icpc_s97013].dt.count(0);
        
        dm_micvas :{ greatest(dm_micvas_neuro,dm_micvas_retino)>0 => 1},{=>0};
        
        
        
        dm_vintage_yr_ : { dm_fd is not null => round((sysdate-dm_fd)/365,0)},{=>0};
        
        dm_vintage_cat : { dm_vintage_yr_>=0 and dm_vintage_yr_ <10 => 1 },
                            { dm_vintage_yr_>=10 and dm_vintage_yr_ <20 => 2 },
                            { dm_vintage_yr_>=20=> 3 },{=>0};
        
        dm_longstanding : {dm_vintage_cat>=2 => 1},{=>0};   
        
        
        
        dm : {greatest(dm_icd,dm_icpc,dm_lab,dm_rxn)>0 =>1},{=>0};
        
        dm_dx_code_flag : {dm >=1 and greatest(dm_icd,dm_icpc)>=1 => 1},{dm >=1 and greatest(dm_lab,dm_rxn)>0 =>0};
        
        dm_dx_undiagnosed : {dm_dx_code_flag=0 => 1},{=>0};
        
        dm_type : {dm=1 and dm_type_1>0 => 1},{dm=1 and dm_type_1=0 => 2},{=>0};
        
        dm_dx_code : {dm=1 => (dm*1000 + dm_type*100 + dm_vintage_cat*10 + dm_micvas)},{=>0};
        
        /*  Diabetic glycaemic control */
        hba1c_n_tot => eadv.lab_bld_hba1c_ngsp.dt.count(0);
        hba1c_n_opt0 => eadv.lab_bld_hba1c_ngsp.dt.count().where(val>=6 and val<8);
        
        hba1c_n_opt :{hba1c_n_opt0 is not null => hba1c_n_opt0},{=>0};
        
        n_opt_qt :{hba1c_n_tot>0 => round((hba1c_n_opt/hba1c_n_tot),2)*100};
        
        hba1c_n0 => eadv.lab_bld_hba1c_ngsp.val.last();
        hba1c_n0_dt => eadv.lab_bld_hba1c_ngsp.dt.max();
        
        /*hba1c_n1 => eadv.lab_bld_hba1c_ngsp.val.last(1);*/
        
        n0_st : { hba1c_n0 <6 => 1},
                            { hba1c_n0 >=6 and hba1c_n0 <8 => 2},
                            { hba1c_n0 >=8 and hba1c_n0 <10 => 3},
                            { hba1c_n0 >=10 4};
                            
      
                            
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
    
    
END;





