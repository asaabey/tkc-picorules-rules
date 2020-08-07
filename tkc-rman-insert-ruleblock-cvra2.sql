CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cvra';
  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to apply Framingham equations*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to apply Framingham equations",            
                is_active:2
                
            }
        );
        
        #doc(,
            {
                txt:"Will  update ruleblock when validated CV risk assessment equation is available for Indigenous patients",
                cite:"cvra_hlc_2019,cvra_circ_2018"
            }
            
        );
        
        #doc(,
            {
                txt:"External bindings"
            }
            
        );
        
        
        ckd => rout_ckd.ckd.val.bind();
        dm => rout_cd_dm_dx.dm.val.bind();
        cp_hicvr => rout_cd_careplan.cp_hicvr.val.bind();
        
        
        
        #doc(,
            {
                txt:"Gather variables including existing assessment demographics and diseases by coding"
            }
            
        );
        
        
        dmg_source => rout_dmg_source.dmg_source.val.bind();
        
        asm_cvra => eadv.asm_cvra.val.lastdv();
        
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

        
        
        age : { dob < sysdate => round(((sysdate-dob)/365.25),0)};
        
        smoke : {smoke0>=29 =>1},{0};
        
        lvh => const(0);
        
        
        #doc(,
            {
                txt:"Determine if overide criteria are met",
                cite:"cvra_nsf_2019"
            }
            
        );
        
        
        dmckd1 : {dm=1 and ckd>=1 => 1},{=>0};
        dm60 : {dm=1 and age>=60 => 1},{=>0};
        ckd3 : {ckd>=3 => 1},{=>0};
        tc7 : {tc>=7 => 1},{=>0};
        sbp180 : {sbp >=180 => 1},{=>0};
        age74 : {age>74 => 1},{=>0};
        
      
        risk_high_ovr : { greatest(dm60,dmckd1,ckd3,tc7,sbp180,age74,cvd_prev)>0 =>1},{=>0};
        
        #doc(,
            {
                txt:"Otherwise calculate the 5 year risk for non-fatal MI, and CVE",
                cite:"cvra_ahj_1991"
            }
            
        );

        ln_zero_ex1 : { nvl(least(age,tc,hdl,sbp),0)=0 => 1},{=>0};
        
        risk_5_chd : {risk_high_ovr=0 and ln_zero_ex1=0 => 
            round(100*(1-EXP(-EXP((LN(5)-(15.5305+(28.4441*(1-male))+(-1.4792*LN(age))+(0*LN(age)*LN(age))+
            (-14.4588*LN(age)*(1-male))+(1.8515*LN(age)*LN(age)*(1-male))+(-0.9119*LN(sbp))+(-0.2767*smoke)+(-0.7181*LN(tc/hdl))+
            (-0.1759*1)+(-0.1999*1*(1-male))+(-0.5865*0)+(0*0*male)))/(EXP(0.9145)*EXP(-0.2784*(15.5305+(28.4441*(1-male))+
            (-1.4792*LN(age))+(0*LN(age)*LN(age))+(-14.4588*LN(age)*(1-male))+(1.8515*LN(age)*LN(age)*(1-male))+(-0.9119*LN(sbp))+
            (-0.2767*smoke)+(-0.7181*LN(tc/hdl))+(-0.1759*1)+(-0.1999*1*(1-male))+(-0.5865*0)+(0*0*male))))))),2)
        };
        
        risk_5_mi : { risk_high_ovr=0 and ln_zero_ex1=0 => round(100*(1-EXP(-EXP((LN(5)-(11.4712+(10.5109*(1-male))+(-0.7965*LN(age))+(0*LN(age)*LN(age))+
            (-5.4216*LN(age)*(1-male))+(0.7101*LN(age)*LN(age)*(1-male))+(-0.6623*LN(sbp))+(-0.2675*smoke)+(-0.4277*LN(tc/hdl))+
            (-0.1534*dm)+(-0.1165*dm*(1-male))+(0*lvh)+(-0.1588*lvh*male)))/(EXP(3.4064)*EXP(-0.8584*(11.4712+(10.5109*(1-male))+
            (-0.7965*LN(age))+(0*LN(age)*LN(age))+(-5.4216*LN(age)*(1-male))+(0.7101*LN(age)*LN(age)*(1-male))+(-0.6623*LN(sbp))+
            (-0.2675*smoke)+(-0.4277*LN(tc/hdl))+(-0.1534*dm)+(-0.1165*dm*(1-male))+(0*lvh)+(-0.1588*lvh*male))))))),2)
        };
        
        risk_5 : { risk_high_ovr=0 => nvl(risk_5_chd,0) + nvl(risk_5_mi,0)};
        
        
        [[rb_id]] :  {risk_high_ovr=1 => 3},
                    { risk_5 >=15 => 3},
                    { risk_5 >=10 and risk_5 <15 => 2},
                    { risk_5 <10 => 1},{=>0};
        cvra_dx_uncoded : {cvra=3 and nvl(asm_cvra_val,0)=0=>1},{=>0};
        
            
        
        
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);  
    -- END OF RULEBLOCK --

    

END;





