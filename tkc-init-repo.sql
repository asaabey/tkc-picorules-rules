



--Init rules
@"tkc-rman-insert-ruleblock-core.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";

@"tkc-rman-insert-ruleblock-ckd-c.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-labs.sql";
@"tkc-rman-insert-ruleblock-cd-dm.sql";
@"tkc-rman-insert-ruleblock-cd-htn.sql";

@"tkc-rman-insert-ruleblock-cd-cardiac-cad.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-vhd.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-chf.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-vte.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-misc.sql";

@"tkc-rman-insert-ruleblock-cd-cva.sql";
@"tkc-rman-insert-ruleblock-cd-dyslip.sql";
@"tkc-rman-insert-ruleblock-cd-obesity.sql";
@"tkc-rman-insert-ruleblock-cd-haem.sql";
@"tkc-rman-insert-ruleblock-cd-cns.sql";
@"tkc-rman-insert-ruleblock-cd-pulm.sql";
@"tkc-rman-insert-ruleblock-cd-rheum.sql";
@"tkc-rman-insert-ruleblock-cd-imm.sql";
@"tkc-rman-insert-ruleblock-ca.sql";
@"tkc-rman-insert-ruleblock-cd-endo-thyroid.sql";
@"tkc-rman-insert-ruleblock-cd-liver.sql";
@"tkc-rman-insert-ruleblock-cd-hep-b.sql";

@"tkc-rman-insert-ruleblock-id.sql";
@"tkc-rman-insert-ruleblock-id-uti.sql";
@"tkc-rman-insert-ruleblock-id-tb.sql";

@"tkc-rman-insert-ruleblock-ckd-at-risk.sql";
@"tkc-rman-insert-ruleblock-cd-careplan.sql";
@"tkc-rman-insert-ruleblock-rrt.sql";
@"tkc-rman-insert-ruleblock-kfre.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";

@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";
@"tkc-rman-insert-ruleblock-graph-bp.sql";
@"tkc-rman-insert-ruleblock-graph-hba1c.sql";
@"tkc-rman-insert-ruleblock-metrics";
@"tkc-rman-insert-ruleblock-cube-accel.sql";
@"tkc-rman-insert-ruleblock-periop-nsqip.sql";


-- Init templates

@"tkc-insert-compositions.sql"
@"tkc-insert-template-block.sql"
-- called by template-block
--@"tkc-insert-composition-template-map.sql"



--Init citations
@"tkc-insert-citations.sql";

--Re-init Rman package
alter package rman_pckg compile;

--Compile rules
execute rman_pckg.compile_active_ruleblocks;

--drop rout & rt tables
execute rman_pckg.drop_rout_tables_direct;






