CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_ix';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  cardiac investigations  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "assess cardiac investigations",
                is_active:2
                
            }
        );
        
        #doc(,{
                    section:"Echocardiogram"
        });

        echo_ld => eadv.[ris_img_echo%].dt.last();
        
        echo_2_ld => eadv.[ris_img_echo%].dt.last(1);
        
        echo_n => eadv.[ris_img_echo%].dt.count();
        
        cardang_ld => eadv.[ris_img_cardan%].dt.last();
        
        cardang_2_ld => eadv.[ris_img_cardan%].dt.last(1);
        
        
        
        [[rb_id]] : {coalesce(echo_ld,cardang_ld)!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "presence of CHF",
                type : 2,
                is_reportable:1
            }
        );

    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --

   
END;





