CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
       
    
        -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cd_dyslip';
  
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess for dyslipidaemia*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess for cd_dyslipidaemia",
                is_active:2
                
            }
        );
        
        
        ascvd => rout_cvra.cvd_prev.val.bind();
        
        dob => rout_dmg.dob.val.bind();
        
        gender => rout_dmg.gender.val.bind();
        
        
        cad => rout_cd_cardiac_cad.cd_cardiac_cad.val.bind();
        
        age : { dob!? => round((sysdate-dob)/365.25,1)};
        
        prem_cad_wt :   { gender=0 and age<55 and cad=1 => 2},
                        { gender=1 and age<60 and cad=1 => 2},
                        {=>0};
                    
        prem_ascvd_wt :     { gender=0 and age<55 and ascvd=1 and cad=0 => 1},
                            { gender=1 and age<60 and ascvd=1 and cad=0 => 1},
                            {=>0};
        
        
        
        
        
        dyslip_code_dt => eadv.[icd_e78%,icpc_t93%].dt.min();
        
        ldl => eadv.lab_bld_cholesterol_ldl._.lastdv().where(dt>sysdate-365);
        
        ldl_unl : { ascvd=1 => 1.8},{=>4.9};
        
        ldl_dls_wt :    { ldl_val>8.5 => 8},
                        { ldl_val between 6.5 and 8.4 => 5},
                        { ldl_val between 5.0 and 6.4 => 3},
                        { ldl_val between 4.0 and 4.9 => 1},
                        { =>0};
                        
        dls : { . => prem_cad_wt + ldl_dls_wt + prem_ascvd_wt };
        
        fhc_prob :  { dls>8 =>4 },
                    { dls between 6 and 8 =>3},
                    { dls between 3 and 5 =>2},
                    { dls<3 =1},
                    {=>0};
        
        ldl_subopt : { (ldl_val/ldl_unl)>1.2 =>1},{=>0};
        
        
        [[rb_id]] :  {((ascvd=1 and nvl(ldl_val,0)>1.8)) or nvl(ldl_val,0)>4.9 or dyslip_code_dt!? or fhc_prob>1 => 1},{=>0};
        
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Hypercholesterolaemia",
                desc:"Presence of Hypercholesterolaemia",
                is_reportable:1,
                type:2
            }
        );
  
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);  
    -- END OF RULEBLOCK --
END;





