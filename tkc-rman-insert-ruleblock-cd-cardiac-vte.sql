CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
    
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_vte';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess VTE  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess VTE",
                is_active:2
                
            }
        );
        
                
            #doc(,{
                    section:"Pulmonary embolism"
            });
            
            
            
            pe_fd => eadv.[icd_i26%,icpc_k93002].dt.min();
            
            pe_ld => eadv.[icd_i26%,icpc_k93002].dt.max();
            
            pe_multi : { pe_ld - pe_fd > 90 =>1},{=>0};
            
            
            
            #doc(,
                {
                    txt:" anticoagulation"
                }
            ); 
            
            rxn_anticoag_dt => rout_cd_cardiac_rx.rxn_anticoag.val.bind();
        
            rxn_anticoag : { rxn_anticoag_dt!? => 1},{=>0};     
            
            
            
            
            [[rb_id]] : { pe_fd!? =>1},{=>0};
            
            
            #define_attribute(
            [[rb_id]],
                {
                    label:"VTE",
                    desc:"Venous-thrombo embolism",
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

     