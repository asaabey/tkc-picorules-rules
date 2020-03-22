CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac disease  */
        
        #define_ruleblock(cd_cardiac,
            {
                description: "Algorithm to assess cardiac disease",
                version: "0.1.2.1",
                blockid: "cd_cardiac",
                target_table:"rout_cd_cardiac",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"cardiac",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
            #doc(,
                {
                    section:"CAD"
                }
            );
            #doc(,
                {
                    txt:"first date of coronary insufficiency based on coding (ICD and ICPC)"
                }
            );    
            
            
            
            cabg => eadv.[icd_z95_1%,icpc_k54007].dt.min();
            
            cad_mi_icd => eadv.[icd_i21%,icd_i22%,icd_i23%].dt.min();
            
            #doc(,
                {
                    txt:"first date of type 2 AMI"
                }
            );   
            
            mi_type2_icd => eadv.icd_i21_a1.dt.min();
            
            cad_chronic_icd => eadv.[icd_i24%,icd_i25%].dt.min();
            
            cad_ihd_icpc => eadv.[icpc_k74%,icpc_k75%,icpc_k76%].dt.min();        
                
                
            #doc(,
                {
                    section:"VHD"
                }
            );
            #doc(,
                {
                    txt:"valvular heart disease based on coding"
                }
            );     
            
             #doc(,
                {
                    txt:"mitral and aortic"
                }
            ); 
            
            vhd_mv_icd => eadv.[icd_i34_%,icd_i05%].dt.min();
            
            vhd_av_icd => eadv.[icd_i35_%,icd_i06%].dt.min();
            
             #doc(,
                {
                    txt:"other valvular including rheumatic heart disease and infective endocarditis"
                }
            ); 
            vhd_ov_icd => eadv.[icd_i07%,icd_i08%,icd_i09%,icd_i36%,icd_i37%].dt.min();
            
            vhd_ie_icd => eadv.[icd_i33%,icd_i38%,icd_i39%].dt.min();
            
            vhd_icpc => eadv.[icpc_k83%].dt.min();
            
            #doc(,
                {
                    txt:"atrial fibrillation based on coding"
                }
            );  
            
            af_icd => eadv.[icd_i48_%].dt.min();
            
            af_icpc => eadv.[icpc_k78%].dt.min();
            
            #doc(,
                {
                    section:"other CVD"
                }
            );
            
            #doc(,
                {
                    txt:"Other atherosclerotic disease"
                }
            );   
            
            
            cva => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min();
            
            pvd => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.min();
           
           #doc(,
                {
                    section:"Management"
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
            
            rxn : {coalesce(rxn_statin,rxn_diu_k_sp,rxn_diu_low_ceil,rxn_diu_loop,rxn_chrono,rxn_anticoag,rxn_ap) is not null=>1},{=>0};
            
            
            cad : { coalesce(cabg,cad_mi_icd,cad_chronic_icd,cad_ihd_icpc) is not null =>1},{=>0};
            
            vhd : { coalesce(vhd_mv_icd,vhd_av_icd,vhd_ov_icd,vhd_ie_icd,vhd_icpc) is not null =>1},{=>0};
            
            cardiac : {greatest(cad,vhd)=1 =>1},{=>0};
            
            #define_attribute(
            cad,
                {
                    label:"Coronary artery disease",
                    desc:"Presence of Coronary artery disease",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            vhd,
                {
                    label:"Valvular heart disease",
                    desc:"Presence of Valvular heart disease",
                    is_reportable:1,
                    type:2
                }
            );
        
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
   
   
END;





