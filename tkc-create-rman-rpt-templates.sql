DROP TABLE rman_rpt_templates;
/
CREATE TABLE rman_rpt_templates
(
    templateid      varchar2(100) not null,
    ruleblockid         varchar2(100),
    placementid     INTEGER,
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


INSERT INTO rman_rpt_templates (templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('cd_dm_syn_1','cd_dm_2',602100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <dm_dx_code_t></dm_dx_code_t> <dm_longstanding_t></dm_longstanding_t> type <dm_type></dm_type> diabetes mellitus since <dm_fd_t></dm_fd_t>.
    There are <dm_micvas_t></dm_micvas_t> non-renal microvascular complications. 
    The glycaemic control is <n0_st_t></n0_st_t> with <n_opt_qt></n_opt_qt>% (<hba1c_n_opt></hba1c_n_opt>/<hba1c_n_tot></hba1c_n_tot>) of the readings in the optimal range.
    '
    );
INSERT INTO rman_rpt_templates (templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('cd_htn_syn_1','cd_htn_2',603100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Hypertension type <htn_type></htn_type> for <htn_vintage_cat></htn_vintage_cat> decade(s).
    '
    );
INSERT INTO rman_rpt_templates (templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('cd_ckd_syn_1','ckd-2-1',601100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Diagnosed CKD stage <ckd_stage></ckd_stage> (<cga_g></cga_g><cga_a></cga_a>).
    '
    );
