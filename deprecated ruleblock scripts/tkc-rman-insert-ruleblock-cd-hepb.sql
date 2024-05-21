CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;
BEGIN
    -- BEGINNING OF RULEBLOCK --
    
    rb.blockid := 'cd_hepb';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock := '
        
        #define_ruleblock(cd_hepb,
            {
                description: "Algorithm to detect Chronic hepatitis B from coding - deprecated",
                is_active: 0,
                author: "richardh@iinet.net.au"
            }
        );
        
        /* Hep B ICPC codes */
        hepb_imm_vac => eadv.[icpc_d72j97].dt.max();
        
        hepb_imm_inf => eadv.[icpc_d72j96].dt.max();
        
        hepb_imm_nos => eadv.[icpc_d72j99].dt.max();
        
        hepb_imm : { coalesce(hepb_imm_vac,hepb_imm_inf,hepb_imm_nos)!? =>1},{=>0};
        
        hepb_nonimm => eadv.[icpc_d72j93].dt.max();
        
        hepb_nos => eadv.[icpc_d72j92,icpc_d72j94,icpc_d72j95,icpc_d72003,icpc_d72010].dt.max();
        
        /* Hep B Surface antibody and antigen */
        s_ab => eadv.lab_bld_hbs_ab_level._.lastdv();
        s_ag => eadv.lab_bld_hbs_ag._.lastdv();
        
        /* Hep B Core antibody*/
        
        c_ab => eadv.lab_bld_hbc_ab._.lastdv();
        
        /* Hep B e antibody and antigen */
        
        e_ab => eadv.[lab_bld_hbe_ab_level,lab_bld_hbe_ab]._.lastdv();
        e_ag => eadv.[lab_bld_hbe_ag_level,lab_bld_hbe_ag]._.lastdv();
        
        e_ab : { e_ab_val >0 =>1},{=>0};
        
        e_ag : { e_ag_val >0 =>1},{=>0};
        
        /* Hep B Viral Load */
        vl => eadv.[lab_bld_hbv_viral_load]._.lastdv();
        
        /* Liver Function AST */
        ast => eadv.[lab_bld_ast]._.lastdv();
        
        /*
        recovery            1
        immunized           2
        non-immune          3
        immune tolerance    4
        immune response     5
        immune control      6
        immune escape       7
        */
        
        hbv_status : { e_ag = 1 and vl_val > 20000  =>4},{=>0};
        
        /*without surface antigen*/
        hbv_chronic : { coalesce(c_ab_val,e_ag,vl_val,0)>0 =>1},{=>0};
        
        hbv_immune : { s_ab_val > 10 =>1},{=>0};
        
        rcm_hbv_ic : {hbv_status = 1 =>1},{=>0};
        
        rcm_hbv_vacc : {hbv_status =3 =>1},{=>0};
        
        rcm_hbv_gp : { hbv_status in (4,6) => 12},{hbv_status in (5,7) => 3 },{=>0};
        
        rcm_hbv_path : { hbv_status in (5,7) => 3},{ hbv_status = 6 => 12},{=>0};
        
        rcm_hbv_rad : { hbv_status = 6 => 12},{ hbv_status = 7 => 6},{=>0};
        
        rcm_hbv_hepref : {hbv_status =5 => 1},{=>0};
        
        cd_hepb : { hbv_chronic>0 =>1},{=>0};
        
        #define_attribute(cd_hepb,
            {
                label: "Chronic Hepatitis B",
                type: 1001,
                is_reportable: 1
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (blockid, picoruleblock) VALUES (rb.blockid, rb.picoruleblock);
    COMMIT;
    -- END OF RULEBLOCK --
    
END;