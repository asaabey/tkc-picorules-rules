CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
     
  

       -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_labs_euc';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to gather lab tests",
                is_active:2,
                
            }
        );

       rrt => rout_rrt.rrt.val.bind();
             
       sodium1 => eadv.lab_bld_sodium.val.lastdv().where(dt>sysdate-60);
    
       potassium1 => eadv.lab_bld_potassium.val.lastdv().where(dt>sysdate-60);
       
       bicarb1 => eadv.lab_bld_bicarbonate.val.lastdv().where(dt>sysdate-60);
       
       [[rb_id]] : {rrt=1 => 1},{=>0};
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
          -- BEGINNING OF RULEBLOCK --
    


END;





