--TKC Composition
--Version 	0.0.2.0
--Creation date	4/10/2019
--Authour		ASAABEY
--
--Purpose
--
--PlacementId : 6 digit code that is used to anchor the template in the composition
--
--Placement Codebook
--30	Alert
--60	Synthesis
--70	Recommendations 
--80	Notes
--
--Disease codes
--10	Chronic disease : RRT
--11	Chronic disease : CKD
--21	Chronic disease : DM2
--31	Chronic disease : HTN
--41	Chronic disease : HTN


DELETE FROM rman_rpt_templates WHERE compositionid='neph002_html';


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_1','cd_dm',602100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <<dm_dx_code_flag>><li>Diagnosed<</dm_dx_code_flag>><<dm_dx_uncoded>>Undiagnosed<</dm_dx_uncoded>> Diabetes type <<dm_type>><</dm_type>>
    <ul>
    <<dm_fd_t>><li>since <<dm_fd_t>><</dm_fd_t>></li><</dm_fd_t>>
    <<dm_micvas>><li>Non-renal microvascular complications present</li><</dm_micvas>>
    <<hba1c_n_tot>><li>Last recorded HbA1c (NGSP) is <<hba1c_n0_val>><</hba1c_n0_val>> % (<<hba1c_n0_dt>><</hba1c_n0_dt>>)</li><</hba1c_n_tot>>
    <<dm_rxn=0>><li>Non-medicated</li><</dm_rxn=0>>
    <<dm_rxn>><li>Current medication classes
    <ul>
    <<dm_rxn_su>><li>sulphonylurea</li><</dm_rxn_su>>
    <<dm_rxn_ins_long>><li>long-acting insulin<li><</dm_rxn_ins_long>>
    <<dm_rxn_glp1>><li>GLP1 analogue</li><</dm_rxn_glp1>>
    <<dm_rxn_dpp4>><li>DPP4 inhibitor</li><</dm_rxn_dpp4>>
    <<dm_rxn_sglt2>><li>SGLT2 inhibitor</li><</dm_rxn_sglt2>>
    </ul>
    </li><</dm_rxn>>
    <<cp_dm=0>><li>Diabetes careplan was not detected [2.4]</li><</cp_dm=0>>
    <<cp_dm>><li>Diabetes careplan was updated on <<cp_dm_ld>><</cp_dm_ld>></li><</cp_dm>>
    </ul>
    </li>
    </ul>
    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_rec_1','cd_dm',702100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<n0_st=3>>Recommendation [2.3] Suggest optimizing glycaemic control<</n0_st=3>>
    <<n0_st=4>>Recommendation [2.3] Suggest optimizing glycaemic control<</n0_st=4>>
    <<cp_dm=0>>Recommendation [2.4] Suggest updating care plan to include diabetes<</cp_dm=0>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_htn_syn_1','cd_htn',603100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li>Hypertension
    <ul>
    <li><<htn_icpc>>Diagnosed<</htn_icpc>> Hypertension <<htn_fd_yr>> since <</htn_fd_yr>><<htn_fd_yr>><</htn_fd_yr>></li>
    <li><<mu_1>>Average systolic BP during last year was <</mu_1>><<mu_1>><</mu_1>><<mu_1>> mmHg<</mu_1>></li>
    <li><<mu_2>> Average systolic BP the year before was <</mu_2>><<mu_2>><</mu_2>><<mu_2>> mmHg.<</mu_2>></li>
    <li><<htn_rxn>>Current antihypertensive classes<</htn_rxn>>
    <ul>
    <li><<htn_rxn_arb>>Angiotensin receptor blocker (ARB) <</htn_rxn_arb>></li>
    <li><<htn_rxn_acei>>ACE inhibitor <</htn_rxn_acei>></li>
    <li><<htn_rxn_ccb>>Calcium channel blocker (CCB) <</htn_rxn_ccb>></li>
    <li><<htn_rxn_bb>>Beta blocker <</htn_rxn_bb>></li>
    <li><<htn_rxn_diuretic_thiazide>>Thiazide diuretic <</htn_rxn_diuretic_thiazide>></li>
    <li><<htn_rxn_diuretic_loop>>Thiazide diuretic <</htn_rxn_diuretic_loop>></li>
    </ul>
    </li>
    </ul>
    </li>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_htn_rec_1','htn_rcm',703100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<htn_icpc=0>>Recommendation [3.1] Update diagnosis to hypertension<</htn_icpc=0>>
    <<bpc=2>>Recommendation [3.4] Optimize BP control<</bpc=2>><<bpc=3>>Recommendation [3.4] Optimize BP control<</bpc=3>>
    <<htn_rcm=11>>Recommendation [3.4.1] Consider adding ACEi or ARB (RAAS blockade) which is recommended as first line therapy<</htn_rcm=11>>
    <<htn_rcm=12>>Recommendation [3.4.1] Consider adding DHP-CCB instead of RAAS blockade as there is a risk worsening hyperkalaemia<</htn_rcm=12>>
    <<htn_rcm=22>>Recommendation [3.4.1] Consider adding CCB which is recommended as second line therapy<</htn_rcm=22>>
    <<htn_rcm=33>>Recommendation [3.4.1] Consider adding low dose thiazide which is recommended as third line therapy<</htn_rcm=33>>
    <<htn_rcm=34>>Recommendation [3.4.1] Consider adding Aldosterone antagonist instead of low dose thiazide as there is a risk of worsening hypokalaemia<</htn_rcm=34>>
    <<htn_rcm=35>>Recommendation [3.4.1] Consider adding beta blocker or central blocker instead of Aldosterone Antagonist as there is a risk of worsening hyperkalaemia<</htn_rcm=35>>
    <<htn_rcm=44>>Recommendation [3.4.1] Consider adding Aldosterone antagonist which is recommended as fourth line therapy<</htn_rcm=44>>
    <<htn_rcm=55>>Recommendation [3.4.1] Consider adding Beta blocker or Central blocker as 5th line therapy<</htn_rcm=55>>
    <<htn_rcm=99>>Recommendation [3.4.1] Best combination cannot be determined<</htn_rcm=99>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_htn_footnote_1','cd_htn',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<iq_tier>>Note [3.1] This is based on <<iq_sbp>><</iq_sbp>> blood pressure readings within the last 2 years<</iq_tier>>
    <<bp_control>>Note [3.3] Based on time in therapeutic range (TITR)<</bp_control>>

    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cardiac_syn','cd_cardiac',604100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li>Cardiac disease
    <ul>
    <li><<cad>>Coronary artery disease<</cad>>
    <ul>
    <li><<cabg>>Cornoary artery bypass grafting <</cabg>><<cabg>><</cabg>></li>
    <li><<cad_mi_icd>>First myocardial infarction <</cad_mi_icd>><<cad_mi_icd>><</cad_mi_icd>></li>
    </ul>
    </li>
    <li><<vhd>>Valvular heart disease :<</vhd>>
    <ul>
    <li><<vhd_mv_icd>>Mitral valve disease <</vhd_mv_icd>><<vhd_mv_icd>><</vhd_mv_icd>></li>
    <li><<vhd_av_icd>>Aortic valve disease <</vhd_av_icd>><<vhd_av_icd>><</vhd_av_icd>></li>
    <li><<vhd_ov_icd>>Non aortic-mitral valve disease <</vhd_ov_icd>><<vhd_ov_icd>><</vhd_ov_icd>></li>
    <li><<vhd_ie_icd>>Infective endocarditis <</vhd_ie_icd>><<vhd_ie_icd>><</vhd_ie_icd>></li>
    <li><<vhd_icpc>>Valvular disease NOS<</vhd_icpc>><<vhd_icpc>><</vhd_icpc>></li>
    </ul>
    </li>
    <li><<rxn>>Current medication classes
    <ul>
    <li><<rxn_ap>>Anti-platelet agents<</rxn_ap>></li>
    <li><<rxn_statin>>Statins<</rxn_statin>></li>
    <li><<rxn_anticoag>>Anti-coagulation (Warfarin or NOAC)<</rxn_anticoag>></li>
    <li><<rxn_diu_loop>>Loop diuretics<</rxn_diu_loop>></li>
    <li><<rxn_diu_low_ceil>>Low-ceiling diuretics<</rxn_diu_low_ceil>></li>
    <li><<rxn_diu_k_sp>>Low-ceiling diuretics<</rxn_diu_k_sp>></li>
    <li><<rxn_chrono>>Anti-arrhythmic agent<</rxn_chrono>><</rxn>></li>
    </ul>
    </li>
    </ul>
    </li>
    </ul>  
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','rrt_syn','rrt',601000,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li>End-stage renal failure (ESRD)
    <ul>
    <li><<rrt=1>>Currently on haemodialysis, since <<hd_dt>><</hd_dt>><</rrt=1>></li>
    <li><<rrt=2>>Currently on peritoneal dialysis, since <<pd_dt>><</pd_dt>><</rrt=2>></li>
    <li><<rrt=3>>Active renal transplant, <<tx_dt>><</tx_dt>><</rrt=3>><br /> <<rrt=4>>Currently on home-haemodialysis, <<homedx_dt>><</homedx_dt>><</rrt=4>></li>
    </ul>
    </li>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_syn_1','ckd',601100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li>CKD stage <strong><<ckd_stage>><</ckd_stage>></strong>
    <ul>
    <<ckd_stage>><li><<dx_ckd>>Diagnosed <</dx_ckd>><<pers>>Persistent <</pers>>CKD stage <strong> (<<cga_g>><</cga_g>><<cga_a>><</cga_a>>)</strong> [1.1].</li><</ckd_stage>>
    <<dx_ckd=0>><li>No coded diagnosis on the EHR [1.2]</li><</dx_ckd=0>>
    <<dx_ckd>><li>The diagnosis on the EHR is CKD stage <<dx_ckd_stage>><</dx_ckd_stage>> [1.2]</li><</dx_ckd>>
    <<egfrlv>><li>Last eGFR is <strong><<egfrlv>><</egfrlv>></strong> ml/min/1.73m2 (<<egfrld>><</egfrld>>)<<egfr_outdated>> and is outdated [1.3].<</egfr_outdated>></li><</egfrlv>>
    <<acrlv>><li>Last uACR is <<acrlv>><</acrlv>> mg/mmol (<<acrld>><</acrld>>)<<acr_outdated>> and is outdated [1.3].<</acr_outdated>></li><</acrlv>>
    <<egfr_decline>><li><<egfr_rapid_decline>>rapid <</egfr_rapid_decline>>progressive decline of renal function with an annual decline of <<egfr_slope2>><</egfr_slope2>>ml/min/yr [1.3]</li><</egfr_decline>>
    <<enc_null=0>><li>No captured encounters with renal services.</li><</enc_null=0>>
    <<enc_ld>><li>Last encounter with renal services was on <<enc_ld>><</enc_ld>><<enc_n>> and there have been <</enc_n>><<enc_n>><</enc_n>><<enc_n>> encounters since <</enc_n>><<enc_fd>><</enc_fd>></li><</enc_ld>>
    <<avf>><li>An arterio-venous fistula has been created on <<avf>><</avf>></li><</avf>>
    <<cp_ckd=0>><li>No current careplan for CKD</li><</cp_ckd=0>>
    <<cp_ckd>><li>CKD current careplan is <<cp_ckd>><</cp_ckd>><<cp_ckd>> updated on <</cp_ckd>><<cp_ckd_ld>><</cp_ckd_ld>><</cp_ckd>>
    <ul>
    <<cp_mis>><li>existing care plan may not be adequate [1.8]</li><</cp_mis>>
    </ul>
    </li>
    </ul>
    </li>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_syn_1z','ckd',601199,'dev','tkc',TO_DATE(SYSDATE),
    '
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','rx_syn_1','rx_desc',691100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Medications(<<rxn_0>><</rxn_0>>)
    --------------
    <<rx_name_obj>><</rx_name_obj>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_cause_syn_1','ckd_cause',601101,'dev','tkc',TO_DATE(SYSDATE),
    '<ul>
    <li>aetiology
    <ul>
    <<aet_multiple=1>><li>Multiple aetiology is suggested<</aet_multiple=1>>
    <ul>
    <<aet_dm=1>><li>diabetes mellitus</li><</aet_dm=1>>
    <<aet_htn=1>><li>hypertension</li><</aet_htn=1>>
    <<aet_gn_ln=1>><li>lupus nephritis</li><</aet_gn_ln=1>>
    <<aet_gn_x=1>><li>glomerulopathy NOS</li><</aet_gn_x=1>>
    </ul>
    </li>
    <<aet_multiple=0>><li>The likely cause is <strong><<aet_dm>>diabetic kidney disease (DKD)<</aet_dm>><<aet_htn>>,hypertensive kidney disease<</aet_htn>><<aet_gn_ln>>,lupus nephritis<</aet_gn_ln>></strong></li><</aet_multiple=0>>
    </ul>
    </li>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_recm_1','ckd',701100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<dx_ckd_diff>>Recommendation [1.2] Update diagnosis to CKD stage <<ckd_stage>><</ckd_stage>><</dx_ckd_diff>>
    <<egfr_outdated>>Recommendation [1.3] Repeat renal function tests.<</egfr_outdated>>
    <<cp_mis>>Recommendation [1.7] Update care plan to include appropriate stage of CKD<</cp_mis>>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_recm_2','ckd_complications',701200,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<hco3_low>>Recommendation [1.5.1] Consider adding oral bicarbonate therapy for metabolic acidosis<</hco3_low>>
    <<phos_high>>Recommendation [1.5.2] Consider adding oral phsophate binder therapy<</phos_high>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_footnote_1','ckd',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<egfr_single>>Note [1.1] This is based on a single egfr value on <<egfrld>><</egfrld>><</egfr_single>>
    <<egfr_multiple>>Note [1.1] This is based on <<iq_egfr>><</iq_egfr>> egfr values between <<egfrfd>><</egfrfd>> and <<egfrld>><</egfrld>><</egfr_multiple>>
    <<egfr_outdated>>Note [1.2.1] Last egfr on <<egfrld>><</egfrld>><</egfr_outdated>>
    <<acr_outdated>>Note [1.2.2] Last uACR on <<acrld>><</acrld>><</acr_outdated>>
    <<asm_viol_3m>>Note [1.2.3] Assumption violation present. +/- 20% fluctuation in last 30 days <</asm_viol_3m>>
    <<egfr_decline>>Note [1.3] Maximum eGFR of <<egfr_max_v>><</egfr_max_v>> ml/min/1.73m2 on <<egfr_max_ld>><</egfr_max_ld>>  with the most recent value being <<egfrlv>><</egfrlv>><</egfr_decline>>
    <<iq_tier=4>>Note [1.0] This was based on the presence of at least one ICPC2+ code and more than two eGFR and uACR value (Tier 4).<</iq_tier=4>>
    <<iq_tier=3>>Note [1.0] This was based on at least two eGFR and uACR values (Tier 3). <</iq_tier=3>>
    <<iq_tier=2>>Note [1.0] This was based on at least one eGFR and uACR value (Tier 3). <</iq_tier=2>>
    <<iq_tier=1>>Note [1.0] This was based on at least one eGFR or uACR value (Tier 4). <</iq_tier=1>>
    '
    );


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cvra_syn_1','cvra',604100,'dev','tkc',TO_DATE(SYSDATE),
    '   |
    +-- Cardiovascular risk (CVR)
    <<risk_high_ovr=0>>|        +-- CVR status was calculated using FRE [4.1]<</risk_high_ovr=0>>
    <<risk_5>>|        +-- Composite 5 year CVD risk is <</risk_5>><<risk_5>><</risk_5>><<risk_5>> ,which is <</risk_5>>
    <<risk_high_ovr=1>>|        +-- The composite 5 year CVD risk is<</risk_high_ovr=1>><<cvra=3>> high <</cvra=3>>
    <<cvra=2>>|        +-- The composite 5 year CVD risk is<<cvra=2>><<cvra=2>> moderate risk<</cvra=2>>
    <<cvra=1>>|        +-- The composite 5 year CVD risk is<<cvra=1>><<cvra=1>> low risk<</cvra=1>> 
    <<risk_high_ovr>>|        +-- The patient meets criteria for high CVR without calculation<</risk_high_ovr>>
    <<cvd_prev>>|            +--  previous documented CVD event<</cvd_prev>>
    <<dm60>>|            +-- Diabetes and age more than 60 <</dm60>>
    <<dmckd1>>|            +-- Diabetes and albuminuria <</dmckd1>>
    <<ckd3>>|            +-- CKD 3b or above <</ckd3>>
    <<tc7>>|            +-- total cholesterol more than 7.5 <</tc7>>
    <<sbp180>>|            +-- systolic bp more than 180mmHg <</sbp180>>
    <<age74>>|            +--  age more than 74 and ATSI.<</age74>>
    <<cp_hicvr=0>>|        +-- There is no cv careplan.<</cp_hicvr=0>><<cp_hicvr=1>>|        +-- A high CVR careplan is already in place.<</cp_hicvr=1>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cvra_rec_1','cvra',704100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<cvra=3>><<cp_hicvr=0>>Recommendation [4.1]  Update care plan to include High CVR <</cp_hicvr=0>><</cvra=3>>
    <<cvra=3>><<smoke0=30>>Recommendation [4.2]  Given high cvr status the smoking cessation is strongly advised <</smoke0=30>><</cvra=3>>
    <<cvra=2>><<smoke0=30>>Recommendation [4.2]  Given moderate cvr status the smoking cessation is advised <</smoke0=30>><</cvra=2>>

    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cvra_footnote_1','cvra',804100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<risk_high_ovr=0>>Note [4.1] The Framigham risk equation was used as per heart foundation guidelines. The CARPA 7th STM uses the same methodology<</risk_high_ovr=0>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_journey_1','ckd_journey',601105,'dev','tkc',TO_DATE(SYSDATE),
    '   |       +-- Renal services engagement
    <<enc_multi=0>><<enc_ld>>|              +-- Nephrologist review <</enc_ld>><<enc_ld>><</enc_ld>><</enc_multi=0>>
    <<enc_multi>>|              +-- Nephrologist reviews :\t<<enc_fd>><</enc_fd>>-<<enc_ld>><</enc_ld>> [<<enc_n>><</enc_n>>] <</enc_multi>>
    <<edu_init>>|              +-- CKD Education (initial) :\t<</edu_init>><<edu_init>><</edu_init>>
    <<edu_rv>>|              +-- CKD Education review (last) :\t<</edu_rv>><<edu_rv>><</edu_rv>>
    <<dietn>>|              +-- Renal Dietician review (last) :\t<</dietn>><<dietn>><</dietn>>
    <<sw>>|              +-- Renal social work review (last) :\t<</sw>><<sw>><</sw>>
    <<avf_ld>>|              +-- CKD Access (AVF) formation date :\t\t<</avf_ld>><<avf_ld>><</avf_ld>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_dx_1','ckd_diagnostics',601110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li>diagnostic workup
    <ul>
    <li>Basic urinalysis : <<ua_null=1>>not performed<</ua_null=1>><<ua_rbc_ld>>last performed on <</ua_rbc_ld>><<ua_rbc_ld>><</ua_rbc_ld>><<ua_rbc_ld>> and shows <</ua_rbc_ld>><<ua_null=0>><<ua_pos=0>>no significance<</ua_pos=0>><<ua_pos=1>> haematuria with leucocyturia <</ua_pos=1>><<ua_pos=2>> haematuria without leucocyturia <</ua_pos=2>><</ua_null=0>></li>
    <li>ANA Serology : <<dsdna_null=1>>not performed <</dsdna_null=1>><<dsdna_null=0>><<dsdna_ld>>last performed on <</dsdna_ld>><<dsdna_ld>><</dsdna_ld>><<dsdna_ld>> and is <</dsdna_ld>><<dsdna_pos=1>>SIGNIFICANT <</dsdna_pos=1>><</dsdna_null=0>></li>
    <li>ANCA Serology : <<anca_null=1>>not performed <</anca_null=1>><<anca_null=0>><<pr3_ld>>last performed on <</pr3_ld>><<pr3_ld>><</pr3_ld>><</anca_null=0>></li>
    <li>Complements : <<c3c4_null=1>>not performed <</c3c4_null=1>><<c3c4_null=0>><<c3_ld>>last performed on <</c3_ld>><<c3_ld>><</c3_ld>><</c3c4_null=0>></li>
    <li>Serum PEP : <<spep_null=1>>not performed <</spep_null=1>><<spep_null=0>><<paraprot_ld>>last performed on <</paraprot_ld>><<paraprot_ld>><</paraprot_ld>><</spep_null=0>></li>
    <li>SFLC assay : <<sflc_null=1>>not performed <</sflc_null=1>><<sflc_null=0>><<sflc_kappa_ld>>last performed on <</sflc_kappa_ld>><<sflc_kappa_ld>><</sflc_kappa_ld>><</sflc_null=0>></li>
    <li>Renal imaging : <<usk_null=1>>not performed <</usk_null=1>><<usk_null=0>>Most recent ultrasound kidney on <<ris_usk_ld>><</ris_usk_ld>><</usk_null=0>></li>
    <li>Kidney biopsy : <<bxk_null=1>>not performed <</bxk_null=1>><<bxk_null=0>>Kidney biopsy on <<ris_bxk_ld>><</ris_bxk_ld>><</bxk_null=0>></li>
    </ul>
    </li>
    </ul>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_compx_1','ckd_complications',601120,'dev','tkc',TO_DATE(SYSDATE),
    '<ul>
    <li>CKD Complications
    <ul>
    <li>Haemopoetic function
    <ul>
    <<hb_lv>><li>Last haemoglobin on <<hb_ld>><</hb_ld>> is <<hb_lv>></hb_lv>> g/L</li><</hb_lv>>
    <<hb_state=2>><li>acceptable range</li><</hb_state=2>>
    <<hb_state=1>><li><<mcv_state=11>>consistent with severe microcytic anaemia <</mcv_state=11>></li><</hb_state=1>>
    <<hb_state=1>></li><<mcv_state=12>>consistent with microcytic anaemia<</mcv_state=12>></li><</hb_state=1>>
    <<hb_state=1>><li><<mcv_state=20>>consistent with normocytic anaemia<</mcv_state=20>></li><</hb_state=1>>
    <<hb_state=1>><li><<mcv_state=31>>consistent with macrocytic anaemia<</mcv_state=31>></li><</hb_state=1>>
    <<hb_state=1>><li><<mcv_state=0>>consistent with anaemia<</mcv_state=0>></li><</hb_state=1>>
    <<esa_state=0>><li>No ESA use</li><</esa_state=0>>
    <<esa_state=1>><li>current ESA use</li><</esa_state=1>>
    <<esa_state=2>><li>Past ESA use but not current</li><</esa_state=2>>
    <<iron_low>><li>Iron stores low/<li><</iron_low>>
    </ul>
    </li>
    <li>Acid-base balance
    <ul>
    <<hco3_low>><li>low tCO2 at <<hco3_lv>><</hco3_lv>> mmol/l likely due to metabolic acidosis</li><</hco3_low>>
    </ul>
    </li>
    </ul>
    </li>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','graph_egfr','egfr_graph',651100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Temporal variation of eGFR  
    eGFR ml/min against time 
    <<br>><<xygraph>><</xygraph>><<br>>
    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','egfr_metrics','egfr_metrics',651110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<r1_stg=1>>Normal renal function of <<egfr_r1_val>><</egfr_r1_val>> ml/min at entry<</r1_stg=1>>
    <<r1_stg=2>>Near normal renal function of <<egfr_r1_val>><</egfr_r1_val>> ml/min at entry<</r1_stg=2>>
    <<p3pg_signal=1>>Apparent progression from <<egfr60_last_val>><</egfr60_last_val>> ml/min to <<egfr_rn_val>><</egfr_rn_val>> ml/min during (<<egfr60_last_dt>><</egfr60_last_dt>>-<<egfr_rn_dt>><</egfr_rn_dt>>) <</p3pg_signal=1>>
    <<est_esrd_lapsed=0>><<est_esrd_dt>>Estimated ESRD around <<est_esrd_dt>><</est_esrd_dt>>.<</est_esrd_dt>><</est_esrd_lapsed=0>>
    <<est_esrd_lapsed=1>><<est_esrd_dt>>Imminent ESRD, with estimation boundry in the past<</est_esrd_lapsed=1>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','graph_acr','acr_graph',661100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Temporal variation of uACR  
    Log(uACR) mg/mmol against time
    <<br>><<xygraph>><</xygraph>><<br>>
    '
    );
@"tkc-create-package-rman-1.sql";