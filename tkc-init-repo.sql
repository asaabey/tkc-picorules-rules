



--Init rules
@"tkc-rman-insert-ruleblock-ckd-c.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-core";
@"tkc-rman-insert-ruleblock-cd-dm.sql";
@"tkc-rman-insert-ruleblock-cd-htn.sql";

@"tkc-rman-insert-ruleblock-cd-cardiac-cad.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-vhd.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-chf.sql";
@"tkc-rman-insert-ruleblock-cd-cardiac-misc.sql";

@"tkc-rman-insert-ruleblock-cd-cva.sql";
@"tkc-rman-insert-ruleblock-cd-dyslip.sql";
@"tkc-rman-insert-ruleblock-cd-obesity.sql";
@"tkc-rman-insert-ruleblock-cd-haem.sql";
@"tkc-rman-insert-ruleblock-cd-cns.sql";
@"tkc-rman-insert-ruleblock-cd-pulm.sql";
@"tkc-rman-insert-ruleblock-ckd-at-risk.sql";
@"tkc-rman-insert-ruleblock-cd-careplan.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-rrt.sql";
@"tkc-rman-insert-ruleblock-kfre.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";
@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";
@"tkc-rman-insert-ruleblock-metrics";
@"tkc-rman-insert-ruleblock-cube-accel.sql";
@"tkc-rman-insert-ruleblock-ckd-at-risk.sql";
@"tkc-rman-insert-ruleblock-periop-nsqip.sql";

-- Init templates
--@"tkc-create-rman-rpt-templates-neph2-h-3.sql";
-- above should be deprecated
@"tkc-insert-compositions.sql"
@"tkc-insert-template-block.sql"
@"tkc-insert-composition-template-map.sql"



--Init citations
@"tkc-insert-citations.sql";

--Re-init Rman package
alter package rman_pckg compile;

--Compile rules
execute rman_pckg.compile_active_ruleblocks;

--drop rout & rt tables
execute rman_pckg.drop_rout_tables_direct;






