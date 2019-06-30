CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_2_1';
    rb.target_table:='rout_rrt';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='rrt';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to calculate dx information quantity*/

        hd_dt => eadv.[caresys_13100_00,icpc_u59001,icpc_u59008,icd_z49_1].dt.max(1900); 
        pd_dt => eadv.[caresys_13100_06,caresys_13100_07,caresys_13100_08,icpc_u59007,icpc_u59009,icd_z49_2].dt.max(1900);
        tx_dt => eadv.[icpc_u28001,icd_z94%].dt.max(1900);
        homedx_dt => eadv.[icpc_u59j99].dt.max(1900);
        
        rrt:{hd_dt > greatest(pd_dt,tx_dt,homedx_dt) => 1},
            {pd_dt > greatest(hd_dt,tx_dt,homedx_dt) => 2},
            {tx_dt > greatest(hd_dt,pd_dt,homedx_dt) => 3},
            {homedx_dt > greatest(hd_dt,pd_dt,tx_dt) => 4},
            {=>0};
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_2_1';
    rb.target_table:='rout_ckd';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='ckd';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to stage CKD */

        /*  External bindings    */
        rrt => rout_rrt.rrt.val.bind();
        cp_ckd => rout_careplan.cp_ckd.val.bind();
        
        cp_ckd_ld => rout_careplan.cp_ld.val.bind();
        
        /* calculate dx information quantity*/
        iq_uacr => eadv.lab_ua_acr.val.count(0);
        iq_egfr => eadv.lab_bld_egfr_c.val.count(0);
        iq_coding => eadv.[icd_%,icpc_%].dt.count(0);
        
        iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4},
                {least(iq_egfr,iq_uacr)>=2 => 3},
                {least(iq_egfr,iq_uacr)>=1 => 2},
                {iq_egfr>0 or iq_uacr>0 => 1},
                {=>0};
        
        
        /*  egfr metrics */
        egfrlv => eadv.lab_bld_egfr_c.val.last();
        egfrld => eadv.lab_bld_egfr_c.dt.max();
        
        egfrfv => eadv.lab_bld_egfr_c.val.first();
        egfrfd => eadv.lab_bld_egfr_c.dt.min();
        
        egfr_single:{ iq_egfr=1 =>1},{=>0};
        egfr_multiple:{ iq_egfr>1 =>1},{=>0};
        egfr_outdated:{ (sysdate-egfrld>730) =>1},{=>0};
        
        egfr_tspan : {1=1 => egfrld-egfrfd};
        
        
        /*  uacr metrics */
        acrlv => eadv.lab_ua_acr.val.last();
        acrld => eadv.lab_ua_acr.dt.max();
        acr_outdated : {sysdate-acrld > 730 =>1},{=>0};
        
        /*  Check for persistence*/
        
        egfr_3m_n => eadv.lab_bld_egfr_c.val.count(0).where(dt<egfrld-90 and val<60);
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt<acrld-30 and val>3);
        
        pers : {least(egfr_3m_n,acr_3m_n)>0 => 1},{=>0};
        
        
        
        /*  check for egfr assumption violation */
        
        egfr_3m_n2 => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfrld-30);
        egfr_3m_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfrld-30);
        
        egfr_3m_qt : {egfr_3m_n2>=2 => round(egfrlv/egfr_3m_mu,2)};
        
        
        
        /* egfr slope */
        egfr_max_v => eadv.lab_bld_egfr_c.val.max();
        egfr_max_ld => eadv.lab_bld_egfr_c.dt.max().where(val=egfr_max_v);
        egfr_ld_max_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt>egfr_max_ld and dt<egfrld);
        
        egfr_slope2 : {egfrld>egfr_max_ld => round((egfrlv-egfr_max_v)/((egfrld-egfr_max_ld)/365),2)};
        
        egfr_decline : {egfrld - egfr_max_ld>365 and egfr_ld_max_n>2 and egfr_max_v-egfrlv>=20 => 1},{=>0};
        
        egfr_rapid_decline : { egfr_decline=1 and egfr_slope2<-10 =>1},{=>0};
        
                
        /*  Apply KDIGO 2012 staging    */
        
        cga_g:  {egfrlv>=90 AND rrt=0 => `G1`},
                {egfrlv<90 AND egfrlv>=60  AND rrt=0 => `G2`},
                {egfrlv<60 AND egfrlv>=45  AND rrt=0 => `G3A`},
                {egfrlv<45 AND egfrlv>=30  AND rrt=0 => `G3B`},
                {egfrlv<30 AND egfrlv>=15  AND rrt=0 => `G4`},
                {egfrlv<15 AND rrt=0 => `G5`},
                {=>`NA`};
            
        cga_a: {acrlv<3 => `A1`},
                {acrlv<30 AND acrlv>=3 => `A2`},
                {acrlv<300 AND acrlv>=30 => `A3`},
                {acrlv>300 => `A4`},{=>`NA`};
        
        asm_viol_3m : {nvl(egfr_3m_qt,1)>1.2 or nvl(egfr_3m_qt,1)<0.8  => 1},{=> 0};
        
        ckd_stage :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => `1`},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => `2`},
                {cga_g=`G3A` => `3A`},
                {cga_g=`G3B` => `3B`},
                {cga_g=`G4` => `4`},
                {cga_g=`G5` => `5`},
                {=> null};
        
        ckd :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => 1},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => 2},
                {cga_g=`G3A` => 3},
                {cga_g=`G3B` => 4},
                {cga_g=`G4` => 5},
                {cga_g=`G5` => 6},
                {=> 0};
        
        /*  ICPC2+ coding , note that val has to set to ordered rank*/
        dx_ckd0  => eadv.[icpc_u990%].val.last();
        dx_ckd : {1=1 => nvl(dx_ckd0,0)};
        
        dx_ckd_stage :{dx_ckd=1 => `1`},
                {dx_ckd=2 => `2`},
                {dx_ckd=3 => `3A`},
                {dx_ckd=4 => `3B`},
                {dx_ckd=5 => `4`},
                {dx_ckd=6 => `5`},
                {dx_ckd=0=> null};
        
        dx_ckd_diff :{abs(ckd-dx_ckd)>=2 => 1 },{=>0};
        
        /* Encounters with specialist services */
        enc_n => eadv.enc_op_renal.dt.count();
        enc_ld => eadv.enc_op_renal.dt.max();
        enc_fd => eadv.enc_op_renal.dt.min();
        
        enc_null : {nvl(enc_n,0)=0 => 0},{=>1};
        
        /*  AVF creation    */
        avf => eadv.caresys_3450901.dt.max();
        
        cp_mis :{cp_ckd>0 and (ckd - cp_ckd)>=2 => 1},{=>0};
        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_cause_2_1';
    rb.target_table:='rout_ckd_cause';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='aet_code';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
     /* Rule block to determine causality for CKD */ 
     
     /* External bindings */ 
     dm => rout_cd_dm.dm.val.bind(); 
     htn => rout_cd_htn.htn.val.bind(); 
     ckd => rout_ckd.ckd.val.bind(); 
     
     /* calculate dx information quantity 
     iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-730); 
     iq_egfr => eadv.lab_bld_egfr_c.val.count(0).where(dt>sysdate-730); 
     iq_coding => eadv.[icd_%,icpc_%].dt.count(0); 
     iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4}, {least(iq_egfr,iq_uacr)>=2 => 3}, {least(iq_egfr,iq_uacr)>=1 => 2}, {iq_egfr>0 or iq_uacr>0 => 1}, {=>0}; 
     */ 
     
     gn_ln => eadv.icd_m32_14.dt.count(0); 
     gn_x => eadv.[icd_n0%,icpc_u88%].dt.count(0); 
     
     aet_dm : {ckd>0 and dm>0 =>1},{=>0};
     aet_htn : {ckd>0 and htn>0 =>1},{=>0};
     aet_gn_ln : {ckd>0 and gn_ln>0 =>1},{=>0};
     aet_gn_x : {ckd>0 and gn_x>0 =>1},{=>0};

     aet_cardinality : { ckd>0 => aet_dm + aet_htn + aet_gn_ln + aet_gn_x };
     
     aet_multiple : { ckd>0 and aet_cardinality >1 => 1},{=>0};
     
     aet_code : { ckd>0 => ( aet_dm * 1000000)+(aet_htn * 100000)+(aet_gn_ln * 10000)+(aet_gn_x * 1000) },{=>0};
     
     
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_journey_2_1';
    rb.target_table:='rout_ckd_journey';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='ckdj';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine journey of CKD */

        /*  External bindings    */
        ckd => rout_ckd.ckd.val.bind();
        cp_ckd => rout_careplan.cp_ckd.val.bind();
        
        enc_ld => rout_ckd.enc_ld.val.bind();
        
        enc_fd => rout_ckd.enc_fd.val.bind();
        
        enc_n => rout_ckd.enc_n.val.bind();
        
        avf_ld => rout_ckd.avf.val.bind();
        
        cp_ckd_ld => rout_careplan.cp_ld.val.bind();
        
        /*  Nursing and allied health encounters    */
        
        edu_init => eadv.enc_op_renal_edu.dt.min().where(val=31);
        
        edu_rv => eadv.enc_op_renal_edu.dt.max().where(val=32);
        
        edu_n => eadv.enc_op_renal_edu.dt.count().where(val=31 or val=32);
        
        /* edu_plan => eadv.enc_op_renal_edu.val.first().where(val=35); */
        
        dietn => eadv.enc_op_renal_edu.dt.max().where(val=61);
        
        sw => eadv.enc_op_renal_edu.dt.max().where(val=51);
        
        enc_multi : { nvl(enc_n,0)>1 =>1},{=>0};
        
        ckdj : { coalesce(edu_init, edu_rv,enc_fd) is not null => 1},{=>0};
        
        
        
        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_diagnostics_2_1';
    rb.target_table:='rout_ckd_diagnostics';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='ckd_dx';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine diagnostics */

        /*  External bindings    */
        ckd => rout_ckd.ckd.val.bind();
        acr_lv => rout_ckd.acrlv.val.bind();
        
        
        
        ua_rbc_lv => eadv.[lab_ua_rbc,lab_ua_poc_rbc].val.last();
        ua_rbc_ld => eadv.[lab_ua_rbc,lab_ua_poc_rbc].dt.max();
        
        ua_wcc_lv => eadv.[lab_ua_leucocytes,lab_ua_poc_leucocytes].val.last();
        ua_wcc_ld => eadv.[lab_ua_leucocytes,lab_ua_poc_leucocytes].dt.max();
                
        sflc_kappa_lv => eadv.lab_bld_sflc_kappa.val.last();
        sflc_lambda_lv => eadv.lab_bld_sflc_lambda.val.last();
        sflc_kappa_ld => eadv.lab_bld_sflc_kappa.dt.max();
        sflc_lambda_ld => eadv.lab_bld_sflc_lambda.dt.max();
        
        paraprot_lv => eadv.lab_bld_spep_paraprotein.val.last();
        paraprot_ld => eadv.lab_bld_spep_paraprotein.dt.max();
        
        pr3_lv => eadv.lab_bld_anca_pr3.val.last();
        mpo_lv => eadv.lab_bld_anca_mpo.val.last();
        pr3_ld => eadv.lab_bld_anca_pr3.dt.max();
        mpo_ld => eadv.lab_bld_anca_mpo.dt.max();
        
        dsdna_lv => eadv.lab_bld_dsdna.val.last();
        dsdna_ld => eadv.lab_bld_dsdna.dt.max();
        
        c3_lv => eadv.lab_bld_complement_c3.val.last();
        c4_lv => eadv.lab_bld_complement_c4.val.last();
        
        c3_ld => eadv.lab_bld_complement_c3.dt.max();
        c4_ld => eadv.lab_bld_complement_c4.dt.max();
        
        ris_usk_ld => eadv.enc_ris_usk.dt.max();
        ris_bxk_ld => eadv.enc_ris_bxk.dt.max();
        
        c3_pos : { nvl(c3_lv,0)<0.2 and nvl(c3_lv,0)>0 => 1},{=>0};
        c4_pos : { nvl(c4_lv,0)<0.2 and nvl(c4_lv,0)>0 => 1},{=>0};
        
        dsdna_pos : { nvl(dsdna_lv,0)>6 => 1},{=>0};
        sflc_ratio : { nvl(sflc_lambda_lv,0)>0 => round(nvl(sflc_kappa_lv,0)/sflc_lambda_lv,2)},{=1};
        
        sflc_ratio_abn : {sflc_ratio<0.26 or sflc_ratio>1.65 =>1 },{=>0};
        
        ua_rbc_pos : {nvl(ua_rbc_lv,0)>=30 =>1},{=>0};
        ua_wcc_pos : {nvl(ua_wcc_lv,0)>=30 =>1},{=>0};
        ua_acr_pos : {nvl(acr_lv,0)>30 =>1},{=>0};
        
        ua_null : { ua_rbc_ld is null => 1},{=>0};
        sflc_null : { sflc_kappa_ld is null =>1},{=>0};
        spep_null : { paraprot_ld is null =>1},{=>0};
        dsdna_null : { dsdna_ld is null =>1},{=>0};
        anca_null : {  pr3_ld is null =>1},{=>0};
        c3c4_null : {  c3_ld is null =>1},{=>0};
        
        
        ua_pos : { ua_rbc_pos=1 and ua_wcc_pos=0 and ua_acr_pos=1 =>1 },
                { ua_rbc_pos=1 and ua_wcc_pos=1 => 2 },
                {=>0};
        
        usk_null : { ris_usk_ld is null =>1},{=>0};
        bxk_null : { ris_bxk_ld is null =>1},{=>0};
        
        
        ckd_dx : {ckd>=1 => 1},{=>0};
     
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_complications_2_1';
    rb.target_table:='rout_ckd_complications';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='ckd_compx';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine diagnostics */

        /*  External bindings    */
        ckd => rout_ckd.ckd.val.bind();
        
        
        hb_lv => eadv.lab_bld_hb.val.last();
        hb_ld => eadv.lab_bld_hb.dt.max();
        
        plt_lv => eadv.lab_bld_platelets.val.last();
        
        wcc_neut_lv => eadv.lab_bld_wcc_neutrophils.val.last();
        wcc_eos_lv => eadv.lab_bld_wcc_eosinophils.val.last();
        
        rbc_mcv_lv => eadv.lab_bld_rbc_mcv.val.last();
        
        esa_lv => eadv.rxnc_b03xa.val.last();
        esa_ld => eadv.rxnc_b03xa.dt.max();
        
        k_lv => eadv.lab_bld_potassium.val.last();
        k_ld => eadv.lab_bld_potassium.dt.max();
        
        
        ca_lv => eadv.lab_bld_calcium_corrected.val.last();
        ca_ld => eadv.lab_bld_calcium_corrected.val.last();
        
        phos_lv => eadv.lab_bld_phosphate.val.last();
        hco3_lv => eadv.lab_bld_bicarbonate.val.last();
        
        alb_lv => eadv.lab_bld_albumin.val.last();
        
        pth_lv => eadv.lab_bld_pth.val.last();
        pth_ld => eadv.lab_bld_pth.val.last();
        
        fer_lv => eadv.lab_bld_ferritin.val.last();
        fer_ld => eadv.lab_bld_ferritin.dt.max();
        
        /*  Haematenics */
        
        hb_state : { nvl(hb_lv,0)>0 and nvl(hb_lv,0)<100 =>1},
                    { nvl(hb_lv,0)>=100 and nvl(hb_lv,0)<180 =>2},
                    { nvl(hb_lv,0)>180 =>3},
                    {=>0};
                    
        mcv_state : { hb_state=1 and nvl(rbc_mcv_lv,0)>0 and nvl(rbc_mcv_lv,0)<70 => 11 },
                    { hb_state=1 and nvl(rbc_mcv_lv,0)>=70 and nvl(rbc_mcv_lv,0)<80 => 12 },
                    { hb_state=1 and nvl(rbc_mcv_lv,0)>=80 and nvl(rbc_mcv_lv,0)<=100 => 20 },
                    { hb_state=1 and nvl(rbc_mcv_lv,0)>=100 => 31 },{ =>0};
                    
        iron_low : { hb_state=1 and nvl(fer_lv,0)>0 and nvl(fer_lv,0)<250 => 1},{=>0};
        
        thal_sig : {mcv_state=11 =>1 },{=>0};
        
        esa_null : { esa_lv is null=>1},{=>0};
        
        esa_state : { esa_null=0 and esa_lv=1 => 1},{ esa_null=0 and esa_lv=0 => 2},{=>0};
        
        /*  CKD-MBD */
        
        phos_null : {phos_lv is null =>1},{=>0};
        phos_high : {phos_null=0 and phos_lv>=2 =>1},{=>0};
        
        k_null : {k_lv is null =>1},{=>0};
        k_high : {k_null=0 and k_lv>=6 =>1},{=>0};
        
        pth_null : {pth_lv is null =>1},{=>0};
        pth_high : {pth_null=0 and pth_lv>=72 =>1},{=>0};
        
        hco3_null : {hco3_lv is null =>1},{=>0};
        hco3_low : {hco3_null=0 and hco3_lv<22 =>1},{=>0};
        
        ckd_compx : {ckd>=3 => 1},{=>0};
     
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
END;





