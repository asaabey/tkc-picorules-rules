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
        
        #define_ruleblock(cd_cardiac_ix,
            {
                description: "assess cardiac investigations",
                is_active:2
                
            }
        );
        
        #doc(,{
                    section:"Echocardiogram"
        });

        echo_ld => eadv.[enc_ris_echo%].dt.last();
        
        /* NT cardiac report hot linking*/
        echo_rep => eadv.[ntc_rep_tte]._.lastdv();
        
        echo_2_ld => eadv.[enc_ris_echo%].dt.last(1);
        
        echo_n => eadv.[enc_ris_echo%].dt.count();
        
        cardang_ld => eadv.[enc_ris_cardang%].dt.last();
        
        
        
        cd_cardiac_ix : {coalesce(echo_ld,cardang_ld)!? =>1},{=>0};
        
        #define_attribute(cd_cardiac_ix,
            {
                label: "presence of cardiac investigations",
                type: 1001,
                is_reportable: 1
            }
        );

    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --

   
END;





