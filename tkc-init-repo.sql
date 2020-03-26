

--Init rules
--@"tkc-rman-insert-ruleblock-cd2.sql";
@"tkc-rman-insert-ruleblock-core";
@"tkc-rman-insert-ruleblock-cd-dm.sql";
@"tkc-rman-insert-ruleblock-cd-htn.sql";
@"tkc-rman-insert-ruleblock-cd-cvd.sql";
@"tkc-rman-insert-ruleblock-cd-obesity.sql";
@"tkc-rman-insert-ruleblock-cd-ckd-at-risk.sql";
@"tkc-rman-insert-ruleblock-cd-careplan.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";
@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";
@"tkc-rman-insert-ruleblock-metrics";
@"tkc-rman-insert-ruleblock-test";
@"tkc-rman-insert-ruleblock-cube-accel.sql";
@"tkc-rman-insert-ruleblock-ckd-at-risk.sql";

-- Init templates
@"tkc-create-rman-rpt-templates-neph2-h-3.sql";


--Init citations
@"tkc-create-rman-ruleblocks-citations.sql";

--Re-init Rman package
@"..\tkc-picorules\tkc-create-package-rman-1.sql";






