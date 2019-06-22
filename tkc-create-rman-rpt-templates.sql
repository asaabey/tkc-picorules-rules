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
--11	Chronic disease : CKD
--21	Chronic disease : DM2
--31	Chronic disease : HTN


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
    VALUES('neph001','alert_tg4620','tg4620_1_1',304620,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Unmanaged advanced CKD with rapid progression (Trigger 4620)
    --------------------------------------------------------------------
    There is CKD stage <ckd_stage></ckd_stage> disease with an annual decline of <eb></eb> ml/min/yr without a recent specialist encounter
    <avf>Please note the AVF creation on </avf><avf></avf>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','alert_tg4610','tg4610_1_1',304610,'dev','tkc',TO_DATE(SYSDATE),
    '
    Alert : Unmanaged possible early CKD with rapid progression (Trigger 4610)
    --------------------------------------------------------------------------
    The current glomerular stage is <ckd_stage></ckd_stage> with an annual decline of <eb></eb> ml/min/yr without a recent specialist encounter
    <egfrlv>The last eGFR was </egfrlv><egfrlv></egfrlv><egfrlv> ml/min on </egfrlv><egfrld></egfrld><egfr_max_v> with a decline from </egfr_max_v><egfr_max_v></egfr_max_v><egfr_max_v> ml/min </egfr_max_v><egfr_max_ld> on </egfr_max_ld><egfr_max_ld></egfr_max_ld> 
    <ckd_null>Please note the absence of CKD staging as this does not currently fullfill criteria.</ckd_null>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_dm_syn_1','cd_dm_2',602100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Diabetes Rubric
    -------------------
    <dm_dx_code_flag>Diagnosed</dm_dx_code_flag><dm_dx_undiagnosed>Undiagnosed</dm_dx_undiagnosed><dm_longstanding> long standing</dm_longstanding> type <dm_type></dm_type> diabetes mellitus since <dm_fd_t></dm_fd_t>.
    <dm_micvas>There are non-renal microvascular complications.</dm_micvas>The glycaemic control is <n0_st=0> unknown </n0_st=0><n0_st=2>optimal (6-8)</n0_st=2><n0_st=1>too tight(<6)</n0_st=1><n0_st=3>sub-optimal (8-10)</n0_st=3><n0_st=4>very sub-optimal (>10)</n0_st=4> with <n_opt_qt></n_opt_qt>% (<hba1c_n_opt></hba1c_n_opt>/<hba1c_n_tot></hba1c_n_tot>) of the readings in the optimal range.
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
    VALUES('neph001','cd_htn_syn_1','cd_htn_2',603100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Hypertension Rubric
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
    VALUES('neph001','cd_ckd_syn_1','ckd_2_1',601100,'dev','tkc',TO_DATE(SYSDATE),
    '
    CKD Rubric
    -------------------
    <dx_ckd>Diagnosed </dx_ckd><pers>Persistent </pers>CKD stage <ckd_stage></ckd_stage> (<cga_g></cga_g><cga_a></cga_a>) [1.1]. 
    <dx_ckd=0>There is no coded diagnosis on the EHR [1.2]</dx_ckd=0>
    <dx_ckd>The diagnosis on the EHR is CKD stage [1.2]<dx_ckd_stage></dx_ckd_stage></dx_ckd>
    The last eGFR is <egfrlv></egfrlv> ml/min/1.73m2 (<egfrld></egfrld>)<egfr_outdated> and is outdated [1.3].</egfr_outdated>
    <egfr_decline>There is <egfr_rapid_decline>rapid </egfr_rapid_decline>progressive decline of renal function with an annual decline of <egfr_slope2></egfr_slope2>ml/min/yr [1.3]</egfr_decline> 
    <enc_null=0>There are no captured encounters with renal services.</enc_null=0>
    <enc_ld>The last encounter with renal services was on </enc_ld><enc_ld></enc_ld><enc_n> and there have been </enc_n><enc_n></enc_n><enc_n> encounters since </enc_n><enc_fd></enc_fd>
    <avf>An arterio-venous fistula has been created on </avf><avf></avf>
    <cp_ckd=0>There is no current careplan for CKD</cp_ckd=0>
    <cp_ckd>The CKD current careplan is </cp_ckd><cp_ckd></cp_ckd><cp_ckd> update on </cp_ckd><cp_ckd_ld></cp_ckd_ld>
    <cp_mis>The existing care plan may not be adequate [1.8]</cp_mis>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_cause_syn_1','ckd_cause_2_1',601101,'dev','tkc',TO_DATE(SYSDATE),
    '
    <aet_multiple=1>Multiple aetiology is suggested by presence of </aet_multiple=1><aet_dm=1>diabetes mellitus </aet_dm=1><aet_htn=1>,hypertension </aet_htn=1><aet_gn_ln=1>,lupus nephritis </aet_gn_ln=1><aet_gn_x=1>,glomerulopathy NOS</aet_gn_x=1>
    <aet_multiple=0>The likely cause is <aet_dm>diabetic kidney disease (DKD)</aet_dm><aet_htn>,hypertensive kidney disease</aet_htn><aet_gn_ln>,lupus nephritis</aet_gn_ln><aet_gn_x>,glomerulopathy NOS</aet_gn_x></aet_multiple=0>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_recm_1','ckd_2_1',701100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <dx_ckd_diff>Recommendation [1.2] Update diagnosis to CKD stage <ckd_stage></ckd_stage></dx_ckd_diff>
    <egfr_outdated>Recommendation [1.3] Repeat renal function tests.</egfr_outdated>
    <cp_mis>Recommendation [1.7] Update care plan to include appropriate stage of CKD</cp_mis>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001','cd_ckd_footnote_1','ckd_2_1',801100,'dev','tkc',TO_DATE(SYSDATE),
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
    VALUES('neph001','cd_htn_footnote_1','cd_htn_2',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <iq_tier>Note [3.1] This is based on <iq_sbp></iq_sbp> blood pressure readings within the last 2 years</iq_tier>
    <bp_control>Note [3.3] Based on time in therapeutic range (TITR)</bp_control>

    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph001_1','cd_htn_footnote_1_1','cd_htn_2',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Test msg

    '
    );