CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;

BEGIN

    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='bi_vm';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        #define_ruleblock(bi_vm,
            {
                description: "Defined stable view of data for BI",
                is_active:2
            }
        );

        dmg_hrn_last => rout_dmg_hrn.hrn_last._.bind();
        dmg_loc_mode_24 => rout_dmg_loc.loc_mode_24._.bind();
        dmg_loc_mode => rout_dmg_loc.loc_mode._.bind();
        dmg_loc_def => rout_dmg_loc.loc_def._.bind();
        dmg_loc => rout_dmg_loc.dmg_loc._.bind();
        dmg_residency => rout_dmg_residency.dmg_residency._.bind();
        dmg_age => rout_dmg.age._.bind();
        dmg_gender => rout_dmg.gender._.bind();
        dmg_dod => rout_dmg.dod._.bind();
        dmg_dob => rout_dmg.dob._.bind();

        at_risk_is_active => rout_at_risk.is_active._.bind();
        at_risk_tkc_cohort => rout_at_risk.tkc_cohort._.bind();
        at_risk_tkc_cat => rout_at_risk.tkc_cat._.bind();
        at_risk_aki => rout_at_risk.aki._.bind();
        at_risk_at_risk => rout_at_risk.at_risk._.bind();
        at_risk_cad => rout_at_risk.cad._.bind();
        at_risk_cvd => rout_at_risk.cvd._.bind();
        at_risk_cva => rout_at_risk.cva._.bind();
        at_risk_ckd => rout_at_risk.ckd._.bind();
        at_risk_dm => rout_at_risk.dm._.bind();
        at_risk_hepb => rout_at_risk.hepb._.bind();
        at_risk_htn => rout_at_risk.htn._.bind();
        at_risk_obesity => rout_at_risk.obesity._.bind();
        at_risk_pvd => rout_at_risk.pvd._.bind();
        at_risk_rrt => rout_at_risk.rrt._.bind();
        at_risk_rhd => rout_at_risk.rhd._.bind();
        at_risk_smoker => rout_at_risk.smoker._.bind();

        ckd_assert_level => rout_ckd.assert_level._.bind();
        ckd_access => rout_ckd_access.ckd_access._.bind();

        bi_vm: { . => 1 }
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --

END;





