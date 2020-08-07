CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
  
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='at_risk';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess at risk population for CKD */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess [[rb_id]]",                
                is_active:2
                
            }
        );
        
        #doc(,
                {
                    txt: "Risk factor assessment for CKD",
                    cite: "at_risk_ckd_ref1, at_risk_ckd_ref2, at_risk_ckd_ref3"
                }
            ); 
        
        
        
        ckd => rout_ckd.ckd.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        dm => rout_cd_dm_dx.dm.val.bind();
        
        htn => rout_cd_htn.cd_htn.val.bind();
        
        cad => rout_cd_cardiac_cad.cad.val.bind();
        
        obesity => rout_cd_obesity.cd_obesity.val.bind();
        
        dod => rout_dmg.dod.val.bind();
    
        #doc(,
            {
                txt:"Gather risk factors from coding"
            }
        );
       
        
        
        lab_ld => eadv.[lab_bld%].dt.max().where(dt > sysdate-730);
        
        obs_ld => eadv.[obs%].dt.max().where(dt > sysdate-730);
        
        is_active_2y : {coalesce(lab_ld,obs_ld)!? and dod? => 1},{=>0};
              
        obst => eadv.[icd_e66%,icpc_t82%].dt.count(0);
            
        lit => eadv.[icd_n20,icd_n21,icd_n22,icd_n23,icpc_u95%].dt.count(0);
        
        struc => eadv.[icd_n25,icd_n26,icd_n27,icd_n28,icd_n29,icpc_u28006].dt.count(0);
            
        cti => eadv.[icd_l00%,icd_l01%,icd_l02%,icd_l03%,icd_l04%,icd_l05%,icd_l06%,icd_l07%,icd_l08%,icd_l09%,icd_m86%,icpc_s76%].dt.count(0);
        
        aki => eadv.[icd_n17%].dt.count(0);
        
        #doc(,
            {
                txt:"Determine at risk for CKD, and active cohort"
            }
        );
        
            
        [[rb_id]] : { greatest(dm,htn,cad,obesity,obst,lit,struc,aki,cti)>0 and ckd=0 =>1},{=>0};
        
        active : {1=1 => is_active_2y};
        
        tkc_cohort : { greatest(ckd,rrt,at_risk)>0 =>1},{=>0};
        
        #define_attribute(
            [[rb_id]],
                {
                    label:"At risk for CKD",
                    is_reportable:1,
                    type:2
                }
        );
        
        #define_attribute(
            tkc_cohort,
                {
                    label:"TKC cohort",
                    is_reportable:1,
                    type:2
                }
        );
        #define_attribute(
            active,
                {
                    label:"Is Active within last 2y",
                    is_reportable:1,
                    type:2
                }
        );
        
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
   
END;





