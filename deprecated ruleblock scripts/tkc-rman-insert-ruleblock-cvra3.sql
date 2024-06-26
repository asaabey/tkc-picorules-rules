CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cvra_predict1_aus';  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess CVRA risk based on Aus Predict1*/
        
        #define_ruleblock(cvra_predict1_aus,{
                description: "Ruleblock to assess CVRA risk based on Aus Predict1",
                is_active:0
                
        });
        
        #doc(,{
                txt:"still under development",
                cite:"cvra_hlc_2019,cvra_circ_2018"
        });
        
        
        
        ckd => rout_ckd.ckd.val.bind();
        esrd_risk => rout_ckd.esrd_risk.val.bind();
        dm => rout_cd_dm_dx.dm.val.bind();
        cp_hicvr => rout_cd_careplan.cp_hicvr.val.bind();
        
        
        
        #doc(,{
                txt:"Gather variables including existing assessment demographics and diseases by coding"
        });
        
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        asm_cvra => eadv.asm_cvra.val.lastdv();
        
        age => rout_dmg.age.val.bind();
        
        male => rout_dmg.gender.val.bind();
        
        egfr => eadv.lab_bld_egfr_c.val.last().where(dt > sysdate -365);
        
        acr => eadv.lab_ua_acr.val.last().where(dt > sysdate -365);
        
        
        /*add rout bindings*/
        cvd_prev : { . =>1},{=>0};
        
        hdl => eadv.lab_bld_cholesterol_hdl.val.last();
        
        tc => eadv.lab_bld_cholesterol_total.val.last();
        
        sbp => eadv.obs_bp_systolic.val.last();
        
        smoke0 => eadv.status_smoking_h2_v1.val.last();

        hba1c => eadv.lab_bld_hba1c_ifcc.val.last().where(dt > sysdate -365);
        
        dm_ins => rout_cd_dm_dx.dm_rxn_ins.val.bind();
        
        dm_fd => rout_cd_dm_dx.dm_fd.val.bind();

        bmi => rout_cd_obesity.bmi.val.bind();
        
        af => rout_cd_cardiac_af.af.val.bind();
        
        bplm => rout_cd_htn.htn_rxn.val.bind();
        
        llm_dt => rout_cd_cardiac_rx.rxn_statin.val.bind();
        
        oatm_dt => rout_cd_cardiac_rx.rxn_anticoag.val.bind();
        
        llm : { llm_dt!? => 1},{=>0};
        
        oatm : { oatm_dt!? => 1},{=>0};
        
        
        smoke : {smoke0>=29 =>1},{=>0};
        
        
        
        
        #doc(,{
                txt:"Determine if overide criteria are met",
                cite:"cvra_nsf_2019"
        });
        
        dmckd1 : {dm=1 and ckd>=1 => 1},{=>0};
        dm60 : {dm=1 and age>=60 => 1},{=>0};
        ckd3 : {ckd>=3 => 1},{=>0};
        tc7 : {tc>=7 => 1},{=>0};
        sbp180 : {sbp >=180 => 1},{=>0};
        age74 : {age>74 => 1},{=>0};
        
        /* mock vars*/
        seifa : {.=>2};
        exsm : {smoke0=29 or smoke0=20 => 1},{=>0};
        sm : { smoke0=30 =>1},{=>0};
        
        dm_yr : { dm_fd!? => round((sysdate-dm_fd)/365,0)};
        hdlq : { coalesce(hdl,0)>0 => tc/hdl};
        
        rxbp : {.=> bplm};
        rxlm : {.=> llm};
        rxac : {.=> oatm};
        
        
        acr3 : { acr > 3 and acr<= 30 =>1},{=>0};
        acr30 : { acr > 30 =>1},{=>0};
        
                       
        eq : { .=> 3};
        
        
      
        risk_high_ovr : { greatest(dm60,dmckd1,ckd3,tc7,sbp180,age74,cvd_prev)>0 =>1},{=>0};
        
        age_i : { eq=1  => (age - 53.77579) * 0.0691512},{ eq=2 => (age - 58.47472) * 0.0905192},{ eq=3 => (age - 56.57672) * 0.0510591},{eq=4 => (age - 57.8318) * 0.0607418 }  ;
        
        seifa_t : {eq=1 => (seifa - 2.625575) * .0900502},{eq=2 => (seifa - 2.625575) * 0.0978413},{eq=3 => (seifa - 2.625575) * .0900502},{eq=4 => (seifa - 2.625575) * 0.0900502};
        
        sm_a : {eq=1 => 0.0635803 * exsm},{eq=2 => 0.1162342 * exsm},{eq=3 => 0.318424 * sm},{eq=4 => 0.7319247 * sm};
        
        sm_n : {eq=1 => 0.5782258 * sm},{eq=2 => 0.8235061 * sm},{eq=3 or eq=4 => 0};
        
        af_o : {eq=1 => af * 0.474629},{eq=2 => af * 0.474629},{eq=3 => af * 0.709571},{eq=4 => af * 0.3149766};
        
        dm_s : {eq=1 => dm * 0.5829839 },{eq=2 => dm * 0.6207569 },{eq=3 => (dm_yr - - 5.255285 )* 0.0117042 },{eq=4 => (dm_yr- 5.222868 )* 0.011011 };
        
        var_r : {eq=1 => (sbp - 129.2052) * 0.0139242 },{eq=2 => (sbp - 129.2052) * 0.0114172 },{eq=3 => (bmi - 29.21475) * 0.0156861 },{eq=4 => (bmi - 30.33892) * 0.0112387 } ;
        
        var_l : {eq=1 => (hdlq - 4.325589) * 0.1350063},{eq=2 => (hdlq - 3.641988) * 0.1067098},{eq=3 => (sbp - 131.8995) * 0.004488},{eq=4 => (sbp - 132.2317) * 0.0084873};
        
        var_c : {(eq=1 or eq=2) and rxbp=1=> 1},{eq=3 => (hdlq - 4.267316) * 0.0858267},{eq=4 => (hdlq - 3.882821) * 0.1025064},{=>0};
        
        var_d : {(eq=1 or eq=2) and rxlm=1=> 1},{eq=3 => (egfr - 88.15267) * 0.002239},{eq=4 => (egfr - 88.38233) * 0.0082137},{=> 0};
        
        var_p : {(eq=1 or eq=2) and rxac=1=> 1},{eq=3 => (hba1c - 57.84909) * 0.0065082},{eq=4 => (hba1c - 57.84909) * 0.0065082},{=> 0};
        
        var_h : {eq=1 => (age - 53.77579) * dm * -0.018881},{eq=2 => (age - 58.47472) * dm * -0.0230893},{eq=3 => acr3 * 0.4277236},{eq=4 => acr3 * 0.2030524};
        
        var_u : {eq=1 => -.0001952 * (age - 53.77579) * (sbp - 129.2052)},{eq=2 => -.0002353 * (age - 58.47472) * (sbp - 129.2052)},{eq=3 => acr30 * 0.803022},{eq=4 => acr30 * 0.7023991};
        
        var_g : {eq=1 => -.0054419 * var_c * (sbp - 129.2052)},{eq=2 => -.0066143 * var_c * (sbp - 129.2052)},{eq=3 => dm_ins * 0.3899748},{eq=4 => dm_ins * 0.2966913};
        
        var_m : {eq=1 => age_i + seifa_t + sm_a + sm_n + af_o + dm_s + (27.8406 - 27.8) * 0.0124319 + var_r + var_l + .2676661 * var_c + -.0383788 * var_d + .0981934 * var_p + var_h + var_u + var_g},
                {eq=2 => age_i + seifa_t + sm_a + sm_n + af_o + dm_s + (27.47728 - 27.5) * 0.0057835 + var_r + var_l + 0.3092255 * var_c + -0.0863215 * var_d + 0.1622663 * var_p + var_h + var_u + var_g},
                {eq=3 => 0.1674871 * bplm},
                {eq=4 => 0.1671067 * bplm};
        
        wt_t :  { male=0 and age >=30 and age <= 44 => 1.3},
                { male=0 and age >=45 and age <= 54 => 1.2},
                { male=1 and age >=30 and age <= 54 => 1.1},
                {(age >=55 and age <= 59) => 1},
                {male=1 and age >=60 and age <= 64 => 0.9},
                {(male=1 and age >=65 and age <= 79) or (male=0 and age >=65 and age <= 69) => 0.8},
                {(male=0 and age >=65 and age <= 79)  => 0.7};
        
        var_x : {eq=1 or eq=2 => wt_t },{eq=3 => -.0616832 * llm},{eq=4 => -.2702909 * llm};
        
        var_f : {eq=3 => .0273617 * oatm},{eq=4 => 0.1205109 * oatm};
        
        var_b : {eq=3 or eq=4 => wt_t };
        
        var_w : {eq=3 => age_i + seifa_t + sm_a + sm_n + 0 + af_o + dm_s + var_r + var_l +var_c + var_d + var_p + var_h + var_u + var_g + 0.1316217 +var_m + var_x + var_f},
                {eq=4 => age_i + seifa_t + sm_a + sm_n + 0 + af_o + dm_s + var_r + var_l +var_c + var_d + var_p + var_h + var_u + var_g + 0.1594838 +var_m + var_x + var_f};
        
              
                
        var_prob : {eq=1 => 1-(power(0.9728782,(exp(var_m))))*100},
                    {eq=2 => 1-(power(0.9828361,(exp(var_m))))*100},
                    {eq=3 => 1-(power(0.9483001,(exp(var_m))))*100},
                    {eq=4 => 1-(power(0.9664823,(exp(var_m))))*100};
                    
        adj_prob : {eq in (1,2) and var_prob<1 => round(var_prob * var_x,0)},
                   {eq in (3,4) and var_prob<1 => round(var_prob * var_b,0)};
        
        
        
        risk_5 : { . => 2};
        
        
        
        cvra_cat :  {risk_high_ovr=1 => 3},
                    { risk_5 >=15 => 3},
                    { risk_5 >=10 and risk_5 <15 => 2},
                    { risk_5 <10 => 1},{=>0};
                    
        cvra_dx_uncoded : {cvra_cat=3 and nvl(asm_cvra_val,0)=0=>1},{=>0};
        
        cvra_predict1_aus :  { cvra_cat>2 => 1},{=>0};
            
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);  
    -- END OF RULEBLOCK --

    

END;





