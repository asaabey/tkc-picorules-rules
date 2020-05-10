CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_haem';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to identify haematological disease  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify haematological disease",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        hb1 => eadv.lab_bld_hb._.lastdv().where(dt>sysdate-365);
        
        hb2 => eadv.lab_bld_hb._.lastdv(2).where(dt>sysdate-365);
        
        
        mcv => eadv.lab_bld_rbc_mcv._.lastdv().where(dt>sysdate-365);
        
        wcc => eadv.lab_bld_wcc_neutrophils._.lastdv().where(dt>sysdate-365);
        
        plt => eadv.lab_bld_platelets._.lastdv().where(dt>sysdate-365);
        
        fer => eadv.lab_bld_ferritin._.lastdv().where(dt>sysdate-365);
        
        hb_low : { hb1_val <100 => 1},{=>0};
        
        wcc_low : { wcc_val <1.5 => 1},{=>0};
        
        plt_low : { plt_val <100 => 1},{=>0};
        
        
        
        
        low_cat : { (hb_low + wcc_low + plt_low=3) => 3},
                    { (hb_low + wcc_low + plt_low=2) =>2},
                    { (hb_low + wcc_low + plt_low=1) =>1},
                    { =>0};
        
        [[rb_id]] : { low_cat>0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of haematological disease"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







