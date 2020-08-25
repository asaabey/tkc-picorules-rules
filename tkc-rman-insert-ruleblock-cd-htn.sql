CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_htn';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess hypertension  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess hypertension",                
                is_active:2
                
            }
        );
        
        #doc(,
            {
                txt:"Calculate information entropy"
            }
        );
        
        
        iq_sbp => eadv.obs_bp_systolic.val.count(0).where(dt>sysdate-730);
        
        iq_tier : {iq_sbp>1 => 2},{iq_sbp>0 => 1},{=>0};
        
        #doc(,
            {
                section: "Diagnosis",
            }
        );
        
        #doc(,
            {
                txt:"Hypertension diagnosis: code criteria"
            }
        );
       
        
        htn_icd => eadv.[icd_i10%,icd_i15%].dt.count(0);
        htn_icpc => eadv.[icpc_k85%,icpc_k86%,icpc_k87%].dt.count(0);
        
        #doc(,
            {
                txt:"Hypertension diagnosis: observation criteria at least 3 readings over SBP140 within 2 years",
                cite:"htn_nhf_2016,htn_aha_2018,htn_mja_2016"
            }
        );
        
        htn_obs => eadv.obs_bp_systolic.val.count(0).where(val>140 and dt>sysdate-730);
        
        #doc(,
            {
                txt:"Ancillary information for causality"
            }
        );
        
        
        bld_k_val => eadv.lab_bld_potassium.val.last().where(dt>sysdate-730);
        
        bld_k_state : {nvl(bld_k_val,0)>5.2 =>3},{nvl(bld_k_val,0)>4.0 =>2},{=>1};
        
        #doc(,
            {
                txt:"Hypertension diagnosis: treatment criteria based on RxNorm medication codes"
            }
        );
        
        htn_rxn_acei => eadv.[rxnc_c09aa].dt.count(0).where(val=1);
        htn_rxn_arb => eadv.[rxnc_c09ca].dt.count(0).where(val=1);
        htn_rxn_bb => eadv.[rxnc_c07%].dt.count(0).where(val=1);
        htn_rxn_ccb => eadv.[rxnc_c08%].dt.count(0).where(val=1);
        htn_rxn_c02 => eadv.[rxnc_c02%].dt.count(0).where(val=1);
        htn_rxn_diuretic_thiaz => eadv.[rxnc_c03aa].dt.count(0).where(val=1);
        htn_rxn_diuretic_loop => eadv.[rxnc_c03c%].dt.count(0).where(val=1);
        
        htn_rxn_raas : { greatest(htn_rxn_acei,htn_rxn_arb)>0 =>1},{=>0};
        
        htn_rxn : { coalesce(htn_rxn_acei, htn_rxn_arb, htn_rxn_bb, htn_rxn_ccb , htn_rxn_c02 , htn_rxn_diuretic_thiaz , htn_rxn_diuretic_loop) is not null =>1 },{=>0};
        
        #doc(,
            {
                section: "Complications"
            }
        );
        
        
        #doc(,
            {
                txt:"Hypertension diagnosis: vintage or date of onset"
            }
        );
        
        
        htn_fd_code => eadv.[icd_i10%,icd_i15%,icpc_k85%,icpc_k86%,icpc_k87%].dt.min();
        htn_fd_obs => eadv.obs_bp_systolic.dt.min().where(val>140);
        
        htn_fd : {coalesce(htn_fd_code,htn_fd_obs) is not null => least(nvl(htn_fd_code,to_date(`01012999`,`DDMMYYYY`)),nvl(htn_fd_obs,to_date(`01012999`,`DDMMYYYY`)))};
        
        htn_fd_yr : { htn_fd is not null => to_char(htn_fd,`YYYY`) };
        
        htn_type_2 => eadv.[icd_i15_%].dt.count(0);
        
        htn_from_obs : { htn_fd_obs<htn_fd_code =>1},{htn_fd_obs!? and htn_fd_code? =>1},{=>0};
        
        #doc(,
            {
                txt:"Hypertension chronology"
            }
        );
        
        
        htn_vintage_yr_ : { htn_fd is not null => round((sysdate-htn_fd)/365,0)},{=>0};
        
        htn_vintage_cat : { htn_vintage_yr_>=0 and htn_vintage_yr_ <10 => 1 },
                            { htn_vintage_yr_>=10 and htn_vintage_yr_ <20 => 2 },
                            { htn_vintage_yr_>=20=> 3 },{=>0};
        
        
        #doc(,
            {
                section: "Management"
            }
        );
        #doc(,
            {
                txt:"BP control : Assessing BP control in past 2 years: time  Proportion? outside of target range SBP >140",
                cite:"htn_plos_2018"
            }
        );
        
        
        sigma_2 => eadv.obs_bp_systolic.val.count().where(dt>=sysdate-730 and dt<sysdate-365); 
        mu_2 => eadv.obs_bp_systolic.val.avg().where(dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        slice140_2_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-730 and dt<sysdate-365);
        
        sigma_1 => eadv.obs_bp_systolic.val.count().where(dt>=sysdate-365); 
        mu_1 => eadv.obs_bp_systolic.val.avg().where(dt>=sysdate-365); 
        slice140_1_n => eadv.obs_bp_systolic.val.count(0).where(val>=140 and dt>=sysdate-365);
        slice140_1_mu => eadv.obs_bp_systolic.val.avg().where(val>=140 and dt>=sysdate-365);
        
        
        sbp_outdated : {nvl(greatest(sigma_2,sigma_1),0)=0 => 1},{=>0};
        
        #doc(,
            {
                txt:"BP control: Time in therapeutic range"
            }
        );
        
        sbp_max_2y => eadv.obs_bp_systolic.val.max().where(dt>=sysdate-730);
        
        sbp_min_2y => eadv.obs_bp_systolic.val.min().where(dt>=sysdate-730);
        
        sbp_target_max : {1=1 => 140};
        
        sbp_target_min : {1=1 => 100};
        
        n_qt_1 : {sigma_1>0 => 1-round(slice140_1_n/sigma_1,1)};
        
        mu_qt : {slice140_2_mu>0 =>round(slice140_1_mu/slice140_2_mu,2)};
        
        bp_trend : { mu_qt <0.9 => 1 },{ mu_qt > 1.1 => 2},{=>0};
        
        bp_control : { n_qt_1 >=0.75 => 3},{ n_qt_1<0.75 and n_qt_1>=0.25 => 2 },{ n_qt_1<0.25 => 1},{=>0};
        
        
        
        htn : {greatest(htn_icd,htn_icpc)>0 or htn_obs>2 =>1},{=>0};
        
        [[rb_id]] : {.=> htn};
        
        htn_dx_uncoded : {htn_obs>=3 and greatest(htn_icd,htn_icpc)=0 => 1},{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Hypertension",
                desc:"Presence of Hypertension",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    -- END OF RULEBLOCK --
    

  
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_htn_rcm';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess hypertension pharmacology recommendations */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess hypertension pharmacology recommendations",                
                is_active:2
                
                
            }
        );
        
       
        
        ckd => rout_ckd.ckd.val.bind();
        
        htn => rout_cd_htn.cd_htn.val.bind();
        
        bpc => rout_cd_htn.bp_control.val.bind();
        
        cad => rout_cd_cardiac_cad.cad.val.bind();
        #doc(,
            {
                txt:"Gather existing medications",
                cite:"htn_tga_2019,htn_jnc_2014"
            }
        );
        
        
        

        acei => eadv.[rxnc_c09aa].dt.count(0).where(val=1);
        arb => eadv.[rxnc_c09ca].dt.count(0).where(val=1);
        bb => eadv.[rxnc_c07%].dt.count(0).where(val=1);
        ccb => eadv.[rxnc_c08%].dt.count(0).where(val=1);
        c02 => eadv.[rxnc_c02%].dt.count(0).where(val=1);
        thiaz => eadv.[rxnc_c03aa].dt.count(0).where(val=1);
        loop => eadv.[rxnc_c03c%].dt.count(0).where(val=1);
        mrb  => eadv.[rxnc_c03da].dt.count(0).where(val=1);
        
        #doc(,
            {
                txt:"Determine potential complications (Needs more work)",
                cite:"htn_rcm_compmethods_2000,htn_rcm_amia_2017"
            }
        );
        
        
        k_val => eadv.lab_bld_potassium.val.last().where(dt>sysdate-730);
        
        k_state : {nvl(k_val,0)>5.2 =>3},{nvl(k_val,0)>4.0 =>2},{=>1};
        
        
        
        raas : { greatest(acei,arb)>0 =>1 },{=>0};
        
        rx_line : { greatest(acei,arb,ccb,bb,c02,thiaz,loop,mrb)=0 =>0},
                    { raas=1 and greatest(ccb,bb,c02,thiaz,loop,mrb)=0 =>1},
                    { raas=1 and ccb>0 and greatest(bb,c02,thiaz,loop,mrb)=0 =>2},
                    { raas=1 and ccb>0 and thiaz>0 and greatest(bb,c02,loop,mrb)=0 =>3};
                    
        #doc(,
            {
                txt:"Treatment recommendation as a code",
                cite:"htn_rcm_amh_2019"
            }
        );
        
        [[rb_id]] :   { htn=1 and bpc>1 and raas=0 and k_state<3 => 11 },
                    { htn=1 and bpc>1 and raas=0 and k_state=3 and ccb=0 => 12 },
                    { htn=1 and bpc>1 and raas=1 and ccb=0 => 22 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=0 and k_state>1 => 33 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=0 and k_state=1 => 34 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=1 and k_state<3 => 44 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=1 and k_state=3 => 35 },
                    { htn=1 and bpc>1 and raas=1 and ccb=1 and thiaz=1 and mrb=1 => 55 },
                    {htn=1 and bpc>1 =>99},
                    {=>0};

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
        
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_htn_bp_control';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess blood pressure control */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess blood pressure control ",                
                is_active:0
                
                
            }
        );
        
       

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
   
END;





