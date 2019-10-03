cd C:\Users\abeya\Documents\Oracle11g\tkc-master\tkc-picorules;

@"tkc-create-eadvx.sql";
@"tkc-create-rman.sql";
@"tkc-create-rman-rpt-templates-neph1.sql";
@"tkc-create-rman-rpt-templates-neph2.sql";
@"tkc-create-rman-rpt-templates-neph2-h.sql";
@"tkc-create-rman-comp-map.sql";
@"tkc-create-package-rman-1.sql";

@"tkc-rman-insert-ruleblock-cd2.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";
@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";

exec rman_pckg.compile_active_ruleblocks;


