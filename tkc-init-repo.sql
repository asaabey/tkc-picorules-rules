



--Init rules
@"tkc-init-ruleblocks.sql";


-- Init templates

--@"tkc-insert-compositions.sql"
--@"tkc-insert-template-block2.sql"
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






