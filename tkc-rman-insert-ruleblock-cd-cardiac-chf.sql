CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_chf';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  CHF  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a assess CHF",
                is_active:2
                
            }
        );
        
        #doc(,
                {
                    section:"CHF"
                }
            );
            
        chf_code => eadv.[icd_i50_%,icpc_k77%].dt.min();
        
        dcm => eadv.[icd_i42_0].dt.min();
        
        hocm => eadv.[icd_i42_1,icd_i42_2].dt.min();
        
        rcm => eadv.[icd_i42_5].dt.min();
        
        ethocm => eadv.[icd_i42_6].dt.min();
        
        noscm => eadv.[icd_i42_8,icd_42_9,icpc_k84041].dt.min();
        
        echo_ld => rout_cd_cardiac_ix.echo_ld.val.bind();
            
        chf : {coalesce(chf_code,dcm,hocm,rcm,ethocm,noscm)!? =>1},{=>0};
        
        [[rb_id]] : {chf=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "presence of CHF",
                type : 2,
                is_reportable:1
            }
        );
        
        #define_attribute(dcm,{ 
                label: "presence of dilated cardiomyopathy",
                type :2,
                is_reportable:1
        });
        
        #define_attribute(hocm,{ 
                label: "presence of hypertrophic cardiomyopathy",
                type : 2,
                is_reportable:1
        });
        
        #define_attribute(rcm,{ 
                label: "presence of restrictive cardiomyopathy",
                type : 2,
                is_reportable:1
        });
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --

   
END;





