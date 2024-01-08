CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ortho_amputation';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Identify amputation phenotypes */
        
        #define_ruleblock(ortho_amputation,
            {
                description: "Identify amputation phenotypes",
                is_active:2
                
            }
        );
        
        /* 2024-01-08 (cresb): 
           add renamed attributes to prepare for MSSQL Migration
           enc_op__kpt,enc_op__prd,enc_op__pot
           will become
           enc_op_po_kpt,enc_op_po_prd,enc_op_po_pot
        */
        prost_clinic_fd => eadv.[enc_op__kpt,enc_op__prd,enc_op__pot,enc_op_po_kpt,enc_op_po_prd,enc_op_po_pot].dt.first();
        
        icd_fd => eadv.[icd_y83_5].dt.first();
        
        icpc_fd => eadv.[icpc_a87010].dt.first();
        
        amp_ld => eadv.[caresys_443%].dt.last();
        
        ta_ld => eadv.[caresys_4433800,caresys_4435800].dt.last();
        
        aa_ld => eadv.[caresys_4436101].dt.last();
        
        mta_ld => eadv.[caresys_4436400].dt.last();
        
        tma_ld => eadv.[caresys_4436401].dt.last();
        
        aka_ld => eadv.[caresys_4436701].dt.last();
        
        bka_ld => eadv.[caresys_4436702].dt.last();
        
        ha_ld => eadv.[caresys_4437000].dt.last();
        
        
        amp_fd : {. =>least_date(prost_clinic_fd, icd_fd, icpc_fd)};
        
        
        ortho_amputation: { amp_fd!? or amp_ld!? => 1 },{=>0};
        
        #define_attribute(ortho_amputation,
            { 
                label: "Presence of amputation",
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







