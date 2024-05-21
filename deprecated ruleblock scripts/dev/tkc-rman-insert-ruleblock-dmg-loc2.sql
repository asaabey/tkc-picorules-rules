CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc2';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographics -method 2 */
        
        #define_ruleblock(dmg_loc2, {
                description: "Algorithm to assess demographics -method 2",
                is_active:0});
        
        my_freq_remote_clinic => eadv.[icd_%,icpc_%,lab_%,rxnc_%,obs_%,mbs_%].loc.stats_mode().where(dt > sysdate - 750  and substr(loc,15,1)= 1 and substr(loc,4,12) not in (`710500019011`,`711800001001`,`711800001011`,`711800001021`,`711800001031`,`711800001041`,`711800001051`,`711811460001`,`711811460051`,`721500018021`,`721511495001`,`721511495011`,`721511495021`,`721590139011`,`721600002001`,`721600002091`,`721600002101`,`721600002111`,`721600002121`,`721600002131`,`721610857151`,`721610878161`,`721611471011`,`721611479051`));
      
        dmg_loc2 : { my_freq_remote_clinic!? =>1 },{=>0};
      
      
 );
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
         
END;





