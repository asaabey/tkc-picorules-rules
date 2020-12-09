CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm_dx';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess diabetic diagnosis */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess diabetic diagnosis",
                is_active:2
                
            }
        );
        
        
        #doc(,
            {
                txt:"Calculate information entropy"
            }
        );
        
       
        
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
        
        dm1_icd_fd => eadv.icd_e10%.dt.min();
        
        dm1_icpc_fd => eadv.icpc_t89%.dt.min();
        
        dm1_fd : {.=> least_date(dm1_icd_fd,dm1_icpc_fd) };
        
        dm2_icd_fd => eadv.[icd_e08%,icd_e11%,icd_e14%].dt.min();
        
        dm2_icpc_fd => eadv.icpc_t90%.dt.min();
        
        dm2_fd : {.=> least_date(dm2_icd_fd,dm2_icpc_fd) };
        
        dm3_icd_fd => eadv.icd_e09%.dt.min();
               
        dm3_fd : {.=> dm3_icd_fd };
        
        predm_icpc_fd => eadv.icpc_a91011.dt.min();
        
        predm_icd_fd => eadv.icd_r73_03%.dt.min();
        
        predm_fd : {.=>least_date(predm_icd_fd,predm_icpc_fd)};
        
        dm_mixed : { dm1_fd!? and dm2_fd!? => 1},{=>0};
        
        dm_icd_fd : {.=> least_date(dm1_icd_fd,dm2_icd_fd,dm3_icd_fd) };
        
        dm_icpc_fd : {.=> least_date(dm1_icpc_fd,dm2_icpc_fd) };
        
        
        #doc(,{
                txt :"Code criteria for Gestational DM"
        });
        
        gdm_code_fd => eadv.[icd_o24%,icpc_w85001,icpc_w85002].dt.min();
      
        #doc(,{
                txt :"Differentiate Type 1 prioritising ICPC"
        });
        dm_code_fd : { . => least_date(dm_icd_fd,dm_icpc_fd) };
        
        
        
        dm_type_1 : { dm1_icpc_fd!? => 1},{ dm2_icpc_fd? and dm1_icd_fd!? =>1},{=>0}; 
        
        
        
        #doc(,
            {
                txt:"lab criteria with hba1c(ngsp) threshold at 6.5",
                cite:"dm_mja_2012,dm_nhmrc_2009"
            }
        );
       
        gluc_hba1c_high1 => eadv.lab_bld_hba1c_ngsp._.lastdv().where(val>=65/10);
        
        gluc_hba1c_high2 => eadv.lab_bld_hba1c_ngsp._.lastdv(1).where(val>=65/10);
        
        gluc_hba1c => eadv.lab_bld_hba1c_ngsp._.lastdv();
        
        /* not implemented yet
        gluc_fasting => eadv.lab_bld_glucose_fasting.val.count(0).where(val>=7);
        
        gluc_random => eadv.lab_bld_glucose_random.val.count(0).where(val>=111/10);
        
        gluc_ogtt_0h => eadv.lab_bld_glucose_ogtt_0h.val.count(0).where(val>=7);
        
        gluc_ogtt_2h => eadv.lab_bld_glucose_ogtt_2h.val.count(0).where(val>=111/10);
        */
        
        dm_lab : { gluc_hba1c_high1_val!? and gluc_hba1c_high2_val!?  =>1},{=>0};
        
        /* not implemented yet
        dm_lab : {coalesce(gluc_hba1c_high1_dt,gluc_fasting,gluc_random,gluc_ogtt_0h,gluc_ogtt_2h)!? =>1},{=>0};
        */
        
        gluc_hba1c_high_f => eadv.lab_bld_hba1c_ngsp._.firstdv().where(val>=65/10);
        
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
    
        dm_rxn_su => eadv.[rxnc_a10bb].dt.min().where(val=1);
        dm_rxn_ins_long => eadv.[rxnc_a10ae].dt.min().where(val=1);
        dm_rxn_ins_int => eadv.[rxnc_a10ac].dt.min().where(val=1);
        dm_rxn_ins_mix => eadv.[rxnc_a10ad].dt.min().where(val=1);
        dm_rxn_ins_short => eadv.[rxnc_a10ab].dt.min().where(val=1);
        dm_rxn_bg => eadv.rxnc_a10ba.dt.min().where(val=1);
        
        
        dm_rxn_dpp4 => eadv.[rxnc_a10bh].dt.min().where(val=1);
        dm_rxn_glp1 => eadv.[rxnc_a10bj].dt.min().where(val=1);
        dm_rxn_sglt2 => eadv.[rxnc_a10bk].dt.min().where(val=1);
           
        dm_rxn_ins : {coalesce(dm_rxn_ins_long,dm_rxn_ins_int,dm_rxn_ins_mix,dm_rxn_ins_short)!? =>1},{=>0};
           
        dm_rxn : { coalesce(dm_rxn1_fd,dm_rxn2_fd)!? => 1},{=>0};
        
        dm_dx_rxn : { dm_rxn1_fd!? => 1},{=>0};
        
        dm_fd :{ . => least_date(dm_code_fd,dm_rxn1_fd,gluc_hba1c_high_f_dt)  };
        
        dm_fd_year :{ . => extract(year from dm_fd) };
        
        dm_vintage_yr_ : { dm_fd!? => round((sysdate-dm_fd)/365,0)},{=>0};
        
        dm_vintage_cat : { dm_vintage_yr_>=0 and dm_vintage_yr_ <10 => 1 },
                            { dm_vintage_yr_>=10 and dm_vintage_yr_ <20 => 2 },
                            { dm_vintage_yr_>=20=> 3 },{=>0};

        
        dm_icpc_coded : { dm_icpc_fd!? =>1},{=>0};
        
        dm_icd_coded : { dm_icd_fd!? =>1},{=>0};
        
        dm : { dm_fd!? =>1},{=>0};
        
        dm_type : {dm=1 and dm_type_1=1 =>1},
                    {dm=1 and dm_type_1=0=>2},
                    {dm_mixed=1 =>2},
                    {=>0};
        
        dm_prev : { dm_fd!? => 1 },{=>0};
        
        dm_incd : { dm_fd > sysdate - 365 => 1},{=>0};
        
        
        dm_dx_code_flag : {greatest(dm_icd_coded,dm_icpc_coded)>0 => 1},{=>0};
        
        dm_dx_uncoded : {dm_dx_code_flag=0 => 1},{=>0};
        
        

        dm_dx_code : {dm=1 => (dm*1000 + dm_type*100 + dm_vintage_cat*10)},{=>0};
        
        dm1_mm_1 : { dm_type=1 and dm_rxn_ins=0 => 1},{=>0};
        
        dm1_mm_2 : { dm_type=1 and dm1_icd_fd? => 1},{ dm_type=1 and dm1_icpc_fd? => 2},{=>0};
        
        dm1_mm_3 : { dm_type=1 and dm2_fd>dm1_fd => 1},{=>0};
        
        dm1_mm : { .=> least(dm1_mm_1,dm1_mm_2,dm1_mm_3)};
        
        dm1_mm_code : {.=> 10000 + dm1_mm_1*1000 + dm1_mm_2*100 + dm1_mm_3*10};
        
        dm2_mm_1 : { dm=1 and dm_type_1=0 and dm_rxn=0 and gluc_hba1c_val<6 =>1 },{=>0};
        
        dm2_mm_2 : { dm=1 and dm_type_1=0 and gluc_hba1c_high_f_dt!? and dm_lab=0 =>1 },{=>0};
        
        dm2_mm_3 : { predm_fd > dm2_fd =>1},{=>0};
        
        dm2_mm_4 : { dm3_fd!? and dm2_fd? and dm1_fd? and predm_fd? =>1},{=>0};
        
        cd_dm_dx_code : { dm=1 => 100000 + dm_icd_coded*10000 + dm_icpc_coded*1000 + dm_lab*100 + dm_rxn*10};
        
        [[rb_id]] : { . => dm};
        
        #define_attribute(
            dm,
            {
                label:"Diabetes",
                desc:"Presence of Type 2/1 Diabetes mellitus",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            dm_prev,
            {
                label:"Prevalent Diabetes Mellitus",
                desc:"Presence of Type 2/1 Diabetes mellitus",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            dm_incd,
            {
                label:"Incident Diabetes Mellitus",
                desc:"Presence of Type 2/1 Diabetes mellitus",
                is_reportable:1,
                type:2
            }
        );
        
        
        #define_attribute(
            dm_dx_uncoded,
            {
                label:"Absent ICPC2+ coding indicating Diabetes Mellitus",
                desc:"",
                is_reportable:1,
                type:2
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm_comp';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess diabetes */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess diabetes",
                is_active:2,
                filter: "SELECT eid FROM rout_cd_dm_dx WHERE cd_dm_dx=1"
                
            }
        );
        
        
        #doc(,
            {
                txt:"Calculate information entropy"
            }
        );
        
       
       dm => rout_cd_dm_dx.cd_dm_dx.val.bind();
        
        
        #doc(,
            {
                section: "Complications"
            }
        );
        
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
        
                
        ndr_icd_e32 => eadv.[icd_e10_32%,icd_e11_32%,icd_e13_32%].dt.min();
        
        ndr_icd_e33 => eadv.[icd_e10_33%,icd_e11_33%,icd_e13_33%].dt.min();
        
        ndr_icd_e34 => eadv.[icd_e10_34%,icd_e11_34%,icd_e13_34%].dt.min();
        
        ndr_icd : {coalesce(ndr_icd_e32,ndr_icd_e33,ndr_icd_e34)!? =>1},{=>0};
        
        #doc(,
            {
                txt:"Proliferative diabetic retinopathy ICD codes"
                
            }
        );
        
        pdr_icd_e35 => eadv.[icd_e11_35%,icd_e11_35%,icd_e13_35%].dt.min();
        
        #doc(,
            {
                txt:"Diabetic retinopathy ICPC codes"
                
            }
        );
        
        dr_icpc_f83 => eadv.icpc_f83002.dt.min();
        
        dm_micvas_retino : { ndr_icd=1 or pdr_icd_e35!? or dr_icpc_f83!? =>1},{=>0};
        
        #doc(,
            {
                txt:"Diabetic neuropathy ICD codes"
                
            }
        );

        dm_micvas_neuro => eadv.[icd_e11_4%,icpc_n94012,icpc_s97013].dt.min();
        
        dm_micvas :{ dm_micvas_neuro!? or dm_micvas_retino!? => 1},{=>0};
        
        [[rb_id]] : { greatest(dm_micvas)>0 and dm=1 =>1},{=>0};
        
        
        #define_attribute(
            [[[rb_id]],
            {
                label:"Diabetic complications",
                desc:"Presence of Diabetic complications",
                is_reportable:1,
                type:2
            }
        );
        
    ';
    
    
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm_glyc_cntrl';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess diabetic glycaemic control*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess diabetic glycaemic control",                
                is_active:2,
                filter: "SELECT eid FROM rout_cd_dm_dx WHERE cd_dm_dx=1"
                
            }
        );
        
        
        #doc(,
            {
                txt:"Calculate information entropy"
            }
        );
        
       
        
        iq_hba1c => eadv.lab_bld_hba1c_ngsp.val.count(0).where(dt>sysdate-730);
        
        iq_tier : {iq_hba1c>1 => 2},{iq_hba1c>0 => 1},{=>0};
        
        dm => rout_cd_dm_dx.cd_dm_dx.val.bind();
        
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
        
        last_hba1c : {hba1c_n0_val!? => hba1c_n0_val};
        
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
        
        cd_dm_glyc_cntrl : { dm=1 => n0_st};
        
        #define_attribute(
            cd_dm_glyc_cntrl,
            {
                label:"Diabetic glycaemic control",
                desc:"Diabetic glycaemic control class",
                is_reportable:1,
                type:2
            }
        );
        
         #define_attribute(
            hba1c_n0_val,
            {
                label:"Last HbA1c ngsp",
                desc:"Last HbA1c ngsp",
                is_reportable:1,
                type:2
            }
        );
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
   
   
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_dm_mx';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess diabetic management*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess diabetic management",
                is_active:2,
                filter: "SELECT eid FROM rout_cd_dm_dx WHERE cd_dm_dx=1"
                
            }
        );
        
        
        #doc(,
            {
                txt:"Get careplan information"
            }
        );
        dm => rout_cd_dm_dx.cd_dm_dx.val.bind();
        
        cp_lv => eadv.careplan_h9_v1.val.last();
        
        cp_ld => eadv.careplan_h9_v1.dt.max();
        
        cp_dm : {cp_lv is not null => to_number(substr(to_char(cp_lv),-6,1))},{=>0};
        
        cp_dm_ld : {cp_dm>0 => cp_ld};
        
        
        cd_dm_mx : {dm=1 and cp_dm>0 => 1},{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Diabetic management",
                desc:"Diabetic management",
                is_reportable:1,
                type:2
            }
        );
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
  
END;





