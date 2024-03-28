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
                
        /* Hep B Serology */
                
        ss => rout_cd_hep_b_sero.hbv_status.val.bind();
                
        sp => rout_cd_hep_b_sero.hbv_phase.val.bind();
        
        vl_val => rout_cd_hep_b_sero.vl_val.val.bind();
        
        vl_dt => rout_cd_hep_b_sero.vl_dt.val.bind();
        
        
        
        /* cd_hepb_coded */
        
        cs => rout_cd_hepb_coded.hepb_status.val.bind();
        
        rx => rout_cd_hepb_coded.rx_av_ld.val.bind();
        
        ck : {. => (coalesce(cs,0) * 1000) + (coalesce(ss,0) * 100) + coalesce(sp,0)};
        
        rx_entecavir => rout_rx_av_nrti.entecavir.val.bind();
                
        rx_tenofovir => rout_rx_av_nrti.tenofovir.val.bind();
                
        rx_lamivudine => rout_rx_av_nrti.lamivudine.val.bind();
                
        rx_adefovir => rout_rx_av_nrti.adefovir.val.bind();
                
        rx_av : { rx_entecavir!? => 1},{ rx_tenofovir!? => 2},{ rx_lamivudine!? => 3},{ rx_adefovir!? => 4};
                
        rx_av_lbl : {rx_av =1 => `Entecavir based`},{rx_av =2 => `Tenofovir based`},{rx_av =3 => `Lamivudine based`},{rx_av =4 => `Adefovir based`};
                
                
        c_s_cngr : { cs in (20,21) and ss in (1,6) => 1000},
                   { cs in (20,21) and ss not in (1,6) => 1010},{ cs not in (20,21) and ss in (1,6) => 1011 };
                          
        c_s_cngr_lbl : { c_s_cngr=1000 => `Coded and Seropositive`},{ c_s_cngr=1010 => `Coded but Seronegative`},{ c_s_cngr=1011 => `Not Coded but Seropositive`};
                
        chb_flag : {c_s_cngr in (1000,1010,1011)=>1},{=>0};
        cd_hepb_master : {coalesce(ss, sp )!? or cs>1 =>1};
        
        chb_imm_tol_flg : {sp=1 => 1};
        chb_imm_clr_flg : {sp=2 => 1};
        chb_imm_ctr_flg : {sp=3 => 1};
        chb_imm_esc_flg : {sp=4 => 1};

        chb_imm_lbl : {sp=1 => `Immune tolerance phase`},{sp=2 => `Immune clearance phase`},{sp=3 => `Immune control phase`},{sp=4 => `Immune escape phase`};

        #define_attribute(chb_imm_lbl ,{
                        label: "Chronic HepB : Immune Phase",
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
                        label: "Chronic HepB coding match",
                        is_reportable:1,
                        type:1
        });
        #define_attribute(rx_av_lbl,{
                        label: "Chronic HepB antiviral agent",
                        is_reportable:1,
                        type:1
        });
        #define_attribute(ss,{
                        label: "Chronic HepB Serological status",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(sp,{
                        label: "Chronic HepB Phase",
                        is_reportable:1,
                        type:2
        });
        #define_attribute(cs,{
                        label: "Chronic HepB Codeded status",
                        is_reportable:1,
                        type:2
        });
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);
    COMMIT;
    -- END OF RULEBLOCK --
    
END;