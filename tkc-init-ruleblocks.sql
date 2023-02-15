



--Init rules
@"tkc-rman-insert-ruleblock-core.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";
@"tkc-rman-insert-ruleblock-dmg-loc.sql";
@"tkc-rman-insert-ruleblock-dmg-source.sql";
@"tkc-rman-insert-ruleblock-dmg-viewmodels.sql";

@"tkc-rman-insert-ruleblock-ipa.sql";
@"tkc-rman-insert-ruleblock-opa.sql";
@"tkc-rman-insert-ruleblock-pregnancy.sql";

@"tkc-rman-insert-ruleblock-ckd-c.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-ckd-mbd.sql";
@"tkc-rman-insert-ruleblock-ckd-anaemia.sql";
@"tkc-rman-insert-ruleblock-ckd-progress-viewmodels.sql";
--@"tkc-rman-insert-ruleblock-labs.sql";
@"tkc-rman-insert-ruleblock-cd-dm.sql";
@"tkc-rman-insert-ruleblock-cd-htn.sql";

@"tkc-rman-insert-ruleblock-cd-cardiac-ix.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-cad.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-vhd.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-chf.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-vte.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-misc.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-device.sql";

@"tkc-rman-insert-ruleblock-cd-cva.sql";
@"tkc-rman-insert-ruleblock-cd-cns-ch.sql";
@"tkc-rman-insert-ruleblock-cd-dyslip.sql";
@"tkc-rman-insert-ruleblock-cd-obesity.sql";
@"tkc-rman-insert-ruleblock-cd-haem.sql";
@"tkc-rman-insert-ruleblock-cd-hepb.sql";
@"tkc-rman-insert-ruleblock-cd-cns.sql";
@"tkc-rman-insert-ruleblock-cd-pulm.sql";
@"tkc-rman-insert-ruleblock-cd-pulm-copd.sql";
@"tkc-rman-insert-ruleblock-cd-pulm-bt.sql";
@"tkc-rman-insert-ruleblock-cd-rheum.sql";
@"tkc-rman-insert-ruleblock-cd-imm.sql";
@"tkc-rman-insert-ruleblock-ca.sql";
@"tkc-rman-insert-ruleblock-cd-endo-thyroid.sql";
@"tkc-rman-insert-ruleblock-cd-liver.sql";
@"tkc-rman-insert-ruleblock-cd-hep-b.sql";

@"tkc-rman-insert-ruleblock-id.sql";
@"tkc-rman-insert-ruleblock-id-uti.sql";
@"tkc-rman-insert-ruleblock-id-tb.sql";
@"tkc-rman-insert-ruleblock-id-hcv.sql";
@"tkc-rman-insert-ruleblock-id-covid19.sql";

@"tkc-rman-insert-ruleblock-ckd-at-risk.sql";
@"tkc-rman-insert-ruleblock-cd-careplan.sql";
@"tkc-rman-insert-ruleblock-rrt.sql";
@"tkc-rman-insert-ruleblock-rrt-hd.sql";
@"tkc-rman-insert-ruleblock-rrt-hd-loc.sql";
@"tkc-rman-insert-ruleblock-rrt-tx.sql";
@"tkc-rman-insert-ruleblock-rrt-labs.sql";
@"tkc-rman-insert-ruleblock-rrt-viewmodels.sql";

@"tkc-rman-insert-ruleblock-kfre.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";

@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";
@"tkc-rman-insert-ruleblock-graph-bp.sql";
@"tkc-rman-insert-ruleblock-graph-hba1c.sql";
@"tkc-rman-insert-ruleblock-metrics.sql";
@"tkc-rman-insert-ruleblock-cube-accel.sql";
@"tkc-rman-insert-ruleblock-periop-nsqip.sql";
@"tkc-rman-insert-ruleblock-cmidx-charlson.sql"
@"tkc-rman-insert-ruleblock-cm-viewmodel.sql"

@"tkc-rman-insert-ruleblock-sx-abdo.sql";
@"tkc-rman-insert-ruleblock-ortho-fractures.sql";
@"tkc-rman-insert-ruleblock-ortho-amputation.sql";

-- SARS-Cov-2
@"tkc-rman-insert-ruleblock-vacc-covid19.sql"

-- added by patty for KPI's
@"tkc-rman-insert-ruleblock-kpis.sql";



--Re-init Rman package
alter package rman_pckg compile;

--Compile rules
execute rman_pckg.compile_active_ruleblocks;



