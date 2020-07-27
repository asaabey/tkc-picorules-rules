CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
 
   -- BEGINNING OF RULEBLOCK --
    
    rb.blockid:='cd_careplan';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /*  Ruleblock to determine existing careplans*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Ruleblock to determine existing careplans",
                version: "0.0.2.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        cp_l => eadv.careplan_h9_v1._.lastdv();
        
        #doc(,
            {
                txt:"Assign binary careplan attributes based on positional values "
            }
        );
        
        
        
        cp_cs : {cp_l_val!? => to_number(substr(to_char(cp_l_val),-1,1))},{=>0};
        
        cp_ckd : {cp_l_val!? => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_dm : {cp_l_val!? => to_number(substr(to_char(cp_l_val),-6,1))},{=>0};
        
        cp_cvd : {cp_l_val!? => to_number(substr(to_char(cp_l_val),-7,1))},{=>0};
        
        cp_hicvr : {cp_l_val!? => to_number(substr(to_char(cp_l_val),-8,1))},{=>0};
        
        [[rb_id]] : {greatest(cp_cs,cp_ckd,cp_dm,cp_cvd,cp_hicvr)>0 => cp_cs};
        
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
      INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
      
    -- END OF RULEBLOCK --
    
  
END;





