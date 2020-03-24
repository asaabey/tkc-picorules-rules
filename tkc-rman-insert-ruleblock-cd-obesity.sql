CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_obesity';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess obesity  */
        
        #define_ruleblock(cd_obesity,
            {
                description: "Ruleblock to assess obesity",
                version: "0.0.2.2",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
            
        ht => eadv.obs_height.val.lastdv();
        
        wt => eadv.obs_weight.val.lastdv();
        
        bmi : { nvl(ht_val,0)>0 and nvl(wt_val,0)>0 => round(wt_val/power(ht_val/100,2),1) };
        
        obs_icd => eadv.[icd_e66%].dt.count(0);
        
        obs_icpc => eadv.[icpc_t82%].dt.count(0);
        
        #doc(,
                {
                    txt: "Obesity diagnosis where BMI >30",
                    cite: "cd_obesity_ref1"
                }
            );
        
        [[rb_id]] : { bmi>30 => 1 },{=>0};
        
        obs_dx_uncoded : {bmi>30 and greatest(obs_icd,obs_icpc)=0 =>1},{=>0};
        
        #define_attribute(
            [[rb_id]],
                {
                    label:"Obesity",
                    desc:"Integer [0-1] if Obesity based on code and observation criteria",
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





