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
    VALUES('cd_dm_rec_1','cd_dm_2',702100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Suggest optimizing glycaemic control
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
    <pers>Persistent </pers>CKD stage <ckd_stage></ckd_stage> (<cga_g></cga_g><cga_a></cga_a>) [1.1]. <egfr_outdated>The results are outdated [1.2].</egfr_outdated>
    '
    );
INSERT INTO rman_rpt_templates (templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('cd_ckd_recm_1','ckd-2-1',701100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <egfr_outdated>Recommendation [1.2] Repeat renal function tests.</egfr_outdated>
    '
    );
INSERT INTO rman_rpt_templates (templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('cd_ckd_footnote_1','ckd-2-1',801100,'dev','tkc',TO_DATE(SYSDATE),
    '
    <egfr_single>Note [1.1] This is based on a single egfr value on <egfrld></egfrld></egfr_single>
    <egfr_multiple>Note [1.1] This is based on <iq_egfr></iq_egfr> egfr values between <egfrfd></egfrfd> and <egfrld></egfrld></egfr_multiple>
    <egfr_outdated>Note [1.2.1] Last egfr on <egfrld></egfrld></egfr_outdated>
    <acr_outdated>Note [1.2.2] Last uACR on <acrld></acrld></acr_outdated>
    '
    );
