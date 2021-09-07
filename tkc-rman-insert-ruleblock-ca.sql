CLEAR SCREEN;

SET SERVEROUTPUT ON;

SET FEEDBACK ON;

DECLARE
    rb rman_ruleblocks%rowtype;
BEGIN


    
-- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_careplan';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify cancer careplan  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify cancer careplan",
                is_active:2
                
            }
        );
        
        
        op_enc_ld => eadv.[enc_op_onc%].dt.max();
        
        
        [[rb_id]] : { op_enc_ld!? => 1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Attendance at oncology clinic",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK --
    

 -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_mets';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify metastatic carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify metastatic carcinoma",
                is_active:2
                
            }
        );
        
        bone_met_fd => eadv.icd_c79_5.dt.first();
        
        cns_met_fd => eadv.icd_c79_3.dt.first();
        
        adr_met_fd => eadv.icd_c79_7.dt.first();
        
        liver_met_fd => eadv.icd_78_7.dt.first();
        
        lung_met_fd => eadv.icd_78_0.dt.first();
        
        perit_met_fd => eadv.icd_78_6.dt.first();
        
        nodal_met_fd => eadv.[icd_77%].dt.first();
        
        nos_met_fd => eadv.[icd_c79_%,icd_c78_%,icpc_a79009].dt.first();
        
        any_met_fd => eadv.[icd_c77_%,icd_c78_%,icd_c79_%,icpc_a79009].dt.first();
        
        
        [[rb_id]] : { any_met_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of metastatic carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK --
    
    
-- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_solid';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify solid organ carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify solid organ carcinoma",
                is_active:2
                
            }
        );
        
        ca_mets => rout_ca_mets.ca_mets.val.bind();
        
        
        ca_breast_fd => rout_ca_breast.code_fd.val.bind();
        
        ca_prostate_fd => rout_ca_prostate.code_fd.val.bind();
        
        ca_rcc_fd => rout_ca_rcc.code_fd.val.bind();
        
        ca_crc_fd => rout_ca_crc.code_fd.val.bind();
        
        ca_lung_fd => rout_ca_lung.code_fd.val.bind();
        
        ca_thyroid_fd => rout_ca_thyroid.code_fd.val.bind();
        
        any_ca : { coalesce(ca_breast_fd,ca_prostate_fd,ca_rcc_fd,ca_crc_fd,ca_lung_fd,ca_thyroid_fd)!? => 1},{=>0};
        
        op_enc_ld => rout_ca_careplan.op_enc_ld.val.bind();
        
        [[rb_id]] : { any_ca=1 or ca_mets=1 => 1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of solid organ carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --

            rb.blockid := 'ca_breast';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify breast carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify breast carcinoma",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_c50%].dt.first();
                
        icpc_fd => eadv.[icpc_x76001,icpc_x76002].dt.first();
        
        code_fd : { . => least_date(icd_fd,icpc_fd)};
        
        #doc(,
                {
                    txt:"Aromatase inhibitor or anti-oestrogen therapy"
                }
        );  
        
        rxnc_l02bg => eadv.rxnc_l02bg.dt.min().where(val=1);
        
        rxnc_l02ba => eadv.rxnc_l02ba.dt.min().where(val=1);
                
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of breast carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK --
    
     
    -- BEGINNING OF RULEBLOCK --

            rb.blockid := 'ca_prostate';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify prostate carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify prostate carcinoma",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.icd_c61.dt.first();
                
        icpc_fd => eadv.[icpc_y7700%].dt.first();
        
        code_fd : { . => least_date(icd_fd,icpc_fd)};
        
                
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of prostate carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK -- 
   
    -- BEGINNING OF RULEBLOCK --

            rb.blockid := 'ca_rcc';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify renal cell carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify renal cell carcinoma",
                is_active:2
                
            }
        );
        
        
        icd_fd => eadv.icd_c64.dt.first();
                
        icpc_fd => eadv.[icpc_u75003].dt.first();
        
        code_fd : { . => least_date(icd_fd,icpc_fd)};
                
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of Renal cell carcinoma RCC",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_crc';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify colorectal carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify colorectal",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_c18%,icd_c19,icd_c20].dt.first();
                
        icpc_fd => eadv.[icpc_d75%].dt.first();
        
        code_fd : { . => least_date(icd_fd,icpc_fd)};
      
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of colorectal carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK -- 
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_lung';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify lung carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify lung carcinoma",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_c34%].dt.first();
                
        icpc_fd => eadv.[icpc_r84%].dt.first();
        
        code_fd : { . => least_date(icd_fd,icpc_fd)};
      
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of lung carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK -- 
    
       
     -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_thyroid';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify thyroid carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify thyroid carcinoma",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_c37%].dt.first();
                
        icpc_fd => eadv.[icpc_t71%].dt.first();
        
        code_fd : { . => least_date(icd_fd,icpc_fd)};
      
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of thyroid carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
    -- END OF RULEBLOCK -- 
    
         
     -- BEGINNING OF RULEBLOCK --

    rb.blockid := 'ca_endometrial';
    DELETE FROM rman_ruleblocks
    WHERE
        blockid = rb.blockid;

    rb.picoruleblock := '
    
        /*  This is a algorithm to identify thyroid carcinoma  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a algorithm to identify thyroid carcinoma",
                is_active:2
                
            }
        );
        
        icd_fd => eadv.[icd_c54_1].dt.first();                
        
        code_fd : { . => least_date(icd_fd)};
      
        [[rb_id]] : { code_fd!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of endometrial carcinoma",
                is_reportable:1,
                type:2
            }
        );
        
        
    ';
    rb.picoruleblock := replace(rb.picoruleblock, '[[rb_id]]', rb.blockid);
    rb.picoruleblock := rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks (
        blockid,
        picoruleblock
    ) VALUES (
        rb.blockid,
        rb.picoruleblock
    );

    COMMIT;
END;