CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
    rb.blockid:='comorb_1_1';
    rb.target_table:='rout_comorb';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=0 ;
    rb.def_exit_prop:='';
    rb.def_predicate:='';
    
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
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,1);
        
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm';
    rb.target_table:='rout_cd_dm';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='dm';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to detect chronic disease entities */
        
        
        cp_lv => eadv.careplan_h9_v1.val.last();
        
        cp_ld => eadv.careplan_h9_v1.dt.max();
        
        cp_dm : {cp_lv is not null => to_number(substr(to_char(cp_lv),-6,1))},{=>0};
        
        cp_dm_ld : {cp_dm>0 => cp_ld};
        
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
        
        dm_rxn => eadv.[rxnc_a10%].dt.count(0).where(val=1);
        dm_rxn_su => eadv.[rxnc_a10bb].dt.count(0).where(val=1);
        dm_rxn_ins_long => eadv.[rxnc_a10ae].dt.count(0).where(val=1);
        dm_rxn_ins_int => eadv.[rxnc_a10ac].dt.count(0).where(val=1);
        dm_rxn_ins_mix => eadv.[rxnc_a10ad].dt.count(0).where(val=1);
        dm_rxn_ins_short => eadv.[rxnc_a10ab].dt.count(0).where(val=1);
        dm_rxn_bg => eadv.[rxnc_a10ba].dt.count(0).where(val=1);
        dm_rxn_dpp4 => eadv.[rxnc_a10bh].dt.count(0).where(val=1);
        dm_rxn_glp1 => eadv.[rxnc_a10bj].dt.count(0).where(val=1);
        dm_rxn_sglt2 => eadv.[rxnc_a10bk].dt.count(0).where(val=1);
               
        
        
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
        
        hba1c_n_tot0 => eadv.lab_bld_hba1c_ngsp.dt.count();
        hba1c_n_opt0 => eadv.lab_bld_hba1c_ngsp.dt.count().where(val>=6 and val<8);
        
        hba1c_n_opt :{hba1c_n_opt0 is not null => hba1c_n_opt0},{=>0};
        
        hba1c_n_tot : {hba1c_n_tot0 is not null => hba1c_n_tot0},{=>0};
        
        n_opt_qt :{hba1c_n_tot>0 => round((hba1c_n_opt/hba1c_n_tot),2)*100};
        
        
        
        hba1c_n0 => eadv.lab_bld_hba1c_ngsp.val.lastdv();
        
        
        
        n0_st : { hba1c_n0_val <6 => 1},
                            { hba1c_n0_val >=6 and hba1c_n0_val <8 => 2},
                            { hba1c_n0_val >=8 and hba1c_n0_val <10 => 3},
                            { hba1c_n0_val >=10 =>4},{=>0};
                            
      
                            
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,2);
    
    -- END OF RULEBLOCK 
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_htn';
    rb.target_table:='rout_cd_htn';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='htn';
    rb.def_predicate:='>0';
    
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
        htn_icpc0 => eadv.[icpc_k85%,icpc_k86%,icpc_k87%].dt.count();
        htn_icpc : {htn_icpc0 is not null=>1},{=>0};
        
        /*  Observation criteria    */
        htn_obs => eadv.obs_bp_systolic.val.count(0).where(val>140);
        
        /*  Rxn cirteria   */
        htn_rxn_acei => eadv.[rxnc_c09aa].dt.count().where(val=1);
        htn_rxn_arb => eadv.[rxnc_c09ca].dt.count().where(val=1);
        htn_rxn_bb => eadv.[rxnc_c07%].dt.count().where(val=1);
        htn_rxn_ccb => eadv.[rxnc_c08%].dt.count().where(val=1);
        htn_rxn_c02 => eadv.[rxnc_c02%].dt.count().where(val=1);
        htn_rxn_diuretic_thiaz => eadv.[rxnc_c03aa].dt.count().where(val=1);
        htn_rxn_diuretic_loop => eadv.[rxnc_c03c%].dt.count().where(val=1);
        
        htn_rxn : { coalesce(htn_rxn_acei, htn_rxn_arb, htn_rxn_bb, htn_rxn_ccb , htn_rxn_c02 , htn_rxn_diuretic_thiaz , htn_rxn_diuretic_loop) is not null =>1 },{=>0};
        
        /*  Vintage */
        htn_fd_code => eadv.[icd_i10_%,icd_i15_%,icpc_k85%,icpc_k86%,icpc_k87%].dt.min();
        htn_fd_obs => eadv.obs_bp_systolic.dt.min().where(val>140);
        
        htn_fd : {coalesce(htn_fd_code,htn_fd_obs) is not null => least(nvl(htn_fd_code,to_date(`01012999`,`DDMMYYYY`)),nvl(htn_fd_obs,to_date(`01012999`,`DDMMYYYY`)))};
        
        htn_fd_yr : { htn_fd is not null => to_char(htn_fd,`YYYY`) };
        
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
        mu_2 => eadv.obs_bp_systolic.val.avg().where(dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        
        sigma_1 => eadv.obs_bp_systolic.val.count(0).where(dt>=sysdate-365); 
        mu_1 => eadv.obs_bp_systolic.val.avg().where(dt>=sysdate-365); 
        slice140_1_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-365);
        slice140_1_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-365);
        
        
        /* Time in therapeutic range */
        n_qt_1 : {sigma_1>0 => 1-round(slice140_1_n/sigma_1,1)};
        
        mu_qt : {slice140_2_mu>0 =>round(slice140_1_mu/slice140_2_mu,2)};
        
        bp_trend : { mu_qt <0.9 => 1 },{ mu_qt > 1.1 => 2},{=>0};
        
        bp_control : { n_qt_1 >=0.75 => 3},{ n_qt_1<0.75 and n_qt_1>=0.25 => 2 },{ n_qt_1<0.25 => 1},{=>0};
        
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,1);
    
    -- END OF RULEBLOCK --
    

   -- BEGINNING OF RULEBLOCK --
    
    rb.blockid:='careplan';
    rb.target_table:='rout_' || rb.blockid;
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='careplan';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /*  Careplan analyser */
        
        
        cp_l => eadv.careplan_h9_v1.val.lastdv();
        
        cp_cs : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-1,1))},{=>0};
        
        cp_ckd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_dm : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-6,1))},{=>0};
        
        cp_cvd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-7,1))},{=>0};
        
        cp_hicvr : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-8,1))},{=>0};
        
        careplan : {1=1 => cp_cs};
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,1);
        
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac';
    rb.target_table:='rout_cd_cardiac';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='cardiac';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac disease  */
        
            
            /* coronary insufficiency */
            cabg => eadv.[icd_z95_1%,icpc_k54007].dt.MIN();
            
            cad_mi_icd => eadv.[icd_i21%,icd_i22%,icd_i23%].dt.min();
            
            cad_chronic_icd => eadv.[icd_i24%,icd_i25%].dt.min();
            
            cad_ihd_icpc => eadv.[icpc_k74%,icpc_k75%,icpc_k76%].dt.min();        
                     
            
            /* valvular heart disease */
            
            vhd_mv_icd => eadv.[icd_i34_%,icd_i05%].dt.min();
            
            vhd_av_icd => eadv.[icd_i35_%,icd_i06%].dt.min();
            
            vhd_ov_icd => eadv.[icd_i07%,icd_i08%,icd_i09%,icd_i36%,icd_i37%].dt.min();
            
            vhd_ie_icd => eadv.[icd_i33%,icd_i38%,icd_i39%].dt.min();
            
            vhd_icpc => eadv.[icpc_k83%].dt.min();
            
            
            /*  Other atherosclerotic disease */
            
            cva => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min();
            
            pvd => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.min();
            
            
            /* Medication */
            /*  antiplatelet agents */
            
            rxn_ap => eadv.[rxnc_b01ac].dt.min().where(val=1);
            
            /*  anticoagulation */
            
            rxn_anticoag => eadv.[rxnc_b01aa,rxnc_b01af,rxnc_b01ae,rxnc_b01ab].dt.min().where(val=1);
            
            /* anti-arrhytmics */
            
            rxn_chrono => eadv.[rxnc_c01%].dt.min().where(val=1);
            
            /* diuretics */
            
            rxn_diu_loop => eadv.[rxnc_c03c%].dt.min().where(val=1);
            
            rxn_diu_low_ceil => eadv.[rxnc_c03b%,rxnc_c03a%].dt.min().where(val=1);
            
            rxn_diu_k_sp => eadv.[rxnc_c03d%].dt.min().where(val=1);
            
            /*  lipid lowering */
            
            rxn_statin => eadv.[rxnc_c10aa,rxnc_c10bx,rxnc_c10ba].dt.min().where(val=1);
            
            rxn : {coalesce(rxn_statin,rxn_diu_k_sp,rxn_diu_low_ceil,rxn_diu_loop,rxn_chrono,rxn_anticoag,rxn_ap) is not null=>1},{=>0};
            
            
            cad : { coalesce(cabg,cad_mi_icd,cad_chronic_icd,cad_ihd_icpc) is not null =>1},{=>0};
            
            vhd : { coalesce(vhd_mv_icd,vhd_av_icd,vhd_ov_icd,vhd_ie_icd,vhd_icpc) is not null =>1},{=>0};
            
            cardiac : {greatest(cad,vhd)=1 =>1},{=>0};
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,1);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
END;





