CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   

    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_hepb_coded';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to detect Chronioc hepatitis B from coding",
                is_active:0
                
            }
        );
        
        hepb_imm_vac => eadv.[icpc_d72j97].dt.max();
        
        hepb_imm_inf => eadv.[icpc_d72j96].dt.max();
        
        hepb_imm_nos => eadv.[icpc_d72j99].dt.max();
        
        hepb_imm : { coalesce(hepb_imm_vac,hepb_imm_inf,hepb_imm_nos)!? =>1},{=>0};
        
        
        hepb_nonimm => eadv.[icpc_d72j93].dt.max();
        
        hepb_nos => eadv.[icpc_d72j92,icpc_d72j94,icpc_d72j95,icpc_d72003,icpc_d72010].dt.max();
        
        /* Hep B Surface antibody */
        hbs_ab_level => eadv.[lab_bld_hbs_ab_level].dt.max();

        /* Hep B e antibody */
        hbe_ab => eadv.[lab_bld_hbe_ab].dt.max();

        /* Hep B e antigen */
        hbe_ag => eadv.[lab_bld_hbe_ag].dt.max();

        /* Hep B Viral Load */
        hbv_viral_load => eadv.[lab_bld_hbv_viral_load].dt.max();

        /* Liver Function AST  - correct code from EADV table when known */
        ast_level => eadv.[lab_bld_ast].dt.max();

        
        hepb : { coalesce(hepb_nonimm,hepb_nos)!? or hepb_imm=1 => 1},{=>0};
        
        [[rb_id]] : { hepb=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Chronic HepB"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







