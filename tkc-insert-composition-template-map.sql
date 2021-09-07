
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

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__header__'), tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_phc_null'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_eid_alt'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_tkcuser_interact'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='_top_banner_begin'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_network_summary'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_loc_summary'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_hosp_summary'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='_top_banner_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_residency'),tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4620'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4610'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4100'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4410'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4720'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4660'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg2610'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cvra_banner_1'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__frame_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__synth_left_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='at_risk'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_1_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_2_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_3_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_4_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_adequacy'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_1_metrics'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_param'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_acc_iv'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_3_metric'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_cause_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_anaemia'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_shpt'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rrt_x_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_journey_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_nephrectomy'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_dx_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_compx_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_3'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_4'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_5'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_obesity'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_bp_control'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_cad_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vhd_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_chf_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_af'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_rhd'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_device'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vte'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dyslip'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cns'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_haem'),tmplts_placement_order_seq.nextval);
--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cva_syn'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_sle'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_imm_vasculitis'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_aps'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_gout'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ca_solid'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ca_breast'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ca_mets'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_pulm'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_endo_hypothyroid'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cirrhosis'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='id_sti'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='id_cap'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='id_uti'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='id_tb'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_hepb_coded'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='sx_abdo'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='tkc_drop_zone'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__synth_left_end__'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__synth_right_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='graph_egfr2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='rx_syn_2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_block'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__synth_right_end__'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__frame_end__'),tmplts_placement_order_seq.nextval);

--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__graph_sec_begin__'),tmplts_placement_order_seq.nextval);
--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='graph_tac'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='acr_graph_acr'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='hb_graph'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='phos_graph'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='hba1c_graph'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='graph_bp'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ldl_graph'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='egfr_metrics'),tmplts_placement_order_seq.nextval);
--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__graph_sec_end__'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__labs_panel_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl3'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_tbl4'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='__labs_panel_end__'),tmplts_placement_order_seq.nextval);

--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='ipa_icu'),tmplts_placement_order_seq.nextval);



Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='frame_recm_begin'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cvra_rec_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_dm_rec_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_recm_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='frame_recm_end'),tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_footnote_1'),tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_htn_footnote_1'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='frame_notes_begin'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='cd_cvra_footnote_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='frame_notes_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='dmg_source_feedback'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph002_html'),(select id from rman_rpt_template_blocks where template_name='debug_info'),tmplts_placement_order_seq.nextval);


-- cse corresp

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='__header__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4100'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4410'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4720'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4660'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg2610'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4620'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='cse_corres_html'),(select id from rman_rpt_template_blocks where template_name='alert_tg4610'),tmplts_placement_order_seq.nextval);


--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology--cardiology
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
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='card001_html'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_device'),tmplts_placement_order_seq.nextval);
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




Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values (4,(select id from rman_rpt_template_blocks where template_name='__masked__'),tmplts_placement_order_seq.nextval);


-- Neph004_Rtf

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='__header__'), tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='__frame_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='__synth_left_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='at_risk'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_1_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_2_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_3_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_4_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_adequacy'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_1_metrics'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_param'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_hd_acc_iv'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_3_metric'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_cause_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_anaemia'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_shpt'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rrt_x_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_journey_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_cause_nephrectomy'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_dx_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_compx_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_ckd_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_3'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_4'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_5'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dm_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_obesity'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_1'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_htn_bp_control'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_htn_syn_end'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_cad_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vhd_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_chf_syn'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_af'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_rhd'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_device'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cardiac_vte'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_dyslip'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cns'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_haem'),tmplts_placement_order_seq.nextval);
--Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cva_syn'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_sle'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_imm_vasculitis'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_aps'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_rheum_gout'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='ca_solid'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='ca_breast'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='ca_mets'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_pulm'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_endo_hypothyroid'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_cirrhosis'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='id_sti'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='id_cap'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='id_uti'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='id_tb'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='cd_hepb_coded'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='sx_abdo'),tmplts_placement_order_seq.nextval);


Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='__synth_left_end__'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='__synth_right_begin__'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='rx_syn_2'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='ckd_labs_block'),tmplts_placement_order_seq.nextval);
Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='ckd_prog_vm'),tmplts_placement_order_seq.nextval);

Insert into RMAN_RPT_COMP_TEMP (COMPOSITION_ID,TEMPLATE_ID,PLACEMENT_ORDER) values ((select id from RMAN_RPT_COMPOSITIONS WHERE composition_name='neph004_rtf'),(select id from rman_rpt_template_blocks where template_name='__synth_right_end__'),tmplts_placement_order_seq.nextval);


alter package rman_tmplts compile;