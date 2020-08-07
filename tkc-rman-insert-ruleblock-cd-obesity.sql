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
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess obesity",
                is_active:2

            }
        );
        
            
        ht => eadv.obs_height.val.lastdv();
        
        wt => eadv.obs_weight.val.lastdv();
        
        bmi : { nvl(ht_val,0)>0 and nvl(wt_val,0)>0 => round(wt_val/power(ht_val/100,2),1) };
        
        obs_icd => eadv.[icd_e66%].dt.count(0);
        
        obs_icpc => eadv.[icpc_t82%].dt.count(0);
        
        #doc(,
                {
                    txt: "Obesity classification",
                    cite: "cd_obesity_ref2"
                }
            );
        
        bmi_class : { bmi between 30 and 34.9 => 1},
                    { bmi between 35 and 39.9 => 2},
                    { bmi >= 40 =>3},
                    {=>0};
        
        
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
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_nutr_low';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess loss of weight */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess loss of weight",
                is_active:2
                
            }
        );
        
            
        ht => eadv.obs_height.val.lastdv();
        
        wt => eadv.obs_weight.val.lastdv().where(dt>sysdate-365);
        
        wt0 => eadv.obs_weight.val.lastdv().where(dt < wt_dt-180 and dt > sysdate-730 );
        
        bmi0 : { nvl(ht_val,0)>0 and nvl(wt0_val,0)>0 => round(wt0_val/power(ht_val/100,2),1) };
        
        wt_qt : { nvl(wt0_val,0)>0 => round((wt0_val - wt_val)/wt0_val,2)},{=>0};
        
        
        
        #doc(,
                {
                    txt: "Loss of weight as a pct atleast 6 m apart"
                }
            );
        
        
        [[rb_id]] : { bmi0<20 and wt_qt>0.1 => 1 },{=>0};
        
        
        #define_attribute(
            [[rb_id]],
                {
                    label:"Loss of weight",
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





