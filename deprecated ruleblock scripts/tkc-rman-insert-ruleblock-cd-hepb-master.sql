CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;
BEGIN
    -- BEGINNING OF RULEBLOCK --
    
    rb.blockid := 'cd_hepb_master';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock := '
        #define_ruleblock(cd_hepb_master,{
              description: "Algorithm to detect Chronic hepatitis B",
              is_active:2
        });

        /* Hep B Serology (cd_hep_b_sero) */

        ss => rout_cd_hep_b_sero.hbv_status.val.bind();

        sp => rout_cd_hep_b_sero.hbv_phase.val.bind();

        vl_val => rout_cd_hep_b_sero.vl_val.val.bind();

        vl_dt => rout_cd_hep_b_sero.vl_dt.val.bind();


        /* Hep B Coding (cd_hepb_coded) */

        cs => rout_cd_hepb_coded.hepb_status.val.bind();

        rx => rout_cd_hepb_coded.rx_av_ld.val.bind();

        ck : {. => (coalesce(cs,0) * 1000) + (coalesce(ss,0) * 100) + coalesce(sp,0)};


        /* Rx: Nucleoside and nucleotide reverse transcriptase inhibitors (rx_av_nrti) */

        rx_entecavir => rout_rx_av_nrti.entecavir.val.bind();

        rx_tenofovir => rout_rx_av_nrti.tenofovir.val.bind();

        rx_lamivudine => rout_rx_av_nrti.lamivudine.val.bind();

        rx_adefovir => rout_rx_av_nrti.adefovir.val.bind();

        rx_av : { rx_entecavir!?  => 1},
                { rx_tenofovir!?  => 2},
                { rx_lamivudine!? => 3},
                { rx_adefovir!?   => 4};

        rx_av_lbl : { rx_av=1 => `Entecavir based` },
                    { rx_av=2 => `Tenofovir based` },
                    { rx_av=3 => `Lamivudine based` },
                    { rx_av=4 => `Adefovir based` };


        coded_status_code : { cs in (20,21,22,23)          => `C+` },
                            { cs in (10,11,12,13,14,15,16) => `C-` },
                            { cs!?                         => `C9` },
                            { cs?                          => `CX` };

        coded_status_lbl : { coded_status_code = `C+` => `Coded Positive` },
                           { coded_status_code = `C-` => `Coded Negative` },
                           { coded_status_code = `C9` => `Unhandled Code` },
                           { coded_status_code = `CX` => `Not Coded` };

        sero_status_code : { ss in (1,6)   => `S+` },
                           { ss in (3,4,5) => `S-` },
                           { ss in (7,8,9) => `SU` },
                           { ss!?          => `S9` },
                           { ss?           => `SX` };

        sero_status_lbl : { sero_status_code = `S+` => `Seropositive` },
                          { sero_status_code = `S-` => `Seronegative` },
                          { sero_status_code = `SU` => `Uninterpreted Serological Results` },
                          { sero_status_code = `S9` => `Unhandled Serological Results` },
                          { sero_status_code = `SX` => `No Serology Status` };


        c_s_cngr_m_ : { . => coded_status_code + '/' + sero_status_code };


        c_s_cngr : { coded_status_code = `C+` and sero_status_code = `S-` => 1010 },
                   { coded_status_code = `C+` and sero_status_code = `S+` => 1011 },
                   { coded_status_code = `C+` and sero_status_code = `SU` => 1018 },
                   { coded_status_code = `C+` and sero_status_code = `SX` => 1019 },

                   { coded_status_code = `C-` and sero_status_code = `S-` => 1000 },
                   { coded_status_code = `C-` and sero_status_code = `S+` => 1001 },
                   { coded_status_code = `C-` and sero_status_code = `SU` => 1008 },
                   { coded_status_code = `C-` and sero_status_code = `SX` => 1009 },

                   { coded_status_code = `CX` and sero_status_code = `S-` => 1090 },
                   { coded_status_code = `CX` and sero_status_code = `S+` => 1091 };


        c_s_cngr_lbl : { coded_status_code = `C+` and sero_status_code = `S-` => `Coded Positive but Seronegative` },
                       { coded_status_code = `C+` and sero_status_code = `S+` => `Coded Positive and Seropositive` },
                       { coded_status_code = `C+` and sero_status_code = `SU` => `Coded Positive but Uninterpreted Serological Results` },
                       { coded_status_code = `C+` and sero_status_code = `SX` => `Coded Positive but No Serology Status` },

                       { coded_status_code = `C-` and sero_status_code = `S-` => `Coded Negative and Seronegative` },
                       { coded_status_code = `C-` and sero_status_code = `S+` => `Coded Negative but Seropositive` },
                       { coded_status_code = `C-` and sero_status_code = `SU` => `Coded Negative but Uninterpreted Serological Results` },
                       { coded_status_code = `C-` and sero_status_code = `SX` => `Coded Negative but No Serology Status` },

                       { coded_status_code = `CX` and sero_status_code = `S-` => `Not Coded and Seronegative` },
                       { coded_status_code = `CX` and sero_status_code = `S+` => `Not Coded but Seropositive` };

        chb_flag : { coded_status_code = `C+` and sero_status_code = `S-` => 1 },
                   { coded_status_code = `C+` and sero_status_code = `S+` => 1 },
                   { coded_status_code = `C+` and sero_status_code = `SU` => 1 },
                   { coded_status_code = `C+` and sero_status_code = `SX` => 1 },

                   { coded_status_code = `C-` and sero_status_code = `S-` => 0 },
                   { coded_status_code = `C-` and sero_status_code = `S+` => 1 },
                   { coded_status_code = `C-` and sero_status_code = `SU` => 1 },
                   { coded_status_code = `C-` and sero_status_code = `SX` => 0 },

                   { coded_status_code = `CX` and sero_status_code = `S-` => 0 },
                   { coded_status_code = `CX` and sero_status_code = `S+` => 1 },
                   { => 0 };

        /*
        chb_flag : { c_s_cngr_m_ in (`C-/S+`,
                                     `C-/SU`,
                                     `C+/S-`,
                                     `C+/S+`,
                                     `C+/SU`,
                                     `C+/SX`,
                                     `CX/S+`) => 1 },
                   { c_s_cngr_m_ in (`C-/S-`,
                                     `C-/SX`,
                                     `CX/S-`) => 0 },
                   {=>0};
        */


        /*
        c_s_cngr : { cs in (20,21,22,23)          and ss in (3,4,5) => 1010 },
                   { cs in (20,21,22,23)          and ss in (1,6)   => 1011 },
                   { cs in (20,21,22,23)          and ss in (7,8,9) => 1018 },
                   { cs in (20,21,22,23)          and ss?           => 1019 },
                   
                   { cs in (10,11,12,13,14,15,16) and ss in (3,4,5) => 1000 },
                   { cs in (10,11,12,13,14,15,16) and ss in (1,6)   => 1001 },
                   { cs in (10,11,12,13,14,15,16) and ss in (7,8,9) => 1008 },
                   { cs in (10,11,12,13,14,15,16) and ss?           => 1009 },
                   
                   { cs?                          and ss in (3,4,5) => 1090 },
                   { cs?                          and ss in (1,6)   => 1091 };

        c_s_cngr_lbl : { c_s_cngr = 1000 => `Coded Negative and Seronegative` },
                       { c_s_cngr = 1001 => `Coded Negative but Seropositive` },
                       { c_s_cngr = 1008 => `Coded Negative but Uninterpreted Serological Results` },
                       { c_s_cngr = 1009 => `Coded Negative but No Serology Status` },
                       
                       { c_s_cngr = 1010 => `Coded Positive but Seronegative` },
                       { c_s_cngr = 1011 => `Coded Positive and Seropositive` },
                       { c_s_cngr = 1018 => `Coded Positive but Uninterpreted Serological Results` },
                       { c_s_cngr = 1019 => `Coded Positive but No Serology Status` },
                       
                       { c_s_cngr = 1090 => `Not Coded and Seronegative` },
                       { c_s_cngr = 1091 => `Not Coded but Seropositive` };

        chb_flag : { c_s_cngr in (     1001,1008,     1010,1011,1018,1019,    1091) => 1 },
                   { c_s_cngr in (1000,          1009,                    1090    ) => 0 },
                   {=>0};
        */

        cd_hepb_master : { coalesce(ss, sp, cs)!? => 1},{ => 0 };

        chb_imm_tol_flg : { sp = 1 => 1 },{ => 0 };
        chb_imm_clr_flg : { sp = 2 => 1 },{ => 0 };
        chb_imm_ctr_flg : { sp = 3 => 1 },{ => 0 };
        chb_imm_esc_flg : { sp = 4 => 1 },{ => 0 };


        chb_imm_lbl => rout_cd_hep_b_sero.hbv_phase_lbl.val.bind();

        hbv_status_lbl => rout_cd_hep_b_sero.hbv_status_lbl.val.bind();

        hepb_status_lbl => rout_cd_hepb_coded.hepb_status_lbl.val.bind();


        #define_attribute(sp,{
                        label: "Chronic HepB : Immune Phase Code",
                        is_reportable:1,
                        type:2
        });

        #define_attribute(chb_imm_lbl, {
                        label: "Chronic HepB : Immune Phase Label",
                        is_reportable:1,
                        type:1
        });

        #define_attribute(chb_imm_tol_flg,{
                        label: "Chronic HepB : Immune tolerance phase",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(chb_imm_clr_flg,{
                        label: "Chronic HepB : Immune clearance phase",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(chb_imm_ctr_flg,{
                        label: "Chronic HepB : Immune control phase",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(chb_imm_esc_flg,{
                        label: "Chronic HepB : Immune escape phase",
                        is_reportable:1,
                        type:2
        });

        #define_attribute(chb_flag,{
                        label: "Chronic HepB",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(c_s_cngr_lbl,{
                        label: "Chronic HepB : Coding vs Serology",
                        is_reportable:1,
                        type:1
        });
        #define_attribute(rx_av_lbl,{
                        label: "Chronic HepB : Antiviral Agent",
                        is_reportable:1,
                        type:1
        });

        #define_attribute(ss,{
                        label: "Chronic HepB : Serological Status Code",
                        is_reportable:1,
                        type:2
        });


        #define_attribute(hbv_status_lbl,{
                        label: "Chronic HepB : Serological Status Label",
                        is_reportable:1,
                        type:1
        });

        #define_attribute(cs,{
                        label: "Chronic HepB : Coded Status Code",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(hepb_status_lbl,{
                        label: "Chronic HepB : Coded Status Label",
                        is_reportable:1,
                        type:1
        });
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);
    COMMIT;
    -- END OF RULEBLOCK --
    
END;