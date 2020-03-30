--TKC Composition
--Version 	0.0.2.0
--Creation date	24/11/2019
--Author		ASAABEY
--
--Purpose
--
--PlacementId : 6 digit code that is used to anchor the template in the composition
--
--Placement Codebook
--10    Header
--30	Alert
--60	Synthesis
--70	Recommendations 
--80	Notes
--90    Footer
--
--Disease codes
--00    reserved
--10	Chronic disease : RRT
--11	Chronic disease : CKD
--21	Chronic disease : DM2
--31	Chronic disease : HTN
--41	Chronic disease : CVD
--90    reserved


DELETE FROM rman_rpt_templates WHERE compositionid='neph002_html';

INSERT INTO rman_rpt_templates (compositionid,templateid,ruleblockid,placementid,environment,template_owner,effective_dt,templatehtml)
      
ALTER PACKAGE rman_pckg COMPILE;
