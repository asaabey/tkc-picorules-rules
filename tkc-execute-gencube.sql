CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
ret_val pls_integer;

BEGIN 

/*
    API usage
    
*/


rman_pckg.compile_active_ruleblocks;

--rman_pckg.gen_cube_from_ruleblock('
--    rrt.rrt,
--    dmg.dob,
--    dmg.dod,
--    ckd.ckd,
--    ckd.egfr_outdated,
--    cd_dm.dm,
--    cd_dm.dm_dx_uncoded,
--    cd_htn.htn,
--    cd_htn.htn_dx_uncoded,
--    cd_obesity.obesity,
--    cd_obesity.obs_dx_uncoded,
--    cvra.cvra,
--    cvra.cvra_dx_uncoded
--    ','01072019,01072018,01072017','rep124');

--rman_pckg.gen_cube_from_ruleblock('
--    rrt.rrt
--    ','01072019,01072018,01072017','rep124');

--rman_pckg.gen_cube_from_ruleblock('
--    at_risk_ckd.rrt,
--    dmg.dob,
--    dmg.dod,
--    at_risk_ckd.ckd,
--    at_risk_ckd.dm,
--    at_risk_ckd.htn,
--    at_risk_ckd.obesity,
--    cvra.cvra,
--    cvra.cvra_dx_uncoded
--    ','01072019,01072018,01072017','rep126');

rman_pckg.gen_cube_from_ruleblock(
    rb_att_str => '
        ckd_dense.dob,
        ckd_dense.dod,
        ckd_dense.gender,
        ckd_dense.loc_mode_phc,
        ckd_dense.rrt,
        ckd_dense.rrt_start,
        ckd_dense.hd_start,
        ckd_dense.pd_start,
        ckd_dense.ckd,
        ckd_dense.cert_level,
        ckd_dense.dx_ckd_diff,
        ckd_dense.avf_has
    ',
    slices_str=>'01072019,01072018,01072017',
    ret_tbl_name=>'rep126',
    batch_level_filter => '');



END;


 




