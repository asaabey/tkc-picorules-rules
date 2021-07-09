CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN

    
    
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_anaemia';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine CKD complications */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine CKD complications",
                is_active:2                
            }
        );
                
        #doc(,
            {
                txt:"Complications including Hb low",
                cite : "ckd_complications_ref1, ckd_complications_ref2"
            }
        );        
        
        ckd => rout_ckd.ckd.val.bind(); 
        
        rrt => rout_rrt.rrt.val.bind();
        
        #doc(,
            {
                txt:"Haematenics"
            }
        );
        
        
        hb => eadv.lab_bld_hb._.lastdv().where(dt>sysdate-60);
        
        
        
        plt1 => eadv.lab_bld_platelets._.lastdv().where(dt>sysdate-60);
        
        wcc_neut1 => eadv.lab_bld_wcc_neutrophils._.lastdv().where(dt>sysdate-60);
        
        wcc_eos1 => eadv.lab_bld_wcc_eosinophils._.lastdv().where(dt>sysdate-60);
        
        
        
        rbc_mcv => eadv.lab_bld_rbc_mcv._.lastdv().where(dt>sysdate-60);
        
        esa => eadv.rxnc_b03xa._.lastdv().where(dt>sysdate-365);
        
        b05_ld => eadv.[rxnc_b05cb,rxnc_b05xa].dt.max().where(val=1);
        
        
        fer => eadv.lab_bld_ferritin._.lastdv().where(dt>sysdate-120);
        
        
        
        tsat1 => eadv.lab_bld_tsat._.lastdv().where(dt>sysdate-120);
        
        #doc(,{
                txt:"Determine haematenic complications"
        });
        
        
        hb_state : { nvl(hb_val,0)>0 and nvl(hb_val,0)<100 =>1},
                    { nvl(hb_val,0)>=100 and nvl(hb_val,0)<180 =>2},
                    { nvl(hb_val,0)>180 =>3},
                    {=>0};
                    
        mcv_state : { hb_state=1 and nvl(rbc_mcv_val,0)>0 and nvl(rbc_mcv_val,0)<70 => 11 },
                    { hb_state=1 and nvl(rbc_mcv_val,0)>=70 and nvl(rbc_mcv_val,0)<80 => 12 },
                    { hb_state=1 and nvl(rbc_mcv_val,0)>=80 and nvl(rbc_mcv_val,0)<=100 => 20 },
                    { hb_state=1 and nvl(rbc_mcv_val,0)>=100 => 31 },{ =>0};
                    
        iron_low : { hb_state=1 and nvl(fer_val,0)>0 and nvl(fer_val,0)<250 => 1},{=>0};
        
        thal_sig : {mcv_state=11 =>1 },{=>0};
        
        esa_null : { esa_dt? =>1},{=>0};
        
        esa_state : { esa_null=0 and esa_val=1 => 1},{ esa_null=0 and esa_val=0 => 2},{=>0};
        
        
                
        
        
        [[rb_id]] : { rrt in(1,2,4) or ckd>4 => 1 },{=>0};
        
        
        
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
END;





