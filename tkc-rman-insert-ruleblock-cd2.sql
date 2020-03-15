CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess diabetes */
        
        #define_ruleblock(cd_dm,
            {
                description: "Ruleblock to assess diabetes",
                version: "0.1.2.1",
                blockid: "cd_dm",
                target_table:"rout_cd_dm",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"dm",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        
        
         #doc(,
            {
                txt:"Get careplan information"
            }
        );
        
        cp_lv => eadv.careplan_h9_v1.val.last();
        
        cp_ld => eadv.careplan_h9_v1.dt.max();
        
        cp_dm : {cp_lv is not null => to_number(substr(to_char(cp_lv),-6,1))},{=>0};
        
        cp_dm_ld : {cp_dm>0 => cp_ld};
        
        #doc(,
            {
                txt:"Calculate information entropy"
            }
        );
        
       
        
        iq_hba1c => eadv.lab_bld_hba1c_ngsp.val.count(0).where(dt>sysdate-730);
        
        iq_tier : {iq_hba1c>1 => 2},{iq_hba1c>0 => 1},{=>0};
        
        #doc(,
            {
                section: "Diagnosis"
            }
        );
        
        
        #doc(,
            {
                txt :"Determine diagnosis by code lab and rxn criteria",
                cite:"dm_bmc_ehr_2019"
            }
        );
        
        
        #doc(,
            {
                txt:"code criteria"
            }
        );
        
        dm1_icd_fd => eadv.icd_e10%.dt.min(2999);
        
        dm1_icpc_fd => eadv.icpc_t89%.dt.min(2999);
        
        dm2_icd_fd => eadv.[icd_e08%,icd_e09%,icd_e11%,icd_e14%].dt.min(2999);
        
        dm2_icpc_fd => eadv.icpc_t90%.dt.min(2999);
        
        dm_icd_fd : {least(dm1_icd_fd,dm2_icd_fd) < to_date(`29991231`,`YYYYMMDD`) => least(dm1_icd_fd,dm2_icd_fd) };
        
        dm_icpc_fd : {least(dm1_icpc_fd,dm2_icpc_fd) < to_date(`29991231`,`YYYYMMDD`) => least(dm1_icpc_fd,dm2_icpc_fd) };
        
        
        dm_code_fd : { dm_icd_fd!? and dm_icpc_fd!? => least(dm_icd_fd,dm_icpc_fd) },
                        {dm_icd_fd!? => dm_icd_fd},
                        {dm_icpc_fd!? => dm_icpc_fd};
        
        dm_type_1 : {least(dm1_icpc_fd,dm1_icd_fd) < to_date(`29991231`,`YYYYMMDD`) => 1},{=>0}; 
        
        
        #doc(,
            {
                txt :"Code criteria for Gestational DM"
            }
        );
        
        gdm_code_fd => eadv.[icd_O24%,icpc_w85001,icpc_w85002].dt.min();
        
        #doc(,
            {
                txt:"lab criteria with hba1c(ngsp) threshold at 6.5",
                cite:"dm_mja_2012,dm_nhmrc_2009"
            }
        );
       
        gluc_hba1c => eadv.lab_bld_hba1c_ngsp.val.count(0).where(val>=65/10);
        
        gluc_fasting => eadv.lab_bld_glucose_fasting.val.count(0).where(val>=7);
        
        gluc_random => eadv.lab_bld_glucose_random.val.count(0).where(val>=111/10);
        
        gluc_ogtt_0h => eadv.lab_bld_glucose_ogtt_0h.val.count(0).where(val>=7);
        
        gluc_ogtt_2h => eadv.lab_bld_glucose_ogtt_2h.val.count(0).where(val>=111/10);
        
        dm_lab : {coalesce(gluc_hba1c,gluc_fasting,gluc_random,gluc_ogtt_0h,gluc_ogtt_2h) is not null =>1},{=>0};
        
        dm_lab_fd => eadv.lab_bld_hba1c_ngsp.dt.min().where(val>=65/10);
        
        #doc(,
            {
                txt:"medication criteria based on rxnorm based on WHO ATC A10",
                cite:"dm_rxn,dm_tg_2019"
            }
        );
        
        
        dm_rxn_n => eadv.[rxnc_a10%].dt.count(0).where(val=1);
        
        #doc(,
            {
                txt:"Medications that if present signify diagnosis"
            }
        );
        dm_rxn1_fd => eadv.[rxnc_a10bb,rxnc_a10ae,rxnc_a10ac,rxnc_a10ad,rxnc_a10ab,rxnc_a10bh,rxnc_a10bj,rxnc_a10bk].dt.min();
    
        dm_rxn2_fd => eadv.[rxnc_a10ba].dt.min();
    
        dm_rxn_su => eadv.[rxnc_a10bb].dt.count(0).where(val=1);
        dm_rxn_ins_long => eadv.[rxnc_a10ae].dt.count(0).where(val=1);
        dm_rxn_ins_int => eadv.[rxnc_a10ac].dt.count(0).where(val=1);
        dm_rxn_ins_mix => eadv.[rxnc_a10ad].dt.count(0).where(val=1);
        dm_rxn_ins_short => eadv.[rxnc_a10ab].dt.count(0).where(val=1);
        dm_rxn_bg => eadv.[rxnc_a10ba].dt.count(0).where(val=1);
        dm_rxn_dpp4 => eadv.[rxnc_a10bh].dt.count(0).where(val=1);
        dm_rxn_glp1 => eadv.[rxnc_a10bj].dt.count(0).where(val=1);
        dm_rxn_sglt2 => eadv.[rxnc_a10bk].dt.count(0).where(val=1);
           
               
        dm_rxn : { coalesce(dm_rxn1_fd,dm_rxn2_fd)!? => 1},{=>0};
        
        #doc(,
            {
                section: "Complications"
            }
        );
        #doc(,
            {
                txt:"Determine dm diabetes start date using earliest trigger for diagnosis",
                cite:"dm_dm_comp_2018,dm_diabetologia_2014"
            }
        );
        
        #doc(,
            {
                txt:"Level of certainity of diagnosis !(TBA)",
                
            }
        );
        
        dm_fd :{coalesce(dm_code_fd,dm_lab_fd,dm_rxn1_fd)!? => 
                    (
                        least(
                            nvl(dm_code_fd,to_date(`29991231`,`YYYYMMDD`)),
                            nvl(dm_lab_fd,to_date(`29991231`,`YYYYMMDD`)),
                            nvl(dm_rxn1_fd,to_date(`29991231`,`YYYYMMDD`))
                        )
                    )
                };
        
                    
        
        dm_fd_t :{ 1=1 => to_char(dm_fd,`YYYY`)};

        
        
        #doc(,
            {
                txt:"Determine diabetic complications including retinopathy neuropathy dm foot",
                cite:"dm_dmcare_2014"
            }
        );
        
        #doc(,
            {
                txt:"Non-proliferative diabetic retinopathy ICD codes"
                
            }
        );
        
        ndr_e10_icd => eadv.[icd_e10_32%,icd_e10_33%,icd_e10_35%].dt.count();
        
        ndr_e11_icd => eadv.[icd_e11_32%,icd_e11_33%,icd_e11_35%].dt.count();
        
        ndr_e13_icd => eadv.[icd_e13_32%,icd_e13_33%,icd_e13_35%].dt.count();
        
        ndr_icd : {coalesce(ndr_e10_icd,ndr_e11_icd,ndr_e13_icd)>0 =>1};
        
        #doc(,
            {
                txt:"Proliferative diabetic retinopathy ICD codes"
                
            }
        );
        
        pdr_icd => eadv.[icd_e11_35%,icd_e11_35%,icd_e13_35%].dt.count();
        
        dr_icpc => eadv.icpc_f83002.dt.count();
        
        dm_micvas_retino : { coalesce(ndr_icd,pdr_icd,dr_icpc) is not null=>1},{=>0};
        
        #doc(,
            {
                txt:"Diabetic neuropathy ICD codes"
                
            }
        );

        dm_micvas_neuro => eadv.[icd_e11_4%,icpc_n94012,icpc_s97013].dt.count(0);
        
        dm_micvas :{ greatest(dm_micvas_neuro,dm_micvas_retino)>0 => 1},{=>0};
        
        #doc(,
            {
                txt:"Determine vintage"
            }
        );
        
        dm_vintage_yr_ : { dm_fd is not null => round((sysdate-dm_fd)/365,0)},{=>0};
        
        dm_vintage_cat : { dm_vintage_yr_>=0 and dm_vintage_yr_ <10 => 1 },
                            { dm_vintage_yr_>=10 and dm_vintage_yr_ <20 => 2 },
                            { dm_vintage_yr_>=20=> 3 },{=>0};
        
        dm_longstanding : {dm_vintage_cat>=2 => 1},{=>0};   
        
        
        dm : { dm_fd!? =>1},{=>0};
        
        dm_icpc_coded : { dm_icpc_fd!? =>1},{=>0};
        
        dm_icd_coded : { dm_icd_fd!? =>1},{=>0};
        
        dm_dx_code_flag : {greatest(dm_icd_coded,dm_icpc_coded)>0 => 1},{=>0};
        
        dm_dx_uncoded : {dm_dx_code_flag=0 => 1},{=>0};
        
        dm_type : {dm=1 and dm_type_1>0 => 1},{dm=1 and dm_type_1=0 => 2},{=>0};

        dm_dx_code : {dm=1 => (dm*1000 + dm_type*100 + dm_vintage_cat*10 + dm_micvas)},{=>0};
        
        #doc(,
            {
                section: "Glycaemic Level"
            }
        );
        
        #doc(,
            {
                txt:"Diabetic glycaemic levels which includes short and long term levels",
                cite:"dm_pcd_2019,dm_ada_2018"
            }
        );
        
        #doc(,
            {
                txt:"Australian guidelines set target glycaemic target as 7 but range from 6-8 in specific populations. However intensive glycaemic target 6pct has limited additional outcome benefits",
                cite:"dm_bmj_2011,dm_nejm_2008,dm_ada_2016"
            }
        );
        
        
        hba1c_n_tot0 => eadv.lab_bld_hba1c_ngsp.dt.count();
        hba1c_n_opt0 => eadv.lab_bld_hba1c_ngsp.dt.count().where(val>=6 and val<8);
        
        hba1c_n_opt :{hba1c_n_opt0 is not null => hba1c_n_opt0},{=>0};
        
        hba1c_n_tot : {hba1c_n_tot0 is not null => hba1c_n_tot0},{=>0};
        
        #doc(,
            {
                txt:"Calculate tir of HbA1c",
                cite:"dm_dmtech_2019,dm_dmrr_2018"
            }
        );
        
        n_opt_qt :{hba1c_n_tot>0 => round((hba1c_n_opt/hba1c_n_tot),2)*100};
        
        
        
        hba1c_n0 => eadv.lab_bld_hba1c_ngsp.val.lastdv();
        
        #doc(,
            {
                txt:"Categories levels into 4 classes",
                cite:"dm_aihwa_atsi_kpi_2018"
            }
        );
        
        
        n0_st : { hba1c_n0_val <6 => 1},
                            { hba1c_n0_val >=6 and hba1c_n0_val <8 => 2},
                            { hba1c_n0_val >=8 and hba1c_n0_val <10 => 3},
                            { hba1c_n0_val >=10 =>4},{=>0};
        
        
        
        #define_attribute(
            dm,
            {
                label:"Diabetes",
                desc:"Presence of Type 2/1 Diabetes mellitus",
                is_reportable:1,
                type:2
            }
        );
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_htn';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess hypertension  */
        
        #define_ruleblock(cd_htn,
            {
                description: "Algorithm to assess hypertension",
                version: "0.1.2.2",
                blockid: "cd_htn",
                target_table:"rout_cd_htn",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"htn",
                def_predicate:">0",
                exec_order:1,
                out_att : "htn_icpc,htn_fd_yr,mu_1,mu_2,slice140_1_n,bp_trend,bp_control,htn_rxn,htn_rxn_arb,htn_rxn_acei,htn_rxn_ccb,htn_rxn_bb,htn_rxn_diuretic_thiazide,htn_rxn_diuretic_loop,iq_tier,iq_sbp,htn"
                
            }
        );
        
        #doc(,
            {
                txt:"Calculate information entropy"
            }
        );
        
        
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-730);
        
        iq_tier : {iq_sbp>1 => 2},{iq_sbp>0 => 1},{=>0};
        
        #doc(,
            {
                section: "Diagnosis",
            }
        );
        
        #doc(,
            {
                txt:"Hypertension diagnosis: code criteria"
            }
        );
       
        
        htn_icd => eadv.[icd_i10_%,icd_i15_%].dt.count(0);
        htn_icpc => eadv.[icpc_k85%,icpc_k86%,icpc_k87%].dt.count(0);
        
        #doc(,
            {
                txt:"Hypertension diagnosis: observation criteria at least 3 readings over SBP140 within 2 years",
                cite:"htn_nhf_2016,htn_aha_2018,htn_mja_2016"
            }
        );
        
        htn_obs => eadv.obs_bp_systolic.val.count(0).where(val>140 and dt>sysdate-730);
        
        #doc(,
            {
                txt:"Ancillary information for causality"
            }
        );
        
        
        bld_k_val => eadv.lab_bld_potassium.val.last().where(dt>sysdate-730);
        
        bld_k_state : {nvl(bld_k_val,0)>5.2 =>3},{nvl(bld_k_val,0)>4.0 =>2},{=>1};
        
        #doc(,
            {
                txt:"Hypertension diagnosis: treatment criteria based on RxNorm medication codes"
            }
        );
        
        htn_rxn_acei => eadv.[rxnc_c09aa].dt.count(0).where(val=1);
        htn_rxn_arb => eadv.[rxnc_c09ca].dt.count(0).where(val=1);
        htn_rxn_bb => eadv.[rxnc_c07%].dt.count(0).where(val=1);
        htn_rxn_ccb => eadv.[rxnc_c08%].dt.count(0).where(val=1);
        htn_rxn_c02 => eadv.[rxnc_c02%].dt.count(0).where(val=1);
        htn_rxn_diuretic_thiaz => eadv.[rxnc_c03aa].dt.count(0).where(val=1);
        htn_rxn_diuretic_loop => eadv.[rxnc_c03c%].dt.count(0).where(val=1);
        
        htn_rxn_raas : { greatest(htn_rxn_acei,htn_rxn_arb)>0 =>1},{=>0};
        
        htn_rxn : { coalesce(htn_rxn_acei, htn_rxn_arb, htn_rxn_bb, htn_rxn_ccb , htn_rxn_c02 , htn_rxn_diuretic_thiaz , htn_rxn_diuretic_loop) is not null =>1 },{=>0};
        
        #doc(,
            {
                section: "Complications"
            }
        );
        
        
        #doc(,
            {
                txt:"Hypertension diagnosis: vintage or date of onset"
            }
        );
        
        
        htn_fd_code => eadv.[icd_i10_%,icd_i15_%,icpc_k85%,icpc_k86%,icpc_k87%].dt.min();
        htn_fd_obs => eadv.obs_bp_systolic.dt.min().where(val>140);
        
        htn_fd : {coalesce(htn_fd_code,htn_fd_obs) is not null => least(nvl(htn_fd_code,to_date(`01012999`,`DDMMYYYY`)),nvl(htn_fd_obs,to_date(`01012999`,`DDMMYYYY`)))};
        
        htn_fd_yr : { htn_fd is not null => to_char(htn_fd,`YYYY`) };
        
        htn_type_2 => eadv.[icd_i15_%].dt.count(0);
        
        #doc(,
            {
                txt:"Hypertension chronology"
            }
        );
        
        
        htn_vintage_yr_ : { htn_fd is not null => round((sysdate-htn_fd)/365,0)},{=>0};
        
        htn_vintage_cat : { htn_vintage_yr_>=0 and htn_vintage_yr_ <10 => 1 },
                            { htn_vintage_yr_>=10 and htn_vintage_yr_ <20 => 2 },
                            { htn_vintage_yr_>=20=> 3 },{=>0};
        
        
        #doc(,
            {
                section: "Management"
            }
        );
        #doc(,
            {
                txt:"BP control : Assessing BP control in past 2 years: time  Proportion? outside of target range SBP >140",
                cite:"htn_plos_2018"
            }
        );
        
        
        sigma_2 => eadv.obs_bp_systolic.val.count(0).where(dt>=sysdate-730 and dt<sysdate-365); 
        mu_2 => eadv.obs_bp_systolic.val.avg().where(dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        
        sigma_1 => eadv.obs_bp_systolic.val.count(0).where(dt>=sysdate-365); 
        mu_1 => eadv.obs_bp_systolic.val.avg().where(dt>=sysdate-365); 
        slice140_1_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-365);
        slice140_1_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-365);
        
        
        #doc(,
            {
                txt:"BP control: Time in therapeutic range"
            }
        );
        
        sbp_max_2y => eadv.obs_bp_systolic.val.max().where(dt>=sysdate-730);
        
        sbp_min_2y => eadv.obs_bp_systolic.val.min().where(dt>=sysdate-730);
        
        sbp_target_max : {1=1 => 140};
        
        sbp_target_min : {1=1 => 100};
        
        n_qt_1 : {sigma_1>0 => 1-round(slice140_1_n/sigma_1,1)};
        
        mu_qt : {slice140_2_mu>0 =>round(slice140_1_mu/slice140_2_mu,2)};
        
        bp_trend : { mu_qt <0.9 => 1 },{ mu_qt > 1.1 => 2},{=>0};
        
        bp_control : { n_qt_1 >=0.75 => 3},{ n_qt_1<0.75 and n_qt_1>=0.25 => 2 },{ n_qt_1<0.25 => 1},{=>0};
        
        htn : {greatest(htn_icd,htn_icpc)>0 or htn_obs>2 =>1},{=>0};
        
        htn_dx_uncoded : {htn_obs>=3 and greatest(htn_icd,htn_icpc)=0 => 1},{=>0};
        
        #define_attribute(
            htn,
            {
                label:"Hypertension",
                desc:"Presence of Hypertension",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    

   -- BEGINNING OF RULEBLOCK --
    
    rb.blockid:='careplan';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /*  Ruleblock to determine existing careplans*/
        
        #define_ruleblock(careplan,
            {
                description: "Ruleblock to determine existing careplans",
                version: "0.0.2.1",
                blockid: "careplan",
                target_table:"rout_careplan",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"careplan",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        cp_l => eadv.careplan_h9_v1.val.lastdv();
        
        #doc(,
            {
                txt:"Assign binary careplan attributes based on positional values "
            }
        );
        
        
        
        cp_cs : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-1,1))},{=>0};
        
        cp_ckd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_dm : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-6,1))},{=>0};
        
        cp_cvd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-7,1))},{=>0};
        
        cp_hicvr : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-8,1))},{=>0};
        
        careplan : {1=1 => cp_cs};
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
      INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
      
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac disease  */
        
        #define_ruleblock(cd_cardiac,
            {
                description: "Algorithm to assess cardiac disease",
                version: "0.1.2.1",
                blockid: "cd_cardiac",
                target_table:"rout_cd_cardiac",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"cardiac",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
            #doc(,
                {
                    section:"CAD"
                }
            );
            #doc(,
                {
                    txt:"first date of coronary insufficiency based on coding (ICD and ICPC)"
                }
            );    
            
            
            
            cabg => eadv.[icd_z95_1%,icpc_k54007].dt.min();
            
            cad_mi_icd => eadv.[icd_i21%,icd_i22%,icd_i23%].dt.min();
            
            #doc(,
                {
                    txt:"first date of type 2 AMI"
                }
            );   
            
            mi_type2_icd => eadv.icd_i21_a1.dt.min();
            
            cad_chronic_icd => eadv.[icd_i24%,icd_i25%].dt.min();
            
            cad_ihd_icpc => eadv.[icpc_k74%,icpc_k75%,icpc_k76%].dt.min();        
                
                
            #doc(,
                {
                    section:"VHD"
                }
            );
            #doc(,
                {
                    txt:"valvular heart disease based on coding"
                }
            );     
            
             #doc(,
                {
                    txt:"mitral and aortic"
                }
            ); 
            
            vhd_mv_icd => eadv.[icd_i34_%,icd_i05%].dt.min();
            
            vhd_av_icd => eadv.[icd_i35_%,icd_i06%].dt.min();
            
             #doc(,
                {
                    txt:"other valvular including rheumatic heart disease and infective endocarditis"
                }
            ); 
            vhd_ov_icd => eadv.[icd_i07%,icd_i08%,icd_i09%,icd_i36%,icd_i37%].dt.min();
            
            vhd_ie_icd => eadv.[icd_i33%,icd_i38%,icd_i39%].dt.min();
            
            vhd_icpc => eadv.[icpc_k83%].dt.min();
            
            #doc(,
                {
                    txt:"atrial fibrillation based on coding"
                }
            );  
            
            af_icd => eadv.[icd_i48_%].dt.min();
            
            af_icpc => eadv.[icpc_k78%].dt.min();
            
            #doc(,
                {
                    section:"other CVD"
                }
            );
            
            #doc(,
                {
                    txt:"Other atherosclerotic disease"
                }
            );   
            
            
            cva => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min();
            
            pvd => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.min();
           
           #doc(,
                {
                    section:"Management"
                }
            );
           #doc(,
            {
                txt: "Medication",
                cite: "cvd_tg_2019,cvd_heart_foundation_2012"
            }
            ); 
            
            
            
            #doc(,
                {
                    txt: "antiplatelet agents"
                }
            ); 
            
            
            
            rxn_ap => eadv.[rxnc_b01ac].dt.min().where(val=1);
            
            
            #doc(,
                {
                    txt: "anti-coagulation including NOAC"
                }
            ); 
            
            
            rxn_anticoag => eadv.[rxnc_b01aa,rxnc_b01af,rxnc_b01ae,rxnc_b01ab].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "anti-arrhythmic"
                }
            ); 
            
        
            
            rxn_chrono => eadv.[rxnc_c01%].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "diuretics"
                }
            ); 
            
            rxn_diu_loop => eadv.[rxnc_c03c%].dt.min().where(val=1);
            
            rxn_diu_low_ceil => eadv.[rxnc_c03b%,rxnc_c03a%].dt.min().where(val=1);
            
            rxn_diu_k_sp => eadv.[rxnc_c03d%].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "lipid lowering"
                }
            ); 
            
            rxn_statin => eadv.[rxnc_c10aa,rxnc_c10bx,rxnc_c10ba].dt.min().where(val=1);
            
            rxn : {coalesce(rxn_statin,rxn_diu_k_sp,rxn_diu_low_ceil,rxn_diu_loop,rxn_chrono,rxn_anticoag,rxn_ap) is not null=>1},{=>0};
            
            
            cad : { coalesce(cabg,cad_mi_icd,cad_chronic_icd,cad_ihd_icpc) is not null =>1},{=>0};
            
            vhd : { coalesce(vhd_mv_icd,vhd_av_icd,vhd_ov_icd,vhd_ie_icd,vhd_icpc) is not null =>1},{=>0};
            
            cardiac : {greatest(cad,vhd)=1 =>1},{=>0};
            
            #define_attribute(
            cad,
                {
                    label:"Coronary artery disease",
                    desc:"Presence of Coronary artery disease",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            vhd,
                {
                    label:"Valvular heart disease",
                    desc:"Presence of Valvular heart disease",
                    is_reportable:1,
                    type:2
                }
            );
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_obesity';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess obesity  */
        
        #define_ruleblock(cd_obesity,
            {
                description: "Ruleblock to assess obesity",
                version: "0.0.2.2",
                blockid: "cd_cardiac",
                target_table:"rout_cd_obesity",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"obesity",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
            
        ht => eadv.obs_height.val.lastdv();
        
        wt => eadv.obs_weight.val.lastdv();
        
        bmi : { nvl(ht_val,0)>0 and nvl(wt_val,0)>0 => round(wt_val/power(ht_val/100,2),1) };
        
        obs_icd => eadv.[icd_e66%].dt.count(0);
        
        obs_icpc => eadv.[icpc_t82%].dt.count(0);
        
        #doc(,
                {
                    txt: "Obesity diagnosis where BMI >30",
                    cite: "cd_obesity_ref1"
                }
            );
        
        obesity : { bmi>30 => 1 },{=>0};
        
        obs_dx_uncoded : {bmi>30 and greatest(obs_icd,obs_icpc)=0 =>1},{=>0};
        
        #define_attribute(
            obesity,
                {
                    label:"Obesity",
                    desc:"Integer [0-1] if Obesity based on code and observation criteria",
                    is_reportable:1,
                    type:2
                }
        );
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='at_risk_ckd';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess at risk population for CKD */
        
        #define_ruleblock(at_risk_ckd,
            {
                description: "Ruleblock to assess at_risk_ckd",
                version: "0.0.2.2",
                blockid: "at_risk_ckd",
                target_table:"rout_at_risk_ckd",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"at_risk_ckd",
                def_predicate:"",
                exec_order:5
                
            }
        );
        
        #doc(,
                {
                    txt: "Risk factor assessment for CKD",
                    cite: "at_risk_ckd_ref1, at_risk_ckd_ref2, at_risk_ckd_ref3"
                }
            ); 
        
        
        
        ckd => rout_ckd.ckd.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        dm => rout_cd_dm.dm.val.bind();
        
        htn => rout_cd_htn.htn.val.bind();
        
        cad => rout_cd_cardiac.cardiac.val.bind();
        
        obesity => rout_cd_obesity.obesity.val.bind();
    
        #doc(,
            {
                txt:"Gather risk factors from coding"
            }
        );
       
        
        
        lab_ld => eadv.[lab_bld%].dt.max().where(dt > sysdate-730);
        
        obs_ld => eadv.[obs%].dt.max().where(dt > sysdate-730);
        
        is_active_2y : {coalesce(lab_ld,obs_ld) is null =>0},{=>1};
              
        obst => eadv.[icd_e66%,icpc_t82%].dt.count(0);
            
        lit => eadv.[icd_n20,icd_n21,icd_n22,icd_n23,icpc_u95%].dt.count(0);
        
        struc => eadv.[icd_n25,icd_n26,icd_n27,icd_n28,icd_n29,icpc_u28006].dt.count(0);
            
        cti => eadv.[icd_l00%,icd_l01%,icd_l02%,icd_l03%,icd_l04%,icd_l05%,icd_l06%,icd_l07%,icd_l08%,icd_l09%,icd_m86%,icpc_s76%].dt.count(0);
        
        aki => eadv.[icd_n17%].dt.count(0);
        
        #doc(,
            {
                txt:"Determine at risk for CKD, and active cohort"
            }
        );
        
            
        at_risk_ckd : { greatest(dm,htn,cad,obesity,obst,lit,struc,aki,cti)>0 and ckd=0 =>1},{=>0};
        
        tkc_active_cohort : { greatest(ckd,rrt,at_risk_ckd)>0 and is_active_2y=1 =>1},{=>0};
        
        #define_attribute(
            at_risk_ckd,
                {
                    label:"At risk for CKD",
                    is_reportable:1,
                    type:2
                }
        );
        
        #define_attribute(
            tkc_active_cohort,
                {
                    label:"TKC active cohort",
                    is_reportable:1,
                    type:2
                }
        );
        
        
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
   
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='htn_rcm';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess hypertension pharmacology recommendations */
        
        #define_ruleblock(htn_rcm,
            {
                description: "Ruleblock to assess hypertension pharmacology recommendations",
                version: "0.1.2.1",
                blockid: "htn_rcm",
                target_table:"rout_htn_rcm",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"htn_rcm",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
       
        
        ckd => rout_ckd.ckd.val.bind();
        
        htn => rout_cd_htn.htn.val.bind();
        
        bpc => rout_cd_htn.bp_control.val.bind();
        
        cad => rout_cd_cardiac.cardiac.val.bind();
        #doc(,
            {
                txt:"Gather existing medications",
                cite:"htn_tga_2019,htn_jnc_2014"
            }
        );
        
        
        

        acei => eadv.[rxnc_c09aa].dt.count(0).where(val=1);
        arb => eadv.[rxnc_c09ca].dt.count(0).where(val=1);
        bb => eadv.[rxnc_c07%].dt.count(0).where(val=1);
        ccb => eadv.[rxnc_c08%].dt.count(0).where(val=1);
        c02 => eadv.[rxnc_c02%].dt.count(0).where(val=1);
        thiaz => eadv.[rxnc_c03aa].dt.count(0).where(val=1);
        loop => eadv.[rxnc_c03c%].dt.count(0).where(val=1);
        mrb  => eadv.[rxnc_c03da].dt.count(0).where(val=1);
        
        #doc(,
            {
                txt:"Determine potential complications (Needs more work)",
                cite:"htn_rcm_compmethods_2000,htn_rcm_amia_2017"
            }
        );
        
        
        k_val => eadv.lab_bld_potassium.val.last().where(dt>sysdate-730);
        
        k_state : {nvl(k_val,0)>5.2 =>3},{nvl(k_val,0)>4.0 =>2},{=>1};
        
        
        
        raas : { greatest(acei,arb)>0 =>1 },{=>0};
        
        rx_line : { greatest(acei,arb,ccb,bb,c02,thiaz,loop,mrb)=0 =>0},
                    { raas=1 and greatest(ccb,bb,c02,thiaz,loop,mrb)=0 =>1},
                    { raas=1 and ccb>0 and greatest(bb,c02,thiaz,loop,mrb)=0 =>2},
                    { raas=1 and ccb>0 and thiaz>0 and greatest(bb,c02,loop,mrb)=0 =>3};
                    
        #doc(,
            {
                txt:"Treatment recommendation as a code",
                cite:"htn_rcm_amh_2019"
            }
        );
        
        htn_rcm :   { htn=1 and bpc>1 and raas=0 and k_state<3 => 11 },
                    { htn=1 and bpc>1 and raas=0 and k_state=3 and ccb=0 => 12 },
                    { htn=1 and bpc>1 and raas=1 and ccb=0 => 22 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=0 and k_state>1 => 33 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=0 and k_state=1 => 34 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=1 and k_state<3 => 44 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=1 and k_state=3 => 35 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=1 and mrb=1 => 55 },
                    {htn=1 and bpc>1 =>99},
                    {=>0};

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
END;





