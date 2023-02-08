CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cns_ch';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to identify cerebral haemorrhage  */
        
        #define_ruleblock(cd_cns_ch,
            {
                description: "Algorithm to identify cerebral haemorrhage",
                is_active:2

                
            }
        );
        
        #doc(,{
                txt:"Subdural Haematoma(SDH)"
        });
        
        code_sdh_fd => eadv.[icpc_n80001,icpc_n80004,icd_62_0].dt.min();
        
        sdh : {code_sdh_fd!?=>1},{=>0};
        
        #doc(,{
                txt:"Intracerebral Haemorrhage(ICH)"
        });
        
        code_ich_fd => eadv.[icpc_n80008,icpc_n80015,icd_61_%].dt.min();
        
        ich : {code_ich_fd!?=>1},{=>0};
        
        #doc(,{
                txt:"Extradural Haemorrhage(ICH)"
        });
        
        code_ech_fd => eadv.[icpc_n80010,icd_62_1].dt.min();
        
        ech : {code_ech_fd!?=>1},{=>0};
        
        cd_cns_ch : { coalesce(code_sdh_fd,code_ich_fd, code_ech_fd)!? => 1},{=>0};
        
        
        #define_attribute(sdh,
            { 
                label: "Presence of Subdural Haemorrhage",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(ich,
            { 
                label: "Presence of Intracerebral Haemorrhage",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(ech,
            { 
                label: "Presence of Extradural Haemorrhage",
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







