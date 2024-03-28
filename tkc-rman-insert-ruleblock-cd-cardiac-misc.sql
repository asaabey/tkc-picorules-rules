CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
  
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_rx';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac medication  */
        
        #define_ruleblock([[rb_id]],
        {
            description: "Algorithm to assess cardiac medication",
            is_active:2
            
        }
        );
        
        
        #doc(,
        {
            txt: "Medication",
            cite: "cvd_tg_2019,cvd_heart_foundation_2012"
        }
        );
        
        
        #doc(,
            {
                txt: "antiplatelet agents"
            }
        );
        
        
        rxn_ap => eadv.[rxnc_b01ac].dt.min().where(val=1);
        
        
        #doc(,
            {
                txt: "anti-coagulation including NOAC"
            }
        );
        
        
        rxn_anticoag => eadv.[rxnc_b01aa,rxnc_b01af,rxnc_b01ae,rxnc_b01ab].dt.min().where(val=1);
        
        #doc(,
            {
                txt: "anti-arrhythmic"
            }
        );
        
        
        
        rxn_chrono => eadv.[rxnc_c01%].dt.min().where(val=1);
        
        #doc(,
            {
                txt: "diuretics"
            }
        );
        
        rxn_diu_loop => eadv.[rxnc_c03c%].dt.min().where(val=1);
        
        rxn_diu_low_ceil => eadv.[rxnc_c03b%,rxnc_c03a%].dt.min().where(val=1);
        
        rxn_diu_k_sp => eadv.[rxnc_c03d%].dt.min().where(val=1);
        
        #doc(,
            {
                txt: "lipid lowering"
            }
        );
        
        rxn_statin => eadv.[rxnc_c10aa,rxnc_c10bx,rxnc_c10ba].dt.min().where(val=1);
        
        rxn : {coalesce(rxn_statin,rxn_diu_k_sp,rxn_diu_low_ceil,rxn_diu_loop,rxn_chrono,rxn_anticoag,rxn_ap)!? =>1},{=>0};

        
        [[rb_id]] : {rxn=1 =>1},{=>0};
        
        #define_attribute(
        [[rb_id]],
            {
                label:"Rx cardiac meds",
                desc:"Presence of cardiac",
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

    rb.blockid:='cd_cardiac_enc';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        
        /* Algorithm to assess cardiac encounters  */
        
        #define_ruleblock([[rb_id]],
        {
            description: "Algorithm to assess cardiac encounters",
            is_active:2
            
        }
        );
        
        car_enc_f_dt => eadv.[enc_op_car_%].dt.first();
        
        car_enc_l_dt => eadv.[enc_op_car_%].dt.last();
        
        [[rb_id]] : {car_enc_l_dt!? => 1},{=>0};
        
        
        #define_attribute(
        [[rb_id]],
            {
                label:"cardiac outpatient encounter",
                desc:"Presence of cardiac outpatient encounter",
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





