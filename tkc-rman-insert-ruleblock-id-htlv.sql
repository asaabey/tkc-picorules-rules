CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='id_htlv';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /*  Algorithm to identify HTLV1-2*/

        #define_ruleblock(id_htlv,{
                description: "Algorithm to identify HTLV1-2",
                is_active:2
        });

        lab_last => eadv.lab_bld_htlv._.lastdv();

        icd => eadv.icd_b97_33.dt.last();

        id_htlv : { lab_last_val=1 or icd!? => 1 },{=>0};

        #define_attribute(id_htlv,
            {
                label: "Presence of HTLV1-2",
                is_reportable:1,
                type:1001
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
  
    
    
    
END;







