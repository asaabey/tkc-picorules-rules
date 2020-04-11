--TKC Composition
--Version 	0.0.2.0
--Creation date	24/11/2019
--Author		ASAABEY
--
--Purpose
--
--PlacementId : 6 digit code that is used to anchor the template in the composition
--
--Placement Codebook
--10    Header
--30	Alert
--60	Synthesis
--70	Recommendations 
--80	Notes
--90    Footer
--
--Disease codes
--00    reserved
--10	Chronic disease : RRT
--11	Chronic disease : CKD
--21	Chronic disease : DM2
--31	Chronic disease : HTN
--41	Chronic disease : CVD
--90    reserved


DELETE FROM rman_rpt_templates WHERE compositionid='neph002_html';

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_main_header','dmg',200001,'dev','tkc',TO_DATE(SYSDATE),
    '
    <style>
                .syn_alert_box {
                    border-style: solid;border-color: brown;border-radius: 10px;padding: 10px
                }
                .syn_dmg_box {
                    border-style: solid;border-color: green;border-radius: 10px;padding: 10px
                }
                .syn_synopsis_box {
                    border-style: solid;border-color: darkgray;border-radius: 10px;padding: 10px
                }
                .syn_recm_box {
                    border-style: solid;border-color: darkorange;border-radius: 10px;padding: 10px
                }
                .syn_notes_box {
                    border-style: solid;background-color: mintcream; border-color: #ccffe6 ;border-radius: 10px;padding: 10px
                }
                .syn_table {
                  border-collapse: collapse;
                  border-spacing: 0;
                  width: 80%;
                  border: 1px solid #ddd;
                  padding: 10px;
                }
                
                .syn_tr:nth-child(even) {
                    background-color: #f2f2f2;
                }
                
                .syn_container {
                    width : 90%;
                    margin : auto;
                }
                
                .syn_col_left {
                    width:350;
                    float: left;
                }
                
                .syn_col_right {
                    margin-left:350;
                    width:200;
                    
                }
                
                .svg_lab_panel {
                    height:60;
                    width:400;
                }
                
                .svg_lab_panel_rect {
                    width:100;
                    height:30;
                    fill:green;
                    stroke:green;
                    stroke-width:2;
                    fill-opacity:0.1;
                    stroke-opacity:0.9;
                    x:150;
                    y:30;
                }
                
                .svg_lab_panel_circle1 {
                    cy:45;
                    r:10;
                    stroke:none;
                    stroke-width:2;
                    fill:red;
                    fill-opacity:0.3;
                }
                
                .svg_lab_panel_circle2 {
                    cy:45;
                    r:10;
                    stroke:none;
                    stroke-width:2;
                    fill:red;
                }
                
                .svg_lab_panel_line {
                    y1:45;
                    y2:45;
                    stroke:black;
                    stroke-width:2;
                    stroke-dasharray:1,2;
                }
                
                .svg_lab_panel_text {
                    text-anchor:middle;
                    font-size:smaller;
                    
                }
                
                
    </style>
    
    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_synthesis_begin','dmg',600010,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
        <h3>Relevant Diagnoses</h3>
        <hr />
        <div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_synthesis_left_begin','dmg',600011,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_synthesis_left_end','dmg',609001,'dev','tkc',TO_DATE(SYSDATE),
    '
    </div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_synthesis_end','dmg',609010,'dev','tkc',TO_DATE(SYSDATE),
    '
    </div></div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_recm_begin','dmg',700001,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_recm_box">
    <h3>Recommendations</h3>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_recm_end','dmg',799999,'dev','tkc',TO_DATE(SYSDATE),
    '
    </div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_notes_begin','dmg',800001,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_notes_box">
    <h4>Footnotes</h4>
    <small>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','frame_notes_end','dmg',899999,'dev','tkc',TO_DATE(SYSDATE),
    '
    </small>
    </div>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','dmg_source_summary','dmg_source',200008,'dev','tkc',TO_DATE(SYSDATE),
    '
    
    <div class="syn_dmg_box">
    <<dmg_source>>
        
            Primary health care network:
            <<dmg_source=1>><b>NTG PCIS</b><hr /><</dmg_source=1>> 
            <<dmg_source=3>><b>NTG EACS</b><hr /><</dmg_source=3>>    
            <<dmg_source=4>><b>LAYNHAPUY</b><hr /><</dmg_source=4>>    
            <<dmg_source=5>><b>MIWATJ</b><hr /><</dmg_source=5>>    
            <<dmg_source=6>><b>ANYINGINYI</b><hr /><</dmg_source=6>> 
            <<pcis_n>><i>PCIS encounters(N=<<pcis_n />>, last=<<pcis_ld />>)</i><</pcis_n>> 
            <<eacs_n>><i>EACS encounters(N=<<eacs_n />>, last=<<eacs_ld />>)</i><</eacs_n>>
            <<miwatj_n>><i>MIWATJ encounters(N=<<miwatj_n />>, last=<<miwatj_ld />>)</i><</miwatj_n>>
            <<laynhapuy_n>><i>LAYNHAPUY encounters(N=<<laynhapuy_n />>, last=<<laynhapuy_ld />>)</i><</laynhapuy_n>>
            <<anyinginyi_n>><i>ANYINGINYI encounters(N=<<anyinginyi_n />>, last=<<anyinginyi_ld />>)</i><</anyinginyi_n>>
        
    <</dmg_source>>
    </div>
    <hr />

    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','dmg_loc_summary','dmg_loc',200010,'dev','tkc',TO_DATE(SYSDATE),
    '
    
    <div class="syn_dmg_box">
    <<episode_single>>Single episode at <<loc_last_val />> on <<loc_last_val />><</episode_single>>
        <<episode_single=0>><<loc_single>>There have been <<loc_n />> visits to <b><<loc_def$loc_sublocality />></b> <</loc_single>><</episode_single=0>>
        
        <<episode_single=0>><<loc_single=0>>visited <b><<loc_def$loc_sublocality />></b>  (<<loc_mode_n />>/<<loc_n />>) which is <<mode_pct />>%.<</loc_single=0>><</episode_single=0>>
        <<episode_single=0>><<diff_last_mode=1>>The last visited site is <<loc_last_val$loc_sublocality />> and the most visited is <<loc_def$loc_sublocality />> <</diff_last_mode=1>> <</episode_single=0>>    
    </div>
    <hr />
    
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4810','tg4810',304810,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>Alert: High haemoglobin on the background of ESA therapy  (Trigger 4810)</h5>
    Current haemoglobin is <<hb_i_val />> g/L which has increased from a previous hb of <<hb_i1_val />> g/L. <br />
    The ESA was last prescribed on \t <<esa_dt />>. 
    This finding is associated with a higher all-cause mortality in CKD and RRT patients.\n 
    It is possible that the medication is not administered,or an undocumented dose reduction has occured.
    </div>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4620','tg4620',304620,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>Alert: Advanced CKD with rapid progression, possibly unprepared (Trigger 4620)</h5>
    There is CKD stage <<ckd_stage />> disease with an annual decline of <<eb />> ml/min/yr without a recent specialist encounter. <br />
    <<avf>>Please note the AVF creation on <</avf>>.<<avf />>
    </div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4610','tg4610',304610,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>Alert: Unmanaged possible early CKD with rapid progression (Trigger 4610)</h5>
    The current glomerular stage is <<ckd_stage />> with an annual decline of <<eb /> ml/min/yr without a recent specialist encounter. <br />
    <<egfrlv>>The last eGFR was <<egfrlv />> ml/min on <</egfrlv>><<egfrld />><<egfr_max_v>> with a decline from <<egfr_max_v />><<egfr_max_v />> ml/min on <</egfr_max_ld />>. <</egfr_max_ld>>
    <<ckd_null>>Please note the absence of CKD staging as this does not currently fullfill criteria. <</ckd_null>>
    </div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4100','tg4100',304100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>Alert: Acute kidney injury in community (Trigger 4100)</h5>
    Baseline creatinine is estimated to be <<cr_base />> umol/l and the maxima is <<cr_max_1y />> umol/l on <<cr_max_ld_1y />>. <br /> 
    This is consistent with an acute kidney injury (AKIN stage 2 or above). 
    <<aki_outcome=3>>There is no resolution. <</aki_outcome=3>> 
    <<aki_outcome=2>>There appears to be partial resolution. <</aki_outcome=2>>
    <<aki_outcome=1>>There appears to be complete resolution. <</aki_outcome=1>> 
    last recorded creatinine is <<cr_lv />>umol/l on <<cr_ld />>.
    </div>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4410','tg4410',304410,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>
    Alert: Nephrotic range proteinuria in the absence of diabetes (Trigger 4410)
    </h5>
    The last uACR was <<uacr1 />> mg/mmol and the one before was <<uacr2 />> mg/mmol. <br />  
    <<iq_tier=3>>Serum Albumin and Cholesterol have been checked <<low_alb>> and there is hypoalbuminaemia<</low_alb>><<higl_chol>> and hypercholesterolaemia<</higl_chol>>. <</iq_tier=3>>
    This is consistent with a primary nephrotic syndrome. 
    <<iq_tier=4>>It is noted that autoimmune and other relevant serological tests have been performed.<</iq_tier=4>>
    </div>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4720','tg4720',304720,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>
    Alert: New commencement on Renal replacement therapy (Trigger 4720)
    </h5>
    <<hd_start>>Patient has been commenced on haemodialysis on <<hd_dt_min />>. <<hd_start>>
    </div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg4660','tg4660',304660,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>
    Alert: Medication safety concern (Trigger 4660)
    </h5>
    This patient is on <<dm_rxn_bg>>a biguanide,<</dm_rxn_bg>><<dm_rxn_sglt2>> SGLT2 inhibitor,<</dm_rxn_sglt2>><<rx_nsaids>> NSAIDS,<</rx_nsaids>> which may be inconsistent with current renal function. <br />
    <<dm_rxn_bg>>Biguanides may be rarely associated with lactic acidosis at this level of renal function. <</dm_rxn_bg>>
    <<dm_rxn_sglt2>>SGLT2 inhibitors are relatively contra-indicated at this level of renal function. <</dm_rxn_sglt2>>
    <<rx_nsaids>>NSAIDS may cause additional renal injury.<</rx_nsaids>>
    </div>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','alert_tg2610','tg2610',302610,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_alert_box">
    <h5>
    Alert: Potentially untreated chronic disease (Trigger 2610)
    </h5>
    <<dm_untreat>>Likely to require pharmacotherapy for glycaemic control. No active medications are detected. <</dm_untreat>>
    <<ckd_untreat>>Likely to benefit from RAAS blockade therapy (ACEi or ARB) in the context of albuminuric chronic kidney disease. <</ckd_untreat>>
    <<ckd_untreat>>Last systolic BP is <<sbp_val />> mmHg ( <<sbp_dt />) and serum potassium is <<k_val />> mmol/l (<<k_dt />>).<</ckd_untreat>>
    </div>
    '
    );


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_1','cd_dm_dx',602110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
        
        <<dm_type=1>><li><b>Diabetes Mellitus Type 1</b> <<dm1_mm>> ? <</dm1_mm>><</dm_type=1>>
        <li><<dm_type=2>><b>Diabetes Mellitus Type 2</b> <<dm2_mm_1>> ? <</dm2_mm_1>><<dm2_mm_2>> ? <</dm2_mm_2>><</dm_type=2>>
        <ul>
            <<dm_fd_year>><li>since <<dm_fd_year />></li><</dm_fd_year>>
            <<dm_dx_uncoded>><li>not coded on primary care EHR</li><</dm_dx_uncoded>>
            <<cd_dm_dx_code=110000>><li>based only on hospital records on <<dm_icd_fd />></li><</cd_dm_dx_code=110000>>
            <<cd_dm_dx_code=101110>><li>based on primary EHR,lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=101110>>
            <<cd_dm_dx_code=111110>><li>based on hospital and primary EHR,lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=111110>>
            <<cd_dm_dx_code=100000>><li>based on a single HbA1c of <<gluc_hba1c_high_f_val />> on <<gluc_hba1c_high_f_dt />></li><</cd_dm_dx_code=100000>>
        
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_2','cd_dm_comp',602115,'dev','tkc',TO_DATE(SYSDATE),
    '
            <li>Non-renal microvascular complications present
                <ul>
                    <<dm_micvas_retino>>
                        <li>Diabetic retinopathy 
                            <ul>
                                <<ndr_icd_e32>><li>Mild non-proliferative retinopathy <<ndr_icd_e32 />></li><</ndr_icd_e32>>
                                <<ndr_icd_e33>><li>Moderate non-proliferative retinopathy <<ndr_icd_e33 />></li><</ndr_icd_e33>>
                                <<ndr_icd_e34>><li>Severe non-proliferative retinopathy <<ndr_icd_e34 />></li><</ndr_icd_e34>>
                                <<pdr_icd_e35>><li>Severe non-proliferative retinopathy <<pdr_icd_e35 />></li><</pdr_icd_e35>>
                            </ul>
                        </li>
                    <</dm_micvas_retino>>
                    <<dm_micvas_neuro>><li>Diabetic neuropathy (<<dm_micvas_neuro />>)</li><</dm_micvas_neuro>>
                </ul>
            </li
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_3','cd_dm_glyc_cntrl',602120,'dev','tkc',TO_DATE(SYSDATE),
    '
            <<hba1c_n_tot>><li>Last recorded HbA1c (NGSP) is <<hba1c_n0_val />> % (<<hba1c_n0_dt />>)</li><</hba1c_n_tot>>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_4','cd_dm_dx',602130,'dev','tkc',TO_DATE(SYSDATE),
    '
            <<dm_rxn=0>>
                <li>No medications recorded</li>
            <</dm_rxn=0>>
            <<dm_rxn>>
                <li>Current medication classes
                <ul>
                    <<dm_rxn_su>><li>sulphonylurea</li><</dm_rxn_su>>
                    <<dm_rxn_ins_long>><li>long-acting insulin</li><</dm_rxn_ins_long>>
                    <<dm_rxn_glp1>><li>GLP1 analogue</li><</dm_rxn_glp1>>
                    <<dm_rxn_dpp4>><li>DPP4 inhibitor (<<dm_rxn_dpp4 />>)</li><</dm_rxn_dpp4>>
                    <<dm_rxn_sglt2>><li>SGLT2 inhibitor</li><</dm_rxn_sglt2>>
                </ul>
                </li>
            <</dm_rxn>>
    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_5','cd_dm_mx',602135,'dev','tkc',TO_DATE(SYSDATE),
    '
             <<cp_dm=0>>
                <li>PCIS diabetes careplan was not detected [2.4]</li>
            <</cp_dm=0>>
            <<cp_dm>>
                <li>PCIS diabetes careplan was updated on <<cp_dm_ld />></li>
            <</cp_dm>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_syn_6','cd_dm_dx',602190,'dev','tkc',TO_DATE(SYSDATE),
    '
             </ul>
        </li>
    </ul>
    '
    );


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_dm_rec_1','cd_dm',702100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<n0_st=3>><div>Recommendation [2.3] Suggest optimizing glycaemic control</div><</n0_st=3>>
    <<n0_st=4>><div>Recommendation [2.3] Suggest optimizing glycaemic control</div><</n0_st=4>>
    <<cp_dm=0>><div>Recommendation [2.4] Suggest updating care plan to include diabetes</div><</cp_dm=0>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_htn_syn_1','cd_htn',603100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
        <li><b>Hypertension</b>
        <ul>
            <li><<htn_icpc>>Diagnosed<</htn_icpc>> Hypertension <<htn_fd_yr>> since <</htn_fd_yr>><<htn_fd_yr />></li>
            <<mu_1>><li>Average systolic BP during last year was <<mu_1 />> mmHg</li><</mu_1>>
            
            <li>
                <<bp_trend=0>>No comment on the trend<</bp_trend=0>>
                <<bp_trend=1>>Hypertension control appears to have improved compared to last year<</bp_trend=1>>
                <<bp_trend=2>>Hypertension control appears to have worsened compared to last year<</bp_trend=2>>        
                
            </li>
            
            <<bp_control>>
            <li>
                BP control <<bp_control=3>>appears to be adequate<</bp_control=3>>
                <<bp_control=2>>can be optimised<</bp_control=2>>
                <<bp_control=1>>appears to sub-optimal<</bp_control=1>>
                <<bp_control=0>>could not be determined<</bp_control=0>>[3.3]
            </li>
            <</bp_control>>
    
            <li><<htn_rxn>>Current antihypertensive classes<</htn_rxn>>
            <ul>
                <<htn_rxn_arb>><li>Angiotensin receptor blocker (ARB)</li><</htn_rxn_arb>>
                <<htn_rxn_acei>><li>ACE inhibitor</li><</htn_rxn_acei>>
                <<htn_rxn_ccb>><li>Calcium channel blocker (CCB)</li><</htn_rxn_ccb>>
                <<htn_rxn_bb>><li>Beta blocker</li><</htn_rxn_bb>>
                <<htn_rxn_diuretic_thiazide>><li>Thiazide diuretic</li><</htn_rxn_diuretic_thiazide>>
                <<htn_rxn_diuretic_loop>><li>Thiazide diuretic</li><</htn_rxn_diuretic_loop>>
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
    <<htn_icpc=0>><div>Recommendation [3.1] Update diagnosis to hypertension</div><</htn_icpc=0>>
    <<bpc=2>><div>Recommendation [3.4] Optimise BP control</div><</bpc=2>>
    <<bpc=3>><div>Recommendation [3.4] Optimise BP control</div><</bpc=3>>
    <<htn_rcm=11>><div>Recommendation [3.4.1] Consider adding ACEi or ARB (RAAS blockade) which is recommended as first line therapy</div><</htn_rcm=11>>
    <<htn_rcm=12>><div>Recommendation [3.4.1] Consider adding DHP-CCB instead of RAAS blockade as there is a risk worsening hyperkalaemia</div><</htn_rcm=12>>
    <<htn_rcm=22>><div>Recommendation [3.4.1] Consider adding CCB which is recommended as second line therapy</div><</htn_rcm=22>>
    <<htn_rcm=33>><div>Recommendation [3.4.1] Consider adding low dose thiazide which is recommended as third line therapy</div><</htn_rcm=33>>
    <<htn_rcm=34>><div>Recommendation [3.4.1] Consider adding Aldosterone antagonist instead of low dose thiazide as there is a risk of worsening hypokalaemia</div><</htn_rcm=34>>
    <<htn_rcm=35>><div>Recommendation [3.4.1] Consider adding beta blocker or central blocker instead of Aldosterone Antagonist as there is a risk of worsening hyperkalaemia</div><</htn_rcm=35>>
    <<htn_rcm=44>><div>Recommendation [3.4.1] Consider adding Aldosterone antagonist which is recommended as fourth line therapy</div><</htn_rcm=44>>
    <<htn_rcm=55>><div>Recommendation [3.4.1] Consider adding Beta blocker or Central blocker as 5th line therapy</div><</htn_rcm=55>>
    <<htn_rcm=99>><div>Recommendation [3.4.1] Best combination cannot be determined</div><</htn_rcm=99>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_htn_footnote_1','cd_htn',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<iq_tier>>
        <div>Note [3.1] This is based on <<iq_sbp />> blood pressure readings within the last 2 years</div>
    <</iq_tier>>

    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','debug_info','dmg',921010,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_notes_box"><small>
    Debug info:
        <<st_rman_ver$rman_status_key_val />>;
        <<st_rman_init$rman_status_key_ts />>;
        <<st_rman_rb$rman_status_key_ts />>;
        <<st_rman_rb_err$rman_status_key_val />>;
        
        </small>
    </div>
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cardiac_syn','cd_cardiac',604100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
        <li><b>Cardiac disease</b>
        <ul>
            <<cad>><li>Coronary artery disease
            <ul>
                <<cabg>><li>Cornoary artery bypass grafting <<cabg />></li><</cabg>>
                <<cad_mi_icd>><li>First myocardial infarction <<cad_mi_icd />></li><</cad_mi_icd>>
            </ul>
            </li><</cad>>
            <<vhd>><li>Valvular heart disease:
            <ul>
                <<vhd_mv_icd>><li>Mitral valve disease <<vhd_mv_icd />></li><</vhd_mv_icd>>
                <<vhd_av_icd>><li>Aortic valve disease <<vhd_av_icd />></li><</vhd_av_icd>>
                <<vhd_ov_icd>><li>Non aortic-mitral valve disease <<vhd_ov_icd />></li><</vhd_ov_icd>>
                <<vhd_ie_icd>><li>Infective endocarditis <<vhd_ie_icd />></li><</vhd_ie_icd>>
                <<vhd_icpc>><li>Valvular disease NOS<<vhd_icpc />></li><</vhd_icpc>>
            </ul>
            </li><</vhd>>
            <li><<rxn>>Current medication classes
            <ul>
                <<rxn_ap>><li>Anti-platelet agents</li><</rxn_ap>>
                <<rxn_statin>><li>Statins</li><</rxn_statin>>
                <<rxn_anticoag>><li>Anti-coagulation (Warfarin or NOAC)</li><</rxn_anticoag>>
                <<rxn_diu_loop>><li>Loop diuretics</li><</rxn_diu_loop>>
                <<rxn_diu_low_ceil>><li>Low-ceiling diuretics</li><</rxn_diu_low_ceil>>
                <<rxn_diu_k_sp>><li>Low-ceiling diuretics</li><</rxn_diu_k_sp>>
                <<rxn_chrono>><li>Anti-arrhythmic agent</li><</rxn_chrono>>
            </ul>
            </li><</rxn>>
        </ul>
        </li>
    </ul>  
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','rrt_syn','rrt',601000,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li><b>End-stage renal failure (ESRD)</b>
        <ul>
            <<rrt=1>><li>Currently on haemodialysis, since <<hd_dt_min />></li><</rrt=1>>
            <<rrt=2>><li>Currently on peritoneal dialysis, since <<pd_dt />></li><</rrt=2>>
            <<rrt=3>><li>Active renal transplant, <<tx_dt />></li><</rrt=3>>
            <<rrt=4>><li>Currently on home-haemodialysis, <<homedx_dt />></li><</rrt=4>>
        </ul>
    </li>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_syn_1','ckd',601100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li><b>CKD stage <<ckd_stage />></b>
    <ul>
    <<ckd_stage>><li><<dx_ckd>>Diagnosed <</dx_ckd>><<pers>>Persistent <</pers>>CKD stage <strong> (<<cga_g />><<cga_a />>)</strong> [1.1].</li><</ckd_stage>>
    <<dx_ckd=0>><li>No coded diagnosis on the EHR (ICD/ICPC coding) [1.2]</li><</dx_ckd=0>>
    <<dx_ckd>><li>The diagnosis on the EHR is CKD stage <<dx_ckd_stage />> [1.2]</li><</dx_ckd>>
    <<egfr_l_val>><li>Last eGFR is <strong><<egfr_l_val />></strong> ml/min/1.73m2 (<<egfr_l_dt />>)<<egfr_outdated>> and is outdated [1.3].<</egfr_outdated>></li><</egfr_l_val>>
    <<acr_l_val>><li>Last uACR is <<acr_l_val />> mg/mmol (<<acr_l_dt />>)<<acr_outdated>> and is outdated [1.3].<</acr_outdated>></li><</acr_l_val>>
    <<egfr_decline>><li><<egfr_rapid_decline>>rapid <</egfr_rapid_decline>>progressive decline of renal function with an annual decline of <<egfr_slope2 />>ml/min/yr [1.3]</li><</egfr_decline>>
    <<enc_null=0>><li>No captured encounters with renal services.</li><</enc_null=0>>
    <<enc_ld>><li>Last captured encounter with renal services was on <<enc_ld />>and there have been <<enc_n />> encounters since <<enc_fd />></li><</enc_ld>>
    <<avf>><li>An arterio-venous fistula has been created on <<avf />></li><</avf>>
    <<cp_ckd=0>><li>No current PCIS careplan for CKD</li><</cp_ckd=0>>
    <<cp_ckd>><li>CKD current PCIS careplan is <<cp_ckd />> updated on <<cp_ckd_ld />></li><</cp_ckd>>
    <ul>
    <<cp_mis>><li>existing care plan may not be adequate [1.8]</li><</cp_mis>>
    </ul>
    </li>
    </ul>
    </li>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_syn_2','ckd',601199,'dev','tkc',TO_DATE(SYSDATE),
    '
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','rx_syn_1','rx_desc',651010,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr/>
    <div class="syn_synopsis_box">
    <h3>Medications</h3>
        <<rx_name_obj$rx_name_obj />>
    </div>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_cause_syn_1','ckd_cause',601101,'dev','tkc',TO_DATE(SYSDATE),
    '<ul>
        <li>aetiology
            <ul>
                <<aet_multiple=1>><li>Multiple aetiology is suggested
                <ul>
                    <<aet_dm=1>><li>diabetes mellitus</li><</aet_dm=1>>
                    <<aet_htn=1>><li>hypertension</li><</aet_htn=1>>
                    <<aet_gn_ln=1>><li>lupus nephritis</li><</aet_gn_ln=1>>
                    <<aet_gn_x=1>><li>glomerulopathy NOS</li><</aet_gn_x=1>>
                    <<c_n00>><li>Acute nephritic syndrome <<c_n00 />></li><</c_n00>>
                    <<c_n01>><li>Rapidly progressive nephritic syndrome <<c_n01 />></li><</c_n01>>
                    <<c_n03>><li>Chronic nephritic syndrome <<c_n03 />></li><</c_n03>>
                    <<c_n04>><li>Nephrotic syndrome <<c_n04 />></li><</c_n04>>
                    <<c_n05>><li>Unspecified nephritic syndrome <<c_n05 />></li><</c_n05>>
                    <<c_n07>><li>Hereditary nephropathy, not elsewhere classified <<c_n07 />></li><</c_n07>>
                    <<c_n08>><li>Glomerular disorders in diseases classified elsewhere <<c_n08 />></li><</c_n08>>
                    <<c_n10_n16>><li>Renal tubulo-interstitial diseases <<c_n10_n16 />></li><</c_n10_n16>>
                    <<c_n17>><li>Acute kidney failure and chronic kidney disease <<c_n17 />></li><</c_n17>>
                    <<c_n20_n23>><li>Urolithiasis <<c_n20_n23 />></li><</c_n20_n23>>
                    <<c_n26_n26>><li>Unspecified contracted kidney <<c_n26_n27 />></li><</c_n26_n27>>
                    <<c_n30_n39>><li>Other diseases of the urinary system including bladder dysfunction<<c_n30_n39 />></li><</c_n30_n39>>
                    <<c_n40>><li>Benign prostatic hyperplasia <<c_n40 />></li><</c_n40>>
                    <<c_q60>><li>Renal agenesis and other reduction defects of kidney <<c_q60 />></li><</c_c_q60>>
                    <<c_q61>><li>Cystic kidney disease <<c_q61 />></li><</c_c_q61>>
                    <<c_q62>><li>Congenital obstructive defects of renal pelvis and congenital malformations of ureter <<c_q62 />></li><</c_c_q62>>
                    <<c_q63>><li>Other congenital malformations of kidney<<c_q63 />></li><</c_c_q63>>
                    <<c_q64>><li>Other congenital malformations of urinary system<<c_q64 />></li><</c_c_q64>>
                </ul></li>
                <</aet_multiple=1>>
                <<aet_multiple=0>>
                    <li>
                        Potential cause for CKD is <strong><<aet_dm>>diabetic kidney disease (DKD)<</aet_dm>>
                        <<aet_htn>>,hypertensive kidney disease<</aet_htn>><<aet_gn_ln>>,lupus nephritis<</aet_gn_ln>></strong></li>
                <</aet_multiple=0>>
            </ul>
        </li>
    </ul>
    '
    );
    

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_recm_1','ckd',701100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<dx_ckd_diff>><div>Recommendation [1.2] Update diagnosis to CKD stage<<ckd_stage />> </div><</dx_ckd_diff>>
    <<egfr_outdated>><div>Recommendation [1.3] Repeat renal function tests.</div><</egfr_outdated>>
    <<cp_mis>><div>Recommendation [1.7] Update care plan to include appropriate stage of CKD</div><</cp_mis>>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_recm_2','ckd_complications',701200,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<rcm_bicarb>><div>Recommendation [1.5.1] Consider adding oral bicarbonate therapy for metabolic acidosis</div><</rcm_bicarb>>
    <<phos_high>><div>Recommendation [1.5.2] Consider adding oral phosphate binder therapy</div><</phos_high>>
    '
    );


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_footnote_1','ckd',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<egfr_single>><div>Note [1.1] This is based on a single egfr value on <<egfr_l_dt />></div><</egfr_single>>
    <<egfr_multiple>><div>Note [1.1] This is based on <<iq_egfr />> eGFR values between <<egfr_f_dt />> and <<egfr_l_dt />></div><</egfr_multiple>>
    <<egfr_outdated>><div>Note [1.2.1] Last eGFR on <<egfr_l_dt />></div><</egfr_outdated>>
    <<acr_outdated>><div>Note [1.2.2] Last uACR on <<acr_l_dt />></div><</acr_outdated>>
    <<asm_viol_3m>><div>Note [1.2.3] Assumption violation present. +/- 20% fluctuation in last 30 days </div><</asm_viol_3m>>
    <<egfr_decline>><div>Note [1.3] Maximum eGFR of <<egfr_max_val />> ml/min/1.73m2 on <<egfr_max_dt />> with the most recent value being <<egfr_l_val />></div><</egfr_decline>>
    <<iq_tier=4>><div>Note [1.0] This was based on the presence of at least one ICPC2+ code and more than two eGFR and uACR values (Tier 4).</div><</iq_tier=4>>
    <<iq_tier=3>><div>Note [1.0] This was based on at least two eGFR and uACR values (Tier 3). </div><</iq_tier=3>>
    <<iq_tier=2>><div>Note [1.0] This was based on at least one eGFR and uACR value (Tier 3).</div> <</iq_tier=2>>
    <<iq_tier=1>><div>Note [1.0] This was based on at least one eGFR or uACR value (Tier 4). </div><</iq_tier=1>>
    '
    );


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cvra_syn_1','cvra',604100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
        <li><b>Cardiovascular risk (CVR)</b></li>
        <ul>
        <<risk_high_ovr=0>>
           <li>CVR status was calculated using FRE [4.1]</li>
            <<risk_5>><li>Composite 5 year CVD risk is <<risk_5 />>%</li><</risk_5>>
        <</risk_high_ovr=0>>
        <<cvra=3>><li>The composite 5 year CVD risk is high</li><</cvra=3>>
        <<cvra=2>><li>The composite 5 year CVD risk is moderate</li><</cvra=2>>
        <<cvra=1>><li>The composite 5 year CVD risk is low</li><</cvra=1>> 
        <<risk_high_ovr>><li>The patient meets criteria for high CVR without calculation
        <ul>
            <<cvd_prev>><li>Previously documented CVD event</li><</cvd_prev>>
            <<dm60>><li>Diabetes and age more than 60</li><</dm60>>
            <<dmckd1>><li>Diabetes and albuminuria</li><</dmckd1>>
            <<ckd3>><li>CKD 3b or above</li><</ckd3>>
            <<tc7>><li>Total cholesterol more than 7.5</li><</tc7>>
            <<sbp180>><li>Systolic bp more than 180mmHg</li><</sbp180>>
            <<age74>><li>Age more than 74 and ATSI</li><</age74>>
        </ul></li><</risk_high_ovr>>
        <<cp_hicvr=0>><li>There is no PCIS CVR careplan</li><</cp_hicvr=0>>
        <<cp_hicvr=1>><li>A PCIS high CVR careplan is already in place</li><</cp_hicvr=1>>
        </ul>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cvra_rec_1','cvra',704100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<cvra=3>><<cp_hicvr=0>><div>Recommendation [4.1] Update PCIS care plan to include high CVR </div><</cp_hicvr=0>><</cvra=3>>
    <<cvra=3>><<smoke0=30>><div>Recommendation [4.2] Given high CVR status the smoking cessation is strongly advised </div><</smoke0=30>><</cvra=3>>
    <<cvra=2>><<smoke0=30>><div>Recommendation [4.2] Given moderate CVR status the smoking cessation is advised </div><</smoke0=30>><</cvra=2>>

    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_cvra_footnote_1','cvra',804100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <<risk_high_ovr=0>><div>Note [4.1] The Framingham risk equation was used as per heart foundation guidelines. The CARPA 7th STM uses the same methodology</div><</risk_high_ovr=0>>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_journey_1','ckd_journey',601105,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
        <li>Renal services engagement</li>
        <<enc_multi=0>><li><<enc_ld>>Nephrologist reviews <<enc_ld />><</enc_ld>></li><</enc_multi=0>>
        <<enc_multi>><li>Nephrologist reviews: \t<<enc_fd />>-<<enc_ld />> [<<enc_n />>]</li> <</enc_multi>>
        <<edu_init>><li>CKD Education (initial): \t<<edu_init />></li><</edu_init>>
        <<edu_rv>><li>CKD Education review (last): \t<<edu_rv />></li><</edu_rv>>
        <<dietn>><li>Renal Dietician review (last): \t<<dietn />></li><</dietn>>
        <<sw>><li>Renal social work review (last): \t<<sw />></li><</sw>>
        <<avf_ld>><li>CKD Access (AVF) formation date: \t\t<<avf_ld />></li><</avf_ld>>
    </ul>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','cd_ckd_dx_1','ckd_diagnostics',601110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <ul>
    <li>Diagnostic workup
    <ul>
    <li>Basic urinalysis
    <<ua_null=1>> not performed <</ua_null=1>>
    <<ua_rbc_ld>> last performed on <<ua_rbc_ld />> and shows<</ua_rbc_ld>>
    <<ua_null=0>>
        <<ua_pos=0>> no significant findings<</ua_pos=0>>
        <<ua_pos=1>> haematuria with leucocyturia <</ua_pos=1>>
        <<ua_pos=2>> haematuria without leucocyturia <</ua_pos=2>>
    <</ua_null=0>></li>
    <li>ANA Serology: <<dsdna_null=1>>not performed <</dsdna_null=1>><<dsdna_null=0>><<dsdna_ld>>last performed on <</dsdna_ld>><<dsdna_ld />><<dsdna_ld>> and is <</dsdna_ld>><<dsdna_pos=1>>SIGNIFICANT <</dsdna_pos=1>><</dsdna_null=0>></li>
    <li>ANCA Serology: <<anca_null=1>>not performed <</anca_null=1>><<anca_null=0>><<pr3_ld>>last performed on <</pr3_ld>><<pr3_ld />><</anca_null=0>></li>
    <li>Complements: <<c3c4_null=1>>not performed <</c3c4_null=1>><<c3c4_null=0>><<c3_ld>>last performed on <</c3_ld>><<c3_ld />><</c3c4_null=0>></li>
    <li>Serum PEP: <<spep_null=1>>not performed <</spep_null=1>><<spep_null=0>><<paraprot_ld>>last performed on <</paraprot_ld>><<paraprot_ld />><</spep_null=0>></li>
    <li>SFLC assay: <<sflc_null=1>>not performed <</sflc_null=1>><<sflc_null=0>><<sflc_kappa_ld>>last performed on <</sflc_kappa_ld>><<sflc_kappa_ld />><</sflc_null=0>></li>
    <li>Renal imaging: <<usk_null=1>>not performed <</usk_null=1>><<usk_null=0>>Most recent ultrasound kidney on <<ris_usk_ld />><</usk_null=0>></li>
    <li>Kidney biopsy: <<bxk_null=1>>not performed <</bxk_null=1>><<bxk_null=0>>Kidney biopsy on <<ris_bxk_ld />><</bxk_null=0>></li>
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
    <<hb_lv>><li>Last haemoglobin on <<hb_ld />> is <<hb_lv />> g/L</li><</hb_lv>>
    <<hb_state=2>><li>acceptable range</li><</hb_state=2>>
    <<hb_state=1>><<mcv_state=11>><li>consistent with severe microcytic anaemia</li><</mcv_state=11>><</hb_state=1>>
    <<hb_state=1>><<mcv_state=12>><li>consistent with microcytic anaemia</li><</mcv_state=12>><</hb_state=1>>
    <<hb_state=1>><<mcv_state=20>><li>consistent with normocytic anaemia</li><</mcv_state=20>><</hb_state=1>>
    <<hb_state=1>><<mcv_state=31>><li>consistent with macrocytic anaemia</li><</mcv_state=31>><</hb_state=1>>
    <<hb_state=1>><<mcv_state=0>><li>consistent with anaemia<</mcv_state=0>></li><</hb_state=1>>
    <<esa_state=0>><li>No ESA use</li><</esa_state=0>>
    <<esa_state=1>><li>Current ESA use</li><</esa_state=1>>
    <<esa_state=2>><li>Past ESA use but not current</li><</esa_state=2>>
    <<iron_low>><li>Iron stores low/<li><</iron_low>>
    </ul>
    </li>
    <li>Acid-base balance
    <ul>
    <<hco3_low>><li>low tCO2 at <<hco3_lv />> mmol/l likely due to metabolic acidosis</li><</hco3_low>>
    </ul>
    </li>
    </ul>
    </li>
    </ul>
    '
    );

    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','graph_egfr2','egfr_graph2',651101,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>Temporal variation of eGFR</h5>
    eGFR ml/min against time 
    <div>
    <svg height=<<egfr_graph_canvas_y />> width=<<egfr_graph_canvas_x />>>
    <defs>
    
        <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
            markerWidth="5" markerHeight="5">
          <circle cx="5" cy="5" r="10" fill="blue" />
        </marker>
        <marker id="startarrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
              <polygon points="10 0, 10 7, 0 3.5" fill="black" />
        </marker>
        <marker id="endarrow" markerWidth="10" markerHeight="7" refX="0" refY="3.5" orient="auto" markerUnits="strokeWidth">
              <polygon points="0 0, 10 3.5, 0 7" fill="black" />
        </marker>
      </defs>
      <polyline points="<<xy_coords />>" 
      style="fill:none;stroke:black;stroke-width:1;"marker-start="url(#dot)" marker-mid="url(#dot)"  marker-end="url(#dot)" />
     
     <line x1="<<line1_x1 />>" x2="<<line1_x2 />>" y1="<<line1_y1 />>" y2="<<line1_y2 />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/> 
     
     <line x1="0" x2="<<line1_x2 />>" y1="<<line2_y1 />>" y2="<<line1_y2 />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/> 
     
     <line x1="0" x2="<<line1_x2 />>" y1="<<line1_y2 />>" y2="<<line1_y2 />>" style="fill:none;stroke:lightslategray;stroke-width:4;stroke-dasharray: 4 2"/>
     
     <line x1="0" x2="<<line1_x2 />>" y1="<<line_max_y />>" y2="<<line_max_y />>" style="fill:none;stroke:lightslategray;stroke-width:4;stroke-dasharray: 4 2"/>
      
     <text x="0" y="<<txt_upper_y />>" class="small"><<egfr_max_val />> ml/min</text>  
     
     <text x="0" y="<<txt_lower_y />>" class="small"><<egfr_l_val />> ml/min</text>  
     
     <text x="0" y="<<egfr_graph_canvas_y />>" ><<egfr_f_dt />></text>  
     
     <text x="510" y="<<egfr_graph_canvas_y />>" ><<egfr_l_dt />></text>  
     
     <line x1="150" x2="450" y1="390" y2="390" stroke="#000" stroke-width="2" marker-end="url(#endarrow)" marker-start="url(#startarrow)" /> 
      
    </svg>

    </div>
    </div>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','acr_graph_acr','acr_graph',651310,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>uACR profile for the last <<dspan_y />> years</h5>
    
    <div class="syn_container">
   
  
    <svg height=<<acr_graph_canvas_y />> width=<<acr_graph_canvas_x />>>
            <defs>
                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                    markerWidth="5" markerHeight="5">
                  <circle cx="5" cy="5" r="10" fill="blue" />
                </marker>
            </defs>
        <polyline points="<<xy_coords />>" 
          style="fill:none;stroke:black;stroke-width:1;"marker-start="url(#dot)" marker-mid="url(#dot)"  marker-end="url(#dot)" />
          <line x1="0" x2="<<acr_graph_canvas_x />>" y1="0" y2="0" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
          
          <line x1="0" x2="<<acr_graph_canvas_x />>" y1="<<line_lower_y />>" y2="<<line_lower_y />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
    
          
          
          <text x="330" y="12" style="fill: #000000; stroke: none; font-size: 8px;"><<acr_graph_y_max />></text>
          <text x="330" y="94" style="fill: #000000; stroke: none; font-size: 8px;"><<acr_graph_y_min />></text>
          
           
    </svg>
    <br />
    
    <svg height=10 width=<<acr_graph_canvas_x />>>
        <text x="0" y="10" style="fill: #000000; stroke: none; font-size: 10px;"><<acr_f_dt />></text>  
        <text x="290" y="10"style="fill: #000000; stroke: none; font-size: 10px;" ><<acr_l_dt />></text> 
    </svg>
    </div>
    </div>
    
    '
    );

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','hb_graph','hb_graph',653120,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>Hb profile for the last 2 years</h5>
    
    <div class="syn_container">
   
  
    <svg height=<<hb_graph_canvas_y />> width=<<hb_graph_canvas_x />>>
            <defs>
                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                    markerWidth="5" markerHeight="5">
                  <circle cx="5" cy="5" r="10" fill="blue" />
                </marker>
            </defs>
        <polyline points="<<xy_coords />>" 
          style="fill:none;stroke:black;stroke-width:1;"marker-start="url(#dot)" marker-mid="url(#dot)"  marker-end="url(#dot)" />
          <line x1="0" x2="<<hb_graph_canvas_x />>" y1="0" y2="0" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
          
          <line x1="0" x2="<<hb_graph_canvas_x />>" y1="<<line_lower_y />>" y2="<<line_lower_y />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
    
          <rect x="0" y="<<line_target_upper_y />>"  width="<<hb_graph_canvas_x />>" height="40" style="fill:green;stroke:black;stroke-width:5;opacity:0.3" />
          
          <text x="330" y="12" style="fill: #000000; stroke: none; font-size: 8px;"><<hb_graph_y_max />></text>
          <text x="330" y="94" style="fill: #000000; stroke: none; font-size: 8px;"><<hb_graph_y_min />></text>
    </svg>
    </div>
    </div>
    
    '
    );
    INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','phos_graph','phos_graph',653130,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>Phosphate profile for the last 2 years</h5>
    
    <div class="syn_container">
   
  
    <svg height=<<phos_graph_canvas_y />> width=<<phos_graph_canvas_x />>>
            <defs>
                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                    markerWidth="5" markerHeight="5">
                  <circle cx="5" cy="5" r="10" fill="blue" />
                </marker>
            </defs>
        <polyline points="<<xy_coords />>" 
          style="fill:none;stroke:black;stroke-width:1;"marker-start="url(#dot)" marker-mid="url(#dot)"  marker-end="url(#dot)" />
          <line x1="0" x2="<<phos_graph_canvas_x />>" y1="0" y2="0" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
          
          <line x1="0" x2="<<phos_graph_canvas_x />>" y1="<<line_lower_y />>" y2="<<line_lower_y />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
    
          <rect x="0" y="<<line_target_upper_y />>"  width="<<phos_graph_canvas_x />>" height="<<line_target_lower_y />>" style="fill:green;stroke:black;stroke-width:5;opacity:0.3" />
          
          <text x="330" y="12" style="fill: #000000; stroke: none; font-size: 8px;"><<phos_graph_y_max />></text>
          <text x="330" y="94" style="fill: #000000; stroke: none; font-size: 8px;"><<phos_graph_y_min />></text>
    </svg>
    </div>
    </div>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','hba1c_graph','hba1c_graph',652110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>Hba1c profile for the last <<dspan_y />> years</h5>
    
    <div class="syn_container">
   
  
    <svg height=<<hba1c_graph_canvas_y />> width=<<hba1c_graph_canvas_x />>>
            <defs>
                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                    markerWidth="5" markerHeight="5">
                  <circle cx="5" cy="5" r="10" fill="blue" />
                </marker>
                <linearGradient id="grad12" x1="0%" y1="100%" x2="0%" y2="0%">
                        <stop offset="0%" style="stop-color:rgb(255,255,0);stop-opacity:0.3" />
                        <stop offset="100%" style="stop-color:rgb(255,0,0);stop-opacity:0.3" />
                </linearGradient>
            </defs>
        <polyline points="<<xy_coords />>" 
          style="fill:none;stroke:black;stroke-width:1;"marker-start="url(#dot)" marker-mid="url(#dot)"  marker-end="url(#dot)" />
          <line x1="0" x2="<<hba1c_graph_canvas_x />>" y1="0" y2="0" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
          
          <line x1="0" x2="<<hba1c_graph_canvas_x />>" y1="<<line_lower_y />>" y2="<<line_lower_y />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
    
          <rect x="0" y="<<line_target_upper_y />>"  width="<<hba1c_graph_canvas_x />>" height="40" fill="url(#grad12)" />
          
          <text x="330" y="12" style="fill: #000000; stroke: none; font-size: 8px;"><<hba1c_graph_y_max />></text>
          <text x="330" y="94" style="fill: #000000; stroke: none; font-size: 8px;"><<hba1c_graph_y_min />></text>
    </svg>
    <br />

    <svg height=10 width=<<hba1c_graph_canvas_x />>>
        <text x="0" y="10" style="fill: #000000; stroke: none; font-size: 10px;"><<hba1c_f_dt />></text>  
        <text x="290" y="10"style="fill: #000000; stroke: none; font-size: 10px;" ><<hba1c_l_dt />></text> 
    </svg>
    </div>
    </div>
    
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','graph_bp','bp_graph',653110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>Blood pressure profile for the last 5 years</h5>
    
    <div class="syn_container">
   
    <div class="syn_col_left">
        
        
        <svg height=<<bp_graph_canvas_y />> width=<<bp_graph_canvas_x />>>
        <defs>
            <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                markerWidth="5" markerHeight="5">
              <circle cx="5" cy="5" r="10" fill="blue" />
            </marker>
        </defs>
    <polyline points="<<xy_coords />>" 
      style="fill:none;stroke:black;stroke-width:1;"marker-start="url(#dot)" marker-mid="url(#dot)"  marker-end="url(#dot)" />
      <line x1="0" x2="<<bp_graph_canvas_x />>" y1="0" y2="0" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>
      
      <line x1="0" x2="<<bp_graph_canvas_x />>" y1="<<line_lower_y />>" y2="<<line_lower_y />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>

      <rect x="0" y="<<line_target_upper_y />>"  width="<<bp_graph_canvas_x />>" height="40" style="fill:green;stroke:black;stroke-width:5;opacity:0.3" />
      
      <text x="330" y="12" style="fill: #000000; stroke: none; font-size: 8px;"><<bp_graph_y_max />></text>
      <text x="330" y="94" style="fill: #000000; stroke: none; font-size: 8px;"><<bp_graph_y_min />></text>
    </svg>
 
    </div>
     <div class="syn_col_right">

        <svg height="200" width="200">
        
        <circle r="50" cx="120" cy="50" fill="white" stroke="<<pie_colour />>" />
        <circle r="<<radius />>" cx="120" cy="50" fill="white" 
              stroke="<<pie_colour />>"
              stroke-width="49"
              stroke-dasharray="<<tir_arc />> <<circum />>"
              />
        <text x="70" y="150" style="font-size:24px;">TIR% <<tir_pct />>%</text>
      
    </svg>
    </div>
    
    

    
      

    </div>
    </div>
    
    '
    );
    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','egfr_metrics','egfr_metrics',651110,'dev','tkc',TO_DATE(SYSDATE),
    '
    <div class="syn_synopsis_box">
    <<r1_stg=1>>Normal renal function of <<egfr_r1_val />> ml/min at entry<</r1_stg=1>>
    <<r1_stg=2>>Near normal renal function of <<egfr_r1_val />> ml/min at entry<</r1_stg=2>>
    <<p3pg_signal=1>>Apparent progression from <<egfr60_last_val />> ml/min to <<egfr_rn_val />> ml/min during (<<egfr60_last_dt />>-<<egfr_rn_dt />>) <</p3pg_signal=1>>
    <<est_esrd_lapsed=0>><<est_esrd_dt>>Estimated ESRD around <<est_esrd_dt />>.<</est_esrd_dt>><</est_esrd_lapsed=0>>
    <<est_esrd_lapsed=1>><<est_esrd_dt>>Imminent ESRD, with estimation boundry in the past<</est_esrd_lapsed=1>>
    </div>
    '
    );

    
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','ckd_labs_tbl1','ckd_labs',661100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <hr />
    <div class="syn_synopsis_box">
    <h5>Lab data panel</h5>
    <table class="syn_table">
        <tbody>
        <tr class="syn_tr">
            <td><strong>Lab</strong></td>
            <td><strong><<creat1_dt />></strong></td>
            <td><strong><<creat2_dt />></strong></td>
            <td><strong><<creat3_dt />></strong></td>

        </tr>
        <tr class="syn_tr">
            <td>Creatinine (umol)</td>
            <td><<creat1_val>><strong><<creat1_val />></strong> <</creat1_val>></td>
            <td><<creat2_val>><strong><<creat2_val />></strong> <</creat2_val>></td>
            <td><<creat3_val>><strong><<creat3_val />></strong> <</creat3_val>></td>
           
            <td></td>
        </tr>
        <tr class="syn_tr">
            <td>eGFR (ml/min/1.72m)</td>
            <td><<egfr1_val>><strong><<egfr1_val />></strong> <</egfr1_val>></td>
            <td><<egfr2_val>><strong><<egfr2_val />></strong> <</egfr2_val>></td>
            <td><<egfr3_val>><strong><<egfr3_val />></strong> <</egfr3_val>></td>

        </tr>
        

    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','ckd_labs_tbl2','ckd_labs',661101,'dev','tkc',TO_DATE(SYSDATE),
    '
        <tr class="syn_tr">
            <td>
                <div>Sodium (mmol/l)</div>
                
            </td>
            <td><<sodium1_val>><strong><<sodium1_val />></strong> <</sodium1_val>></td>
            <td><<sodium2_val>><strong><<sodium2_val />></strong> <</sodium2_val>></td>
            <td><<sodium3_val>><strong><<sodium3_val />></strong> <</sodium3_val>></td>
            
        </tr>
        <tr class="syn_tr">
            <td>
            <div>Potassium (mmol/l)</div>
                
            
            </td>
            <td><<potassium1_val>><strong><<potassium1_val />></strong> <</potassium1_val>></td>
            <td><<potassium2_val>><strong><<potassium2_val />></strong> <</potassium2_val>></td>
            <td><<potassium3_val>><strong><<potassium3_val />></strong> <</potassium3_val>></td>
            
        <td> </td>
        </tr>
    '
    );
INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('neph002_html','ckd_labs_tbl3','ckd_labs',661102,'dev','tkc',TO_DATE(SYSDATE),
    '
        <tr class="syn_tr">
            <td>CO2 (mmol/l)</td>
            <td><<bicarb1_val>><strong><<bicarb1_val />></strong> <</bicarb1_val>></td>
            <td><<bicarb2_val>><strong><<bicarb2_val />></strong> <</bicarb2_val>></td>
            <td><<bicarb3_val>><strong><<bicarb3_val />></strong> <</bicarb3_val>></td>
            
        </tr>
        <tr class="syn_tr">
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
            
        </tr>
        <tr class="syn_tr">
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
            
        </tr>
        <tr class="syn_tr">
            <td>Calcium (mmol/l)</td>
            <td><<calcium1_val>><strong><<calcium1_val />></strong> <</calcium1_val>></td>
            <td><<calcium2_val>><strong><<calcium2_val />></strong> <</calcium2_val>></td>
            <td><<calcium3_val>><strong><<calcium3_val />></strong> <</calcium3_val>></td>
            
        </tr>
        <tr class="syn_tr">
            <td>Phosphate (mmol/l)</td>
            <td><<phos1_val>><strong><<phos1_val />></strong> <</phos1_val>></td>
            <td><<phos2_val>><strong><<phos2_val />></strong> <</phos2_val>></td>
            <td><<phos3_val>><strong><<phos3_val />></strong> <</phos3_val>></td>
            
        
        
        </tr>
        <tr class="syn_tr">
            <td>uACR (mg/mmol)</td>
            <td><<uacr1_val>><strong><<uacr1_val />></strong> (<<uacr1_dt />>)<</uacr1_val>></td>
            <td><<uacr2_val>><strong><<uacr2_val />></strong> (<<uacr2_dt />>)<</uacr2_val>></td>
            <td><<uacr3_val>><strong><<uacr3_val />></strong> (<<uacr3_dt />>)<</uacr3_val>></td>
         
        </tr>
        </tbody>
    </table>
    </div>
    '
    );
    
    
ALTER PACKAGE rman_pckg COMPILE;
