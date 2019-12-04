--cd C:\Users\abeya\Documents\Oracle11g\tkc-master\tkc-picorules;
--cd C:\Users\ora\Documents\GitHub\tkc-picorules;

@"tkc-create-eadvx.sql";

@"tkc-create-rman.sql";
@"tkc-create-rman-rpt-templates-neph1.sql";
@"tkc-create-rman-rpt-templates-neph2.sql";
@"tkc-create-rman-rpt-templates-neph2-h-2.sql";
@"tkc-create-rman-comp-map.sql";


@"tkc-rman-insert-ruleblock-cd2.sql";
@"tkc-rman-insert-ruleblock-ckd2.sql";
@"tkc-rman-insert-ruleblock-cvra2.sql";
@"tkc-rman-insert-ruleblock-trigger2.sql";
@"tkc-rman-insert-ruleblock-dmg.sql";
@"tkc-rman-insert-ruleblock-rx.sql";
@"tkc-rman-insert-ruleblock-graph.sql";


@"tkc-create-insert-rman-admin-sqlblocks";
@"tkc-create-rman-resource-lookup.sql";
@"tkc-create-rman-ruleblocks-citations.sql";

@"tkc-create-package-rman-1.sql";

exec rman_pckg.compile_active_ruleblocks;


