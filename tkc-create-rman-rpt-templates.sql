--TKC Natural Language Composition(NLC) engine 
--Version 	0.0.1.0
--Creation date	17/06/2019
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


DROP TABLE rman_rpt_templates;
/
CREATE TABLE rman_rpt_templates
(
    templateid      varchar2(100) not null,
    ruleblockid     varchar2(100),
    placementid     INTEGER,
    templatehtml    clob,
    environment     varchar2(30),
    template_owner  varchar2(30),
    effective_dt    date,
    compositionid   varchar2(100)not null,
    CONSTRAINT pk_rman_rpt_templates PRIMARY KEY(templateid)
    --CONSTRAINT fk_template_ruleblock FOREIGN KEY(ruleblockid) REFERENCES rman_ruleblocks(blockid)
);
/
DROP INDEX rman_rpt_templates_ruleblockid;
/
CREATE INDEX rman_rpt_templates_ruleblockid ON rman_rpt_templates(ruleblockid);
/
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4620','tg4620',304620,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Unmanaged advanced CKD with rapid progression (Trigger 4620)
    --------------------------------------------------------------------
    There is CKD stage <ckd_stage></ckd_stage> disease with an annual decline of <eb></eb> ml/min/yr without a recent specialist encounter
    <avf>Please note the AVF creation on </avf><avf></avf>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4610','tg4610',304610,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Unmanaged possible early CKD with rapid progression (Trigger 4610)
    --------------------------------------------------------------------------
    The current glomerular stage is <ckd_stage></ckd_stage> with an annual decline of <eb></eb> ml/min/yr without a recent specialist encounter
    <egfrlv>The last eGFR was </egfrlv><egfrlv></egfrlv><egfrlv> ml/min on </egfrlv><egfrld></egfrld><egfr_max_v> with a decline from </egfr_max_v><egfr_max_v></egfr_max_v><egfr_max_v> ml/min </egfr_max_v><egfr_max_ld> on </egfr_max_ld><egfr_max_ld></egfr_max_ld> 
    <ckd_null>Please note the absence of CKD staging as this does not currently fullfill criteria.</ckd_null>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4100','tg4100',304100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Acute kidney injury in community (Trigger 4100)
    --------------------------------------------------------------------------
    Baseline creatinine is estimated to be <cr_base></cr_base> umol/l and the maxima is <cr_max_1y></cr_max_1y> umol/l on <cr_max_ld_1y></cr_max_ld_1y>
    This is consistent with an acute kidney injury (AKIN stage 2 or above).
    <aki_outcome=3>There is no resoltion </aki_outcome=3>
    <aki_outcome=2>There appears to be partial resolution</aki_outcome=2>
    <aki_outcome=1>There appears to be complete resolution</aki_outcome=1>
    last recored creatinine is <cr_lv></cr_lv>umol/l on <cr_ld></cr_ld>.
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4410','tg4410',304410,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Nephrotic range proteinuria in the absence of diabetes (Trigger 4410)
    -----------------------------------------------------------------------------
    The last uACR was <uacr1></uacr1> mg/mmol and the one before was <uacr2></uacr2> mg/mmol.
    <iq_tier=3>Serum Albumin and Cholesterol have been checked <low_alb> and there is hypoalbuminaemia</low_alb><higl_chol> and hypercholesterolaemia</higl_chol></iq_tier=3>
    This is consistent with a primary nephrotic syndrome
    <iq_tier=4>It is noted that autoimmune and other relevant serological tests have been performed</iq_tier=4>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4720','tg4720',304720,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : New commencement on Renal replacement therapy (Trigger 4720)
    --------------------------------------------------------------------
    <hd_start>Patient has been commenced on haemodialysis on <hd_dt_min></hd_dt_min><hd_start>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4660','tg4660',304660,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Medication safety concern (Trigger 4660)
    ------------------------------------------------
    This patient is on <dm_rxn_bg>a biguanide,</dm_rxn_bg><dm_rxn_sglt2> SGLT2 inhibitor,</dm_rxn_sglt2><rx_nsaids> NSAIDS,</rx_nsaids> which is inconsistent with the current renal function.
    <dm_rxn_bg>Biguanides may be rarely associated with lactic acidosis at this level of renal function</dm_rxn_bg>
    <dm_rxn_sglt2>SGLT2 inhibitors are relatively contra-indicated at this level of renal function</dm_rxn_sglt2>
    <rx_nsaids>NSAIDS may cause additional renal injury</rx_nsaids>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg2610','tg2610',302610,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Potentially untreated chronic disease (Trigger 2610)
    ------------------------------------------------------------
    <dm_untreat>Likely to require pharmacotherapy for glycaemic control. No active medications are detected.</dm_untreat>
    <ckd_untreat>Likely to benefit from RAAS blockade therapy (ACEi or ARB) in the context of albuminuric chronic kidney disease</ckd_untreat>
    <ckd_untreat>Last systolic BP is <sbp_val></sbp_val> mmHg ( <sbp_dt></sbp_dt>) and serum potassium is <k_val></k_val> mmol/l (<k_dt></k_dt>)</ckd_untreat>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_dm_syn_1','cd_dm',602100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Diabetes rubric
    -------------------
    <dm_dx_code_flag>Diagnosed</dm_dx_code_flag><dm_dx_undiagnosed>Undiagnosed</dm_dx_undiagnosed><dm_longstanding> long standing</dm_longstanding> type <dm_type></dm_type> diabetes mellitus since <dm_fd_t></dm_fd_t>.
    <dm_micvas>There are non-renal microvascular complications.</dm_micvas>
    <hba1c_n_tot>The last recorded HbA1c (NGSP) is <hba1c_n0_val></hba1c_n0_val> % (<hba1c_n0_dt></hba1c_n0_dt>).</hba1c_n_tot>
    The glycaemic control is <n0_st=0> unknown </n0_st=0><n0_st=2>optimal (6-8)</n0_st=2><n0_st=1>too tight(<6)</n0_st=1><n0_st=3>sub-optimal (8-10)</n0_st=3><n0_st=4>very sub-optimal (>10)</n0_st=4> with <n_opt_qt></n_opt_qt>% (<hba1c_n_opt></hba1c_n_opt>/<hba1c_n_tot></hba1c_n_tot>) of the readings in the optimal range.
    <dm_rxn=0>No medications were detected.</dm_rxn=0>
    <dm_rxn>Medications used currently include</dm_rxn><dm_rxn_su> ,a sulphonylurea </dm_rxn_su><dm_rxn_ins_long>, a long-acting insulin</dm_rxn_ins_long><dm_rxn_glp1>, a GLP1 analogue</dm_rxn_glp1><dm_rxn_dpp4>, a DPP4 inhibitor</dm_rxn_dpp4><dm_rxn_sglt2>, a SGLT2 inhibitor</dm_rxn_sglt2>
    <cp_dm=0>Diabetes careplan was not detected [2.4]</cp_dm=0>
    <cp_dm>Diabetes careplan was updated on </cp_dm><cp_dm_ld></cp_dm_ld>
    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_dm_rec_1','cd_dm_2',702100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <n0_st=3>Recommendation [2.3] Suggest optimizing glycaemic control</n0_st=3>
    <n0_st=4>Recommendation [2.3] Suggest optimizing glycaemic control</n0_st=4>
    <cp_dm=0>Recommendation [2.4] Suggest updating care plan to include diabetes</cp_dm=0>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_htn_syn_1','cd_htn',603100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Hypertension rubric
    -------------------
    <htn_icpc>Diagnosed</htn_icpc> Hypertension <htn_fd_yr> since </htn_fd_yr><htn_fd_yr></htn_fd_yr>.
    <mu_1>The average systolic BP during last year was </mu_1><mu_1></mu_1><mu_1> mmHg</mu_1><mu_2> and the year before was </mu_2><mu_2></mu_2><mu_2> mmHg.</mu_2>
    <slice140_1_n></slice140_1_n><slice140_1_n> out of </slice140_1_n><sigma_1></sigma_1><slice140_1_n> are above 140mmHg</slice140_1_n>
    <bp_trend=1>Hypertension control appears to have improved compared to last year</bp_trend=1>
    <bp_trend=2>Hypertension control appears to have worsened compared to last year</bp_trend=2>
    BP control <bp_control=3>appears to be adequate</bp_control=3><bp_control=2>can be optimized</bp_control=2><bp_control=1>appears to sub-optimal</bp_control=1><bp_control=0>could not be determined</bp_control=0>[3.3]
    <htn_rxn>Currently used agents </htn_rxn><htn_rxn_arb>Angiotensin receptor blocker (ARB) </htn_rxn_arb><htn_rxn_acei>ACE inhibitor </htn_rxn_acei><htn_rxn_ccb>Calcium channel blocker (CCB) </htn_rxn_ccb> 
    <htn_rxn_bb>Beta blocker </htn_rxn_bb><htn_rxn_diuretic_thiazide>Thiazide diuretic </htn_rxn_diuretic_thiazide><htn_rxn_diuretic_loop>Thiazide diuretic </htn_rxn_diuretic_loop>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_htn_rec_1','cd_htn_2',703100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <htn_icpc=0>Recommendation [3.1] Update diagnosis to hypertension</htn_icpc=0>
    <bp_control=2>Recommendation [3.4] Optimize BP control</bp_control=2>
    <bp_control=1>Recommendation [3.14] Optimize BP control</bp_control=1>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_htn_footnote_1','cd_htn',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <iq_tier>Note [3.1] This is based on <iq_sbp></iq_sbp> blood pressure readings within the last 2 years</iq_tier>
    <bp_control>Note [3.3] Based on time in therapeutic range (TITR)</bp_control>

    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_cardiac_syn','cd_cardiac',604100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Cardiac disease rubric
    ----------------------
    <cad>Coronary artery disease :</cad><cabg>Cornoary artery bypass grafting </cabg><cabg></cabg>
    <cad_mi_icd>First myocardial infarction </cad_mi_icd><cad_mi_icd></cad_mi_icd>
    <vhd>Valvular heart disease :</vhd><vhd_mv_icd>Mitral valve disease </vhd_mv_icd><vhd_mv_icd></vhd_mv_icd><vhd_av_icd>Aortic valve disease </vhd_av_icd><vhd_av_icd></vhd_av_icd><vhd_ov_icd>Non aortic-mitral valve disease </vhd_ov_icd><vhd_ov_icd></vhd_ov_icd><vhd_ie_icd>Infective endocarditis </vhd_ie_icd><vhd_ie_icd></vhd_ie_icd><vhd_icpc>Valvular disease NOS</vhd_icpc><vhd_icpc></vhd_icpc>
    <rxn>Currently used classes : <rxn_ap>Anti-platelet agents,</rxn_ap><rxn_statin>Statins,</rxn_statin><rxn_anticoag>Anti-coagulation (Warfarin or NOAC)</rxn_anticoag></rxn>
    <rxn><rxn_diu_loop>Loop diuretics,</rxn_diu_loop><rxn_diu_low_ceil>Low-ceiling diuretics,</rxn_diu_low_ceil><rxn_diu_k_sp>Low-ceiling diuretics,</rxn_diu_k_sp></rxn>
    <rxn><rxn_chrono>Anti-arrhythmic agent</rxn_chrono></rxn>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','rrt_syn','rrt',601000,'dev','tkc',TO_DATE(SYSDATE),
    '
    End-stage renal failure (ESRD)
    ------------------------------
    <rrt=1>Currently on haemodialysis, since <hd_dt></hd_dt></rrt=1>
    <rrt=2>Currently on peritoneal dialysis, since <pd_dt></pd_dt></rrt=2>
    <rrt=3>Active renal transplant, <tx_dt></tx_dt></rrt=3>
    <rrt=4>Currently on home-haemodialysis, <homedx_dt></homedx_dt></rrt=4>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_syn_1','ckd',601100,'dev','tkc',TO_DATE(SYSDATE),
    '
    CKD rubric
    ----------
    <dx_ckd>Diagnosed </dx_ckd><pers>Persistent </pers>CKD stage <ckd_stage></ckd_stage> (<cga_g></cga_g><cga_a></cga_a>) [1.1]. 
    <dx_ckd=0>There is no coded diagnosis on the EHR [1.2]</dx_ckd=0>
    <dx_ckd>The diagnosis on the EHR is CKD stage <dx_ckd_stage></dx_ckd_stage> [1.2] </dx_ckd>
    The last eGFR is <egfrlv></egfrlv> ml/min/1.73m2 (<egfrld></egfrld>)<egfr_outdated> and is outdated [1.3].</egfr_outdated>
    The last uACR is <acrlv></acrlv> mg/mmol (<acrld></acrld>)<acr_outdated> and is outdated [1.3].</acr_outdated>
    <egfr_decline>There is <egfr_rapid_decline>rapid </egfr_rapid_decline>progressive decline of renal function with an annual decline of <egfr_slope2></egfr_slope2>ml/min/yr [1.3]</egfr_decline> 
    <enc_null=0>There are no captured encounters with renal services.</enc_null=0>
    <enc_ld>The last encounter with renal services was on </enc_ld><enc_ld></enc_ld><enc_n> and there have been </enc_n><enc_n></enc_n><enc_n> encounters since </enc_n><enc_fd></enc_fd>
    <avf>An arterio-venous fistula has been created on </avf><avf></avf>
    <cp_ckd=0>There is no current careplan for CKD</cp_ckd=0>
    <cp_ckd>The CKD current careplan is </cp_ckd><cp_ckd></cp_ckd><cp_ckd> updated on </cp_ckd><cp_ckd_ld></cp_ckd_ld>
    <cp_mis>The existing care plan may not be adequate [1.8]</cp_mis>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_cause_syn_1','ckd_cause',601101,'dev','tkc',TO_DATE(SYSDATE),
    '
    <aet_multiple=1>Multiple aetiology is suggested by presence of </aet_multiple=1><aet_dm=1>diabetes mellitus </aet_dm=1><aet_htn=1>,hypertension </aet_htn=1><aet_gn_ln=1>,lupus nephritis </aet_gn_ln=1><aet_gn_x=1>,glomerulopathy NOS</aet_gn_x=1>
    <aet_multiple=0>The likely cause is <aet_dm>diabetic kidney disease (DKD)</aet_dm><aet_htn>,hypertensive kidney disease</aet_htn><aet_gn_ln>,lupus nephritis</aet_gn_ln><aet_gn_x>,glomerulopathy NOS</aet_gn_x></aet_multiple=0>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_recm_1','ckd',701100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <dx_ckd_diff>Recommendation [1.2] Update diagnosis to CKD stage <ckd_stage></ckd_stage></dx_ckd_diff>
    <egfr_outdated>Recommendation [1.3] Repeat renal function tests.</egfr_outdated>
    <cp_mis>Recommendation [1.7] Update care plan to include appropriate stage of CKD</cp_mis>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_footnote_1','ckd',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <egfr_single>Note [1.1] This is based on a single egfr value on <egfrld></egfrld></egfr_single>
    <egfr_multiple>Note [1.1] This is based on <iq_egfr></iq_egfr> egfr values between <egfrfd></egfrfd> and <egfrld></egfrld></egfr_multiple>
    <egfr_outdated>Note [1.2.1] Last egfr on <egfrld></egfrld></egfr_outdated>
    <acr_outdated>Note [1.2.2] Last uACR on <acrld></acrld></acr_outdated>
    <asm_viol_3m>Note [1.2.3] Assumption violation present. +/- 20% fluctuation in last 30 days </asm_viol_3m>
    <egfr_decline>Note [1.3] Maximum eGFR of <egfr_max_v></egfr_max_v> ml/min/1.73m2 on <egfr_max_ld></egfr_max_ld>  with the most recent value being <egfrlv></egfrlv></egfr_decline>
    <iq_tier=4>Note [1.0] This was based on the presence of at least one ICPC2+ code and more than two eGFR and uACR value (Tier 4).</iq_tier=4>
    <iq_tier=3>Note [1.0] This was based on at least two eGFR and uACR values (Tier 3). </iq_tier=3>
    <iq_tier=2>Note [1.0] This was based on at least one eGFR and uACR value (Tier 3). </iq_tier=2>
    <iq_tier=1>Note [1.0] This was based on at least one eGFR or uACR value (Tier 4). </iq_tier=1>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001_1','cd_htn_footnote_1_1','cd_htn',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Test msg

    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_cvra_syn_1','cvra',604100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Cardiovascular risk (CVR) rubric
    --------------------------------
    <risk_high_ovr=0>The CVR status was calculated using FRE [4.1]</risk_high_ovr=0><risk_5>The composite 5 year CVD risk is </risk_5><risk_5></risk_5><risk_5> ,which is </risk_5><risk_high_ovr=1>The composite 5 year CVD risk is</risk_high_ovr=1><cvra=3> high </cvra=3><cvra=2> moderate risk</cvra=2><cvra=1> low risk</cvra=1> 
    <risk_high_ovr>The patient meets criteria for high CVR without calculation, which are </risk_high_ovr><cvd_prev> previous documented CVD event </cvd_prev><dm60>Diabetes and age more than 60 </dm60><dmckd1> Diabetes and albuminuria </dmckd1><ckd3> CKD 3b or above </ckd3><tc7> total cholesterol more than 7.5 </tc7><sbp180> systolic bp more than 180mmHg </sbp180><age74> age more than 74 and ATSI.</age74>
    <cp_hicvr=0>There is no cv careplan.</cp_hicvr=0><cp_hicvr=1>A high CVR careplan is already in place.</cp_hicvr=1>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_cvra_rec_1','cvra',704100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <cvra=3><cp_hicvr=0>Recommendation [4.1]  Update care plan to include High CVR </cp_hicvr=0></cvra=3>
    <cvra=3><smoke0=30>Recommendation [4.2]  Given high cvr status the smoking cessation is strongly advised </smoke0=30></cvra=3>
    <cvra=2><smoke0=30>Recommendation [4.2]  Given moderate cvr status the smoking cessation is advised </smoke0=30></cvra=2>

    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_cvra_footnote_1','cvra',804100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <risk_high_ovr=0>Note [4.1] The Framigham risk equation was used as per heart foundation guidelines. The CARPA 7th STM uses the same methodology</risk_high_ovr=0>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_journey_1','ckd_journey',601200,'dev','tkc',TO_DATE(SYSDATE),
    '
    Renal services engagement rubric
    --------------------------------------
    <enc_multi=0><enc_ld>Nephrologist review :               </enc_ld><enc_ld></enc_ld></enc_multi=0>
    <enc_multi>Nephrologist reviews :              <enc_fd></enc_fd>-<enc_ld></enc_ld> [<enc_n></enc_n>] </enc_multi>
    <edu_init>CKD Education (initial) :           </edu_init><edu_init></edu_init>
    <edu_rv>CKD Education review (last) :       </edu_rv><edu_rv></edu_rv>
    <dietn>Renal Dietician review (last) :     </dietn><dietn></dietn>
    <sw>Renal social work review (last) :         </sw><sw></sw>
    
    <avf_ld>CKD Access (AVF) formation date :   </avf_ld><avf_ld></avf_ld>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_dx_1','ckd_diagnostics',601300,'dev','tkc',TO_DATE(SYSDATE),
    '
    CKD : Diagnostics rubric
    ------------------------
    Basic urinalysis    :       <ua_null=1>not performed</ua_null=1><ua_rbc_ld>last performed on </ua_rbc_ld><ua_rbc_ld></ua_rbc_ld><ua_rbc_ld> and shows </ua_rbc_ld><ua_null=0><ua_pos=0>no significance</ua_pos=0><ua_pos=1> haematuria with leucocyturia </ua_pos=1><ua_pos=2> haematuria without leucocyturia </ua_pos=2></ua_null=0>
    ANA Serology        :       <dsdna_null=1>not performed </dsdna_null=1><dsdna_null=0><dsdna_ld>last performed on </dsdna_ld><dsdna_ld></dsdna_ld><dsdna_ld> and is </dsdna_ld><dsdna_pos=1>SIGNIFICANT </dsdna_pos=1></dsdna_null=0>
    ANCA Serology       :       <anca_null=1>not performed </anca_null=1><anca_null=0><pr3_ld>last performed on </pr3_ld><pr3_ld></pr3_ld></anca_null=0>
    Complements         :       <c3c4_null=1>not performed </c3c4_null=1><c3c4_null=0><c3_ld>last performed on </c3_ld><c3_ld></c3_ld></c3c4_null=0>
    Serum PEP           :       <spep_null=1>not performed </spep_null=1><spep_null=0><paraprot_ld>last performed on </paraprot_ld><paraprot_ld></paraprot_ld></spep_null=0>
    SFLC assay          :       <sflc_null=1>not performed </sflc_null=1><sflc_null=0><sflc_kappa_ld>last performed on </sflc_kappa_ld><sflc_kappa_ld></sflc_kappa_ld></sflc_null=0>
    
    Renal tract imaging :       <usk_null=1>not performed </usk_null=1><usk_null=0>Most recent ultrasound kidney on <ris_usk_ld></ris_usk_ld></usk_null=0>
    Kidney biopsy       :       <bxk_null=1>not performed </bxk_null=1><bxk_null=0>Kidney biopsy on <ris_bxk_ld></ris_bxk_ld></bxk_null=0>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_compx_1','ckd_complications',601400,'dev','tkc',TO_DATE(SYSDATE),
    '
    CKD : Complications rubric
    --------------------------
    Haemopoetic function
    --------------------
    <hb_lv>The last haemoglobin on <hb_ld></hb_ld> is </hb_lv><hb_lv></hb_lv> g/L and is consistent a <hb_state=2> with an acceptable range</hb_state=2>
    <hb_state=1><mcv_state=11> severe microcytic </mcv_state=11><mcv_state=12> microcytic </mcv_state=12><mcv_state=20> normocytic </mcv_state=20><mcv_state=31> macrocytic </mcv_state=31> anaemia</hb_state=1>
    <esa_state=0>There is no ESA use</esa_state=0><esa_state=1>There is current ESA use</esa_state=1><esa_state=2>There is past ESA use but not current</esa_state=2>
    <iron_low>Iron store are low</iron_low>
    
    
    '
    );
@"tkc-create-package-rman-1.sql";