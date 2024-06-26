CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;
BEGIN
    -- BEGINNING OF RULEBLOCK --
    
    rb.blockid := 'cd_hep_b_sero';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock := '
        #define_ruleblock(cd_hep_b_sero,
            {
                description: "Algorithm to detect Chronic hepatitis B from serology",
                is_active: 2
            }
        );

        /* HepB Surface antibody and antigen */

        s_ab_level => eadv.[lab_bld_hbs_ab_level]._.lastdv();

        s_ab_val : { s_ab_level_val = 0 => 0 },
                   { s_ab_level_val > 0 => 1 };

        s_ab_dt : { . => s_ab_level_dt };

        s_ag => eadv.[lab_bld_hbs_ag]._.lastdv();

        /* HepB Core antibody */

        c_ab => eadv.[lab_bld_hbc_ab]._.lastdv();

        /* HepB e antibody and antigen */

        e_ab_0 => eadv.[lab_bld_hbe_ab_level, lab_bld_hbe_ab]._.lastdv();

        e_ag_0 => eadv.[lab_bld_hbe_ag_level, lab_bld_hbe_ag]._.lastdv();

        e_ab : { e_ab_0_val=0 => 0 },
               { e_ab_0_val>0 => 1 };

        e_ag : { e_ag_0_val=0 => 0 },
               { e_ag_0_val>0 => 1 };


        /* HepB Viral Load */

        vl => eadv.[lab_bld_hbv_viral_load]._.lastdv();

        /* Liver Function AST */

        ast => eadv.[lab_bld_ast]._.lastdv();

        alt => eadv.[lab_bld_alt]._.lastdv();

        /*
        +--------------------------------------------------------------------------------------------------------------------------------------------+
        | Hepatitis B virus testing and interpreting test results                                                                                    |
        | https:\\hepatitisb.org.au/hepatitis-b-virus-testing-and-interpreting-test-results/                                                         |
        +----------+----------+----------+--------------+------------------------------------------+----------+--------------------------------------+
        | HBsAg    | anti-HBc | Anti-HBs | IgM anti-HBc | Interpretation                           | Status # |            Status Label              |
        | s_ag_val | c_ab_val | s_ab_val | c_ab_igm_val |                                          |          |                                      |
        +----------+----------+----------+--------------+------------------------------------------+----------+--------------------------------------+
        | pos      | pos      | neg      | neg          | Chronic HBV infection                    |        1 | HepB Positive: Chronic Infection *1  |
        | pos      | pos      | neg      | pos          | Acute HBV infection                      |        2 | HepB Positive: Acute Infection *1    |
        | neg      | neg      | neg      |              | Susceptible to infection                 |        3 | HepB Negative: Non Immune            |
        | neg      | pos      | pos      |              | Immune due to resolved infection         |        4 | HepB Negative: Immune by Exposure    |
        | neg      | neg      | pos      |              | Immune due to hepatitis B vaccination    |        5 | HepB Negative: Immune by Vaccination |
        | neg      | pos      | neg      |              | Isolated elevation of anti-HBc           |        6 | HepB Positive: Chronic Infection NOS |
        +----------+----------+----------+--------------+------------------------------------------+----------+--------------------------------------+
        | pos      | pos      | pos      |              | No Interpretation                        |        7 |                                      |
        | pos      | neg      | pos      |              | No Interpretation                        |        8 |                                      |
        | pos      | neg      | neg      |              | No Interpretation                        |        9 |                                      |
        +----------+----------+----------+--------------+------------------------------------------+----------+--------------------------------------+
        | *1: Without IgM data we can''t distinguish between acute and chronic infection so we will assume chronic                                    |
        +--------------------------------------------------------------------------------------------------------------------------------------------|
        */

        hbv_status : { s_ag_val=1 and c_ab_val=1 and s_ab_val=0 => 1 },
                     { s_ag_val=0 and c_ab_val=0 and s_ab_val=0 => 3 },
                     { s_ag_val=0 and c_ab_val=1 and s_ab_val=1 => 4 },
                     { s_ag_val=0 and c_ab_val=0 and s_ab_val=1 => 5 },
                     { s_ag_val=0 and c_ab_val=1 and s_ab_val=0 => 6 },
                     { s_ag_val=1 and c_ab_val=1 and s_ab_val=1 => 7 },
                     { s_ag_val=1 and c_ab_val=0 and s_ab_val=1 => 8 },
                     { s_ag_val=1 and c_ab_val=0 and s_ab_val=0 => 9 };

        /*
                     { s_ag_val=1 and c_ab_val=1 and s_ab_val=0 and c_ab_igm_val=0 => 1 }
                     { s_ag_val=1 and c_ab_val=1 and s_ab_val=0 and c_ab_igm_val=1 => 2 }
        */

        hbv_status_date_upper_dt : { hbv_status!? => greatest_date(s_ag_dt, c_ab_dt, s_ab_dt) };

        hbv_status_date_lower_dt : { hbv_status!? => least_date(s_ag_dt, c_ab_dt, s_ab_dt) };

        hbv_status_date_spread : { hbv_status!? => hbv_status_date_upper_dt - hbv_status_date_lower_dt };

        hbv_status_lbl : { hbv_status=1 => `HepB Positive: Chronic Infection` },
                         { hbv_status=2 => `HepB Positive: Acute Infection` },
                         { hbv_status=3 => `HepB Negative: Non Immune` },
                         { hbv_status=4 => `HepB Negative: Immune by Exposure` },
                         { hbv_status=5 => `HepB Negative: Immune by Vaccination` },
                         { hbv_status=6 => `HepB Positive: Chronic Infection NOS` },
                         { hbv_status=7 => `Uninterpreted Serological Results: +++` },
                         { hbv_status=8 => `Uninterpreted Serological Results: +-+` },
                         { hbv_status=9 => `Uninterpreted Serological Results: +--` };

        /*
        +--------------------------+
        | Hep B Virus Phase        |
        +-------+------------------+
        | Value |      Label       |
        +-------+------------------+
        |     1 | Immune tolerance |
        |     2 | Immune clearance |
        |     3 | Immune control   |
        |     4 | Immune escape    |
        +-------+------------------+
        */
        hbv_phase : { e_ag=1 and            alt_val < 30 and vl_val > 1000000 => 1 },
                    { e_ag=1 and            alt_val > 30 and vl_val > 20000   => 2 },
                    { e_ag=0 and e_ab=1 and alt_val < 30 and vl_val < 2000    => 3 },
                    { e_ag=0 and e_ab=1 and alt_val > 30 and vl_val > 2000    => 4 };


        hbv_phase_date_upper_dt : { hbv_phase!? => greatest_date(e_ag_0_dt, e_ab_0_dt, alt_dt, vl_dt) };

        hbv_phase_date_lower_dt : { hbv_phase!? => least_date(e_ag_0_dt, e_ab_0_dt, alt_dt, vl_dt) };

        hbv_phase_date_spread : { hbv_phase!? => hbv_phase_date_upper_dt - hbv_phase_date_lower_dt };

        hbv_phase_lbl : { hbv_phase=1 => `Immune tolerance phase` },
                        { hbv_phase=2 => `Immune clearance phase` },
                        { hbv_phase=3 => `Immune control phase` },
                        { hbv_phase=4 => `Immune escape phase` };


        cd_hep_b_sero : { hbv_status in (1,6) => 1 },{=>0};
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);
    COMMIT;
    -- END OF RULEBLOCK --
    
END;