CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
        
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='global';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        
        #define_ruleblock(global,{
                description: "Global TKC interface",
                is_active:2
        });
        
        tkc_cat => rout_at_risk.tkc_cat.val.bind();

        opt_out_ld => eadv.dmg_opted_out.dt.last();
        
        tkc_visible : {tkc_cat < 3 or opt_out_ld!? =>1},{=>0};
        
        global : { . => tkc_visible};
        
        #define_attribute(tkc_visible,{
                    label:"Visible in TKC app",
                    is_reportable:1,
                    is_bi_obj:1,
                    type:1001
        });
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







