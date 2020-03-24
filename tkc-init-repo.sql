
-- Init templates
@"tkc-create-rman-rpt-templates-neph2-h-2.sql";


--Init rules
@"tkc-rman-insert-ruleblock-cd2.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";
@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";
@"tkc-rman-insert-ruleblock-metrics";
@"tkc-rman-insert-ruleblock-test";
@"tkc-rman-insert-ruleblock-cube-accel.sql";


--Init citations
@"tkc-create-rman-ruleblocks-citations.sql";

--Re-init Rman package
@"..\tkc-picorules\tkc-create-package-rman-1.sql";






