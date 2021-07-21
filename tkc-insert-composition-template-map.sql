
TRUNCATE TABLE rman_rpt_comp_temp;

/*
Header      20xxxx
Alerts      30xxxx
Priority    50xxxx
Synthesis   60xxxx
Recommend   70xxxx

Renal       xx11xx
DM          xx21xx
Obesity     xx29xx
Htn         xx31xx
Cardiac     xx41xx
Pulm        xx51xx
Other endo  xx53xx
Liver       xx61xx
Infection   xx81xx
Carcinoma   xx91xx
*/

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='__header__'), 200000);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='dmg_source_summary'),200008);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='dmg_phc_null'),200004);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='dmg_eid_alt'),200006);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='dmg_tkcuser_interact'),200007);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='dmg_residency'),200020);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='dmg_source_feedback'),200010);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg4620'),304620);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg4610'),304610);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg4100'),304100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg4410'),304410);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg4720'),304720);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg4660'),304660);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='alert_tg2610'),302610);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cvra_banner_1'),310101);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='__synth_begin__'),600010);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='__synth_end__'),699990);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_1_syn'),601001);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_2_syn'),601002);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_3_syn'),601003);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_4_syn'),601004);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_hd_adequacy'),601005);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_1_metrics'),601006);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_hd_param'),601008);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_hd_acc_iv'),601010);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_3_metric'),601031);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_cause_syn_1'),601040);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_anaemia'),601050);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_shpt'),601045);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_x_syn_end'),601099);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_1'),601100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_syn_1'),601101);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_nephrectomy'),601190);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_dx_1'),601110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_compx_1'),601120);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_end'),601199);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_1'),602110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_2'),602115);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_3'),602120);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_4'),602130);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_5'),602135);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_end'),602199);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_obesity'),602900);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_1'),603100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_htn_bp_control'),603110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_end'),603199);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cardiac_cad_syn'),604100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vhd_syn'),604101);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cardiac_chf_syn'),604102);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cardiac_af'),604103);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cardiac_rhd'),604104);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vte'),604106);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dyslip'),604105);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cns'),605100);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_haem'),606100);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cva_syn'),604110);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='tkc_drop_zone'),609990);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rx_syn_2'),651011);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cvra_rec_1'),704100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cvra_footnote_1'),804100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_journey_1'),601105);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='graph_egfr2'),651101);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='acr_graph_acr'),651310);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='hb_graph'),653120);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='phos_graph'),653130);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='hba1c_graph'),652110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='graph_bp'),653110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='egfr_metrics'),651110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl1'),661100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl2'),661101);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='frame_recm_begin'),700001);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='frame_recm_end'),799999);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='frame_notes_begin'),800001);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='frame_notes_end'),899999);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl3'),661102);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ckd_labs_ga'),661105);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='at_risk'),600910);


--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='rrt_cause_syn_1'),601007);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ldl_graph'),651102);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ca_solid'),609110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ca_breast'),609120);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ca_mets'),609150);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_pulm'),605110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_endo_hypothyroid'),605310);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_cirrhosis'),606110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='id_sti'),608110);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='id_cap'),608140);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='id_uti'),608112);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='id_tb'),608190);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_rheum_sle'),603010);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_imm_vasculitis'),603012);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_rheum_aps'),603020);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_rheum_gout'),603030);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ckd_labs_block'),651012);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_hepb_coded'),606120);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='ipa_icu'),691010);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (4,(select id from rman_rpt_template_blocks where template_name='__masked__'),200000);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_dm_rec_1'),702100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_recm_1'),701100);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_ckd_footnote_1'),803100);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='cd_htn_footnote_1'),801100);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (1,(select id from rman_rpt_template_blocks where template_name='debug_info'),921010);

-- cse corresp

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='__header__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4100'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4410'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4720'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4660'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg2610'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4620'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4610'),tmplts_placement_order_seq.nextval);


--cardiology
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='__header__'), tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='dmg_source_summary'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='dmg_phc_null'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='dmg_eid_alt'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='dmg_tkcuser_interact'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='dmg_residency'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='dmg_source_feedback'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cvra_banner_1'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='__synth_begin__'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_cad_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vhd_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_chf_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_af'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_rhd'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vte'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dyslip'),tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_1_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_2_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_3_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_4_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_adequacy'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_1_metrics'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_param'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_acc_iv'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_3_metric'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_cause_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_anaemia'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_shpt'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rrt_x_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_nephrectomy'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_dx_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_compx_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_3'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_4'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_5'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_obesity'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_bp_control'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_end'),tmplts_placement_order_seq.nextval);



Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='at_risk'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='ca_solid'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='ca_breast'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='ca_mets'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_pulm'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_endo_hypothyroid'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cirrhosis'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='id_sti'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='id_cap'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='id_uti'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='id_tb'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_sle'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_imm_vasculitis'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_aps'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_gout'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_block'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_hepb_coded'),tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='ipa_icu'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cns'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_haem'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cva_syn'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='tkc_drop_zone'),tmplts_placement_order_seq.nextval);



Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='__synth_end__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='rx_syn_2'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='ldl_graph'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='graph_bp'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='hba1c_graph'),tmplts_placement_order_seq.nextval);







alter package rman_tmplts compile;