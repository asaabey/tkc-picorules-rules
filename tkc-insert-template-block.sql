REM INSERTING into RMAN_RPT_TEMPLATE_BLOCKS

SET DEFINE OFF;

Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (1,'frame_main_header','dmg','
    <style>
                .syn_alert_box {
                    border-style: none;border-color: brown;border-radius: 10px;padding: 10px
                }
                .syn_dmg_box {
                    border-style: none;border-color: green;border-radius: 10px;padding: 10px
                }
                .syn_synopsis_box {
                    border-style: none;border-color: darkgray;border-radius: 10px;padding: 10px
                }
                .syn_recm_box {
                    border-style: none;border-color: darkorange;border-radius: 10px;padding: 10px
                }
                .syn_notes_box {
                    border-style: none;background-color: mintcream; border-color: #ccffe6 ;border-radius: 10px;padding: 10px
                }
                .syn_table {
                  border-collapse: collapse;
                  border-spacing: 0;
                  width: 80%;
                  border: 1px none #ddd;
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


                .body {
                    font-family:Arial, Helvetica, sans-serif;
                }





    </style>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (2,'dmg_source_summary','dmg_source','

    <div class="syn_dmg_box">
    <<dmg_source>>

            Primary health care network:
            <<dmg_source=1>><b>NTG PCIS</b><hr /><</dmg_source=1>> 
            <<dmg_source=3>><b>NTG EACS</b><hr /><</dmg_source=3>>    
            <<dmg_source=4>><b>LAYNHAPUY</b><hr /><</dmg_source=4>>    
            <<dmg_source=5>><b>MIWATJ</b><hr /><</dmg_source=5>>    
            <<dmg_source=6>><b>ANYINGINYI</b><hr /><</dmg_source=6>> 
            <<dmg_source=8>><b>CONGRESS</b><hr /><</dmg_source=8>>
            <<pcis_n>><i>PCIS encounters(N=<<pcis_n />>, last=<<pcis_ld />>)</i><</pcis_n>> 
            <<eacs_n>><i>EACS encounters(N=<<eacs_n />>, last=<<eacs_ld />>)</i><</eacs_n>>
            <<miwatj_n>><i>MIWATJ encounters(N=<<miwatj_n />>, last=<<miwatj_ld />>)</i><</miwatj_n>>
            <<laynhapuy_n>><i>LAYNHAPUY encounters(N=<<laynhapuy_n />>, last=<<laynhapuy_ld />>)</i><</laynhapuy_n>>
            <<anyinginyi_n>><i>ANYINGINYI encounters(N=<<anyinginyi_n />>, last=<<anyinginyi_ld />>)</i><</anyinginyi_n>>
            <<congress_n>><i>CONGRESS encounters(N=<<congress_n />>, last=<<congress_n />>)</i><</congress_n>>

    <</dmg_source>>
    </div>
    <hr />

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (3,'dmg_loc_summary','dmg_loc','

    <div class="syn_dmg_box">
    <<episode_single>>Single episode at <<loc_last_val />> on <<loc_last_val />><</episode_single>>
        <<episode_single=0>><<loc_single>>There have been <<loc_n />> visits to <b><<loc_def$loc_sublocality />></b> <</loc_single>><</episode_single=0>>

        <<episode_single=0>><<loc_single=0>>visited <b><<loc_def$loc_sublocality />></b>  (<<loc_mode_n />>/<<loc_n />>) which is <<mode_pct />>%.<</loc_single=0>><</episode_single=0>>
        <<episode_single=0>><<diff_last_mode=1>>The last visited site is <<loc_last_val$loc_sublocality />> and the most visited is <<loc_def$loc_sublocality />> <</diff_last_mode=1>> <</episode_single=0>>    
    </div>
    <hr />

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (4,'alert_tg2610','tg2610','
    <div class="syn_alert_box">
    <h5>
    Alert: Potentially untreated chronic disease (Trigger 2610)
    </h5>
    <<dm_untreat>>Likely to require pharmacotherapy for glycaemic control. No active medications are detected. <</dm_untreat>>
    <<ckd_untreat>>Likely to benefit from RAAS blockade therapy (ACEi or ARB) in the context of albuminuric chronic kidney disease. <</ckd_untreat>>
    <<ckd_untreat>>Last systolic BP is <<sbp_val />> mmHg ( <<sbp_dt />) and serum potassium is <<k_val />> mmol/l (<<k_dt />>).<</ckd_untreat>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (5,'alert_tg4100','tg4100','
    <div class="syn_alert_box">
    <h5>Alert: Acute kidney injury in community (Trigger 4100)</h5>
    Baseline creatinine is estimated to be <<cr_base />> umol/l and the maxima is <<cr_max_1y />> umol/l on <<cr_max_ld_1y />>. <br /> 
    This is consistent with an acute kidney injury (AKIN stage 2 or above). 
    <<aki_outcome=3>>There is no resolution. <</aki_outcome=3>> 
    <<aki_outcome=2>>There appears to be partial resolution. <</aki_outcome=2>>
    <<aki_outcome=1>>There appears to be complete resolution. <</aki_outcome=1>> 
    last recorded creatinine is <<cr_lv />>umol/l on <<cr_ld />>.
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (6,'alert_tg4410','tg4410','
    <div class="syn_alert_box">
    <h5>
    Alert: Nephrotic range proteinuria in the absence of diabetes (Trigger 4410)
    </h5>
    The last uACR was <<uacr1 />> mg/mmol and the one before was <<uacr2 />> mg/mmol. <br />  
    <<iq_tier=3>>Serum Albumin and Cholesterol have been checked <<low_alb>> and there is hypoalbuminaemia<</low_alb>><<higl_chol>> and hypercholesterolaemia<</higl_chol>>. <</iq_tier=3>>
    This is consistent with a primary nephrotic syndrome. 
    <<iq_tier=4>>It is noted that autoimmune and other relevant serological tests have been performed.<</iq_tier=4>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (7,'alert_tg4610','tg4610','
    <div class="syn_alert_box">
    <h5>Alert: Unmanaged possible early CKD with rapid progression (Trigger 4610)</h5>
    The current glomerular stage is <<ckd_stage />> with an annual decline of <<eb /> ml/min/yr without a recent specialist encounter. <br />
    <<egfrlv>>The last eGFR was <<egfrlv />> ml/min on <</egfrlv>><<egfrld />><<egfr_max_v>> with a decline from <<egfr_max_v />><<egfr_max_v />> ml/min on <</egfr_max_ld />>. <</egfr_max_ld>>
    <<ckd_null>>Please note the absence of CKD staging as this does not currently fullfill criteria. <</ckd_null>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (8,'alert_tg4620','tg4620','
    <div class="syn_alert_box">
    <h5>Alert: Advanced CKD with rapid progression, possibly unprepared (Trigger 4620)</h5>
    There is CKD stage <<ckd_stage />> disease with an annual decline of <<eb />> ml/min/yr without a recent specialist encounter. <br />
    <<avf>>Please note the AVF creation on <<avf />>.<</avf>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (9,'alert_tg4660','tg4660','
    <div class="syn_alert_box">
    <h5>
    Alert: Medication safety concern (Trigger 4660)
    </h5>
    This patient is on <<dm_rxn_bg>>a biguanide,<</dm_rxn_bg>><<dm_rxn_sglt2>> SGLT2 inhibitor,<</dm_rxn_sglt2>><<rx_nsaids>> NSAIDS,<</rx_nsaids>> which may be inconsistent with current renal function. <br />
    <<dm_rxn_bg>>Biguanides may be rarely associated with lactic acidosis at this level of renal function. <</dm_rxn_bg>>
    <<dm_rxn_sglt2>>SGLT2 inhibitors are relatively contra-indicated at this level of renal function. <</dm_rxn_sglt2>>
    <<rx_nsaids>>NSAIDS may cause additional renal injury.<</rx_nsaids>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (10,'alert_tg4720','tg4720','
    <div class="syn_alert_box">
    <h5>
    Alert: New commencement on Renal replacement therapy (Trigger 4720)
    </h5>
    <<hd_start>>Patient has been commenced on haemodialysis on <<hd_dt_min />>. <<hd_start>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (11,'alert_tg4810','tg4810','
    <div class="syn_alert_box">
    <h5>Alert: High haemoglobin on the background of ESA therapy  (Trigger 4810)</h5>
    Current haemoglobin is <<hb_i_val />> g/L which has increased from a previous hb of <<hb_i1_val />> g/L. <br />
    The ESA was last prescribed on \t <<esa_dt />>. 
    This finding is associated with a higher all-cause mortality in CKD and RRT patients.\n 
    It is possible that the medication is not administered,or an undocumented dose reduction has occured.
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (12,'frame_synthesis_begin','dmg','
    <hr />
    <div class="syn_synopsis_box">
        <h3>Relevant Diagnoses</h3>
        <hr />
        <div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (13,'frame_synthesis_left_begin','dmg','
    <div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (14,'rrt_frame_begin','rrt','
    <ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (15,'rrt_1_syn','rrt','
    <<rrt=1>>
    <li><b>End-stage renal failure (ESRD)</b>
        <ul>
            <li>Currently on satelite haemodialysis, since <<hd_dt_min />></li>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ul>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />></li><</tx_dt>>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt />></li><</pd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ul>
            <</rrt_past=1>>
        </ul>
    </li>
    <</rrt=1>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (16,'rrt_2_syn','rrt','
    <<rrt=2>>
    <li><b>End-stage renal failure (ESRD)</b>
        <ul>
            <li>Currently on peritoneal dialysis, since <<pd_dt_min />></li>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ul>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />></li><</tx_dt>>
                        <<hd_dt>><li>Past haemo dialysis <<hd_dt />></li><</hd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ul>
            <</rrt_past=1>>
        </ul>
    </li>
    <</rrt=2>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (17,'rrt_3_syn','rrt','
    <<rrt=3>>
    <li><b>Renal transplant due to (ESRD)</b>
        <ul>
            <li>Functioning allograft, since <<tx_dt />></li>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ul>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt />></li><</pd_dt>>
                        <<hd_dt>><li>Past haemo dialysis <<hd_dt />></li><</hd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ul>
            <</rrt_past=1>>
        </ul>
    </li>
    <</rrt=3>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (18,'rrt_4_syn','rrt','
    <<rrt=4>>
    <li><b>End-stage renal failure (ESRD)</b>
        <ul>
            <li>Currently on home or community dialysis, since <<homedx_dt />></li>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ul>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt />></li><</pd_dt>>
                        <<hd_dt>><li>Past haemo dialysis <<hd_dt />></li><</hd_dt>>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />></li><</tx_dt>>
                    </ul>
            <</rrt_past=1>>
        </ul>
    </li>
    <</rrt=4>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (19,'rrt_3_metric','rrt_tx','
    <ul>
    <<cr_min_dt>><li>Best graft function creatinine <<cr_min_val />> on <<cr_min_dt />></li><</cr_min_dt>> 
    <<cr_last_dt>><li>Last recorded creatinine <<cr_last_val />> on <<cr_last_dt />></li><</cr_last_dt>>
    <<rxn>>
    <li>Immunosuppressant regimen
        <ul>
            <<rx_h02ab>><li>Corticosteroid <<rx_h02ab />></li><</rx_h02ab>>
            <<rx_l04ad>><li>Calcineurin inhibitor <<rx_l04ad />></li><</rx_l04ad>>
            <<rx_l04aa>><li>Antimetabolite or MTOR class agent <<rx_l04aa />></li><</rx_l04aa>>
            <<rx_l04ax>><li>L04AX class agent <<rx_l04ax />></li><</rx_l04ax>>
        </ul>
    </li>
    <</rxn>>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (20,'rrt_frame_end','rrt','
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (21,'cd_ckd_syn_1','ckd','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (27,'cd_dm_syn_1','cd_dm_dx','
    <ul>

        <<dm_type=1>><li><b>Diabetes Mellitus Type 1</b> <<dm1_mm>> ? <</dm1_mm>></li><</dm_type=1>>
        <<dm_type=2>><li><b>Diabetes Mellitus Type 2</b> <<dm2_mm_1>> ? <</dm2_mm_1>><<dm2_mm_2>> ? <</dm2_mm_2>></li><</dm_type=2>>
        <ul>
            <<dm_mixed>><li>coded as type 1? on <<dm1_fd />></li><</dm_mixed>>
            <<dm_fd_year>><li>since <<dm_fd_year />></li><</dm_fd_year>>
            <<dm_dx_uncoded>><li>not coded on primary care EHR</li><</dm_dx_uncoded>>
            <<cd_dm_dx_code=110000>><li>based only on hospital records on <<dm_icd_fd />></li><</cd_dm_dx_code=110000>>
            <<cd_dm_dx_code=101110>><li>based on primary EHR,lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=101110>>
            <<cd_dm_dx_code=111110>><li>based on hospital and primary EHR,lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=111110>>
            <<cd_dm_dx_code=100000>><li>based on a single HbA1c of <<gluc_hba1c_high_f_val />> on <<gluc_hba1c_high_f_dt />></li><</cd_dm_dx_code=100000>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (28,'cd_dm_syn_2','cd_dm_comp','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (29,'cd_dm_syn_3','cd_dm_glyc_cntrl','
            <<hba1c_n_tot>><li>Last recorded HbA1c (NGSP) is <<hba1c_n0_val />> % (<<hba1c_n0_dt />>)</li><</hba1c_n_tot>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (30,'cd_dm_syn_4','cd_dm_dx','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (31,'cd_dm_syn_5','cd_dm_mx','
             <<cp_dm=0>>
                <li>PCIS diabetes careplan was not detected [2.4]</li>
            <</cp_dm=0>>
            <<cp_dm>>
                <li>PCIS diabetes careplan was updated on <<cp_dm_ld />></li>
            <</cp_dm>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (32,'cd_dm_syn_6','cd_dm_dx','
             </ul>
        </li>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (33,'cd_obesity','cd_obesity','
    <ul>
        <<cd_obesity>><li><b>Obesity</b></li><</cd_obesity>>
        <ul>
            <li>obesity class <<bmi_class />>: BMI <<bmi />> kg/m2 (<<wt_dt />>)</li>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (34,'cd_htn_syn_1','cd_htn','
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


            <<bp_control=3>><li>BP control appears to be adequate</li><</bp_control=3>>
            <<bp_control=2>><li>BP control can be optimised</li><</bp_control=2>>
            <<bp_control=1>><li>BP control appears to sub-optimal</li><</bp_control=1>>
            <<bp_control=0>><li>could not be determined</li><</bp_control=0>>

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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (35,'cd_cardiac_cad_syn','cd_cardiac_cad','

        <ul>
            <<cad>><li><b>Coronary artery disease</b>
            <ul>
                <<cabg>><li>Cornoary artery bypass grafting <<cabg />></li><</cabg>>
                <<ami_icd_null>><li>No recorded myocardial infarction in hospital</li><</ami_icd_null>>
                <<stemi_fd>><li>First STEMI <<stemi_fd />></li><</stemi_fd>>

                    <ul>
                        <<stemi_anat=1>><li>LMS or LAD territory</li><</stemi_anat=1>>
                        <<stemi_anat=2>><li>RCA territory</li><</stemi_anat=2>>
                        <<stemi_anat=3>><li>Left circumflex territory</li><</stemi_anat=3>>
                        <<stemi_anat=4>><li>territory not specified</li><</stemi_anat=4>>
                    </ul>

                <<stemi_ld>><li>Most recent STEMI <<stemi_ld />></li><</stemi_ld>>
                <<nstemi_fd>><li>First NSTEMI <<nstemi_fd />></li><</nstemi_fd>>
                <<nstemi_ld>><li>Most recent NSTEMI <<nstemi_ld />></li><</nstemi_ld>>
                <<rxn>><li>relevant medication </li><</rxn>>
                    <ul>
                        <<rxn_ap>><li>Anti-platelet agent(s) <<rxn_ap />> </li><</rxn_ap>>
                        <<rxn_bb>><li>Betablocker <<rxn_bb />> </li><</rxn_bb>>
                        <<rxn_raas>><li>ACEi or ARB <<rxn_raas />> </li><</rxn_raas>>
                        <<rxn_statin>><li>Statin <<rxn_statin />> </li><</rxn_statin>>
                    </ul>


            </ul>
            </li><</cad>>
        </ul>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (36,'cd_cvra_syn_1','cvra','
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
        <<dmg_source=1>>
            <<cp_hicvr=0>><li>There is no PCIS CVR careplan</li><</cp_hicvr=0>>
            <<cp_hicvr=1>><li>A PCIS high CVR careplan is already in place</li><</cp_hicvr=1>>
        <</dmg_source=1>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (37,'cd_cardiac_vhd_syn','cd_cardiac_vhd','

        <ul>

            <<vhd>><li><b>Valvular heart disease</b>
            <ul>
                <<vhd_ie_icd>><li>Infective endocarditis <<vhd_ie_icd />></li><</vhd_ie_icd>>
                <<vhd_icpc>><li>Valvular disease NOS<<vhd_icpc />></li><</vhd_icpc>>
                <<rhd_aet>><li>Likely due to <b>rheumatic</b> heart disease</li><</rhd_aet>>
                <<car_enc_l_dt>><li>Last outpatient encounter <<car_enc_l_dt />></li><</car_enc_l_dt>>
            </ul>
            <ul>
                <<mv>><li>Mitral valve involvement</li><</mv>>
                <ul>
                    <<mv_s>><li>Mitral stenosis <<mv_s_dt />></li><</mv_s>>
                    <<mv_i>><li>Mitral regurgitation <<mv_i_dt />></li><</mv_i>>
                    <<mv_r>><li>Mitral replacement <<mv_r_dt />></li><</mv_r>>
                </ul>
            </ul>
            <ul>
                <<av>><li>Aortic valve involvement</li><</av>>
                <ul>
                    <<av_s>><li>Aortic stenosis <<av_s_dt />></li><</av_s>>
                    <<av_i>><li>Aortic regurgitation <<av_i_dt />></li><</av_i>>
                    <<av_r>><li>Aortic replacement <<av_r_dt />></li><</av_r>>
                </ul>
            </ul>
            <ul>
                <<tv>><li>Tricuspid valve involvement</li><</tv>>
                <ul>
                    <<tv_s>><li>Tricuspid stenosis <<tv_s_dt />></li><</tv_s>>
                    <<tv_i>><li>Tricuspid regurgitation <<tv_i_dt />></li><</tv_i>>
                    <<tv_r>><li>Tricuspid replacement <<tv_r_dt />></li><</tv_r>>
                </ul>
                <<rxn_anticoag>><li>On anticoagulation </li><</rxn_anticoag>>
            </ul>
            <</vhd>>


        </ul>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (38,'cd_cardiac_chf_syn','cd_cardiac_chf','
        <ul>
            <<chf>><li><b>Congestive heart failure</b>
            <</chf>>
        </ul>   
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (39,'cd_cardiac_af','cd_cardiac_af','
    <ul>
        <b><li>Atrial fibrillation</li></b>
        <ul>
            <li>Diagnosed <<af_dt />></li>
            <li>CHA2DS2VASC score  : <<cha2ds2vasc />></li>
            <<rxn_anticoag>><li>Anticoagulation <<rxn_anticoag_dt />></li><</rxn_anticoag>>
            <<rxn_anticoag=0>><li>Not on anticoagulation </li><</rxn_anticoag=0>>
        </ul>

    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (40,'cd_dyslip','cd_dyslip','
    <ul>
        <b><li>Dyslipidaemia</li></b>
        <ul>
            <<ldl_dt>><li>Last LDL-C value <<ldl_val />>(<<ldl_dt />>)</li><</ldl_dt>>
            <<ascvd>><li>Secondary prevention as there is past atherosclerotic cvd </li><</ascvd>>
            <<ldl_subopt=1>><li>Suboptimal control (LDL-C level 20% above threshold of <<ldl_unl />>)</li><</ldl_subopt=1>>
        </ul>

    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (41,'cd_cva_syn','cd_cva','
    <ul>
        <li><b>Cerebrovascular disease</b>
        <ul>
            <<cva_infarct_dt>><li>cerebral infarct <<cva_infarct_dt />></li><</cva_infarct_dt>>
            <<cva_hmrage_dt>><li>subarachnoid or intracerebral haemorrhage <<cva_hmrage_dt />></li><</cva_hmrage_dt>>
            <<cva_nos_dt>><li>Stroke <<cva_nos_dt />></li><</cva_nos_dt>>
        </ul>
    </ul>  
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (42,'cd_cns','cd_cns','
    <ul>
        <<md>><b><li>Mood disorder</li></b>
        <ul>
            <li>Diagnosed (<<code_md_dt />>) and medicated</li>
        </ul>
        <</md>>
        <<schiz>><b><li>Psychotic disorder</li></b>
        <ul>
            <<code_shiz_dt>><li>Diagnosed (<<code_shiz_dt />>) and medicated</li><</code_shiz_dt>>
            <<rx_n05a_dt>><li>medicated for ?</li><</rx_n05a_dt>>
        </ul>
        <</schiz>>
        <<epil>><b><li>Seizure disorder</li></b>
        <ul>
            <li>Diagnosed (<<code_epil_dt />>) and medicated</li>
        </ul>
        <</epil>>
        <<pd>><b><li>Parkinson disease</li></b>
        <ul>
            <li>Diagnosed (<<code_pd_dt />>) and medicated</li>
        </ul>
        <</pd>>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (43,'cd_haem','cd_haem','
    <ul>
        <<low_cat=3>><b><li>Pancytopaenia</li></b><</low_cat=3>>
        <<low_cat=2>><b><li>Bicytopaenia</li></b><</low_cat=2>>
        <<low_cat=1>><b><li>Monocytopaenia</li></b><</low_cat=1>>
        <<low_cat>>
            <ul>
            <<hb_low=1>>
                <b><li>Anaemia</li></b>
                <ul>
                    <li>Last Haemoglobin <<hb1_val />> g/L (<<hb1_dt />>)</li>
                </ul>
            <</hb_low=1>>
            <<plt_low=1>>
                <b><li>Thrombocytopaenia</li></b>
                <ul>
                    <li>Last Platelet count <<plt_val />> x10^6/ml (<<plt_dt />>)</li>
                </ul>
            <</plt_low=1>>
            <<wcc_low=1>>
                <b><li>Neutropaenia</li></b>
                <ul>
                    <li>Last Neutrophil count <<wcc_val />> x10^6/ml (<<wcc_dt />>)</li>
                </ul>
            <</wcc_low=1>>
            </ul>
        <</low_cat>>

    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (44,'frame_synthesis_left_end','dmg','
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (45,'frame_synthesis_end','dmg','
    </div></div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (46,'rx_syn_1','rx_desc','
    <hr/> 
    <div class="syn_synopsis_box">
    <h3>Medications</h3>
    <ol>
        <<rx_name_obj$rx_name_obj />>
    </ol>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (47,'graph_egfr2','egfr_graph2','
    <hr />
    <div class="syn_synopsis_box">
    <h5>Temporal variation of eGFR</h5>
    eGFR ml/min against time 
    <div>
    <svg height=<<egfr_graph_canvas_y />> width=<<egfr_graph_canvas_x />>>
    <style>
        .small { font:Ariel 18px;font-weight:normal;}
    </style>
    <defs>

        <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
            markerWidth="5" markerHeight="5">
          <circle cx="5" cy="5" r="10" fill="blue" />
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

     <text x="0" y="<<egfr_graph_canvas_y />>" class="small"><<egfr_f_dt />></text>  

     <text x="510" y="<<egfr_graph_canvas_y />>" class="small" ><<egfr_l_dt />></text>  



    </svg>

    </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (22,'cd_ckd_cause_syn_1','ckd_cause','<ul>
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (23,'cd_ckd_journey_1','ckd_journey','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (24,'cd_ckd_dx_1','ckd_diagnostics','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (25,'cd_ckd_compx_1','ckd_complications','<ul>
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (26,'cd_ckd_syn_2','ckd','
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (52,'hb_graph','hb_graph','
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

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (53,'phos_graph','phos_graph','
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

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (54,'ckd_labs_tbl1','ckd_labs','
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


    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (55,'ckd_labs_tbl2','ckd_labs','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (56,'ckd_labs_tbl3','ckd_labs','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (57,'frame_recm_begin','dmg','
    <hr />
    <div class="syn_recm_box">
    <h3>Recommendations</h3>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (58,'cd_ckd_recm_1','ckd','
    <<dx_ckd_diff>><div>Recommendation [1.2] Update diagnosis to CKD stage<<ckd_stage />> </div><</dx_ckd_diff>>
    <<egfr_outdated>><div>Recommendation [1.3] Repeat renal function tests.</div><</egfr_outdated>>
    <<cp_mis>><div>Recommendation [1.7] Update care plan to include appropriate stage of CKD</div><</cp_mis>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (59,'cd_dm_rec_1','cd_dm','
    <<n0_st=3>><div>Recommendation [2.3] Suggest optimizing glycaemic control</div><</n0_st=3>>
    <<n0_st=4>><div>Recommendation [2.3] Suggest optimizing glycaemic control</div><</n0_st=4>>
    <<cp_dm=0>><div>Recommendation [2.4] Suggest updating care plan to include diabetes</div><</cp_dm=0>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (60,'cd_cvra_rec_1','cvra','
    <<cvra=3>><<cp_hicvr=0>><div>Recommendation [4.1] Update PCIS care plan to include high CVR </div><</cp_hicvr=0>><</cvra=3>>
    <<cvra=3>><<smoke0=30>><div>Recommendation [4.2] Given high CVR status the smoking cessation is strongly advised </div><</smoke0=30>><</cvra=3>>
    <<cvra=2>><<smoke0=30>><div>Recommendation [4.2] Given moderate CVR status the smoking cessation is advised </div><</smoke0=30>><</cvra=2>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (61,'frame_recm_end','dmg','
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (62,'frame_notes_begin','dmg','
    <hr />
    <div class="syn_notes_box">
    <h4>Footnotes</h4>
    <small>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (63,'cd_htn_footnote_1','cd_htn','
    <<iq_tier>>
        <div>Note [3.1] This is based on <<iq_sbp />> blood pressure readings within the last 2 years</div>
    <</iq_tier>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (64,'cd_ckd_footnote_1','ckd','
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
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (65,'cd_cvra_footnote_1','cvra','
    <<risk_high_ovr=0>><div>Note [4.1] The Framingham risk equation was used as per heart foundation guidelines. The CARPA 7th STM uses the same methodology</div><</risk_high_ovr=0>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (66,'frame_notes_end','dmg','
    </small>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (67,'debug_info','dmg','
    <hr />
    <div class="syn_notes_box"><small>
    Debug info:
        <<st_rman_ver$rman_status_key_val />>;
        <<st_rman_init$rman_status_key_ts />>;
        <<st_rman_rb$rman_status_key_ts />>;
        <<st_rman_rb_err$rman_status_key_val />>;

        </small>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (48,'egfr_metrics','egfr_metrics','
    <div class="syn_synopsis_box">
    <<r1_stg=1>>Normal renal function of <<egfr_r1_val />> ml/min at entry<</r1_stg=1>>
    <<r1_stg=2>>Near normal renal function of <<egfr_r1_val />> ml/min at entry<</r1_stg=2>>
    <<p3pg_signal=1>>Apparent progression from <<egfr60_last_val />> ml/min to <<egfr_rn_val />> ml/min during (<<egfr60_last_dt />>-<<egfr_rn_dt />>) <</p3pg_signal=1>>
    <<est_esrd_lapsed=0>><<est_esrd_dt>>Estimated ESRD around <<est_esrd_dt />>.<</est_esrd_dt>><</est_esrd_lapsed=0>>
    <<est_esrd_lapsed=1>><<est_esrd_dt>>Imminent ESRD, with estimation boundry in the past<</est_esrd_lapsed=1>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (49,'acr_graph_acr','acr_graph','
    <hr />
    <div class="syn_synopsis_box">
    <h5>uACR profile for the last <<dspan_y />> years</h5>

    <div class="syn_container">


    <svg height=<<acr_graph_canvas_y />> width=<<acr_graph_canvas_x />>>
            <style>
                    .small { font:Ariel 8px;font-weight:normal;}
            </style>
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



          <text x="330" y="12" class="small"><<acr_graph_y_max />></text>
          <text x="330" y="94" class="small"><<acr_graph_y_min />></text>


    </svg>
    <br />

    <svg height=10 width=<<acr_graph_canvas_x />>>
    <style>
                    .small { font:Ariel 8px;font-weight:normal;}
    </style>
        <text x="0" y="10" class="small"><<acr_f_dt />></text>  
        <text x="290" y="10" class="small"><<acr_l_dt />></text> 
    </svg>
    </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (50,'hba1c_graph','hba1c_graph','
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

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (51,'graph_bp','bp_graph','
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

    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (ID,TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values (152,'periop_nsqip','periop_nsqip','
   <ul>
        <li><b>Perioperative mortality prediction</b></li>
        <ul>
            <li>ACS NSQIP</li>
            <ul>
                <li>Perioperative mortality risk <<pmp_score />>%</li>             
            </ul>
        </ul>
   
   </ul>

');
