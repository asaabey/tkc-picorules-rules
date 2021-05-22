REM INSERTING into RMAN_RPT_TEMPLATE_BLOCKS

SET DEFINE OFF;

TRUNCATE TABLE RMAN_RPT_TEMPLATE_BLOCKS;


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__masked__','dmg_source','
 _      ____  ____  _  __ _____ ____ 
/ \__/|/  _ \/ ___\/ |/ //  __//  _ \
| |\/||| / \||    \|   / |  \  | | \|
| |  ||| |-||\___ ||   \ |  /_ | |_/|
\_/  \|\_/ \|\____/\_|\_\\____\\____/
                                     
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__header__','dmg_source','
    <style>        
    </style>
    
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_source_summary','dmg_source','   
            <div class="card">
                <div class="card-body">
                <div class="d-none d-print-block">EID(<<eid />>)</div>
                    <<dmg_source=999>><h4>No primary care</h4><</dmg_source=999>>                
                            <<phc_0>><span>Primary health care network:</span><</phc_0>>
                            <<dmg_source=21>><span class="badge badge-info">NTG PCIS</span><</dmg_source=21>> 
                            <<dmg_source=22>><span class="badge badge-info">NTG EACS</span><</dmg_source=22>>
                            <<dmg_source=33>><span class="badge badge-warning">LAYNHAPUY</span><</dmg_source=33>>
                            <<dmg_source=31>><span class="badge badge-warning">MIWATJ</span><</dmg_source=31>>
                            <<dmg_source=32>><span class="badge badge-warning">ANYINGINYI</span><</dmg_source=32>>
                            <<dmg_source=37>><span class="badge badge-warning">CONGRESS</span><</dmg_source=37>>
                            <<dmg_source=38>><span class="badge badge-warning">CONGRESS</span><</dmg_source=38>>
                            <<dmg_source=39>><span class="badge badge-warning">CONGRESS</span><</dmg_source=39>>
                            <<dmg_source=41>><span class="badge badge-warning">CONGRESS</span><</dmg_source=41>>
                            <<dmg_source=42>><span class="badge badge-warning">CONGRESS</span><</dmg_source=42>>
                            <<dmg_source=36>><span class="badge badge-warning">WURLI</span><</dmg_source=36>>
                            <<dmg_source=35>><span class="badge badge-warning">KWHB</span><</dmg_source=35>>
                            <br />
                            <<pcis_n>><span class="badge badge-pill badge-info">NTG PCIS</span><</pcis_n>> 
                            <<eacs_n>><span class="badge badge-pill badge-info">NTG EACS</span><</eacs_n>>
                            <<laynhapuy_n>><span class="badge badge-pill badge-warning">LAYNHAPUY</span><</laynhapuy_n>>
                            <<miwatj_n>><span class="badge badge-pill badge-warning">MIWATJ</span><</miwatj_n>>
                            <<congress_n>><span class="badge badge-pill badge-warning">CONGRESS</span><</congress_n>>
                            <<wurli_n>><span class="badge badge-pill badge-warning">WURLI</span><</wurli_n>>
                            <<pcis_n>><i>PCIS encounters (N=<<pcis_n />>, last=<<pcis_ld />>)</i><</pcis_n>> 
                            <<eacs_n>><i>EACS encounters (N=<<eacs_n />>, last=<<eacs_ld />>)</i><</eacs_n>>
                            <<miwatj_n>><i>MIWATJ encounters (N=<<miwatj_n />>, last=<<miwatj_ld />>)</i><</miwatj_n>>
                            <<laynhapuy_n>><i>LAYNHAPUY encounters (N=<<laynhapuy_n />>, last=<<laynhapuy_ld />>)</i><</laynhapuy_n>>
                            <<anyinginyi_n>><i>ANYINGINYI encounters (N=<<anyinginyi_n />>, last=<<anyinginyi_ld  />>)</i><</anyinginyi_n>>
                            <<congress_n>><i>CONGRESS encounters (N=<<congress_n />>, last=<<congress_ld />>)</i><</congress_n>>
                            <<wurli_n>><i>WURLI encounters (N=<<wurli_n />>, last=<<wurli_ld />>)</i><</wurli_n>>
                            <<loc_def>>Visited <b><<loc_def$loc_sublocality />></b>   (<<loc_mode_n />>/<<loc_n />>) which is <<mode_pct />>%<</loc_def>>
                </div>            
        </div>
        <hr />
    ');


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('tkc_drop_zone','dmg_source','
    <tkc_drop_zone><div class="card">
        <div class="card-body">
            ..<br /><br/>..
        </div></div></tkc_drop_zone>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_source_feedback','dmg_source','
    <div class="card">
      <div class="card-body">
         <a href="mailto:asanga.abeyaratne@nt.gov.au?cc=renal.csu@nt.gov.au&subject=TKC Feedback EID: <<eid />> HRN: <<hrn />>" class="btn btn-primary btn-sm">TKC Feedback</a>
         <<tkc_provider=1>><a href="mailto:pratish.george@nt.gov.au?subject=TKC Enquiry EID: <<eid />> HRN: <<hrn />>" class="btn btn-warning btn-sm">Contact Specialist (Dr George)</a> <</tkc_provider=1>>
         <<tkc_provider=2>><a href="mailto:asanga.abeyaratne@nt.gov.au?subject=TKC Enquiry EID: <<eid />> HRN: <<hrn />>" class="btn btn-warning btn-sm">Contact Specialist (Dr Abeyaratne)</a> <</tkc_provider=2>>
      </div>
    </div>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_residency','dmg_residency','
    <div class="card">
      <div class="card-body">
        Residential care resident
      </div>
    </div>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_tkcuser_interact','dmg_tkcuser_interact','
    <blockquote class="blockquote">
        <<corr_ld>>Last correspondence sent on <<corr_ld />><</corr_ld>>
        <<tag_sys_pr_dt>>This record has been flagged as <span class="badge badge-pill badge-danger">Partial</span> by user <<tag_sys_pr_val$user_id_name />> on <<tag_sys_pr_dt />><</tag_sys_pr_val>>
    </blockquote>
    <hr>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_eid_alt','dmg_eid_alt','
    <div class="alert alert-warning" role="alert">
      
        <h5> Potential duplicate <a href="/#/patient-detail/<<alt_eid_last />>"><<alt_eid_last />></a>
        <p>Record may be incomplete !</p>
        </h5>
        <<alt_eid_last_1>><h5> Another duplicate <<alt_eid_last_1 />></h5><</alt_eid_last_1>>
      
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_phc_null','dmg_source','
    <<dmg_source=999>>
        <div class="alert alert-warning" role="alert">
            <h5> 
            <p>Record may be incomplete ! No primary care records found</p>
            </h5>
            <p>This is most likely due to</p>
            <ol>
                <li>Interstate client</li>
                <li>Client of non-participating PHC</li>
                <li>Linking failure</li>
            </ol>
        </div>
    <</dmg_source=999>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg2610','tg2610','
    <div class="alert alert-warning" role="alert">
        <h5>
        Alert: Potentially untreated chronic disease (Trigger 2610)
        </h5>
        <<dm_untreat>>Likely to require pharmacotherapy for glycaemic control. No active medications are detected. <</dm_untreat>>
        <<ckd_untreat>>Likely to benefit from RAAS blockade therapy (ACEi or ARB) in the context of albuminuric chronic kidney disease. <</ckd_untreat>>
        <<ckd_untreat>>Last systolic BP is <<sbp_val />> mmHg ( <<sbp_dt />>) and serum potassium is <<k_val />> mmol/l (<<k_dt />>).<</ckd_untreat>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4100','tg4100','
    <div class="alert alert-warning" role="alert">
    <h5>Alert: Acute kidney injury in community (Trigger 4100)</h5>
    Baseline creatinine is estimated to be <<cr_base />> umol/l and the maxima is <<cr_max_1y />> umol/l on <<cr_max_ld_1y />>. <br /> 
    This is consistent with an acute kidney injury (AKIN stage 2 or above). 
    <<aki_outcome=3>>There is no resolution. <</aki_outcome=3>> 
    <<aki_outcome=2>>There appears to be partial resolution. <</aki_outcome=2>>
    <<aki_outcome=1>>There appears to be complete resolution. <</aki_outcome=1>> 
    last recorded creatinine is <<cr_lv />>umol/l on <<cr_ld />>.
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4410','tg4410','
    <div class="alert alert-warning" role="alert">
    <h5>
    Alert: Nephrotic range proteinuria in the absence of diabetes (Trigger 4410)
    </h5>
    The last uACR was <<uacr1 />> mg/mmol and the one before was <<uacr2 />> mg/mmol. <br />  
    <<iq_tier=3>>Serum Albumin and Cholesterol have been checked <<low_alb>> and there is hypoalbuminaemia<</low_alb>><<higl_chol>> and hypercholesterolaemia<</higl_chol>>. <</iq_tier=3>>
    This is consistent with a primary nephrotic syndrome. 
    <<iq_tier=4>>It is noted that autoimmune and other relevant serological tests have been performed.<</iq_tier=4>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4610','tg4610','
    <div class="alert alert-warning" role="alert">
        
            <h5>Alert: Unmanaged possible early albuminuric CKD with rapid progression (Trigger 4610)</h5>
            The current glomerular stage is <<ckd_stage />> with an annual decline of <<eb />> ml/min/yr without a recent specialist encounter or referral. <br />
            <<egfr_l_val>>The last eGFR was <<egfr_l_val />> ml/min on <</egfr_l_val>><<egfr_l_dt />><<egfr_max_val>> with a decline from <<egfr_max_val />> ml/min on <<egfr_max_dt />>
            <<ckd_null>>Please note the absence of CKD staging as this does not currently fullfill criteria. <</ckd_null>>
        
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4620','tg4620','
    <div class="alert alert-warning" role="alert">
        <h5>Alert: Advanced CKD with rapid progression, possibly unprepared (Trigger 4620)</h5>
        There is CKD stage <<ckd_stage />> disease with an annual decline of <<eb />> ml/min/yr without a recent specialist encounter. <br />
        There is no recorded access creation
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4660','tg4660','
    <div class="alert alert-warning" role="alert">
    <h5>
    Alert: Medication safety concern (Trigger 4660)
    </h5>
    This patient is on <<dm_rxn_bg>>a biguanide,<</dm_rxn_bg>><<dm_rxn_sglt2>> SGLT2 inhibitor,<</dm_rxn_sglt2>><<rx_nsaids>> NSAIDS,<</rx_nsaids>> which may be inconsistent with current renal function. <br />
    <<dm_rxn_bg>>Biguanides may be rarely associated with lactic acidosis at this level of renal function. <</dm_rxn_bg>>
    <<dm_rxn_sglt2>>SGLT2 inhibitors are relatively contra-indicated at this level of renal function. <</dm_rxn_sglt2>>
    <<rx_nsaids>>NSAIDS may cause additional renal injury.<</rx_nsaids>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4720','tg4720','
    <div class="alert alert-warning" role="alert">
    <h5>
    Alert: New commencement on Renal replacement therapy (Trigger 4720)
    </h5>
    <<hd_start>>Patient has been commenced on haemodialysis on <<hd_dt_min />>. <</hd_start>>
    <<pd_start>>Patient has been commenced on peritoneal dialysis on <<pd_dt_min />>. <</pd_start>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('alert_tg4810','tg4810','
    <div class="alert alert-warning" role="alert">
    <h5>Alert: High haemoglobin on the background of ESA therapy  (Trigger 4810)</h5>
    Current haemoglobin is <<hb_i_val />> g/L which has increased from a previous hb of <<hb_i1_val />> g/L. <br />
    The ESA was last prescribed on \t <<esa_dt />>. 
    This finding is associated with a higher all-cause mortality in CKD and RRT patients.\n 
    It is possible that the medication is not administered,or an undocumented dose reduction has occured.
    </div>

    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_1_syn','rrt','
    <<rrt=1>>
    <ul>
    <li><b>End-stage renal failure (ESRD)</b>
        <ul>
            <li>Currently on satellite haemodialysis, since <<hd_dt_min />></li>
            <<rrt_mm1=1>><li><span class="badge badge-danger">Discrepancy</span>No recent episodes. Private dialysis provider ? recovered CKD?</li><</rrt_mm1=1>>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ul>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />> - <<ret_hd_post_tx />></li><</tx_dt>>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt_min />> - <<ret_hd_post_pd />></li><</pd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ul>
            <</rrt_past=1>>
        </ul>
    </li>
    </ul>
    <</rrt=1>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_hd_acc_iv','rrt_hd_acc_iv','
    <ul><ul>
    <li>Vascular access
        <ul>
            <<avf_dt>><li><b>AVF</b> date <<avf_dt />></li><</avf_dt>>
            <<av_us_ld>><li>Last US fistulogram <<av_us_ld />></li><</av_us_ld>>
            <<av_gram_ld>><li>Last DSA fistulogram <<av_gram_ld />></li><</av_gram_ld>>
            <<av_plasty_ld>><li>DSA fistuloplasty [<<av_plasty_ld />>-<<av_plasty_1_ld />>][<<av_plasty_n />>]</li><</av_plasty_ld>>
            <<av_plasty_ld>><li>
                <<iv_periodicity=99>>Periodicity cannot be determined<</iv_periodicity=99>>
                <<iv_periodicity=3>>Periodicity 3 monthly<</iv_periodicity=3>>
                <<iv_periodicity=6>>Periodicity 6 monthly<</iv_periodicity=6>>
                <<iv_periodicity=12>>Periodicity yearly<</iv_periodicity=12>>                
            </li><</av_plasty_ld>>
        </ul>
    </li>
    </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_2_syn','rrt','
    <<rrt=2>>
    <ul>
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
    </ul>
    <</rrt=2>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_3_syn','rrt','
    <<rrt=3>>
    <ul>
    <li><b>Renal transplant due to (ESRD)</b>
        <ul>
            <<tx_multi_current>><li>Multiparity detected</li><</tx_multi_current>>
            <<tx_multi_current=0>><li>Functioning allograft, since <<tx_dt />></li><</tx_multi_current=0>>
            <<tx_multi_current=1>><li>Functioning allograft, since <<tx_multi_fd />></li><</tx_multi_current=1>>
            <<tx_multi_current=1>><li>First graft <<tx_dt />></li><</tx_multi_current=1>>
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
    </ul>
    <</rrt=3>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_4_syn','rrt','
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_3_metric','rrt_tx','
    <ul><ul>
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
    </ul></ul>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_syn_1','ckd','
    <ul>
        <li><b>CKD stage <<ckd_stage />></b><<mm1>>?<</mm1>><<mm2>>??<</mm2>>
        <ul>
            <<assert_level=101100>><li>Has not met persistent criteria</li><</assert_level=101100>>
            <<mm1>><li>Could be a dialysis patient with non-captured episodes</li><</mm1>>
            <<ckd_stage>><li><<dx_ckd>>Diagnosed <</dx_ckd>><<pers>>Persistent <</pers>>CKD stage <strong> (<<cga_g />><<cga_a />>)</strong> [1.1].</li><</ckd_stage>>
            <<dx_ckd=0>><li>No coded diagnosis on the primary care EHR (ICPC coding) [1.2]</li><</dx_ckd=0>>
            <<dx_ckd>><li>The diagnosis on the primary care EHR is CKD stage <<dx_ckd_stage />> [1.2]</li><</dx_ckd>>
            <<egfr_l_val>><li>Last eGFR is <strong><<egfr_l_val />></strong> ml/min/1.73m2 (<<egfr_l_dt />>)<<egfr_outdated>> and is outdated [1.3].<</egfr_outdated>></li><</egfr_l_val>>
            <<acr_l_val>><li>Last uACR is <<acr_l_val />> mg/mmol (<<acr_l_dt />>)<<acr_outdated>> and is outdated [1.3].<</acr_outdated>></li><</acr_l_val>>
            <<egfr_decline>><li><<egfr_rapid_decline>>rapid <</egfr_rapid_decline>>progressive decline of renal function with an annual decline of <<egfr_slope2 />>ml/min/yr [1.3]</li><</egfr_decline>>
            <<enc_ld>><li>Last captured encounter with renal services was on <<enc_ld />> and there have been <<enc_n />> encounters since <<enc_fd />></li><</enc_ld>>
            <<ref_ld>><li>Last renal <b>referral</b> <<ref_ld />></li><</ref_ld>>
            <<avf>><li>An <strong>arterio-venous fistula</strong> has been created on <<avf_dt />></li><</avf>>
            <<rsc_ld>><li><b>Renal supportive care <<rsc_ld />></b></li><</rsc_ld>>
            <<is_pcis=1>><<cp_ckd=0>><li>No current PCIS careplan for CKD</li><</cp_ckd=0>><</is_pcis=1>>
            <<is_pcis=1>><<cp_ckd>><li>CKD current PCIS careplan is <<cp_ckd />> updated on <<cp_ckd_ld />></li><</cp_ckd>><</is_pcis=1>>
            <<is_pcis=1>><ul><<cp_mis>><li>existing care plan may not be adequate [1.8]</li><</cp_mis>></ul><</is_pcis=1>>
            </li>
        </ul>
        </li>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_1','cd_dm_dx','
    <br />
    <ul>
        <<dm_type=1>><li><b>Diabetes Mellitus Type 1</b> <<dm1_mm>> ? <</dm1_mm>></li><</dm_type=1>>
        <<dm_type=2>><li><b>Diabetes Mellitus Type 2</b> <<dm2_mm_1>> ? <</dm2_mm_1>><<dm2_mm_2>> ? <</dm2_mm_2>><<dm2_mm_3>> ? <</dm2_mm_3>><<dm2_mm_4>> ? <</dm2_mm_4>></li><</dm_type=2>>
        <ul>
            <<dm2_mm_3>><li>Dm2 codes predate pre-diabetes</li> <</dm2_mm_3>>
            <<dm2_mm_4>><li>Codes suggestive of non type 1 or non-type 2</li> <</dm2_mm_4>>
            <<dm_mixed>><li>coded as type 1? on <<dm1_fd />></li><</dm_mixed>>
            <<dm_fd_year>><li>since <<dm_fd_year />></li><</dm_fd_year>>
            <<dm_dx_uncoded>><li>not coded on primary care EHR</li><</dm_dx_uncoded>>
            <<cd_dm_dx_code=110000>><li>based only on hospital records on <<dm_icd_fd />></li><</cd_dm_dx_code=110000>>
            <<cd_dm_dx_code=101110>><li>based on primary EHR, lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=101110>>
            <<cd_dm_dx_code=111110>><li>based on hospital and primary EHR, lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=111110>>
            <<cd_dm_dx_code=100000>><li>based on a single HbA1c of <<gluc_hba1c_high_f_val />> on <<gluc_hba1c_high_f_dt />></li><</cd_dm_dx_code=100000>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_2','cd_dm_comp','
       <ul><ul>
            <li>Non-renal microvascular complications present
                <ul>
                    <<dm_micvas_retino>>
                        <li>Diabetic retinopathy</li><</dm_micvas_retino>> 
                            <ul>
                                <<ndr_icd_e31>><li>Background retinopathy <<ndr_icd_e31 />></li><</ndr_icd_e31>>
                                <<ndr_icd_e32>><li>Mild non-proliferative retinopathy <<ndr_icd_e32 />></li><</ndr_icd_e32>>
                                <<ndr_icd_e33>><li>Moderate non-proliferative retinopathy <<ndr_icd_e33 />></li><</ndr_icd_e33>>
                                <<ndr_icd_e34>><li>Severe non-proliferative retinopathy <<ndr_icd_e34 />></li><</ndr_icd_e34>>
                                <<pdr_icd_e35>><li>Severe non-proliferative retinopathy <<pdr_icd_e35 />></li><</pdr_icd_e35>>
                            </ul>
                    <<dm_micvas_neuro>><li>Diabetic neuropathy (<<dm_micvas_neuro />>)</li><</dm_micvas_neuro>>
                    <<dm_foot_ulc>><li>Diabetic foot ulcer (<<dm_foot_ulc />>)</li><</dm_foot_ulc>>
                </ul>
            </li>
        </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_3','cd_dm_glyc_cntrl','
       <ul><ul>
            <<hba1c_n_tot>><li>Last recorded HbA1c (NGSP) is <<hba1c_n0_val />> % (<<hba1c_n0_dt />>)</li><</hba1c_n_tot>>
            <<hba1c_max_val>><li>Maximum HbA1c (NGSP) is <<hba1c_max_val />> % (<<hba1c_max_dt />>)</li><</hba1c_max_val>>
            <<n_opt_qt>><li>Time in range <<n_opt_qt />> % in the last 2 years </li><</n_opt_qt>>
       </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_4','cd_dm_dx','
    <<dm_rxn=0>>
    <ul>
        <ul>
                <li>No medications recorded</li>
        </ul>
    </ul>
    <</dm_rxn=0>>
    <<dm_rxn>>
    <ul>
        <ul>    
                <li>Current medication classes
                <ul>
                    <<dm_rxn_su>><li>sulphonylurea (<<dm_rxn_su />>)</li><</dm_rxn_su>>
                    <<dm_rxn_bg>><li>biguanide (<<dm_rxn_bg />>)</li><</dm_rxn_bg>>
                    <<dm_rxn_ins_long>><li>long-acting insulin (<<dm_rxn_ins_long />>)</li><</dm_rxn_ins_long>>
                    <<dm_rxn_ins_int>><li>Intermediate-acting insulin (<<dm_rxn_ins_int />>)</li><</dm_rxn_ins_int>>
                    <<dm_rxn_ins_mix>><li>Mixed insulin (<<dm_rxn_ins_mix />>)</li><</dm_rxn_ins_mix>>
                    <<dm_rxn_ins_short>><li>short-acting insulin (<<dm_rxn_ins_short />>)</li><</dm_rxn_ins_short>>
                    <<dm_rxn_glp1>><li>GLP1 analogue (<<dm_rxn_glp1 />>)</li><</dm_rxn_glp1>>
                    <<dm_rxn_dpp4>><li>DPP4 inhibitor (<<dm_rxn_dpp4 />>)</li><</dm_rxn_dpp4>>
                    <<dm_rxn_sglt2>><li>SGLT2 inhibitor (<<dm_rxn_sglt2 />>)</li><</dm_rxn_sglt2>>
                </ul>
                </li>
        </ul>
    </ul>
    <</dm_rxn>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_5','cd_dm_mx','
    <<cp_dm=0>>
    <ul><ul>
                <li>PCIS diabetes careplan was not detected [2.4]</li>
    </ul></ul>
    <</cp_dm=0>>
    <<cp_dm>>
    <ul><ul>
                <li>PCIS diabetes careplan was updated on <<cp_dm_ld />></li>
    </ul></ul>
    <</cp_dm>>
    <<rv_edu_ld>><ul><ul><li>Last Diabetic educator review <<rv_edu_ld />></li></ul></ul><</rv_edu_ld>>
    <<rv_pod_ld>><ul><ul><li>Last Podiatry review <<rv_pod_ld />></li></ul></ul><</rv_pod_ld>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_obesity','cd_obesity','
    <br />
    <ul>
        <<cd_obesity>><li><b>Obesity</b></li><</cd_obesity>>
        <ul>
            <li>obesity class <<bmi_class />>: BMI <<bmi />> kg/m2 (<<wt_dt />>)</li>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_htn_syn_1','cd_htn','
    <br />
    <ul>
        <li><b>Hypertension</b>
        <ul>
            <li><<htn_icpc>>Diagnosed<</htn_icpc>> Hypertension <<htn_from_obs>> from observations <</htn_from_obs>> <<htn_fd_yr>> since <</htn_fd_yr>><<htn_fd_yr />></li>
            <<sbp_outdated=1>><li>No readings within last two years</li><</sbp_outdated=1>>
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_htn_bp_control','cd_htn_bp_control','
    <ul><ul>
        <li>BP control
        <ul>
            <li>Recommended target <<sbp_target_max />>/<<dbp_target_max />> mmHg or less</li>
            <li>Average BP <<sbp_mu_1 />>/<<dbp_mu_1 />> (<<sbp_min />>-<<sbp_max />>) mmHg </li>
            <li>Time in range <<sbp_tir_1y />>%</li>
        </ul>
        </li>
    </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_cad_syn','cd_cardiac_cad','
        <br />
        <ul>
            <<cad>><li><b>Coronary artery disease</b>
            <ul>
                <<cabg>><li>Coronary artery bypass grafting <<cabg />></li><</cabg>>
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cvra_syn_1','cvra','
    <br />
    <ul>
        <li><b>Cardiovascular risk (CVR)</b></li>
        <ul>
        <<risk_high_ovr=0>>
           <li>CVR status was calculated using FRE [4.1]</li>
            <<risk_5>><li>Composite 5 year CVD risk is <<risk_5 />>%</li><</risk_5>>
        <</risk_high_ovr=0>>
        <<cvra_cat=3>><li>The composite 5 year CVD risk is high</li><</cvra_cat=3>>
        <<cvra_cat=2>><li>The composite 5 year CVD risk is moderate</li><</cvra_cat=2>>
        <<cvra_cat=1>><li>The composite 5 year CVD risk is low</li><</cvra_cat=1>> 
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cvra_banner_1','cvra','
    <div class="card">
      <div class="card-body">
        <<cvra_cat=2>><span class="badge badge-pill badge-warning">Mod CVR</span><</cvra_cat=2>>
        <<cvra_cat=3>><span class="badge badge-pill badge-danger">High CVR</span><</cvra_cat=3>>
        
        <<dm=1>><span class="badge badge-pill badge-warning">DM</span><</dm=1>>
        <<esrd_risk=1>><span class="badge badge-pill badge-success">ESRD Risk 1</span><</esrd_risk=1>>
        <<esrd_risk=2>><span class="badge badge-pill badge-warning">ESRD Risk 2</span><</esrd_risk=2>>
        <<esrd_risk=3>><span class="badge badge-pill badge-danger">ESRD Risk 3</span><</esrd_risk=3>>
        <<esrd_risk=4>><span class="badge badge-pill badge-danger">ESRD Risk 4</span><</esrd_risk=4>>
   
      </div>
    </div>
    
    
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_vhd_syn','cd_cardiac_vhd','
        <br />
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_chf_syn','cd_cardiac_chf','
        <br />
        <ul>
            <<chf>><li><b>Congestive heart failure</b>
            <<dcm>><ul><li>Dilated cardiomyopathy <<dcm />></li></ul><</dcm>>
            <<hocm>><ul><li>Hypertrophic obstructive cardiomyopathy <<hocm />></li></ul><</hocm>>
            <<rcm>><ul><li>Restrictive cardiomyopathy <<rcm />></li></ul><</rcm>>
            <<ethocm>><ul><li>Alcohol related cardiomyopathy <<ethocm />></li></ul><</ethocm>>
            <<noscm>><ul><li>Cardiomyopathy NOS <<noscm />></li></ul><</noscm>>
            <</chf>>
        </ul>   
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_rhd','cd_cardiac_rhd','
        <br />
        <ul>
            <<rhd_dt>><li><b>Rheumatic heart disease</b>
            <ul>
                <li>Diagnosed <<rhd_dt />>
            </ul>
            <</rhd_dt>>
        </ul>   
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_af','cd_cardiac_af','
    <br />
    <ul>
        <b><li>Atrial fibrillation</li></b>
        <ul>
            <li>Diagnosed <<af_dt />></li>
            <<vhd=0>><li>Non-valvular AF</li><</vhd=0>>
            <<vhd=1>><li>Valvular AF</li><</vhd=1>>
            <<cha2ds2vasc>><li>CHA2DS2VASC score  : <<cha2ds2vasc />></li><</cha2ds2vasc>>
            <<rxn_anticoag>><li>Anticoagulation <<rxn_anticoag_dt />></li><</rxn_anticoag>>
            <<rxn_anticoag=0>><li>Not on anticoagulation </li><</rxn_anticoag=0>>
        </ul>

    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dyslip','cd_dyslip','
    <br />
    <ul>
        <b><li>Dyslipidaemia</li></b>
        <ul>
            <<ldl_dt>><li>Last LDL-C value <<ldl_val />>(<<ldl_dt />>)</li><</ldl_dt>>
            <<ascvd>><li>Secondary prevention as there is past atherosclerotic cvd </li><</ascvd>>
            <<ldl_subopt=1>><li>Suboptimal control (LDL-C level 20% above threshold of <<ldl_unl />>)</li><</ldl_subopt=1>>
            <<fhc_prob=4>>
                <li>Definite familial hypercholesterolaemia based on an abbreviated dutch lipid score of <<dls />></li>
            <</fhc_prob=4>>
            <<fhc_prob=3>>
                <li>Probable familial hypercholesterolaemia based on an abbreviated dutch lipid score of <<dls />></li>
            <</fhc_prob=3>>
            <<fhc_prob=2>>
                <li>Possible familial hypercholesterolaemia based on an abbreviated dutch lipid score of <<dls />></li>
            <</fhc_prob=2>>
        </ul>

    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cva_syn','cd_cva','
    <br />
    <ul>
        <li><b>Cerebrovascular disease</b>
        <ul>
            <<cva_infarct_dt>><li>cerebral infarct <<cva_infarct_dt />></li><</cva_infarct_dt>>
            <<cva_hmrage_dt>><li>subarachnoid or intracerebral haemorrhage <<cva_hmrage_dt />></li><</cva_hmrage_dt>>
            <<cva_nos_dt>><li>Stroke <<cva_nos_dt />></li><</cva_nos_dt>>
        </ul>
    </ul>  
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cns','cd_cns','
    <br />
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
            <<code_epil_dt>><li>Diagnosed (<<code_epil_dt />>) and medicated</li><</code_epil_dt>>
            <<rx_n03_dt>><li>Medicated for (<<rx_n03_dt />>)</li><</rx_n03_dt>>
        </ul>
        <</epil>>
        <<pd>><b><li>Parkinson disease</li></b>
        <ul>
            <li>Diagnosed (<<code_pd_dt />>) and medicated</li>
        </ul>
        <</pd>>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_haem','cd_haem','
    <br />
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

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rx_syn_1','rx_desc','
    <hr/> 
    <br />
    <div class="syn_synopsis_box">
    <h3>Medications</h3>
    <ol>
        <<rx_name_obj$rx_name_obj />>
    </ol>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rx_syn_2','rx_desc_ptr','
    <hr/> 
    <br />
    <div class="syn_synopsis_box">
    <h3>Medications v2</h3>
    <ol>
        <<rx_name_obj$rx_name_obj2 />>
    </ol>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('graph_egfr2','egfr_graph2','
    <hr />
    <div class="syn_synopsis_box">
    <div class="card" style="width: 640px;">
        <div class="card-header">
            <h5>Temporal variation of eGFR over <<yspan />> years</h5>
            (ml/min against time)
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                      <svg height=<<egfr_graph_canvas_y />> width=<<egfr_graph_canvas_x />>>
                        <style>
                            .small { font:Ariel 18px;font-weight:normal;}
                        </style>
                        <defs>
                    
                            <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                                markerWidth="5" markerHeight="5">
                              <circle cx="5" cy="5" r="5" fill="grey" />
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
        </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_cause_syn_1','ckd_cause','
    <ul><ul>
        <li>Aetiology
            <ul>
                <li>Potential cause for CKD</li>
                <ul>
                    <<aet_dm=1>><li>diabetes mellitus</li><</aet_dm=1>>
                    <<aet_htn=1>><li>hypertension</li><</aet_htn=1>>
                    <<aet_gn_ln=1>><li>lupus nephritis</li><</aet_gn_ln=1>>
                    <<aet_gn=1>><li>glomerulopathy NOS</li><</aet_gn=1>>
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
                    <<c_q60>><li>Renal agenesis and other reduction defects of kidney <<c_q60 />></li><</c_q60>>
                    <<c_q61>><li>Cystic kidney disease <<c_q61 />></li><</c_q61>>
                    <<c_q62>><li>Congenital obstructive defects of renal pelvis and congenital malformations of ureter <<c_q62 />></li><</c_q62>>
                    <<c_q63>><li>Other congenital malformations of kidney <<c_q63 />></li><</c_q63>>
                    <<c_q64>><li>Other congenital malformations of urinary system <<c_q64 />></li><</c_q64>>
                    <<c_c64>><li>Renal cell cancer <<c_c64 />></li><</c_c64>>
                    <<c_z90_5>><li>Complete or partial nephrectomy (Acquired single kidney) <<c_z90_5 />></li><</c_z90_5>>
                </ul>
            </ul>
        </li>
    </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_cause_nephrectomy','ckd_cause','
    <<c_z90_5>>
        <br />
        <ul>
            <li><b>Nephrectomy</b></li>
            <ul>
                <li>First procedure <<c_z90_5 />></li>
            </ul>
        </ul>
    <</c_z90_5>>
        
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_journey_1','ckd_journey','
    <ul><ul>
        <li>Renal services engagement</li>
        <ul>
            <<enc_multi=0>><<enc_ld>><li>Nephrologist reviews <<enc_ld />></li><</enc_ld>><</enc_multi=0>>
            <<enc_multi>><<enc_fd>><li>Nephrologist reviews: \t<<enc_fd />>-<<enc_ld />> [<<enc_n />>]</li><</enc_fd>><</enc_multi>>
            <<edu_init>><li>CKD Education (initial): \t<<edu_init />></li><</edu_init>>
            <<edu_rv>><li>CKD Education review (last): \t<<edu_rv />></li><</edu_rv>>
            <<dietn>><li>Renal Dietician review (last): \t<<dietn />></li><</dietn>>
            <<sw>><li>Renal social work review (last): \t<<sw />></li><</sw>>
            <<avf_ld>><li>CKD Access (AVF) formation date: \t\t<<avf_ld />></li><</avf_ld>>
        </ul>
    </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_dx_1','ckd_diagnostics','
    <ul><ul>
        <li>Diagnostic workup</li>
        <<canddt_gn_wu=1>>
        <ul>
            <li>Basic urinalysis
            <<ua_null=1>> not performed <</ua_null=1>>
            <<ua_rbc_ld>> last performed on <<ua_rbc_ld />> and shows<</ua_rbc_ld>>
            <<ua_null=0>>
                <<ua_pos=0>> no significant findings<</ua_pos=0>>
                <<ua_pos=1>> haematuria with leucocyturia <</ua_pos=1>>
                <<ua_pos=2>> haematuria without leucocyturia <</ua_pos=2>>
            <</ua_null=0>></li>
            <<ana_dt>><li>ANA Serology: <<ana_dt />></li><</ana_dt>>
            <<dsdna_dt>><li>DsDNA Serology: <<dsdna_dt />><<dsdna_pos=1>>:SIGNIFICANT <</dsdna_pos=1>></li><</dsdna_dt>>            
            <<anca_dt>><li>ANCA Serology: <<anca_dt />></li><</anca_dt>>
            <<c3_dt>><li>Complements: <<c3_dt />>
                <<c3_pos=1>>,C3 hypocomplementaemia <</c3_pos=1>>
                <<c4_pos=1>>,C4 hypocomplementaemia <</c4_pos=1>>
            </li><</c3_dt>>
            <<spep_dt>><li>Serum protein electrophoresis: <<spep_dt />></li><</spep_dt>>
            <<sflc_kappa_dt>><li>SFLC assay: <<sflc_kappa_dt />>
                <<sflc_ratio_abn=1>>:SIGNIFICANT <</sflc_ratio_abn=1>>
            </li><</sflc_kappa_dt>>
            <<gbma_dt>><li>Anti-GBM : <<gbma_dt />></li><</gbma_dt>>
            <<aca_dt>><li>Anti-cardiolipin : <<aca_dt />></li><</aca_dt>>
            <<b2gpa_dt>><li>Anti-beta 2 glycoprotein 1 : <<b2gpa_dt />></li><</b2gpa_dt>>
            <<cryo_dt>><li>Cryoglobulin : <<cryo_dt />></li><</cryo_dt>>
        </ul>
        <</canddt_gn_wu=1>>
        <<canddt_bx=1>>    
        <ul>
            <li>Renal imaging: <<usk_null=1>>not performed <</usk_null=1>><<usk_null=0>>Most recent ultrasound kidney on <<ris_usk_ld />><</usk_null=0>></li>
            <<ris_bxk_ld>><li>Kidney biopsy on <<ris_bxk_ld />></li><</ris_bxk_ld>>             
        </ul>
        <</canddt_bx=1>>
    </ul></ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_compx_1','ckd_complications','
    <ul><ul>
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
                <<iron_low>><li>Iron stores low</li>
                    <ul>
                        <<fer_val>><li>Ferritin <<fer_val />>(<<fer_dt />>)</li><</fer_val>>
                    </ul>
                <</iron_low>>
            </ul>
            </li>
            <li>Acid-base balance
            <ul>
                <<hco3_low>><li>low tCO2 at <<hco3_val />> mmol/l (<<hco3_dt />>) likely due to metabolic acidosis</li><</hco3_low>>
            </ul>
            </li>
        </ul>
        </li>
    </ul></ul>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('hb_graph','hb_graph','
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('phos_graph','phos_graph','
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_tbl1','ckd_labs','
    <hr />
    <div class="syn_synopsis_box">
    <h5>Lab data panel</h5>
    <table class="table table-striped">
        <tbody>
        <tr>
            <td><strong>Lab</strong></td>
            <td></td>
            <td></td>
            <td></td>

        </tr>
        <tr>
            <td>Creatinine (umol)</td>
            <td><<creat1_val>><strong><<creat1_val />></strong>(<<creat1_dt />>) <</creat1_val>></td>
            <td><<creat2_val>><strong><<creat2_val />></strong> (<<creat2_dt />>)<</creat2_val>></td>
            <td><<creat3_val>><strong><<creat3_val />></strong> (<<creat3_dt />>)<</creat3_val>></td>

            <td></td>
        </tr>
        <tr>
            <td>eGFR (ml/min/1.72m)</td>
            <td><<egfr1_val>><strong><<egfr1_val />></strong>(<<egfr1_dt />>) <</egfr1_val>></td>
            <td><<egfr2_val>><strong><<egfr2_val />></strong>(<<egfr2_dt />>) <</egfr2_val>></td>
            <td><<egfr3_val>><strong><<egfr3_val />></strong>(<<egfr3_dt />>) <</egfr3_val>></td>

        </tr>


    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_tbl2','ckd_labs','
        <tr>
            <td>
                <div>Sodium (mmol/l)</div>

            </td>
            <td><<sodium1_val>><strong><<sodium1_val />></strong> (<<sodium1_dt />>)<</sodium1_val>></td>
            <td><<sodium2_val>><strong><<sodium2_val />></strong> (<<sodium2_dt />>) <</sodium2_val>></td>
            <td><<sodium3_val>><strong><<sodium3_val />></strong> (<<sodium3_dt />>)<</sodium3_val>></td>

        </tr>
        <tr>
            <td>
            <div>Potassium (mmol/l)</div>


            </td>
            <td><<potassium1_val>><strong><<potassium1_val />></strong>(<<potassium1_dt />>) <</potassium1_val>></td>
            <td><<potassium2_val>><strong><<potassium2_val />></strong>(<<potassium2_dt />>) <</potassium2_val>></td>
            <td><<potassium3_val>><strong><<potassium3_val />></strong>(<<potassium3_dt />>) <</potassium3_val>></td>

        
        </tr>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_tbl3','ckd_labs','
        <tr>
            <td>CO2 (mmol/l)</td>
            <td><<bicarb1_val>><strong><<bicarb1_val />></strong>(<<bicarb1_dt />>) <</bicarb1_val>></td>
            <td><<bicarb2_val>><strong><<bicarb2_val />></strong>(<<bicarb2_dt />>) <</bicarb2_val>></td>
            <td><<bicarb3_val>><strong><<bicarb3_val />></strong>(<<bicarb3_dt />>) <</bicarb3_val>></td>

        </tr>
        <tr>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>

        </tr>
        <tr>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>

        </tr>
        <tr>
            <td>Calcium (mmol/l)</td>
            <td><<calcium1_val>><strong><<calcium1_val />></strong>(<<calcium1_dt />>) <</calcium1_val>></td>
            <td><<calcium2_val>><strong><<calcium2_val />></strong>(<<calcium2_dt />>) <</calcium2_val>></td>
            <td><<calcium3_val>><strong><<calcium3_val />></strong>(<<calcium3_dt />>) <</calcium3_val>></td>

        </tr>
        <tr>
            <td>Phosphate (mmol/l)</td>
            <td><<phos1_val>><strong><<phos1_val />></strong> (<<phos1_dt />>) <</phos1_val>></td>
            <td><<phos2_val>><strong><<phos2_val />></strong> (<<phos2_dt />>)<</phos2_val>></td>
            <td><<phos3_val>><strong><<phos3_val />></strong> (<<phos3_dt />>)<</phos3_val>></td>



        </tr>
        <tr>
            <td>uACR (mg/mmol)</td>
            <td><<uacr1_val>><strong><<uacr1_val />></strong> (<<uacr1_dt />>)<</uacr1_val>></td>
            <td><<uacr2_val>><strong><<uacr2_val />></strong> (<<uacr2_dt />>)<</uacr2_val>></td>
            <td><<uacr3_val>><strong><<uacr3_val />></strong> (<<uacr3_dt />>)<</uacr3_val>></td>

        </tr>
        </tbody>
    </table>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('frame_recm_begin','dmg','
    <hr />
    <div class="syn_recm_box">
    <h3>Comments</h3>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_recm_1','ckd','
    <<dx_ckd_diff>><div>Recommendation [1.2] Update diagnosis to CKD stage<<ckd_stage />> </div><</dx_ckd_diff>>
    <<egfr_outdated>><div>Recommendation [1.3] Repeat renal function tests.</div><</egfr_outdated>>
    <<cp_mis>><div>Recommendation [1.7] Modify care plan to include appropriate stage of CKD</div><</cp_mis>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_rec_1','cd_dm','
    <<n0_st=3>><div>Recommendation [2.3] Suggest optimizing glycaemic control</div><</n0_st=3>>
    <<n0_st=4>><div>Recommendation [2.3] Suggest optimizing glycaemic control</div><</n0_st=4>>
    <<cp_dm=0>><div>Recommendation [2.4] Suggest modify care plan to include diabetes</div><</cp_dm=0>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cvra_rec_1','cvra','
    <<cvra=3>><<cp_hicvr=0>><div>Recommendation [4.1] Suggest modify care plan to include high CVR </div><</cp_hicvr=0>><</cvra=3>>
    <<cvra=3>><<smoke0=30>><div>Recommendation [4.2] Given high CVR status the smoking cessation is strongly advised </div><</smoke0=30>><</cvra=3>>
    <<cvra=2>><<smoke0=30>><div>Recommendation [4.2] Given moderate CVR status the smoking cessation is advised </div><</smoke0=30>><</cvra=2>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('frame_recm_end','dmg','
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('frame_notes_begin','dmg','
    <hr />
    <div class="syn_notes_box">
    <h4>Footnotes</h4>
    <small>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_htn_footnote_1','cd_htn','
    <<iq_tier>>
        <div>Note [3.1] This is based on <<iq_sbp />> blood pressure readings within the last 2 years</div>
    <</iq_tier>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_footnote_1','ckd','
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cvra_footnote_1','cvra','
    <<risk_high_ovr=0>><div>Note [4.1] The Framingham risk equation was used as per heart foundation guidelines. The CARPA 7th STM uses the same methodology</div><</risk_high_ovr=0>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('frame_notes_end','dmg','
    </small>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('debug_info','dmg','
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('egfr_metrics','egfr_metrics','
    <div class="syn_synopsis_box">
    <<r1_stg=1>>Normal renal function of <<egfr_r1_val />> ml/min at entry<</r1_stg=1>>
    <<r1_stg=2>>Near normal renal function of <<egfr_r1_val />> ml/min at entry<</r1_stg=2>>
    <<p3pg_signal=1>>Apparent progression from <<egfr60_last_val />> ml/min to <<egfr_rn_val />> ml/min during (<<egfr60_last_dt />>-<<egfr_rn_dt />>) <</p3pg_signal=1>>
    <<est_esrd_lapsed=0>><<est_esrd_dt>>Estimated ESRD around <<est_esrd_dt />>.<</est_esrd_dt>><</est_esrd_lapsed=0>>
    <<est_esrd_lapsed=1>><<est_esrd_dt>>Imminent ESRD, with estimation boundry in the past<</est_esrd_lapsed=1>>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('acr_graph_acr','acr_graph','
    <hr />
    <div class="syn_synopsis_box">
    <div class="card" style="width: 640px;">
        <div class="card-header">
            uACR profile for the last <<dspan_y />> years
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                      <svg height=<<acr_graph_canvas_y />> width=<<acr_graph_canvas_x />>>
                            <style> .small { font:Ariel 8px;font-weight:normal;} </style>
                            <defs>
                                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="5" markerHeight="5">
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
                    <svg height=10 width=<<acr_graph_canvas_x />>>

                        <text x="0" y="10" style="fill: #000000; stroke: none; font-size: 10px;"><<acr_f_dt />></text>  
                        <text x="290" y="10" style="fill: #000000; stroke: none; font-size: 10px;"><<acr_l_dt />></text> 
                    </svg>
                </div>
                <div class="col-md-4">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><small><strong>Last <<acr_l_val />> (<<acr_l_dt />>) </strong></small></li>
                        <li class="list-group-item"><small>Max <<acr_max_val />> (<<acr_max_dt />>) </small></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('hba1c_graph','hba1c_graph','
    <hr />
    <div class="syn_synopsis_box">
    
    <div class="card" style="width: 640px;">
        <div class="card-header">
            Hba1c profile for the last <<dspan_y />> years
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                    <svg height=<<hba1c_graph_canvas_y />> width=<<hba1c_graph_canvas_x />>>
                            <defs>
                                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="5" markerHeight="5">
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
                    <svg height=10 width=<<hba1c_graph_canvas_x />>>
                        <text x="0" y="10" style="fill: #000000; stroke: none; font-size: 10px;"><<hba1c_f_dt />></text>  
                        <text x="290" y="10"style="fill: #000000; stroke: none; font-size: 10px;" ><<hba1c_l_dt />></text> 
                    </svg>
            </div>
            <div class="col-md-4">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><small><strong>Last <<hba1c_l_val />> (<<hba1c_l_dt />>) </strong></small></li>
                        <li class="list-group-item"><small>Max <<hba1c_max_val />> (<<hba1c_max_dt />>) </small></li>
                        <li class="list-group-item"><small>Min <<hba1c_min_val />> (<<hba1c_min_dt />>) </small></li>
                        
                    </ul>
            </div>
        </div>
        </div>

    </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('graph_bp','bp_graph','
    <hr />
    <div class="syn_synopsis_box">
    
    <div class="card" style="width: 640px;">
        <div class="card-header">
            Blood pressure profile for the last 5 years
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                     <svg height=<<bp_graph_canvas_y />> width=<<bp_graph_canvas_x />>>
                        <defs>
                            <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="5" markerHeight="5">
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
                <div class="col-md-4">
                    <ul class="list-group list-group-flush">
                        <<tir_pct>><li class="list-group-item"><small>Time in range <<tir_pct />>%</small></li><</tir_pct>>
                        <li class="list-group-item"><small>Maximum <<sbp_max />> mmHg</small></li>
                        <li class="list-group-item"><small>Minimum <<sbp_min />> mmHg</small></li>
                        <<avg_bp_1y>><li class="list-group-item"><small>Average (1y) <<avg_bp_1y />> mmHg</small></li><</avg_bp_1y>>
                    </ul>
                </div>
            </div>
        </div>
        
    </div>
    
    </div>

    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('periop_nsqip','periop_nsqip','
   <br />
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



Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_ga','ckd_labs_ga','
   <hr/> 
   <div class="syn_synopsis_box">
   <h3>GA Labs</h3>
        <<egfr />>
        <<creat />>
        <<uacr />>
   </div>
');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_1_metrics','rrt_1_metrics','
    <<rrt=1>>
    <ul><ul>
        <<tspan_y>><li>Dialysis vintage <<tspan_y />> years</li><</tspan_y>>
        <li>Regularity <<hd_sl />>% </li>
        <li>Thrice weekly target achievement <<hd_oe />>% </li>
    </ul></ul>
    <</rrt=1>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('at_risk','at_risk','
    <<at_risk=1>>
    <ul>
    <li><b>At risk of CKD</b></li>
        <ul>
            <li>CKD criteria not met</li>
            <li>Risk factors</li>
            <ul>
                <<dm>><li>Diabetes mellitus</li><</dm>>
                <<htn>><li>Hypertension</li><</htn>>
                <<cad>><li>Coronary artery disease</li><</cad>>
                <<obesity>><li>Obesity</li><</obesity>>
                <<struc>><li>GU tract abnormalities</li><</struc>>
                <<lit>><li>Nephro-Urolithiasis</li><</lit>>
                <<aki>><li>AKI <<aki_ld />></li><</aki>>
                <<gn>><li>Resolved Glomerulonephritis</li><</gn>>
                <<tid>><li>Tubulo-interstitial disease</li><</tid>>
                <<obst>><li>Obstructive uropathy</li><</obst>>
                <<cti>><li>Connective tissue disorder</li><</cti>>
            </ul>
        </ul>
    </ul>
    <</at_risk=1>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_sle','cd_rheum_sle','
    <br />
    <ul>
    <li><b>Systemic Lupus Erythematosus</b></li>
        <ul>
            <li>Diagnosed <<sle_fd />> </li>
            <ul>
                <<rxn_l04ax>><li>Thiopurine <<rxn_l04ax />></li><</rxn_l04ax>>
                <<rxn_p01ba>><li>Hydroxychloroquine <<rxn_p01ba />></li><</rxn_p01ba>>
            </ul>
        </ul>
    </ul>
    
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_hd_param','rrt_hd_param','
    <ul><ul>
    <li>Haemodialysis prescription <<mode_dt />></li>
        <ul>
            <<mode_val=10>><li>High Flux haemodialysis</li><</mode_val=10>>
            <<mode_val=20>><li>Haemodialfitration (post dilutional)</li><</mode_val=20>>
            <<mode_val=22>><li>Haemodialfitration (mixed dilutional</li>)<</mode_val=22>>
            <<hours_val>><li>Hours : <<hours_val />></li><</hours_val>>
            <<dx_val>><li>Dialyzer : <<dx_val />></li><</dx_val>>
            <<ibw_val>><li>IBW : <<ibw_val />> kg</li><</ibw_val>>
        </ul>
    </ul>
    </ul>
    
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_cause_syn_1','ckd_cause','
       <<rrt=1>>
       <ul><ul>
         <li>Aetiology</li>
         <ul>
                <<aet_multiple=1>><li>Multiple aetiology is suggested</li>
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
                    <<c_q64>><li>Other congenital malformations of urinary system<<c_q64 />></li><</c_q64>>
                    <<c_c64>><li>Renal cell carcinoma<<c_c64 />></li><</c_c64>>
                </ul>
                <</aet_multiple=1>>
                <<aet_multiple=0>>
                    <li>
                        Potential cause for CKD is <strong><<aet_dm>>diabetic kidney disease (DKD)<</aet_dm>>
                        <<aet_htn>>,hypertensive kidney disease<</aet_htn>><<aet_gn_ln>>,lupus nephritis<</aet_gn_ln>></strong>
                    </li>
                <</aet_multiple=0>>
            </ul>
    </ul></ul>
    <</rrt=1>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ldl_graph','ldl_graph','
    <hr />
    <div class="syn_synopsis_box">
    <h5>LDL profile for the last <<dspan_y />> years</h5>

    <div class="syn_container">


    <svg height=<<g_graph_canvas_y />> width=<<g_graph_canvas_x />>>
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
          <line x1="0" x2="<<g_graph_canvas_x />>" y1="0" y2="0" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>

          <line x1="0" x2="<<g_graph_canvas_x />>" y1="<<line_lower_y />>" y2="<<line_lower_y />>" style="fill:none;stroke:black;stroke-width:4;stroke-dasharray: 1 2"/>

          <rect x="0" y="<<line_target_upper_y />>"  width="<<g_graph_canvas_x />>" height="40" fill="url(#grad12)" />

          <text x="330" y="12" style="fill: #000000; stroke: none; font-size: 8px;"><<g_graph_y_max />></text>
          <text x="330" y="94" style="fill: #000000; stroke: none; font-size: 8px;"><<g_graph_y_min />></text>
    </svg>
    <br />

    
    </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ca_solid','ca_solid','
    <br />
    <ul>
    <li><b>Solid organ cancer</b></li>
        <<ca_prostate_fd>>
        <ul>
            <li>Prostate carcinoma <<ca_prostate_fd />></li> 
        </ul>
        <</ca_prostate_fd>>
        <<ca_crc_fd>>
        <ul>
            <li>Prostate carcinoma <<ca_crc_fd />></li> 
        </ul>
        <</ca_crc_fd>>
        <<ca_rcc_fd>>
        <ul>
            <li>Renal cell carcinoma <<ca_rcc_fd />></li> 
        </ul>
        <</ca_rcc_fd>>
        <<ca_lung_fd>>
        <ul>
            <li>Lung carcinoma <<ca_lung_fd />></li> 
        </ul>
        <</ca_lung_fd>>
        <<ca_thyroid_fd>>
        <ul>
            <li>Thyroid carcinoma <<ca_thyroid_fd />></li> 
        </ul>
        <</ca_thyroid_fd>>
        <ul>
            <<op_enc_ld>><li>Last oncology clinic visit <<op_enc_ld />></li><</op_enc_ld>>
        </ul>
    </ul>
    
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ca_breast','ca_breast','
    <ul>
        <ul>
            <li>Breast carcinoma <<code_fd />></li> 
            <ul>
                <<rxnc_l02bg>><li>Aromatase inhibitor <<rxnc_l02bg />></li><</rxnc_l02bg>>
                <<rxnc_l02ba>><li>Anti-oestrogren therapy <<rxnc_l02ba />></li><</rxnc_l02ba>>
            </ul>
        </ul>
    </ul>
    
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ca_mets','ca_mets','
    <ul>
    <ul>
    <li><b>Metastatic disease</b></li>
        <<bone_met_fd>>
        <ul>
            <li>Bone metastatases <<bone_met_fd />></li>
        </ul>
        <</bone_met_fd>>
        <<cns_met_fd>>
        <ul>
            <li>Brain or CNS metastatases <<cns_met_fd />></li>
        </ul>
        <</cns_met_fd>>
        <<adr_met_fd>>
        <ul>
            <li>Adrenal metastatases <<adr_met_fd />></li>
        </ul>
        <</adr_met_fd>>
        <<liver_met_fd>>
        <ul>
            <li>Liver metastatases <<liver_met_fd />></li>
        </ul>
        <</liver_met_fd>>
        <<lung_met_fd>>
        <ul>
            <li>Liver metastatases <<lung_met_fd />></li>
        </ul>
        <</lung_met_fd>>
        <<perit_met_fd>>
        <ul>
            <li>Peritoneal metastatases <<perit_met_fd />></li>
        </ul>
        <</perit_met_fd>>
        <<nodal_met_fd>>
        <ul>
            <li>Nodal metastatases <<nodal_met_fd />></li>
        </ul>
        <</nodal_met_fd>>
        <<nos_met_fd>>
        <ul>
            <li>Metastatases NOS <<nos_met_fd />></li>
        </ul>
        <</nos_met_fd>>
    
    </ul>
    </ul>
    
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_pulm','cd_pulm','
    <br />
    <ul>
    <li><b>Chronic obstructive pulmonary disease</b></li>
        <ul>
            <<code_copd_dt>><li>Diagnosed <<code_copd_dt />></li><</code_copd_dt>>
            <<rx_r03_dt>><li>Bronchodilator therapy <<rx_r03_dt />></li><</rx_r03_dt>>
        </ul>
    </ul>
    
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_endo_hypothyroid','cd_endo_hypothyroid','
    <br />
    <ul>
    <li><b>Hypothyroidism</b></li>
        <ul>
            <<code_fd>><li>Cause</li><</code_fd>>
            <ul>
                <<cong_fd>><li>Congenital <<cong_fd />></li><</cong_fd>>
                <<rx_induced_fd>><li>Acquired <<rx_induced_fd />></li><</rx_induced_fd>>
                <<post_mx_fd>><li>Post ablative therapy <<post_mx_fd />></li><</post_mx_fd>>
                <<nos_fd>><li>Unspecified cause <<nos_fd />></li><</nos_fd>>
            </ul>
            <<rx_h03aa_ld>><li>Thyroxin replacement therapy <<rx_h03aa_ld />></li><</rx_h03aa_ld>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cirrhosis','cd_cirrhosis','
    <br />
    <ul>
    <li><b>Cirrhosis of liver</b></li>
        <ul>
            <<code_fd>><li>Diagnosed <<code_fd />></li><</code_fd>>
            
        </ul>
    </ul>
    
    ');
/
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_sti','id_sti','
    <br />
    <ul>
    <li><b>Recurrent Soft tissue infection</b></li>
        <ul>
            <<code_ld>><li>Last episode <<code_ld />></li><</code_ld>>
            <li><<icd_n />> infections over <<gap />> years</li>
            
        </ul>
    </ul>
    
    ');
/

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_cap','id_cap','
    <br />
    <ul>
    <li><b>Respiratory infection requiring hospitalization</b></li>
        <ul>
            <<cap_viral_ld>><li>Viral pneumonia <<cap_viral_ld />></li><</cap_viral_ld>>
            <<cap_strep_ld>><li>Streptococcal pneumonia <<cap_strep_ld />></li><</cap_strep_ld>>
            <<cap_hi_ld>><li>Haemophilus pneumonia <<cap_hi_ld />></li><</cap_hi_ld>>
            <<cap_mel_ld>><li>Melioidosis <<cap_mel_ld />></li><</cap_mel_ld>>
            <<cap_nos_ld>><li>Melioidosis <<cap_nos_ld />></li><</cap_nos_ld>>
        </ul>
    </ul>
    
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ipa_icu','ipa_icu','
    <br />
    <ul>
    <li><b>Admission to Intensive care</b></li>
        <ul>
            <<icu_los_dt>><li>ICU bed days <<icu_los_val />>(<<icu_los_dt />>)</li><</icu_los_dt>>
            <<icu_vent_los_dt>><li>Ventilation days <<icu_vent_los_val/>>(<<icu_vent_los_dt />>)</li><</icu_vent_los_dt>>
        </ul>
    </ul>
    
    ');


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_ra','cd_rheum_ra','
    <br />
    <ul>
    <li><b>Rheumatoid Arthritis</b></li>
        <ul>
            <li>Diagnosed <<ra_fd />> </li>
            <ul>
                <<rxn_l04ax>><li>Thiopurine <<rxn_l04ax />></li><</rxn_l04ax>>
                <<rxn_p01ba>><li>Hydroxychloroquine <<rxn_p01ba />></li><</rxn_p01ba>>
                <<rxn_a07ec>><li>Aminosalicylic acid and similar agents <<rxn_a07ec />></li><</rxn_a07ec>>
            </ul>
            <<op_enc_ld>><li>Last specialist clinic <<op_enc_ld />></li><</op_enc_ld>>
        </ul>
    </ul>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_aps','cd_rheum_aps','
    <br />
    <ul>
    <li><b>Antiphospholipid syndrome</b></li>
        <ul>
            <li>Diagnosed <<aps_fd />> </li>
            <ul>
                <<rxn_anticoag_dt>><li>Anticoagulated <<rxn_anticoag_dt />></li><</rxn_anticoag_dt>>
            </ul>
            <<op_enc_ld>><li>Last specialist clinic <<op_enc_ld />></li><</op_enc_ld>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_gout','cd_rheum_gout','
    <br />
    <ul>
    <li><b>Gout</b></li>
        <ul>
            <li>Diagnosed <<gout_fd />> </li>
            <ul>
                <<rxnc_m04aa_ld>><li>Urate lowering therapy <<rxnc_m04aa_ld />></li><</rxnc_m04aa_ld>>
            </ul>
            <<op_enc_ld>><li>Last specialist clinic <<op_enc_ld />></li><</op_enc_ld>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_hepb_coded','cd_hepb_coded','
    <br />
    <ul>
    <li><b>Chronic Hepatitis B</b></li>
        <ul>
            <<hepb_imm>>
                <li>Immune</li>
                <ul>
                    <<hepb_imm_vac>><li>by vaccination <<hepb_imm_vac />></li><</hepb_imm_vac>>
                    <<hepb_imm_inf>><li>by infection <<hepb_imm_inf />></li><</hepb_imm_inf>>
                </ul>
                
            <</hepb_imm>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_uti','id_uti','
    <br />
    <ul>
    <li><b>Recurrent UTI</b></li>
        <ul>
            <<uti_ld>><li>Last UTI <<uti_ld />></li><</uti_ld>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_tb','id_tb','
    <br />
    <ul>
    <li><b>Tuberculosis</b></li>
        <ul>
            <<tb_code>><li>TB first diagnosed <<tb_code />></li><</tb_code>>
            <<ltb_code>><li>Latent TB first diagnosed <<ltb_code />></li><</ltb_code>>
        </ul>
    </ul>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_vte','cd_cardiac_vte','
    <br />
    <ul>
    <li><b>Venous thrombo-embolism</b></li>
        <ul>
            <<pe_multi>><li>Multiple PE <<pe_fd />>-<<pe_ld />></li><</pe_multi>>
            <<pe_ld>><li>PE <<pe_ld />></li><</pe_ld>>
            <<dvt_fd>><li>Deep vein thrombosis <<dvt_fd />></li><</dvt_fd>>
            <<svt_fd>><li>Superficial vein thrombosis <<svt_fd />></li><</svt_fd>>
            <<budd_chiari_fd>><li>Budd-Chiari Syndrome <<budd_chiari_fd />></li><</budd_chiari_fd>>
            <<rxn_anticoag_dt>><li>Anticoagulated <<rxn_anticoag_dt />></li><</rxn_anticoag_dt>>
        </ul>
    </ul>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_block','ckd_labs','
    <hr />
    <h5>Lab data panel</h5>
    <p>
    <<creat1_val>>Creatinine <strong><<creat1_val />></strong>(<<creat1_dt />>) <</creat1_val>>
    <<egfr1_val>>eGFR <strong><<egfr1_val />></strong>(<<egfr1_dt />>) <</egfr1_val>>
    <<uacr1_val>>uACR <strong><<uacr1_val />></strong>(<<uacr1_dt />>) <</uacr1_val>>
    <<sodium1_val>>Sodium <strong><<sodium1_val />></strong>(<<sodium1_dt />>) <</sodium1_val>>
    <<potassium1_val>>Potassium <strong><<potassium1_val />></strong>(<<potassium1_dt />>) <</potassium1_val>>
    <<biacrb1_val>>Bicarbonate <strong><<biacrb1_val />></strong>(<<biacrb1_dt />>) <</biacrb1_val>>
    </p>
    <p>
    <<calcium1_val>>Calcium <strong><<calcium1_val />></strong>(<<calcium1_dt />>) <</calcium1_val>>
    <<phos1_val>>Phosphate <strong><<phos1_val />></strong>(<<phos1_dt />>) <</phos1_val>>
    </p>
    <p>
    <<hb1_val>>Haemoglobin <strong><<hb1_val />></strong>(<<hb1_dt />>) <</hb1_val>>
    <<ferritin1_val>>Ferritin <strong><<ferritin1_val />></strong>(<<ferritin1_dt />>) <</ferritin1_val>>
    </p>
        

    ');

@"tkc-insert-composition-template-map.sql"
-- Compile rman_tmplts
alter package rman_tmplts compile;
