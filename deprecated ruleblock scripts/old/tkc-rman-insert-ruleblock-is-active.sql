CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
  
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='is_active';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Ruleblock to assess if active */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to assess if active",
                is_active:2
                
            }
        );
        
        dod => eadv.dmg_dod.dt.max().where(dt > sysdate-730);
      
        obs_ld => eadv.[obs%].dt.max().where(dt > sysdate-730);
        
        enc_ld => eadv.[enc%].dt.max().where(dt > sysdate-730);
        
        mbs_ld => eadv.[mbs%].dt.max().where(dt > sysdate-730);
        
        [[rb_id]] : { coalesce(obs_ld,enc_ld,mbs_ld)!? and dod? => 1},{=>0};
              
        
        #define_attribute(
            [[rb_id]],
                {
                    label:"Is active",
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





