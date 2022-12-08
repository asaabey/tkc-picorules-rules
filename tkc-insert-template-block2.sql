REM INSERTING into RMAN_RPT_TEMPLATE_BLOCKS

SET DEFINE OFF;

TRUNCATE TABLE RMAN_RPT_TEMPLATE_BLOCKS;


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__masked__','dmg_vm','
 _      ____  ____  _  __ _____ ____ 
/ \__/|/  _ \/ ___\/ |/ //  __//  _ \
| |\/||| / \||    \|   / |  \  | | \|
| |  ||| |-||\___ ||   \ |  /_ | |_/|
\_/  \|\_/ \|\____/\_|\_\\____\\____/
                                     
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__header__','dmg_vm','
        <head>
         <style> 
            .badge-purple {color: #5032a8; background-color: #ffffff ;border: 2px solid;}
            
            .badge-danger {color: #c90202; font-weight: 600; background-color: #ffffff ;border: 1px solid;}
            
            .badge-warning {color: #2596be; font-weight: 600; background-color: #ffffff ;border: 1px solid;}
            
            .badge-success {color: #32a852; font-weight: 600; background-color: #ffffff ;border: 1px solid;}
            
            .badge-teal {color: #08768c; font-weight: 600; background-color: #ffffff ;border: 1px solid;}
            
            
            ol {
              list-style-type: none;
              counter-reset: item;
              margin: 0;
              padding: 0;
            }
            
            ol > li {
              display: table;
              counter-increment: item;
              margin-bottom: 0.6em;
            }
            
            ol > li:before {
              content: counters(item, ".") ". ";
              display: table-cell;
              padding-right: 0.6em;    
            }
            
            li ol > li {
              margin: 0;
            }
            
            li ol > li:before {
              content: counters(item, ".") " ";
            }
    
        </style>
        </head>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__synth_left_begin__','dmg_vm','
    <div id="column1" style="min-width: 450px; max-width: 48%; padding-right: 2%;">
    <br /><br />
    <h3>Diagnoses</h3>
    <ol>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__synth_left_end__','dmg_vm','
    </ol>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__synth_right_begin__','dmg_vm','
    <div id="column2" style="min-width: 600px; max-width: 48%; padding-left: 2%;">
    <ol>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__synth_right_end__','dmg_vm','
    </ol>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__frame_begin__','dmg_vm','
    <div id="outerflex" style="display:flex; flex-wrap: wrap; justify-content: flex-start;">
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__frame_end__','dmg_vm','
    </div>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('_top_banner_begin','dmg_vm','
    <div class="card">
                <div class="card-body">
                <span>
                    <<dmg_source=900>><h6>Nephrology clinic</h6><</dmg_source=900>>
                    <<dmg_source=999>><h6>No recent primary care episodes</h6><</dmg_source=999>>                
                    <div class="d-none d-print-block">EID(<<eid />>)</div>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('_top_banner_end','dmg_vm','
     </span></div></div><hr />     
    ');


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_network_summary','dmg_vm','   
                          
                            <<phc_0>><span>Primary health care network:</span><</phc_0>>
                            
                            <<dmg_source=21>><span class="badge badge-pill badge-teal">NTG PCIS</span><</dmg_source=21>> 
                            <<dmg_source=22>><span class="badge badge-pill badge-teal">NTG EACS</span><</dmg_source=22>>
                            <<dmg_source=33>><span class="badge badge-pill badge-warning">LAYNHAPUY</span><</dmg_source=33>>
                            <<dmg_source=31>><span class="badge badge-pill badge-warning">MIWATJ</span><</dmg_source=31>>
                            <<dmg_source=32>><span class="badge badge-pill badge-warning">ANYINGINYI</span><</dmg_source=32>>
                            <<dmg_source=37>><span class="badge badge-pill badge-warning">CONGRESS</span><</dmg_source=37>>
                            <<dmg_source=38>><span class="badge badge-pill badge-warning">CONGRESS</span><</dmg_source=38>>
                            <<dmg_source=39>><span class="badge badge-pill badge-warning">CONGRESS</span><</dmg_source=39>>
                            <<dmg_source=41>><span class="badge badge-pill badge-warning">CONGRESS</span><</dmg_source=41>>
                            <<dmg_source=42>><span class="badge badge-pill badge-warning">CONGRESS</span><</dmg_source=42>>
                            <<dmg_source=36>><span class="badge badge-pill badge-warning">WURLI</span><</dmg_source=36>>
                            <<dmg_source=35>><span class="badge badge-pill badge-warning">KWHB</span><</dmg_source=35>>
                            <span>~~</span>
                          
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_loc_summary','dmg_vm','   
                            <<pcis_n>><span class="badge badge-pill badge-teal">NTG PCIS+<<pcis_n />>[<<pcis_ld />>]</span><</pcis_n>> 
                            <<eacs_n>><span class="badge badge-pill badge-teal">NTG EACS+<<eacs_n />>[<<eacs_ld />>]</span><</eacs_n>>
                            <<laynhapuy_n>><span class="badge badge-pill badge-warning">LAYNHAPUY+<<laynhapuy_n />>[<<laynhapuy_ld />>]</span><</laynhapuy_n>>
                            <<anyinginyi_n>><span class="badge badge-pill badge-warning">ANYINGINYI+<<anyinginyi_n />>[<<anyinginyi_ld />>]</span><</anyinginyi_n>>
                            <<miwatj_n>><span class="badge badge-pill badge-warning">MIWATJ+<<miwatj_n />>[<<miwatj_ld />>]</span><</miwatj_n>>
                            <<congress_n>><span class="badge badge-pill badge-warning">CONGRESS+<<congress_n />>[<<congress_ld />>]</span><</congress_n>>
                            <<kwhb_n>><span class="badge badge-pill badge-warning">KWHB+<<kwhb_n />>[<<kwhb_ld />>]</span><</kwhb_n>>
                            <<wurli_n>><span class="badge badge-pill badge-warning">WURLI+<<wurli_n />>[<<wurli_n />>]</span><</wurli_n>>
                            <span>~</span>
                            <<loc_def>><span class="badge badge-pill badge-warning"><<loc_def$loc_sublocality />>(<<loc_mode_n />>/<<loc_n />>)<<mode_pct />>%</span><</loc_def>>                                                        
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_hosp_summary','dmg_vm','   
                          
                            <<ipa_sep_ld>><span>~~</span><span class="badge badge-pill badge-purple">Hosp+<<ipa_sep_n />>[<<ipa_sep_ld />>]</span><</ipa_sep_ld>>
                            <<icu_ld>><span>~</span><span class="badge badge-pill badge-danger">ICU +[<<icu_ld />>]</span><</icu_ld>>
                            <<opa_sep_ld>><span>~</span><span class="badge badge-pill badge-purple">OP+<<opa_sep_n />>[<<opa_sep_ld />>]</span><</opa_sep_ld>>
                            <<preg_1y_f>><span>~</span><span class="badge badge-pill badge-info">Pregnancy+[<<preg_ld />>]</span><</preg_1y_f>>
    ');



Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('tkc_drop_zone','dmg_vm','
    <tkc_drop_zone><div class="card">
        <div class="card-body">
            ..<br /><br/>..
        </div></div></tkc_drop_zone>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_source_feedback','dmg_vm','
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
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('dmg_phc_null','dmg_vm','
    <<dmg_source=999>>
        <div class="alert alert-warning" role="alert">
            <h5> 
            <p>Record may be incomplete ! No recent primary care episodes found</p>
            </h5>
            <p>Possible Interstate client,Client of non-participating PHC, Client has not attended clinic in 3 years or Linking failure </p>
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
    <li><b>End-stage renal failure (ESRD)</b>
        <ol>
            <li>Currently on satellite haemodialysis, since <<hd_dt_min />></li>
            <<rrt_mm1=1>><li><span class="badge badge-danger">Discrepancy</span>No recent episodes. Private dialysis provider ? recovered CKD?</li><</rrt_mm1=1>>
            <<rrt_past=1>>
                <li>Past renal replacement therapies
                    <ol>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />> - <<ret_hd_post_tx />></li><</tx_dt>>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt_min />> - <<ret_hd_post_pd />></li><</pd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ol>
                </li>
            <</rrt_past=1>>
    <</rrt=1>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_hd_adequacy','rrt_hd_adequacy','
            <li>Solute clearance adequacy
                <ol>
                    <<urr>><li>URR <<urr />> spKT/V <<spktv />> (<<post_u_dt />>) <<err_urr_flag>>Sampling error ?<</err_urr_flag>></li><</urr>>
                    <<low_urr_flag>><li><b>Persistently low adequacy target</b></li><</low_urr_flag>>
                </ol>
            </li>
');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_1_metrics','rrt_1_metrics','
        <li>Dialysis attendance metrics
        <ol>
            <<loc_fixed>><li><<loc_def$loc_sublocality />> (sessions=<<loc_1_n />>)</li><</loc_fixed>>
            <<tspan_y>><li>Dialysis vintage <<tspan_y />> years</li><</tspan_y>>
            <li>Thrice weekly target achievement <<hd_oe />>% </li>
        </ol>
        </li>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_hd_param','rrt_hd_param','
    <li>Haemodialysis prescription
        <ol>
            <<mode_val=10>><li>High Flux haemodialysis</li><</mode_val=10>>
            <<mode_val=20>><li>Haemodialfitration (post dilutional)</li><</mode_val=20>>
            <<mode_val=22>><li>Haemodialfitration (mixed dilutional</li>)<</mode_val=22>>
            <<hours_val>><li>Hours : <<hours_val />></li><</hours_val>>
            <<dx_val>><li>Dialyzer : <<dx_val />></li><</dx_val>>
            <<ibw_val>><li>IBW : <<ibw_val />> kg</li><</ibw_val>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_hd_acc_iv','rrt_hd_acc_iv','
            <li>Vascular access
                <ol>
                    <<avf_dt>><li><b>AVF</b> date <<avf_dt />></li><</avf_dt>>
                    <<acc_detail>><li>
                        <<acc_side_val=1>>Left<</acc_side_val=1>>
                        <<acc_side_val=2>>Right<</acc_side_val=2>>
                        <<acc_type_val=1>>-Radio-cephalic AVF<</acc_type_val=1>>
                        <<acc_type_val=2>>-Brachio-cephalic AVF<</acc_type_val=2>>
                        <<acc_type_val=3>>-Brachio-basilic AVF<</acc_type_val=3>>
                        <<acc_type_val=4>>-sided AVF<</acc_type_val=4>>
                    </li><</acc_detail>>
                    <<av_us_ld>><li>Last US fistulogram <<av_us_ld />></li><</av_us_ld>>
                    <<av_gram_ld>><li>Last DSA fistulogram <<av_gram_ld />></li><</av_gram_ld>>
                    <<av_plasty_ld>><li>DSA fistuloplasty [<<av_plasty_ld />>-<<av_plasty_fd />>][<<av_plasty_n />>]</li><</av_plasty_ld>>
                    <<av_plasty_ld>><li>
                        <<iv_periodicity=99>>Periodicity cannot be determined<</iv_periodicity=99>>
                        <<iv_periodicity=3>>Periodicity 3 monthly<</iv_periodicity=3>>
                        <<iv_periodicity=6>>Periodicity 6 monthly<</iv_periodicity=6>>
                        <<iv_periodicity=12>>Periodicity yearly<</iv_periodicity=12>>                
                    </li><</av_plasty_ld>>
                </ol>
            </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_2_syn','rrt','
    <<rrt=2>>
    <li><b>End-stage renal failure (ESRD)</b>
        <ol>
            <li>Currently on peritoneal dialysis, since <<pd_dt_min />></li>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ol>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />></li><</tx_dt>>
                        <<hd_dt>><li>Past haemo dialysis <<hd_dt />></li><</hd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ol>
            <</rrt_past=1>>
    <</rrt=2>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_3_syn','rrt','
    <<rrt=3>>
    <li><b><div >Renal transplant due to (ESRD)</div></b>
        <ol>
            <<tx_multi_current>><li>Multiparity detected</li><</tx_multi_current>>
            <<tx_multi_current=0>><li>Functioning allograft, since <<tx_dt />></li><</tx_multi_current=0>>
            <<tx_multi_current=1>><li>Functioning allograft, since <<tx_multi_fd />></li><</tx_multi_current=1>>
            <<tx_multi_current=1>><li>First graft <<tx_dt />></li><</tx_multi_current=1>>
            <<rrt_past=1>>
                <li>Past renal replacement therapies
                    <ol>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt />></li><</pd_dt>>
                        <<hd_dt>><li>Past haemo dialysis <<hd_dt />></li><</hd_dt>>
                        <<homedx_dt>><li>Home haemo dialysis <<homedx_dt />></li><</homedx_dt>>
                    </ol>
                </li>
            <</rrt_past=1>>
    <</rrt=3>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_4_syn','rrt','
    <<rrt=4>>
    <li><b>End-stage renal failure (ESRD)</b>
        <ol>
            <li>Currently on home or community dialysis, since <<homedx_dt />></li>
            <<rrt_past=1>>
                <li>Past renal replacement therapies</li>
                    <ol>
                        <<pd_dt>><li>Past peritoneal dialysis <<pd_dt />></li><</pd_dt>>
                        <<hd_dt>><li>Past haemo dialysis <<hd_dt />></li><</hd_dt>>
                        <<tx_dt>><li>Past failed renal transplant <<tx_dt />></li><</tx_dt>>
                    </ol>
            <</rrt_past=1>>
    <</rrt=4>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_3_metric','rrt_tx','
            <<cr_min_dt>><li>Best graft function creatinine <<cr_min_val />> on <<cr_min_dt />></li><</cr_min_dt>> 
            <<cr_last_dt>><li>Last recorded creatinine <<cr_last_val />> on <<cr_last_dt />></li><</cr_last_dt>>
            <<enc_op_ld>><li>Last transplant clinic <<enc_op_ld />></li><</enc_op_ld>>
            <<rxn>>
            <li>Immunosuppressant regimen
                <ol>
                    <<rx_h02ab>><li>Corticosteroid <<rx_h02ab />></li><</rx_h02ab>>
                    <<rx_l04ad>>
                        <li>Calcineurin inhibitor <<rx_l04ad />>
                        <ol>
                            <<tac>><li>Tacrolimus C0 <<tdm_tac_val />>(<<tdm_tac_dt />>)</li><</tac>>
                        </ol>
                    </li><</rx_l04ad>>
                    <<rx_l04aa>><li>Antimetabolite or MTOR class agent <<rx_l04aa />></li><</rx_l04aa>>
                    <<rx_l04ax>><li>L04AX class agent <<rx_l04ax />></li><</rx_l04ax>>
                </ol>
            </li>
            <</rxn>>
    ');
    Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_cause_syn_1','ckd_cause','
       <<esrd=1>>
         <li>Aetiology
         <ol>
                <<aet_multiple=1>><li>Multiple aetiology is suggested
                <ol>
                    <<aet_dm=1>><li>Diabetes mellitus</li><</aet_dm=1>>
                    <<aet_htn=1>><li>Hypertension</li><</aet_htn=1>>
                    <<aet_gn_ln=1>><li>Lupus nephritis</li><</aet_gn_ln=1>>
                    <<aet_gn_x=1>><li>Glomerulopathy NOS</li><</aet_gn_x=1>>
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
                    <<c_q63>><li>Other congenital malformations of kidney<<c_q63 />></li><</c_q63>>
                    <<c_q64>><li>Other congenital malformations of urinary system<<c_q64 />></li><</c_q64>>
                    <<c_c64>><li>Renal cell carcinoma<<c_c64 />></li><</c_c64>>
                </ol></li>
                <</aet_multiple=1>>
                <<aet_multiple=0>>
                    <li>
                        Potential cause for CKD is <strong><<aet_dm>>diabetic kidney disease (DKD)<</aet_dm>>
                        <<aet_htn>>,hypertensive kidney disease<</aet_htn>><<aet_gn_ln>>,lupus nephritis<</aet_gn_ln>></strong>
                    </li>
                <</aet_multiple=0>>
            </ol>
            </li>
    <</esrd=1>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_anaemia','ckd_anaemia','
    <<esrd=1>>
        <li>Anaemia management
            <ol>
                <<hb_val>><li>Last Hb <<hb_val />> (<<hb_dt />>)
                    <ol>
                        <<hb_state=2>><li>Severe anaemia</li><</hb_state=2>>
                        <<hb_state=3>><li>Moderate anaemia</li><</hb_state=3>>
                        <<hb_state=4>><li>Acceptable range</li><</hb_state=4>>
                        <<hb_cum_qt=0>><li>Steady over 60 days</li><</hb_cum_qt=0>>
                        <<hb_cum_qt=1>><li>Sustained increase more than 20%</li><</hb_cum_qt=1>>
                        <<hb_cum_qt=2>><li>Sustained increase more than 10%</li><</hb_cum_qt=2>>
                        <<hb_cum_qt=3>><li>Sustained decrease more than 10%</li><</hb_cum_qt=3>>
                        <<hb_cum_qt=4>><li>Sustained decrease more than 20%</li><</hb_cum_qt=4>>
                        
                    </ol>
                </li><</hb_val>>
                <<fe_status_null=1>><li>Iron status unknown</li><</fe_status_null=1>>
                <<fe_status_null=0>><li>Iron stores<</fe_status_null=0>>
                    <<fe_status_null=0>><ol><</fe_status_null=0>>
                        <<fe_status_null=0>><li><<fer_val>>Ferritin <<fer_val />> (<<fer_dt />>)<</fer_val>><<tsat1_val>>TSAT <<tsat1_val />>% (<<tsat1_dt />>)<</tsat1_val>></li><</fe_status_null=0>>
                        <<fe_low=1>><li><b>Low iron stores</b></li><</fe_low=1>>
                        <<hyper_ferr=1>><li>Hyperferritinaemia</li><</hyper_ferr=1>>
                        <<hyper_ferr=1>><<crp_val>><li>CRP <<crp_val />></li><</crp_val>><</hyper_ferr=1>>
                    <<fe_status_null=0>></ol><</fe_status_null=0>>
                <<fe_status_null=0>></li><</fe_status_null=0>>
                <<esa_state=0>><li>No ESA use</li><</esa_state=0>>
                <<esa_state=1>><li>Current ESA use</li><</esa_state=1>>
                <<esa_state=2>><li>Past ESA use but not current</li><</esa_state=2>>
            </ol>
        </li>
    <</esrd=1>>
');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_anaemia_narrative','ckd_anaemia','
    <<esrd=1>>
        <p>Haemoglobin is <<hb_val />> g/L (<<hb_dt />>) which is 
        <<hb_state=2>>consistent with severe anaemia.<</hb_state=2>>
        <<hb_state=3>>consistent with moderate anaemia.<</hb_state=3>>
        <<hb_state=4>>in the acceptable range.<</hb_state=4>>
        <<hb_cum_qt=0>>The Hb has been steady over the last 60 days.<</hb_cum_qt=0>>
        <<hb_cum_qt=1>>a sustained increase more than 20%.<</hb_cum_qt=1>>
        <<hb_cum_qt=2>>a sustained increase more than 10%.<</hb_cum_qt=2>>
        <<hb_cum_qt=3>>a sustained decrease more than 10%.<</hb_cum_qt=3>>
        <<hb_cum_qt=4>>a sustained decrease more than 20%.<</hb_cum_qt=4>>
        <<fe_status_null=1>>Iron status unknown.<</fe_status_null=1>>
        <<fe_status_null=0>>Iron studies show <</fe_status_null=0>>            
        <<fe_status_null=0>><<fer_val>>a Ferritin of <<fer_val />> (<<fer_dt />>)<</fer_val>><<tsat1_val>>and a TSAT of <<tsat1_val />>% (<<tsat1_dt />>)<</tsat1_val>><</fe_status_null=0>>
        <<fe_low=1>><b> indicative of low iron stores.</b><</fe_low=1>>
        <<hyper_ferr=1>> indicative of hyperferritinaemia<</hyper_ferr=1>>
        <<hyper_ferr=1>><<crp_val>> CRP is <<crp_val />><</crp_val>>.<</hyper_ferr=1>>
    <</esrd=1>>
');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_shpt','ckd_shpt','
    <<esrd=1>>
        <li>Bone mineral disease management
            <ol>
                <li>PTH <<pth1_val />> (<<pth1_dt />>)</li>
                <<calcium1_val>><li>Calcium <<calcium1_val />> mmol/l (<<calcium1_dt />>)</li><</calcium1_val>>
                <<phos1_val>><li>Phosphate <<phos1_val />> mmol/l (<<phos1_dt />>)</li><</phos1_val>>
                <<cinacalcet_ld>><li>Cinacalcet last scripted <<cinacalcet_ld />></li><</cinacalcet_ld>>
                <<calcitriol_ld>><li>Calcitriol last scripted <<calcitriol_ld />></li><</calcitriol_ld>>
            </ol>
        </li>
    <</esrd=1>>
');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_shpt_narrative','ckd_shpt','
    <<esrd=1>>
        <<calcium1_val>>Serum calcium is <<calcium1_val />> mmol/l (<<calcium1_dt />>)</li><</calcium1_val>>
        <<phos1_val>>, phosphate is <<phos1_val />> mmol/l (<<phos1_dt />>)<</phos1_val>>
        <<pth1_val>>and PTH is <<pth1_val />> pg/ml (<<pth1_dt />>).<</pth1_val>>
        <<cinacalcet_ld>>Cinacalcet last scripted <<cinacalcet_ld />><</cinacalcet_ld>>
        <<calcitriol_ld>>Calcitriol last scripted <<calcitriol_ld />><</calcitriol_ld>>
        </p>
    <</esrd=1>>
');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_x_syn_end','rrt','
    </ol>
    </li>
');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_syn_end','ckd','</ol></li>');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_syn_1','ckd','
        <<ckd_stage_val=1>><li><b><div snomed-id="431855005">CKD stage 1</div></b><</ckd_stage_val=1>>
        <<ckd_stage_val=2>><li><b><div snomed-id="431856006">CKD stage 2</div></b><</ckd_stage_val=2>>
        <<ckd_stage_val=3>><li><b><div snomed-id="700378005">CKD stage 3a</div></b><</ckd_stage_val=3>>
        <<ckd_stage_val=4>><li><b><div snomed-id="700379002">CKD stage 3b</div></b><</ckd_stage_val=4>>
        <<ckd_stage_val=5>><li><b><div snomed-id="431857002">CKD stage 4</div></b><</ckd_stage_val=5>>
        <<ckd_stage_val=6>><li><b><div snomed-id="433146000">CKD stage 5</div></b><</ckd_stage_val=6>>
        <<mm1>>?<</mm1>><<mm2>>*<</mm2>>
        <ol>
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
            <<is_pcis=1>><ol><<cp_mis>><li>existing care plan may not be adequate [1.8]</li><</cp_mis>></ol><</is_pcis=1>>
            </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_cause_syn_1','ckd_cause','
        <<esrd=0>>
        <li>Aetiology
            <ol>
                <li>Potential cause for CKD
                <ol>
                    <<aet_dm=1>><li>Diabetes mellitus</li><</aet_dm=1>>
                    <<aet_htn=1>><li>Hypertension</li><</aet_htn=1>>
                    <<aet_gn_ln=1>><li>Lupus nephritis</li><</aet_gn_ln=1>>
                    <<aet_gn=1>><li>Glomerulopathy NOS</li><</aet_gn=1>>
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
                    <<c_n30_n39>><li>Other diseases of the urinary system including bladder dysfunction <<c_n30_n39 />></li><</c_n30_n39>>
                    <<c_n40>><li>Benign prostatic hyperplasia <<c_n40 />></li><</c_n40>>
                    <<c_q60>><li>Renal agenesis and other reduction defects of kidney <<c_q60 />></li><</c_q60>>
                    <<c_q61>><li>Cystic kidney disease <<c_q61 />></li><</c_q61>>
                    <<c_q62>><li>Congenital obstructive defects of renal pelvis and congenital malformations of ureter <<c_q62 />></li><</c_q62>>
                    <<c_q63>><li>Other congenital malformations of kidney <<c_q63 />></li><</c_q63>>
                    <<c_q64>><li>Other congenital malformations of urinary system <<c_q64 />></li><</c_q64>>
                    <<c_c64>><li>Renal cell cancer <<c_c64 />></li><</c_c64>>
                    <<c_z90_5>><li>Complete or partial nephrectomy (Acquired single kidney) <<c_z90_5 />></li><</c_z90_5>>
                </ol>
                </li>
            </ol>
        </li>
        <</esrd=0>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_cause_nephrectomy','ckd_cause','
    <<c_z90_5>>
        <br />
        <ol>
            <li><b>Nephrectomy</b>
            <ol>
                <li>First procedure <<c_z90_5 />></li>
            </ol>
            </li>
        </ol>
    <</c_z90_5>>
        
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_journey_1','ckd_journey','
    <ol>
        <li>Renal services engagement
        <ol>
            <<enc_multi=0>><<enc_ld>><li>Nephrologist reviews <<enc_ld />></li><</enc_ld>><</enc_multi=0>>
            <<enc_multi>><<enc_fd>><li>Nephrologist reviews: \t<<enc_fd />>-<<enc_ld />> [<<enc_n />>]</li><</enc_fd>><</enc_multi>>
            <<edu_init>><li>CKD Education (initial): \t<<edu_init />></li><</edu_init>>
            <<edu_rv>><li>CKD Education review (last): \t<<edu_rv />></li><</edu_rv>>
            <<dietn>><li>Renal Dietician review (last): \t<<dietn />></li><</dietn>>
            <<sw>><li>Renal social work review (last): \t<<sw />></li><</sw>>
            <<avf_ld>><li>CKD Access (AVF) formation date: \t\t<<avf_ld />></li><</avf_ld>>
        </ol></li>
    </ol>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_dx_1','ckd_diagnostics','
    
        <li>Diagnostic workup
        <<canddt_gn_wu=1>>
        <ol>
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
            <<usk_null=1>><li>Renal imaging not found</li><</usk_null=1>>
            <<ris_usk_ld>><li>Most recent ultrasound kidney on <<ris_usk_ld />></li><</ris_usk_ld>>
            <<ris_ctab_ld>><li>Most recent CT Abdomen on <<ris_ctab_ld />></li><</ris_ctab_ld>>
            <<ris_bxk_ld>><li>Kidney biopsy on <<ris_bxk_ld />></li><</ris_bxk_ld>>
        </ol>
        </li>
        <</canddt_gn_wu=1>>
    
    ');


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_ckd_compx_1','ckd_complications','
    <ol>
        <li>CKD Complications
        <ol>
            <li>Haemopoetic function
            <ol>
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
                    <ol>
                        <<fer_val>><li>Ferritin <<fer_val />>(<<fer_dt />>)</li><</fer_val>>
                    </ol>
                <</iron_low>>
            </ol>
            </li>
            <li>Acid-base balance
            <ol>
                <<hco3_low>><li>low tCO2 at <<hco3_val />> mmol/l (<<hco3_dt />>) likely due to metabolic acidosis</li><</hco3_low>>
            </ol>
            </li>
        </ol>
        </li>
    </ol>
    ');

    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_end','cd_dm_dx','
    </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_1','cd_dm_dx','
    <br />
        <<dm_type=1>><li><b><div snomed-id="46635009">Diabetes Mellitus Type 1</div></b> <<dm1_mm>> ? <</dm1_mm>><</dm_type=1>>
        <<dm_type=2>><li><b><div snomed-id="44054006">Diabetes Mellitus Type 2</div></b> <<dm2_mm_1>> ? <</dm2_mm_1>><<dm2_mm_2>> ? <</dm2_mm_2>><<dm2_mm_3>> ? <</dm2_mm_3>><<dm2_mm_4>> ? <</dm2_mm_4>><</dm_type=2>>
        <ol>
            <<dm2_mm_3>><li>Dm2 codes predate pre-diabetes</li> <</dm2_mm_3>>
            <<dm2_mm_4>><li>Codes suggestive of non type 1 or non-type 2</li> <</dm2_mm_4>>
            <<dm_mixed>><li>coded as type 1? on <<dm1_fd />></li><</dm_mixed>>
            <<dm_fd_year>><li>since <<dm_fd_year />></li><</dm_fd_year>>
            <<dm_dx_uncoded>><li>not coded on primary care EHR</li><</dm_dx_uncoded>>
            <<cd_dm_dx_code=110000>><li>based only on hospital records on <<dm_icd_fd />></li><</cd_dm_dx_code=110000>>
            <<cd_dm_dx_code=101110>><li>based on primary EHR, lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=101110>>
            <<cd_dm_dx_code=111110>><li>based on hospital and primary EHR, lab tests and presence of medication <<dm_icpc_fd />></li><</cd_dm_dx_code=111110>>
            <<cd_dm_dx_code=100000>><li>based on a single HbA1c of <<gluc_hba1c_high_f_val />> on <<gluc_hba1c_high_f_dt />></li><</cd_dm_dx_code=100000>>
        
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_2','cd_dm_comp','
            <li>Diabetic complications 
                <ol>
                    
                        <<ndr_icd_e31>><li>Background retinopathy <<ndr_icd_e31 />></li><</ndr_icd_e31>>
                                <<ndr_icd_e32>><li>Mild non-proliferative retinopathy <<ndr_icd_e32 />></li><</ndr_icd_e32>>
                                <<ndr_icd_e33>><li>Moderate non-proliferative retinopathy <<ndr_icd_e33 />></li><</ndr_icd_e33>>
                                <<ndr_icd_e34>><li>Severe non-proliferative retinopathy <<ndr_icd_e34 />></li><</ndr_icd_e34>>
                                <<pdr_icd_e35>><li>Severe non-proliferative retinopathy <<pdr_icd_e35 />></li><</pdr_icd_e35>>
                    
                    <<dm_micvas_neuro>><li>Diabetic neuropathy (<<dm_micvas_neuro />>)</li><</dm_micvas_neuro>>
                    <<dm_foot_ulc>><li>Diabetic foot ulcer (<<dm_foot_ulc />>)</li><</dm_foot_ulc>>
                    <<dm_dka>><li>Diabetic ketoacidosis <<dka_ld />></li><</dm_dka>>
                </ol>                
            </li>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_3','cd_dm_glyc_cntrl','
        <li>Glycaemic control
        <ol>
            <<hba1c_n_tot>><li>Last recorded HbA1c (NGSP) is <<hba1c_n0_val />> % (<<hba1c_n0_dt />>)</li><</hba1c_n_tot>>
            <<hba1c_max_val>><li>Maximum HbA1c (NGSP) is <<hba1c_max_val />> % (<<hba1c_max_dt />>)</li><</hba1c_max_val>>
            <<n_opt_qt>><li>Time in range <<n_opt_qt />> % in the last 2 years </li><</n_opt_qt>>
        </ol>
        </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_4','cd_dm_dx','
    <<dm_rxn=0>>
                <li>No medications recorded</li>
    <</dm_rxn=0>>
    <<dm_rxn>>
                <li>Current medication classes
                <ol>
                    <<dm_rxn_su>><li>sulphonylurea (<<dm_rxn_su />>)</li><</dm_rxn_su>>
                    <<dm_rxn_bg>><li>biguanide (<<dm_rxn_bg />>)</li><</dm_rxn_bg>>
                    <<dm_rxn_ins_long>><li>long-acting insulin (<<dm_rxn_ins_long />>)</li><</dm_rxn_ins_long>>
                    <<dm_rxn_ins_int>><li>Intermediate-acting insulin (<<dm_rxn_ins_int />>)</li><</dm_rxn_ins_int>>
                    <<dm_rxn_ins_mix>><li>Mixed insulin (<<dm_rxn_ins_mix />>)</li><</dm_rxn_ins_mix>>
                    <<dm_rxn_ins_short>><li>short-acting insulin (<<dm_rxn_ins_short />>)</li><</dm_rxn_ins_short>>
                    <<dm_rxn_glp1>><li>GLP1 analogue (<<dm_rxn_glp1 />>)</li><</dm_rxn_glp1>>
                    <<dm_rxn_dpp4>><li>DPP4 inhibitor (<<dm_rxn_dpp4 />>)</li><</dm_rxn_dpp4>>
                    <<dm_rxn_sglt2>><li>SGLT2 inhibitor (<<dm_rxn_sglt2 />>)</li><</dm_rxn_sglt2>>
                </ol>
                </li>
    <</dm_rxn>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dm_syn_5','cd_dm_mx','
    <<cp_dm=0>>
              <li>PCIS diabetes careplan was not detected [2.4]</li>
    <</cp_dm=0>>
    <<cp_dm>>

            <li>PCIS diabetes careplan was updated on <<cp_dm_ld />></li>
    <</cp_dm>>
    <<rv_edu_ld>><li>Last Diabetic educator review <<rv_edu_ld />></li><</rv_edu_ld>>
    <<rv_pod_ld>><li>Last Podiatry review <<rv_pod_ld />></li><</rv_pod_ld>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_obesity','cd_obesity','
    <br />
    <li><b>Obesity</b>
        <ol>
            <li>obesity class <<bmi_class />>: BMI <<bmi />> kg/m2 (<<wt_dt />>)</li>
        </ol>
    </li>
    ');
    

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_htn_syn_1','cd_htn','
    <br />
        <li><b><div snomed-id="38341003">Hypertension</div></b>
        <ol>
            <li><<htn_icpc>>Diagnosed<</htn_icpc>> Hypertension <<htn_from_obs>> from observations <</htn_from_obs>> <<htn_fd_yr>> since <</htn_fd_yr>><<htn_fd_yr />></li>
            <<sbp_outdated=1>><li>No readings within last two years</li><</sbp_outdated=1>>
            <li><<htn_rxn>>Current antihypertensive classes<</htn_rxn>>
            <ol>
                <<htn_rxn_arb>><li>Angiotensin receptor blocker (ARB)</li><</htn_rxn_arb>>
                <<htn_rxn_acei>><li>ACE inhibitor</li><</htn_rxn_acei>>
                <<htn_rxn_ccb>><li>Calcium channel blocker (CCB)</li><</htn_rxn_ccb>>
                <<htn_rxn_bb>><li>Beta blocker</li><</htn_rxn_bb>>
                <<htn_rxn_diuretic_thiazide>><li>Thiazide diuretic</li><</htn_rxn_diuretic_thiazide>>
                <<htn_rxn_diuretic_loop>><li>Loop diuretic</li><</htn_rxn_diuretic_loop>>
            </ol>
            </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_htn_bp_control','cd_htn_bp_control','
        <li>BP control
        <ol>
            <li>Recommended target <<sbp_target_max />>/<<dbp_target_max />> mmHg or less</li>
            <li>Average BP <<sbp_mu_1 />>/<<dbp_mu_1 />> (<<sbp_min />>-<<sbp_max />>) mmHg </li>
            <li>Time in range <<sbp_tir_1y />>%</li>
        </ol>
        </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_htn_syn_end','cd_htn','
        </ol>
        </li>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_cad_syn','cd_cardiac_cad','
            <br />
            <li><b><div snomed-id="53741008">Coronary artery disease</div></b>
                <ol>
                    <<cabg>><li>Coronary artery bypass grafting <<cabg />></li><</cabg>>
                    <<ami_icd_null>><li>No recorded myocardial infarction in hospital</li><</ami_icd_null>>
                    <<stemi_fd>><li>First STEMI <<stemi_fd />><</stemi_fd>>
                        <<stemi_fd>><ol><</stemi_fd>>
                            <<stemi_anat=1>><li>LMS or LAD territory</li><</stemi_anat=1>>
                            <<stemi_anat=2>><li>RCA territory</li><</stemi_anat=2>>
                            <<stemi_anat=3>><li>Left circumflex territory</li><</stemi_anat=3>>
                            <<stemi_anat=4>><li>territory not specified</li><</stemi_anat=4>>
                        <<stemi_fd>></ol></li><</stemi_fd>>
                    <<stemi_ld>><li>Most recent STEMI <<stemi_ld />></li><</stemi_ld>>
                    
                    <<nstemi_fd>><li>First NSTEMI <<nstemi_fd />></li><</nstemi_fd>>
                    <<nstemi_ld>><li>Most recent NSTEMI <<nstemi_ld />></li><</nstemi_ld>>
                    <<rxn>><li>relevant medication<</rxn>> 
                                <<rxn>><ol><</rxn>>
                                    <<rxn_ap>><li>Anti-platelet agent(s) <<rxn_ap />> </li><</rxn_ap>>
                                    <<rxn_bb>><li>Betablocker <<rxn_bb />> </li><</rxn_bb>>
                                    <<rxn_raas>><li>ACEi or ARB <<rxn_raas />> </li><</rxn_raas>>
                                    <<rxn_statin>><li>Statin <<rxn_statin />> </li><</rxn_statin>>
                                <<rxn>></ol><</rxn>>
                    <<rxn>></li><</rxn>>
                    <<echo_ld>><li>Last Echocardiogram <<echo_ld />></li><</echo_ld>>
                    <<cardang_ld>><li>Cardiac angiogram <<cardang_ld />></li><</cardang_ld>>
                    
                    </ol>
            </li>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cvra_banner_1','cm_vm','
    <div class="card">
      <div class="card-body">
      
        <<vax_max_dt>><span><img src="https://www.durham.ca/en/health-and-wellness/resources/Images/Eligibility-Icon.png" alt="COVID vax" width="60" height="60"></span><</vax_max_dt>>
        <<vax_pf>><span>---~</span><span class="badge badge-pill badge-success">Pfizer</span><</vax_pf>>
        <<vax_az>><span>---~</span><span class="badge badge-pill badge-success">Aztrazenaca</span><</vax_az>>
        <<vax_md>><span>---~</span><span class="badge badge-pill badge-success">Moderna</span><</vax_md>>
        <<vax_max_dt>><span>~</span><span class="badge badge-pill badge-success"><<vax_max_dt />></span><</vax_max_dt>>
        <<vax_max_val>><span>~</span><span class="badge badge-pill badge-success"><<vax_max_val />></span><</vax_max_val>>
        
        <<cmcat_charlson=1>><span>~~</span><span class="badge badge-pill badge-success">Charlson cmi ~ <<cmidx_charlson />> </span><</cmcat_charlson=1>>
        <<cmcat_charlson=2>><span>~~</span><span class="badge badge-pill badge-warning">Charlson cmi ~ <<cmidx_charlson />> </span><</cmcat_charlson=2>>
        <<cmcat_charlson=3>><span>~~</span><span class="badge badge-pill badge-danger">Charlson cmi ~ <<cmidx_charlson />> </span><</cmcat_charlson=3>>
        
        <<cvra_cat=2>><span>~</span><span class="badge badge-pill badge-warning">Mod CVR</span><</cvra_cat=2>>
        <<cvra_cat=3>><span>~</span><span class="badge badge-pill badge-danger">High CVR</span><</cvra_cat=3>>
        
        <<dm=1>><span>~</span><span class="badge badge-pill badge-danger">DM</span><</dm=1>>
        <<esrd_risk=1>><span>~</span><span class="badge badge-pill badge-success">ESRD Risk 1</span><</esrd_risk=1>>
        <<esrd_risk=2>><span>~</span><span class="badge badge-pill badge-warning">ESRD Risk 2</span><</esrd_risk=2>>
        <<esrd_risk=3>><span>~</span><span class="badge badge-pill badge-danger">ESRD Risk 3</span><</esrd_risk=3>>
        <<esrd_risk=4>><span>~</span><span class="badge badge-pill badge-danger">ESRD Risk 4</span><</esrd_risk=4>>
        <<cad>><span>~</span><span class="badge badge-pill badge-danger">CAD</span><</cad>>
        <<rrt_flag>><span>~</span><span class="badge badge-pill badge-danger">ESRD~RRT</span><</rrt_flag>>
        
        
        
      </div>
    </div>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_vhd_syn','cd_cardiac_vhd','
           <br />
            <<vhd>><li><b>Valvular heart disease</b>
            <ol>
                <<vhd_ie_icd>><li>Infective endocarditis <<vhd_ie_icd />></li><</vhd_ie_icd>>
                <<vhd_icpc>><li>Valvular disease NOS<<vhd_icpc />></li><</vhd_icpc>>
                <<rhd_aet>><li>Likely due to <b>rheumatic</b> heart disease</li><</rhd_aet>>
                <<car_enc_l_dt>><li>Last outpatient encounter <<car_enc_l_dt />></li><</car_enc_l_dt>>

                <<mv>><li>Mitral valve involvement
                <ol>
                    <<mv_s>><li>Mitral stenosis <<mv_s_dt />></li><</mv_s>>
                    <<mv_i>><li>Mitral regurgitation <<mv_i_dt />></li><</mv_i>>
                    <<mv_r>><li>Mitral replacement <<mv_r_dt />></li><</mv_r>>
                </ol></li><</mv>>
                <<av>><li>Aortic valve involvement
                <ol>
                    <<av_s>><li>Aortic stenosis <<av_s_dt />></li><</av_s>>
                    <<av_i>><li>Aortic regurgitation <<av_i_dt />></li><</av_i>>
                    <<av_r>><li>Aortic replacement <<av_r_dt />></li><</av_r>>
                </ol></li><</av>>
                <<tv>><li>Tricuspid valve involvement
                <ol>
                    <<tv_s>><li>Tricuspid stenosis <<tv_s_dt />></li><</tv_s>>
                    <<tv_i>><li>Tricuspid regurgitation <<tv_i_dt />></li><</tv_i>>
                    <<tv_r>><li>Tricuspid replacement <<tv_r_dt />></li><</tv_r>>
                </ol></li><</tv>>
                <<rxn_anticoag>><li>On anticoagulation </li><</rxn_anticoag>>
                <<echo_ld>><li>Last Echocardiogram <<echo_ld />></li><</echo_ld>>
            </ol>
            <</vhd>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_chf_syn','cd_cardiac_chf','
        <br />
        <<chf>><li><b>Congestive heart failure</b>
            <<dcm>><ol><li>Dilated cardiomyopathy <<dcm />></li></ol><</dcm>>
            <<hocm>><ol><li>Hypertrophic obstructive cardiomyopathy <<hocm />></li></ol><</hocm>>
            <<rcm>><ol><li>Restrictive cardiomyopathy <<rcm />></li></ol><</rcm>>
            <<ethocm>><ol><li>Alcohol related cardiomyopathy <<ethocm />></li></ol><</ethocm>>
            <<noscm>><ol><li>Cardiomyopathy NOS <<noscm />></li></ol><</noscm>>
            <<echo_ld>><ol><li>Last Echocardiogram <<echo_ld />></li></ol><</echo_ld>>
            
            </li>
        <</chf>>   
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_rhd','cd_cardiac_rhd','
        <br />
        <li><b>Rheumatic heart disease</b>
            <ol>
                <li>Diagnosed <<rhd_dt />></li>
                <<echo_ld>><li>Last Echocardiogram <<echo_ld />></li><</echo_ld>>
            </ol>
        </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_af','cd_cardiac_af','
    <br />
        <b><li>Atrial fibrillation</b>
        <ol>
            <li>Diagnosed <<af_dt />></li>
            <<vhd=0>><li>Non-valvular AF</li><</vhd=0>>
            <<vhd=1>><li>Valvular AF</li><</vhd=1>>
            <<cha2ds2vasc>><li>CHA2DS2VASC score  : <<cha2ds2vasc />></li><</cha2ds2vasc>>
            <<rxn_anticoag>><li>Anticoagulation <<rxn_anticoag_dt />></li><</rxn_anticoag>>
            <<rxn_anticoag=0>><li>Not on anticoagulation </li><</rxn_anticoag=0>>
            <<echo_ld>><li>Last Echocardiogram <<echo_ld />></li><</echo_ld>>
        </ol>
        </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_device','cd_cardiac_device','
    <br />
        <b><li>Implanted cardiac device</b>
        <ol>
            <<ppm_fd>><li>Pacemaker <<ppm_fd />></li><</ppm_fd>>
            <<defib_fd>><li>Defibrilator <<defib_fd />></li><</defib_fd>>
        </ol>
        </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_dyslip','cd_dyslip','
    <br />
    <b><li>Dyslipidaemia</b>
        <ol>
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
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cva_syn','cd_cva','
    <br />
        <li><b>Cerebrovascular disease</b>
        <ol>
            <<cva_infarct_dt>><li>cerebral infarct <<cva_infarct_dt />></li><</cva_infarct_dt>>
            <<cva_hmrage_dt>><li>subarachnoid or intracerebral haemorrhage <<cva_hmrage_dt />></li><</cva_hmrage_dt>>
            <<cva_nos_dt>><li>Stroke <<cva_nos_dt />></li><</cva_nos_dt>>
        </ol> 
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cns','cd_cns','
    <br />
        <<md>><b><li>Mood disorder</b>
        <ol>
            <li>Diagnosed (<<code_md_dt />>) and medicated</li>
        </ol></li>
        <</md>>
        <<schiz>><b><li>Psychotic disorder</b>
        <ol>
            <<code_shiz_dt>><li>Diagnosed (<<code_shiz_dt />>) and medicated</li><</code_shiz_dt>>
            <<rx_n05a_dt>><li>medicated for ?</li><</rx_n05a_dt>>
        </ol></li>
        <</schiz>>
        <<epil>><b><li>Seizure disorder</b>
        <ol>
            <<code_epil_dt>><li>Diagnosed (<<code_epil_dt />>) and medicated</li><</code_epil_dt>>
            <<rx_n03_dt>><li>Medicated for (<<rx_n03_dt />>)</li><</rx_n03_dt>>
        </ol></li>
        <</epil>>
        <<pd>><b><li>Parkinson disease</b>
        <ol>
            <li>Diagnosed (<<code_pd_dt />>) and medicated</li>
        </ol></li>
        <</pd>>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_haem','cd_haem','
    <br />
        <<low_cat=3>><b><li>Pancytopaenia</b><</low_cat=3>>
        <<low_cat=2>><b><li>Bicytopaenia</b><</low_cat=2>>
        <<low_cat=1>><b><li>Monocytopaenia</b><</low_cat=1>>
        <<low_cat>>
            <ul>
            <<hb_low=1>>
                <b><li>Anaemia</b>
                <ol>
                    <li>Last Haemoglobin <<hb1_val />> g/L (<<hb1_dt />>)</li>
                </ol>
                </li>
            <</hb_low=1>>
            <<plt_low=1>>
                <b><li>Thrombocytopaenia</b>
                <ol>
                    <li>Last Platelet count <<plt_val />> x10^6/ml (<<plt_dt />>)</li>
                </ol>
                </li>
            <</plt_low=1>>
            <<wcc_low=1>>
                <b><li>Neutropaenia</b>
                <ol>
                    <li>Last Neutrophil count <<wcc_val />> x10^6/ml (<<wcc_dt />>)</li>
                </ol>
                </li>
            <</wcc_low=1>>
            </ul>
            </li>
        <</low_cat>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rx_syn_1','rx_desc','
    <hr/> 
    <br />
    <div class="syn_synopsis_box">
    <h3>Medications</h3>
    <ul>
        <<rx_name_obj$rx_name_obj />>
    </ul>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rx_syn_2','rx_desc_ptr','
    <hr/> 
    <br />
    <div>
    <h3>Medications</h3>
    <ul>
        <<rx_name_obj$rx_name_obj2 />>
    </ul>
    </div>

    ');
    

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('graph_egfr2','egfr_graph2','
    <hr />
    <div class="syn_synopsis_box">
    <div class="card" style="width: 480px;">
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
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__graph_sec_begin__','dmg_vm','
    <div id="outerflex" style="display:flex; flex-wrap: wrap; justify-content: flex-start;">
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__graph_sec_end__','dmg_vm','
    </div>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('hb_graph','hb_graph','
    <hr />
    <div class="syn_synopsis_box">
    
    <div class="card" style="width: 640px;">
        <div class="card-header">
            Hb profile for the last 2 years
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">
                    <svg height=<<hb_graph_canvas_y />> width=<<hb_graph_canvas_x />>>
                            <defs>
                                <marker id="dot" viewBox="0 0 10 10" refX="5" refY="5"
                                    markerWidth="5" markerHeight="5">
                                  <circle cx="5" cy="5" r="15" fill="gray" />
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
            <div class="col-md-4">
                        <ul class="list-group list-group-flush">
                        <li class="list-group-item"><small>Max <<hb_max_val />> (<<hb_max_dt />>)</small></li>
                        <li class="list-group-item"><small>Min <<hb_min_val />> (<<hb_min_dt />>)</small></li>                        
                        </ul>
                </div>
        </div>        
    </div>    
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('phos_graph','phos_graph','
    <hr />
    <div class="syn_synopsis_box">
    
    <div class="card" style="width: 640px;">
        <div class="card-header">
            Phosphate profile for the last 2 years
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-8">


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
                 <div class="col-md-4">
                        <ul class="list-group list-group-flush">
                        <li class="list-group-item"><small>Max <<phos_max_val />> (<<phos_max_dt />>)</small></li>
                        <li class="list-group-item"><small>Min <<phos_min_val />> (<<phos_min_dt />>)</small></li>                        
                        </ul>
                </div>
    </div>
    </div>
    </div>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_tbl1','ckd_labs','

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
        <<rrt=0>>
        <tr>
        
            <td>eGFR (ml/min/1.72m)</td>
            <td><<egfr1_val>><strong><<egfr1_val />></strong>(<<egfr1_dt />>) <</egfr1_val>></td>
            <td><<egfr2_val>><strong><<egfr2_val />></strong>(<<egfr2_dt />>) <</egfr2_val>></td>
            <td><<egfr3_val>><strong><<egfr3_val />></strong>(<<egfr3_dt />>) <</egfr3_val>></td>

        </tr>
        <</rrt=0>>


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
        <tr><td> </td><td> </td><td> </td><td> </td></tr>
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
            <td>Magnesium (mmol/l)</td>
            <td><<magnesium1_val>><strong><<magnesium1_val />></strong> (<<magnesium1_dt />>) <</magnesium1_val>></td>
            <td><<magnesium2_val>><strong><<magnesium2_val />></strong> (<<magnesium2_dt />>)<</magnesium2_val>></td>
            <td><<magnesium3_val>><strong><<magnesium3_val />></strong> (<<magnesium3_dt />>)<</magnesium3_val>></td>
        </tr>
        <tr>
            <td>PTH (pmol/l)</td>
            <td><<pth1_val>><strong><<pth1_val />></strong> (<<pth1_dt />>) <</pth1_val>></td>
            <td><<pth2_val>><strong><<pth2_val />></strong> (<<pth2_dt />>)<</pth2_val>></td>
            <td><<pth3_val>><strong><<pth3_val />></strong> (<<pth3_dt />>)<</pth3_val>></td>
        </tr>
        <<rrt=0>>
        <tr>
            <td>uACR (mg/mmol)</td>
            <td><<uacr1_val>><strong><<uacr1_val />></strong> (<<uacr1_dt />>)<</uacr1_val>></td>
            <td><<uacr2_val>><strong><<uacr2_val />></strong> (<<uacr2_dt />>)<</uacr2_val>></td>
            <td><<uacr3_val>><strong><<uacr3_val />></strong> (<<uacr3_dt />>)<</uacr3_val>></td>

        </tr>
        <</rrt=0>>

    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_tbl4','ckd_labs','
        <tr>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
        </tr>
        <tr>
            <td>Hb (g/l)</td>
            <td><<hb1_val>><strong><<hb1_val />></strong>(<<hb1_dt />>) <</hb1_val>></td>
            <td><<hb2_val>><strong><<hb2_val />></strong>(<<hb2_dt />>) <</hb2_val>></td>
            <td><<hb3_val>><strong><<hb3_val />></strong>(<<hb3_dt />>) <</hb3_val>></td>
        </tr>
          <tr>
            <td>Ferritin (ug/l)</td>
            <td><<fer1_val>><strong><<fer1_val />></strong>(<<fer1_dt />>) <</fer1_val>></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>TSAT </td>
            <td><<tsat1_val>><strong><<tsat1_val />></strong>(<<tsat1_dt />>) <</tsat1_val>></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
        </tr>
        <tr>
            <td>Platelets </td>
            <td><<plt1_val>><strong><<plt1_val />></strong>(<<plt1_dt />>) <</plt1_val>></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Neutrophils </td>
            <td><<wcc_n1_val>><strong><<wcc_n1_val />></strong>(<<wcc_n1_dt />>) <</wcc_n1_val>></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Eosinophils </td>
            <td><<wcc_eos1_val>><strong><<wcc_eos1_val />></strong>(<<wcc_eos1_dt />>) <</wcc_eos1_val>></td>
            <td></td>
            <td></td>
        </tr>
        
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__labs_panel_begin__','dmg','
    <div class="syn_synopsis_box">
    <h3>Lab data panel</h3>
    <table class="table table-sm table-striped">
    <colgroup>
          <col class="col-md-1">
          <col class="col-md-1">
          <col class="col-md-1">
          <col class="col-md-1">
    </colgroup>
        <tbody>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__labs_panel_end__','dmg','
        </tbody></table></div>
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
    <<egfr_decline>><div>Note [1.3] Most recent value being <<egfr_l_val />></div><</egfr_decline>>
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
                    </ol>
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
                        
                    </ol>
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
                        <<tir>><li class="list-group-item"><small>Time in range <<tir />>%</small></li><</tir>>
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
   <ol>
        <li><b>Perioperative mortality prediction</b>
        <ol>
            <li>ACS NSQIP</li>
            <ol>
                <li>Perioperative mortality risk <<pmp_score />>%</li>             
            </ol>
        </ol>
        </li>
   </ol>

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



Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('at_risk','at_risk','
    <<at_risk=1>>
    <li><b>At risk of CKD</b>
        <ol>
            <li>CKD criteria not met</li>
            <li>Risk factors
            <ol>
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
            </ol></li>
        </ol>
        </li>
    <</at_risk=1>>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_sle','cd_rheum_sle','
    <br />
    
        <li><b>Systemic Lupus Erythematosus</b>
            <ol>
                <li>Diagnosed <<sle_fd />> </li>
                <<rxn_l04ax>><li>Thiopurine <<rxn_l04ax />></li><</rxn_l04ax>>
                <<rxn_p01ba>><li>Hydroxychloroquine <<rxn_p01ba />></li><</rxn_p01ba>>
            </ol>
        </li>
    
    
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
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('graph_tac','graph_tac','
    <hr />
    <div class="syn_synopsis_box">
    <h5>Tac profile </h5>

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
        <li><b>Solid organ cancer</b>
            <<ca_prostate_fd>>
            <ol>
                <li>Prostate carcinoma <<ca_prostate_fd />></li> 
            </ol>
            <</ca_prostate_fd>>
            <<ca_crc_fd>>
            <ol>
                <li>Colorectal carcinoma <<ca_crc_fd />></li> 
            </ol>
            <</ca_crc_fd>>
            <<ca_rcc_fd>>
            <ol>
                <li>Renal cell carcinoma <<ca_rcc_fd />></li> 
            </ol>
            <</ca_rcc_fd>>
            <<ca_lung_fd>>
            <ol>
                <li>Lung carcinoma <<ca_lung_fd />></li> 
            </ol>
            <</ca_lung_fd>>
            <<ca_thyroid_fd>>
            <ol>
                <li>Thyroid carcinoma <<ca_thyroid_fd />></li> 
            </ol>
            <</ca_thyroid_fd>>
            <<ca_ovarian_fd>>
            <ol>
                <li>Ovarian carcinoma <<ca_ovarian_fd />></li> 
            </ol>
            <</ca_ovarian_fd>>
            <<ca_endometrial_fd>>
            <ol>
                <li>Endometrial carcinoma <<ca_endometrial_fd />></li> 
            </ol>
            <</ca_endometrial_fd>>
            <ol>
                <<op_enc_ld>><li>Last oncology clinic visit <<op_enc_ld />></li><</op_enc_ld>>
            </ol>
        </li>
    
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ca_breast','ca_breast','
            <li>Breast carcinoma <<code_fd />> 
            <ol>
                <<rxnc_l02bg>><li>Aromatase inhibitor <<rxnc_l02bg />></li><</rxnc_l02bg>>
                <<rxnc_l02ba>><li>Anti-oestrogren therapy <<rxnc_l02ba />></li><</rxnc_l02ba>>
            </ol>
            </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ca_skin_melanoma','ca_skin_melanoma','
            <li><b>Melanoma <<code_fd />> </b></li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ca_mets','ca_mets','
    <li><b>Metastatic disease</b></li>
        <<bone_met_fd>>
        <ol>
            <li>Bone metastatases <<bone_met_fd />></li>
        </ol>
        <</bone_met_fd>>
        <<cns_met_fd>>
        <ol>
            <li>Brain or CNS metastatases <<cns_met_fd />></li>
        </ol>
        <</cns_met_fd>>
        <<adr_met_fd>>
        <ol>
            <li>Adrenal metastatases <<adr_met_fd />></li>
        </ol>
        <</adr_met_fd>>
        <<liver_met_fd>>
        <ol>
            <li>Liver metastatases <<liver_met_fd />></li>
        </ol>
        <</liver_met_fd>>
        <<lung_met_fd>>
        <ol>
            <li>Liver metastatases <<lung_met_fd />></li>
        </ol>
        <</lung_met_fd>>
        <<perit_met_fd>>
        <ol>
            <li>Peritoneal metastatases <<perit_met_fd />></li>
        </ol>
        <</perit_met_fd>>
        <<nodal_met_fd>>
        <ol>
            <li>Nodal metastatases <<nodal_met_fd />></li>
        </ol>
        <</nodal_met_fd>>
        <<nos_met_fd>>
        <ol>
            <li>Metastatases NOS <<nos_met_fd />></li>
        </ol>
        <</nos_met_fd>>
    
    
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_pulm_copd','cd_pulm_copd','
    <br />
    <li><b>Chronic obstructive pulmonary disease</b>
        <ol>
            <<code_copd_dt>><li>Diagnosed <<code_copd_dt />></li><</code_copd_dt>>
            <<rx_r03_dt>><li>Bronchodilator therapy <<rx_r03_dt />></li><</rx_r03_dt>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_pulm_bt','cd_pulm_bt','
    <br />
    <li><b>Bronchiectasis</b>
        <ol>
            <<bt_fd>><li>Diagnosed <<bt_fd />></li><</bt_fd>>
        </ol>
    </li>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_endo_hypothyroid','cd_endo_hypothyroid','
    <br />
    <li><b>Hypothyroidism</b>
        <ol>
            <<code_fd>><li>Cause<</code_fd>>
            <ol>
                <<cong_fd>><li>Congenital <<cong_fd />></li><</cong_fd>>
                <<rx_induced_fd>><li>Acquired <<rx_induced_fd />></li><</rx_induced_fd>>
                <<post_mx_fd>><li>Post ablative therapy <<post_mx_fd />></li><</post_mx_fd>>
                <<nos_fd>><li>Unspecified cause <<nos_fd />></li><</nos_fd>>
            </ol>
            <<rx_h03aa_ld>><li>Thyroxin replacement therapy <<rx_h03aa_ld />></li><</rx_h03aa_ld>>
            </li>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cirrhosis','cd_cirrhosis','
    <br />
    <li><b>Cirrhosis of liver</b>
        <ol>
            <<code_fd>><li>Diagnosed <<code_fd />></li><</code_fd>> 
            <<cirr_pbc_fd>><li>Primary biliary cirrhosis</li><</cirr_pbc_fd>>
            <<cirr_nos_fd>><li>Cirrhosis Nos</li><</cirr_nos_fd>>
            <<cps_abbr_class=3>><li>CTP class C</li><</cps_abbr_class=3>>
            <<cps_abbr_class=2>><li>CTP class B</li><</cps_abbr_class=2>>
            <<cps_abbr_class=1>><li>CTP class A</li><</cps_abbr_class=1>>
        </ol>
    </li>
    ');
/
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_sti','id_sti','
    <br />
    <li><b>Recurrent Soft tissue infection</b>
        <ol>
            <<code_ld>><li>Last episode <<code_ld />></li><</code_ld>>
            <li><<icd_n />> infections over <<gap />> years</li>
            
        </ol>
    </li>
    ');
/

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_cap','id_cap','
    <br />
    <li><b>Respiratory infection requiring hospitalization</b>
        <ol>
            <<cap_viral_ld>><li>Viral pneumonia <<cap_viral_ld />></li><</cap_viral_ld>>
            <<cap_strep_ld>><li>Streptococcal pneumonia <<cap_strep_ld />></li><</cap_strep_ld>>
            <<cap_hi_ld>><li>Haemophilus pneumonia <<cap_hi_ld />></li><</cap_hi_ld>>
            <<cap_mel_ld>><li>Melioidosis <<cap_mel_ld />></li><</cap_mel_ld>>
            <<cap_nos_ld>><li>Community acquired pneumonia NOS <<cap_nos_ld />></li><</cap_nos_ld>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ortho_fractures','ortho_fractures','
    <br />
    <li><b>Fractures</b>
        <ol>
            <<pelvic_frac>><li>Pelvic fracture <<pelvic_frac_ld />></li><</pelvic_frac>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ortho_amputation','ortho_amputation','
    <br />
    <li><b>Limb amputation</b>
        <ol>
            <<prost_clinic_fd>><li>First orthotic/prosthetic clinic <<prost_clinic_fd />></li><</prost_clinic_fd>>
        </ol>
    </li>
    ');


--Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ipa_icu','ipa_icu','
--    <br />
--    <li><b>Admission to Intensive care</b>
--        <ol>
--            <<icu_los_dt>><li>ICU bed days <<icu_los_val />>(<<icu_los_dt />>)</li><</icu_los_dt>>
--            <<icu_vent_los_dt>><li>Ventilation days <<icu_vent_los_val/>>(<<icu_vent_los_dt />>)</li><</icu_vent_los_dt>>
--        </ol>
--    </li>
--    ');


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_ra','cd_rheum_ra','
    <br />
    <li><b>Rheumatoid Arthritis</b>
        <ol>
            <li>Diagnosed <<ra_fd />> 
            <ol>
                <<rxn_l04ax>><li>Thiopurine <<rxn_l04ax />></li><</rxn_l04ax>>
                <<rxn_p01ba>><li>Hydroxychloroquine <<rxn_p01ba />></li><</rxn_p01ba>>
                <<rxn_a07ec>><li>Aminosalicylic acid and similar agents <<rxn_a07ec />></li><</rxn_a07ec>>
            </ol>
            </li>
            <<op_enc_ld>><li>Last specialist clinic <<op_enc_ld />></li><</op_enc_ld>>
        </ol>
    </li>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_aps','cd_rheum_aps','
    <br />
    <li><b>Antiphospholipid syndrome</b>
        <ol>
            <li>Diagnosed <<aps_fd />> 
            <ol>
                <<rxn_anticoag_dt>><li>Anticoagulated <<rxn_anticoag_dt />></li><</rxn_anticoag_dt>>
            </ol>
            </li>
            <<op_enc_ld>><li>Last specialist clinic <<op_enc_ld />></li><</op_enc_ld>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_rheum_gout','cd_rheum_gout','
    <br />
    <li><b>Gout</b>
        <ol>
            <li>Diagnosed <<gout_fd />>
            <ol>
                <<rxnc_m04aa_ld>><li>Urate lowering therapy <<rxnc_m04aa_ld />></li><</rxnc_m04aa_ld>>
            </ol>
             </li>
            <<op_enc_ld>><li>Last specialist clinic <<op_enc_ld />></li><</op_enc_ld>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_imm_vasculitis','cd_imm_vasculitis','
    <br />
    <li><b>Systemic vasculitis</b>
        <ol>
            <<gpa_fd>><li>Granulomatosis with polyangiitis (Wegeners granulomatosis) <<gpa_fd />></li><</gpa_fd>>
            <<gca_fd>><li>Giant cell arteritis/Polymaglia rheumatica <<gca_fd />></li><</gca_fd>>
            <<mpo_fd>><li>Microscopic polyaniitis <<mpo_fd />></li><</mpo_fd>>
            <<tak_fd>><li>Takayasu arteritis <<tak_fd />></li><</tak_fd>>
            <ol>
                <<rxn_l01xc>><li>Monoclonal antibody therapy <<rxn_l01xc />></li><</rxn_l01xc>>
                <<rxn_h02ab>><li>Corticosteroid therapy <<rxn_h02ab />></li><</rxn_h02ab>>
            </ol>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_hepb','cd_hepb','
    <br />
    <li><b>Chronic Hepatitis B</b>
        <ol>
            <<hepb_imm>>
                <li>Immune
                <ol>
                    <<hepb_imm_vac>><li>by vaccination <<hepb_imm_vac />></li><</hepb_imm_vac>>
                    <<hepb_imm_inf>><li>by infection <<hepb_imm_inf />></li><</hepb_imm_inf>>
                </ol>
                </li>
            <</hepb_imm>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_uti','id_uti','
    <br />
    <li><b>Recurrent UTI</b>
        <ol>
            <<uti_ld>><li>Last UTI <<uti_ld />></li><</uti_ld>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_tb','id_tb','
    <br />
    <li><b>Tuberculosis</b>
        <ol>
            <<tb_code>><li>TB first diagnosed <<tb_code />></li><</tb_code>>
            <<ltb_code>><li>Latent TB first diagnosed <<ltb_code />></li><</ltb_code>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_melioid','id_melioid','
    <br />
    <li><b>Melioidosis</b>
        <ol>
            <<code>><li>Melioidosis first diagnosed <<code />></li><</code>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_covid19','id_covid19','
    <br />
    <li><b>Covid19 infection</b>
        <ol>
            <<covid19_icpc>><li>Last infection or date of close contact <<covid19_icpc />></li><</covid19_icpc>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('pregnancy','pregnancy','
    <br />
    <li><b>Obstetric history</b>
        <ol>
            <<partum_n>><li>GxP<<partum_n />></li><</partum_n>>
            <<partum_ld>><li>Last Partum <<partum_ld />></li><</partum_ld>>
            <<partum_lscs_ld>><li>Last C-section <<partum_lscs_ld />></li><</partum_lscs_ld>>
            <<gdm_code_fd>><li>Gestational diabetes <<gdm_code_fd />></li><</gdm_code_fd>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cardiac_vte','cd_cardiac_vte','
    <br />
    <li><b>Venous thrombo-embolism</b>
        <ol>
            <<pe_multi>><li>Multiple PE <<pe_fd />>-<<pe_ld />></li><</pe_multi>>
            <<pe_ld>><li>PE <<pe_ld />></li><</pe_ld>>
            <<dvt_fd>><li>Deep vein thrombosis <<dvt_fd />></li><</dvt_fd>>
            <<svt_fd>><li>Superficial vein thrombosis <<svt_fd />></li><</svt_fd>>
            <<budd_chiari_fd>><li>Budd-Chiari Syndrome <<budd_chiari_fd />></li><</budd_chiari_fd>>
            <<rxn_anticoag_dt>><li>Anticoagulated <<rxn_anticoag_dt />></li><</rxn_anticoag_dt>>
        </ol>
    </li>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('id_hcv','id_hcv','
    <br />
    <li><b>Chronic Hepatitis C</b>
        <ol>
            <<icpc_code>><li>Diagnosed <<icpc_code />></li><</icpc_code>>
        </ol>
    </li>
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('cd_cns_ch','cd_cns_ch','
    <br />
    <li><b>Cerebral Haemorrhage </b>
        <ol>
            <<code_sdh_fd>><li>Subdural Haemorrhage <<code_sdh_fd />></li><</code_sdh_fd>>
            <<code_ich_fd>><li>Intracerebral Haemorrhage <<code_ich_fd />></li><</code_ich_fd>>
            <<code_edh_fd>><li>Extradural Haemorrhage <<code_edh_fd />></li><</code_edh_fd>>
        </ol>
    </li>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('sx_abdo','sx_abdo','
    <br />
        <<exp_lap_fd>><li><b>Exploratory Laparotomy </b>(<<exp_lap_fd />>)</li><</exp_lap_fd>>
        <<r_hemi_fd>><li><b>Right Hemicolectomy </b>(<<r_hemi_fd />>)</li><</r_hemi_fd>>
        <<l_hemi_fd>><li><b>Left Hemicolectomy </b>(<<l_hemi_fd />>)</li><</l_hemi_fd>>
        <<h_ar_fd>><li><b>High Anterior resection </b>(<<h_ar_fd />>)</li><</h_ar_fd>>
        <<l_ar_fd>><li><b>Low Anterior resection </b>(<<l_ar_fd />>)</li><</l_ar_fd>>
        <<hartmann_fd>><li><b>Hartmann procedure </b>(<<hartmann_fd />>)</li><</hartmann_fd>>        
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_labs_block','ckd_labs','
    <br />
    <p>
        [<<creat1_dt />>]<<creat1_val>> Creatinine <strong><<creat1_val />></strong> umol/l <</creat1_val>>
        <<rrt=0>><<egfr1_val>>[<<egfr1_dt />>] eGFR <strong><<egfr1_val />></strong>ml/min/1.72m2 <</egfr1_val>><<uacr1_val>>[<<uacr1_dt />>] uACR <strong><<uacr1_val />></strong> mg/mmol <</uacr1_val>><</rrt=0>>
        
        <<sodium1_val>> Sodium <strong><<sodium1_val />></strong> mmol/l<</sodium1_val>>
        <<potassium1_val>> Potassium <strong><<potassium1_val />></strong> mmol/l<</potassium1_val>>
        <<bicarb1_val>> Bicarbonate <strong><<bicarb1_val />></strong> mmol/l<</bicarb1_val>>
        <<calcium1_val>>[<<calcium1_dt />>] Calcium <strong><<calcium1_val />></strong><</calcium1_val>>
        <<phos1_val>> [<<phos1_dt />>] Phosphate <strong><<phos1_val />></strong><</phos1_val>>
        <<magnesium1_val>> [<<magnesium1_dt />>] Magnesium <strong><<magnesium1_val />></strong><</magnesium1_val>>
        <<pth1_val>> [<<pth1_dt />>] PTH <strong><<pth1_val />></strong> pg/ml<</pth1_val>>
        <<hb1_val>>[<<hb1_dt />>] Haemoglobin <strong><<hb1_val />></strong> <</hb1_val>>
        <<hb_delta>><strong>(<<hb_delta />>%)</strong><</hb_delta>>
        <<ferritin1_val>>[<<ferritin1_dt />>] Ferritin <strong><<ferritin1_val />></strong> <</ferritin1_val>>
        <<tsat1_val>>[<<tsat1_dt />>] Transferrin saturation ratio <strong><<tsat1_val />></strong> <</tsat1_val>>
    </p>
        ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_prog_vm','ckd_prog_vm','
    <br />
    <p>
    <<rrt=0>>
    Case conference :
    <<gender=0>>She <</gender=0>><<gender=1>>He <</gender=1>> is a <<age />> year old patient with CKD stage <<ckd_stage />>.<<enc_ld>>Previous review was on the <<enc_ld />><</enc_ld>> 
    <<ipa_sep_ld>>The last hospital admission was on the <<ipa_sep_ld />><</ipa_sep_ld>>.
    The last Creatinine is <<creat1_val />> umol/l with a corresponding eGFR of <<egfr1_val />>(<<egfr1_dt />>)ml/min/1.72m2. <<uacr1_val>>uACR <<uacr1_val />> mg/mmol (<<uacr1_dt />>) .<</uacr1_val>>
    The average blood pressure was <<sbp_mu_1 />>/<<dbp_mu_1 />> mmHg with a maximum of <<sbp_max />> mmHg. 
    <<dm>><<hba1c_lv>>The Last HbA1c is <<hba1c_lv />>(<<hba1c_ld />>).<</hba1c_lv>>
    <<hba1c_stmt=11>>The glycaemic control is sub-optimal.<</hba1c_stmt=11>>
    <<hba1c_stmt=12>>The glycaemic control is optimal.<</hba1c_stmt=12>>
    <<hba1c_stmt=22>>The glycaemic control is optimal and stable.<</hba1c_stmt=22>>
    <<hba1c_stmt=23>>The glycaemic control is optimal but worsening.<</hba1c_stmt=23>>
    <<hba1c_stmt=31>>The glycaemic control is sub-optimal but improving.<</hba1c_stmt=31>>
    <<hba1c_stmt=32>>The glycaemic control is sub-optimal with no imporovement.<</hba1c_stmt=32>>
    <<hba1c_stmt=33>>The glycaemic control is sub-optimal and continues to worsen.<</hba1c_stmt=33>>
    <</dm>>
    </p>
    
    <p>
    <h3>Plan</h3>
    <ul>
        <li>Suggested medication changes :  </li>
        <li>Blood test interval : <<review_int />> months </li>
        <li>Blood pressure target : <<sbp_target_max />>/<<dbp_target_max />> mmHg</li>
        <li>Referral : </li>
        <li>Review by renal in : <<review_int />> months </li>
    </ul>
    </p>
    <</rrt=0>>
    <p>
    <br />
    <<tkc_provider=2>>Dr Asanga Abeyaratne, Nephrologist, Royal Darwin Hospital<</tkc_provider=2>>
    <br />
    </p>
    ');


Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_intro_narrative','rrt_hd_prog_vm','
    <br />
    <p>
    <<gender=0>>She <</gender=0>><<gender=1>>He <</gender=1>> is a <<age />> year old patient reviewed today at the Dialysis clinic.<<enc_ld>> Previous review was on the <<enc_ld />><</enc_ld>> 
    <<ipa_sep_ld>>The last hospital admission was on the <<ipa_sep_ld />><</ipa_sep_ld>>.
    </p><p>
    <<ibw_val>>The IBW is <<ibw_val />> kg set on <<ibw_dt />>.<</ibw_val>>The average blood pressure was <<sbp_mu_1 />>/<<dbp_mu_1 />> mmHg with a maximum of <<sbp_max />> mmHg. 
    <<spktv>>Single pool Kt/V is <<spktv />><</spktv>><<hours>> and dialysis durations is <<hours />> hrs.<</hours>>
    </p>
    ');
    
    Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('rrt_plan_narrative','rrt_hd_prog_vm','
    <br />
    <h3>Plan</h3>
    <ul>
        <li>Medication changes : None </li>
        <li>IBW changed:</li>
        <li>Review by renal in : 3 months </li>
    </ul>
    </p>
    <p>
    <br />
    <<tkc_provider=2>>Dr Asanga Abeyaratne, Nephrologist, Royal Darwin Hospital<</tkc_provider=2>>
    <br />
    </p>
    ');

Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_edu_video_resources_treatment_options','dmg_vm','
   <br />
        <h1>Treatment Options</h1>
        <br />
        <h2>Peritoneal Dialysis</h2>
        <iframe width="640" height="360" src="https://web.microsoftstream.com/embed/video/da0e05fe-e4c5-4281-872f-89636512b97a?autoplay=false&showinfo=true" allowfullscreen style="border:none;"></iframe>
        <h2>Haemodialysis</h2>
        <br />
        <iframe width="640" height="360" src="https://web.microsoftstream.com/embed/video/a959b475-633a-4b31-a56f-489a691629c6?autoplay=false&showinfo=true" allowfullscreen style="border:none;"></iframe>
        <br />
        <h2>Palliative Care</h2>
        <br />
        <iframe width="640" height="360" src="https://web.microsoftstream.com/embed/video/1c939491-c6a1-4658-8df1-d12f42dacca9?autoplay=false&showinfo=true" allowfullscreen style="border:none;"></iframe>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('ckd_edu_video_resources_living_with_ckd','dmg_vm','
   <br />
        <h1>Treatment Options</h1>
        <br />
        <h2>Peritoneal Dialysis</h2>
        <iframe width="640" height="360" src="https://web.microsoftstream.com/embed/video/da0e05fe-e4c5-4281-872f-89636512b97a?autoplay=false&showinfo=true" allowfullscreen style="border:none;"></iframe>
        <h2>Haemodialysis</h2>
        <br />
        <iframe width="640" height="360" src="https://web.microsoftstream.com/embed/video/a959b475-633a-4b31-a56f-489a691629c6?autoplay=false&showinfo=true" allowfullscreen style="border:none;"></iframe>
        <br />
        <h2>Palliative Care</h2>
        <br />
        <iframe width="640" height="360" src="https://web.microsoftstream.com/embed/video/1c939491-c6a1-4658-8df1-d12f42dacca9?autoplay=false&showinfo=true" allowfullscreen style="border:none;"></iframe>
    ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('perioperative_edu_heading','dmg_vm','
   <h1>Your Fitness for Surgery</h1><br />
   ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('periop_edu_bp','dmg_vm','
   <br /><h2>Your Blood Pressure</h2><br />
   ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('periop_edu_hb','dmg_vm','
   <br /><h2>Your Haemoglobin (HB)</h2><br />
   ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('periop_edu_egfr','dmg_vm','
   <br /><h2>Your eGFR</h2><br />
   ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('perioperative_edu_reminders','dmg_vm','
   <h1>Things to remember to bring with you to hospital</h1>
    <br />
    <p>* Bring your tablets (medicines) <br />
    * Phone and charger <br /> 
    <h2> Contacts</h2>
    <br>
    <p>PeriopMedRDH.DoH@nt.gov.au </p>
    <br />
   ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('perioperative_video_1','dmg_vm','
   <br />
    <h1>The Elective Surgery Story</h1>
    <br />
    <video src="https://digitallibrary.health.nt.gov.au/prodjspui/bitstream/10137/599/16/ENGLISHfinal.mp4" controls />
   ');
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__rtf_frame_begin__','dmg_vm','
    <div id="outerflex" style="display:flex; flex-wrap: wrap; justify-content: flex-start;">
    <!--OVR_ENUM_START-->
    ');
    
Insert into RMAN_RPT_TEMPLATE_BLOCKS (TEMPLATE_NAME,RULEBLOCKID,TEMPLATEHTML) values ('__rtf_frame_end__','dmg_vm','
    <!--OVR_ENUM_STOP-->
    </div>
    ');

@"tkc-insert-composition-template-map.sql"
-- Compile rman_tmplts
alter package rman_tmplts compile;
