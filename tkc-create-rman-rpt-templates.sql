DROP TABLE rman_rpt_templates;
/
CREATE TABLE rman_rpt_templates
(
    templateid      varchar2(100) not null,
    ruleblockid         varchar2(100),
    templatehtml    clob,
    environment     varchar2(30),
    template_owner  varchar2(30),
    effective_dt    date,
    CONSTRAINT pk_rman_rpt_templates PRIMARY KEY(templateid)
    --CONSTRAINT fk_template_ruleblock FOREIGN KEY(ruleblockid) REFERENCES rman_ruleblocks(blockid)
);
/
DROP INDEX rman_rpt_templates_ruleblockid;
/
CREATE INDEX rman_rpt_templates_ruleblockid ON rman_rpt_templates(ruleblockid);
/


INSERT INTO rman_rpt_templates (templateid,ruleblockid,environment,template_owner,effective_dt,templatehtml)
    VALUES('cd_dm_syn_1','cd_dm_2','dev','tkc',TO_DATE(SYSDATE),
    '
    <dm_dx_code_t></dm_dx_code_t> <dm_longstanding_t></dm_longstanding_t> type <dm_type></dm_type> diabetes mellitus since <dm_fd_t></dm_fd_t>.
    '
    );
