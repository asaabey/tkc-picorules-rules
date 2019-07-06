CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cvra_1_1';
    rb.target_table:='rout_' || 'cvra';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='cvra';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Framingham equation*/
        
        /*  External bindings*/
        ckd0 => rout_ckd.ckd.val.bind();
        dm => rout_cd_dm.dm.val.bind();
        cp_hicvr => rout_careplan.cp_hicvr.val.bind();
        
        /*  Gather variables */
        
        /*  on basic */
        
        dob => eadv.dmg_dob.dt.max();
        
        male => eadv.dmg_gender.val.max();
        
        cabg => eadv.[icd_z95_1%,icpc_k54007].dt.count(0);
            
        cad => eadv.[icd_i20%,icd_i21%,icd_i22%,icd_i23%,icd_i24%,icd_i25%,icpc_k74%,icpc_k75%,icpc_k76%].dt.count(0);
            
        cva => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.count(0);
        
        cvd_prev : { (cabg + cad + cva)>0 =>1},{=>0};
        
        hdl => eadv.lab_bld_cholesterol_hdl.val.last();
        
        tc => eadv.lab_bld_cholesterol_total.val.last();
        
        sbp => eadv.obs_bp_systolic.val.last();
        
        smoke0 => eadv.status_smoking_h2_v1.val.last();
        
        
        age : { dob<sysdate => round(((sysdate-dob)/365.25),0)};
        
        smoke : {smoke0>=29 =>1},{0};
        
        lvh => const(0);
        
        dmckd1 : {dm=1 and ckd0>=1 => 1},{=>0};
        dm60 : {dm=1 and ckd0>=1 => 1},{=>0};
        ckd3 : {ckd0>=3 => 1},{=>0};
        tc7 : {tc>=7 => 1},{=>0};
        sbp180 : {sbp >=180 => 1},{=>0};
        age74 : {age>74 => 1},{=>0};
        
      
        risk_high_ovr : { greatest(dm60,dmckd1,ckd3,tc7,sbp180,age74,cvd_prev)>0 =>1},{=>0};
        
        
        risk_5_chd : {risk_high_ovr=0 and nvl(hdl,0)>0 => round(100*(1-EXP(-EXP((LN(5)-(15.5305+(28.4441*(1-male))+(-1.4792*LN(age))+(0*LN(age)*LN(age))+
            (-14.4588*LN(age)*(1-male))+(1.8515*LN(age)*LN(age)*(1-male))+(-0.9119*LN(sbp))+(-0.2767*smoke)+(-0.7181*LN(tc/hdl))+
            (-0.1759*1)+(-0.1999*1*(1-male))+(-0.5865*0)+(0*0*male)))/(EXP(0.9145)*EXP(-0.2784*(15.5305+(28.4441*(1-male))+
            (-1.4792*LN(age))+(0*LN(age)*LN(age))+(-14.4588*LN(age)*(1-male))+(1.8515*LN(age)*LN(age)*(1-male))+(-0.9119*LN(sbp))+
            (-0.2767*smoke)+(-0.7181*LN(tc/hdl))+(-0.1759*1)+(-0.1999*1*(1-male))+(-0.5865*0)+(0*0*male))))))),2)
        };
        
        risk_5_mi : { risk_high_ovr=0 and nvl(hdl,0)>0 => round(100*(1-EXP(-EXP((LN(5)-(11.4712+(10.5109*(1-male))+(-0.7965*LN(age))+(0*LN(age)*LN(age))+
            (-5.4216*LN(age)*(1-male))+(0.7101*LN(age)*LN(age)*(1-male))+(-0.6623*LN(sbp))+(-0.2675*smoke)+(-0.4277*LN(tc/hdl))+
            (-0.1534*dm)+(-0.1165*dm*(1-male))+(0*lvh)+(-0.1588*lvh*male)))/(EXP(3.4064)*EXP(-0.8584*(11.4712+(10.5109*(1-male))+
            (-0.7965*LN(age))+(0*LN(age)*LN(age))+(-5.4216*LN(age)*(1-male))+(0.7101*LN(age)*LN(age)*(1-male))+(-0.6623*LN(sbp))+
            (-0.2675*smoke)+(-0.4277*LN(tc/hdl))+(-0.1534*dm)+(-0.1165*dm*(1-male))+(0*lvh)+(-0.1588*lvh*male))))))),2)
        };
        
        risk_5 : { risk_high_ovr=0 => nvl(risk_5_chd,0) + nvl(risk_5_mi,0)};
        
        
        cvra :  {risk_high_ovr=1 => 3},
                    { risk_5 >=15 => 3},
                    { risk_5 >=10 and risk_5 <15 => 2},
                    { risk_5 <15 => 1},{=>0};
        
            
        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,3);
    
    -- END OF RULEBLOCK --
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='kfre_2_1';
    rb.target_table:='rout_' || 'kfre';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='kfre4v_ap';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  KFRE */
        
        /*  External bindings*/
        ckd => rout_ckd.ckd.val.bind();
        
        /*  Gather variables */
        dob => eadv.dmg_dob.dt.max();
        
        male => eadv.dmg_gender.val.max();
        
        egfr_lv => eadv.lab_bld_egfr_c.val.last();
        
        egfr_ld => eadv.lab_bld_egfr_c.dt.max();
        
        uacr_lv => eadv.lab_ua_acr.val.last();
        
        uacr_ld => eadv.lab_ua_acr.dt.max();
        
        kfre4v_ap : { least(dob,egfr_ld,uacr_ld) is not null and male is not null and ckd>=3 and ckd<5 => 1},{=>0};
        
        egfr_1 : { 1=1 => egfr_lv};
        
        ln_uacr_1 : { nvl(uacr_lv,0)>0  => ln(uacr_lv * 8.84)};
        
        age : { 1=1 => round(((egfr_ld-dob)/365.25),0)};
        
        kfre4v_exp : { kfre4v_ap =1 => exp((-0.5567*(egfr_1/5-7.222))+(0.2467*(male - 0.5642))+(0.451*(ln_uacr_1-5.137))-(0.2201*(age/10-7.036)))},{=>0};
        
        kfre4v_2yr : { kfre4v_ap =1 => round(1-power(0.9832,kfre4v_exp) ,2)};
        
        kfre4v_5yr : { kfre4v_ap =1 => round(1-power(0.9365,kfre4v_exp) ,2)};
                  
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,3);
    
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='pcd_2_1';
    rb.target_table:='rout_' || 'pcd';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='pcd';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  PCD Traffic light report */
        
        /*  External bindings*/
        ckd => rout_ckd.ckd.val.bind();
        
        dm => rout_cd_dm.dm.val.bind();
        
        cvra_calc => rout_cvra.cvra.val.bind();
        
        /*  Gather variables */
        dob => eadv.dmg_dob.dt.max();
        
        male => eadv.dmg_gender.val.max();
        
        pcd_dt => eadv.mbs_721.dt.max();
        
        cvra => eadv.asm_cvra.val.lastdv();
        
        tc => eadv.lab_bld_cholesterol_tot.va.lastdv();
        
        hba => eadv.lab_bld_hba1c.val.lastdv();
        
        acr => eadv.lab_ua_acr.val.lastdv();
        
        smoke0 => eadv.status_smoking_h2_v1.val.lastdv();
        
        gpmp_dt => eadv.mbs_721.dt.max();
        
        ahc_dt => eadv.mbs_715.dt.max();
        
        
        
        pcd12m : { pcd_dt < sysdate-365 => 1 },{=>0};
        
        cvra12m : { cvra_dt < sysdate-365 =>1},{=>0};
        
        age : { dob< sysdate => (sysdate-dob)/365.25};
        
        pcd : { pcd_dt is not null =>1},{=>0};       
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,4);
    
    -- END OF RULEBLOCK --
END;





