CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb RMAN_RULEBLOCKS%ROWTYPE;


BEGIN


    -- BEGINNING OF RULEBLOCK --

--    rb.blockid := 'rx_desc';
--
--    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;
--
--    rb.picoruleblock := '
--    
--        /* Algorithm to assess Medication  */
--        
--            
--             #define_ruleblock([[rb_id]],
--                {
--                    description: "Algorithm to serialize active medications",
--                    
--                    is_active:0
--                    
--                }
--            );
--            
--            
--            rxn_0 => eadv.[rxnc_%].dt.count().where(val=1);
--            
--            rx_name_obj => eadv.rx_desc.val.serialize2();
--            
--            rx_n => eadv.rx_desc.val.count(0);
--            
--            [[rb_id]] : {rx_n>0 =>1},{=>0};
--            
--    ';
--    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
--    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
--    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);
--
--    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_desc_ptr';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
        
        /* Algorithm to assess Medication  */
        
        
         #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to serialize active medications",
                
                is_active:2
                
            }
        );
        
        
        
        
        rx_name_obj => eadv.rx_desc_ptr.val.serialize2();
        
        rx_n => eadv.rx_desc_ptr.val.count();
        
        [[rb_id]] : {coalesce(rx_n,0)>0 =>1},{=>0};
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --


    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_av_nrti';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
        /* Rx: Nucleoside and nucleotide reverse transcriptase inhibitors */

        #define_ruleblock(rx_av_nrti,{
            description: "Rx: Nucleoside and nucleotide reverse transcriptase inhibitors",
            is_active:2
        });

        /*
        +--------------------------------------+---------+
        |       Clinical Drug Component        |  RXCUI  |
        +--------------------------------------+---------+
        | Entecavir 0.5 MG                     |  485432 |
        | Entecavir 1 MG                       |  485435 |
        | Tenofovir Disoproxil Fumarate 300 MG |  393334 |
        | Tenofovir Alafenamide 25 MG          | 1741729 |
        | Lamivudine 150mg                     |  316127 |
        | Lamivudine 100mg                     |  317397 |
        | Adefovir Dipivoxil 10 MG             |  881340 |
        +--------------------------------------+---------+
        */

        entecavir_0_5 => eadv.[rxn_cui_485432].dt.last();
        entecavir_1_0 => eadv.[rxn_cui_485435].dt.last();

        entecavir : { coalesce(entecavir_0_5,entecavir_1_0)!? =>1};

        tenofovir_dpf_300 => eadv.[rxn_cui_393334].dt.last();
        tenofovir_alf_25 => eadv.[rxn_cui_1741729].dt.last();

        tenofovir : { coalesce(tenofovir_dpf_300,tenofovir_alf_25)!? =>1};

        lamivudine_100 => eadv.[rxn_cui_317397].dt.last();
        lamivudine_150 => eadv.[rxn_cui_316127].dt.last();

        lamivudine : { coalesce(lamivudine_100,lamivudine_150)!? => 1};

        adefovir_dip => eadv.[rxn_cui_881340].dt.last();

        adefovir : { adefovir_dip!? =>1};

        rx_av_nrti : { coalesce(entecavir,tenofovir,lamivudine,adefovir)!? => 1 },{=>0};
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --

    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_cv_common';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
        /* Rx: Common cardiac drugs */
        
        
        #define_ruleblock(rx_cv_common,{
                description: "Rx: Common cardiac drugs",
                is_active:2
        });
        
        /* ACEi and ARB single */
        #doc(,{txt:"ARB"});
        
        /* Irbesartan*/
        irb_75 => eadv.[rxn_cui_316100].dt.last();
        irb_150 => eadv.[rxn_cui_316098].dt.last();
        irb_300 => eadv.[rxn_cui_316099].dt.last();
        
        irb : {coalesce(irb_75,irb_150,irb_300)!? =>1};
        
        
        #doc(,{txt:"ACEI"});
        /* Perindopril */
        /* Perindopril arginine not available in US pharmacopia */
        /* Using codes for doses 3.5, 7 and 14 */
        per_2_5 => eadv.[rxn_cui_1600723].dt.last();
        per_5 => eadv.[rxn_cui_1600727].dt.last();
        per_10 => eadv.[rxn_cui_1600712].dt.last();
        
        per : {coalesce(per_2_5,per_5,per_10)!? =>1};
        
        /* Ramipril */
        ram_2_5 => eadv.[rxn_cui_316628].dt.last();
        ram_5 => eadv.[rxn_cui_317482].dt.last();
        ram_10 => eadv.[rxn_cui_316627].dt.last();
        
        ram : {coalesce(ram_2_5,ram_5,ram_10)!? =>1};
        
        #doc(,{txt:"CCB"});
        /* Amlodipine */
        amlo_5 => eadv.[rxn_cui_329528].dt.last();
        amlo_10 => eadv.[rxn_cui_329526].dt.last();
        
        amlo :{ coalesce(amlo_5, amlo_10)!?=>1};
        
        
        #doc(,{txt:"Beta blockers"});
        /* Metoprolol succinate */
        /* Dosing not available in US pharmacopia */
        /* Using 25, 5,100, 200 */
        mtprl_xr_23_75 => eadv.[rxn_cui_1370489].dt.last();
        mtprl_xr_47_5 => eadv.[rxn_cui_1370474].dt.last();
        mtprl_xr_95 => eadv.[rxn_cui_1370483].dt.last();
        mtprl_xr_190 => eadv.[rxn_cui_1370500].dt.last();
        
        mtprl_50 => eadv.[rxn_cui_866435].dt.last();
        mtprl_100 => eadv.[rxn_cui_866411].dt.last();
        
        mtprl : { coalesce(mtprl_xr_23_75,mtprl_xr_47_5,mtprl_xr_95 , mtprl_xr_190, mtprl_50, mtprl_100)!? =>1};
        
        /* Bisoprolol */
        bis_2_5 => eadv.[rxn_cui_854915].dt.last();
        bis_5 => eadv.[rxn_cui_854904].dt.last();
        bis_10 => eadv.[rxn_cui_854900].dt.last();
        
        bis : { coalesce(bis_2_5,bis_5, bis_10 )!? => 1};
        
        /* Atenolol */
        atn_50 => eadv.[rxn_cui_315438].dt.last();
        
        atn : {atn_50!? =>1};
        
        /* Carvedilol */
        carv_6_25 => eadv.[rxn_cui_315577].dt.last();
        carv_12_5 => eadv.[rxn_cui_315575].dt.last();
        carv_25 => eadv.[rxn_cui_315576].dt.last();
        
        carv : { coalesce(carv_6_25, carv_12_5, carv_25)!?=>1};
        
        /* Diuretics */
        fru_20 => eadv.[rxn_cui_315970].dt.last();
        fru_40 => eadv.[rxn_cui_315971].dt.last();
        fru_500 => eadv.[rxn_cui_331965].dt.last();
        
        fru : { coalesce(fru_20, fru_40, fru_500)!? =>1};
        
        /* Nitrates */
        ismn_60  =>  eadv.[rxn_cui_381044].dt.last();
        ismn_120  =>  eadv.[rxn_cui_353420].dt.last();
        
        ismn : { coalesce(ismn_60, ismn_120)!? => 1};
        
        rx_cv_common : {coalesce(irb, per, ram, amlo, mtprl, atn, bis, carv, fru, ismn)!? =>1},{=>0};
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --

    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_is_sot';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
        /* Rx: Immunosuppresion for Solid organ Transplant */
        
        
        #define_ruleblock(rx_is_sot,{
                description: "Rx: Immunosuppresion for Solid organ Transplant",
                is_active:2
        });
        
        
        #doc(,{txt:"Tacrolimus"});
        
        tac_0_5_ir => eadv.[rxn_cui_330404].dt.last();
        
        tac_1_ir => eadv.[rxn_cui_42316].dt.last();
        
        tac : {coalesce(tac_0_5_ir,tac_1_ir)!? =>1};
        
        
        #doc(,{txt:"Everolimus"});
        
        evl_0_5 => eadv.[rxn_cui_977437].dt.last();
        
        evl_0_75 => eadv.[rxn_cui_977437].dt.last();
        
        evl_1 => eadv.[rxn_cui_2056894].dt.last();
        
        evl_5 => eadv.[rxn_cui_845514].dt.last();
        
        evl : {coalesce(evl_0_5,evl_0_75,evl_1,evl_5)!? =>1};
        
        
        #doc(,{txt:"MMF"});
        
        mmf_250 => eadv.[rxn_cui_316316].dt.last();
        
        mmf_500 => eadv.[rxn_cui_316317].dt.last();
        
        mmf : {coalesce(mmf_250,mmf_500)!? =>1};
        
        
        #doc(,{txt:"Prednisolone"});
        
        prd_1 => eadv.[rxn_cui_333209].dt.last();
        
        prd_5 => eadv.[rxn_cui_316579].dt.last();
        
        prd_25 => eadv.[rxn_cui_333210].dt.last();
        
        prd : {coalesce(prd_1,prd_5,prd_25)!? =>1};
        
        
        rx_is_sot : {coalesce(tac,evl,mmf,prd)!? =>1},{=>0};
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --

    -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'rx_rrt_common';

    DELETE FROM rman_ruleblocks WHERE blockid = rb.blockid;

    rb.picoruleblock := '
        /* Rx: Common renal drugs */
        
        
        #define_ruleblock(rx_rrt_common,{
                description: "Rx: Common renal drugs",
                is_active:2
        });
        
        
        #doc(,{txt:"Calcitriol"});
        
        d3_0_25 => eadv.[rxn_cui_315513, rxn_cui_308867].dt.last();
        
        d3 : {d3_0_25!? =>1};
        
        
        #doc(,{txt:"Calcium carbonate"});
        
        cal_600 => eadv.[rxn_cui_328936].dt.last();
        
        cal : {cal_600!? =>1};
        
        
        #doc(,{txt:"Sevelamer"});
        
        sev_hcl => eadv.[rxn_cui_857223].dt.last();
        
        sev_co3 => eadv.[rxn_cui_749204].dt.last();
        
        sev : {coalesce(sev_hcl,sev_co3)!? =>1};
        
        
        #doc(,{txt:"Pantoprazole"});
        
        pnt_20 => eadv.[rxn_cui_336764].dt.last();
        pnt_40 => eadv.[rxn_cui_330396].dt.last();
        
        pnt : {coalesce(pnt_20,pnt_40)!? =>1};
        
        #doc(,{txt:"Bactrim"});
        
        bac_800_160 => eadv.[rxn_cui_198335].dt.last();
        
        bac : {bac_800_160!? =>1};
        
        #doc(,{txt:"Patiromer"});
        
        pat => eadv.[rxn_cui_1716205,rxn_cui_1716216].dt.last();
        
        rx_rrt_common : {coalesce(d3,cal,sev,pnt,bac)!? =>1},{=>0};
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;
