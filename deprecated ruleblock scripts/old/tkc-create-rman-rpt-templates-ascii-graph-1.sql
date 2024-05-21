


DELETE FROM rman_rpt_templates WHERE compositionid='graph01';


INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
    VALUES('graph01','graph_egfr','egfr_graph',651100,'dev','tkc',TO_DATE(SYSDATE),
    '
    Temporal variation of eGFR  
    eGFR ml/min against time 
    <br />
    <<xygraph />>
    '
    );
    

@"tkc-create-package-rman-1.sql";