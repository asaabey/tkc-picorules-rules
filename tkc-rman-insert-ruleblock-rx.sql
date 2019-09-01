CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='rx_desc';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess Medication  */
        
            
             #define_ruleblock(rx_desc,
                {
                    description: "Algorithm to serialize active medications",
                    version: "0.0.1.1",
                    blockid: "rx_desc",
                    target_table:"rout_rx_desc",
                    environment:"DEV_2",
                    rule_owner:"TKCADMIN",
                    is_active:2,
                    def_exit_prop:"rx_desc",
                    def_predicate:">0",
                    exec_order:1
                    
                }
            );
            
            
            rxn_0 => eadv.[rxnc_%].dt.count().where(val=1);
            
            rx_name_obj => vw_eadv_rx.rx_desc.val.serialize();
            
            rx_desc : {nvl(rxn_0,0)>0 =>1},{=>0};
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
    
   
END;





