CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_cad';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac disease  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess cardiac disease",
                version: "0.1.2.1",
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
        
            
        
            #doc(,
                {
                    section:"CAD"
                }
            );
            #doc(,
                {
                    txt:"first date of coronary insufficiency based on coding (ICD and ICPC)"
                }
            );    
            
            
            
            cabg => eadv.[icd_z95_1,icpc_k54007].dt.min();
            
            /*cad_mi_icd => eadv.[icd_i21%,icd_i22%,icd_i23%].dt.min();*/
            
            #doc(,
                {
                    txt:"first date of type 2 AMI (not implemented as codes non-existent)"
                }
            );   
            
            /* mi_type2_icd => eadv.icd_i21_a1.dt.min(); */
            
            #doc(,
                {
                    txt:"first and last dates of AMI inclusive of NSTEMI and STEMI and subsequent"
                }
            );  
            
            nstemi_fd_icd => eadv.[icd_i21_4,icd_i22_2].dt.min();
            
            nstemi_fd_icpc => eadv.icpc_k75016.dt.min();        
            
            nstemi_fd : {. => least_date(nstemi_fd_icd,nstemi_fd_icpc)};
            
            stemi_fd_icd => eadv.[icd_i21_0,icd_i21_1,icd_i21_2,icd_i21_3,icd_i22_0,icd_i22_1,icd_i22_8,icd_i22_9].dt.min();
            
            stemi_fd_icpc => eadv.icpc_k75015.dt.min();
            
            stemi_fd : {. => least_date(stemi_fd_icd,stemi_fd_icpc)};
        
            nstemi_ld => eadv.[icpc_k75016,icd_i21_4,icd_i22_2].dt.max().where(dt > nstemi_fd);
            
            stemi_ld => eadv.[icpc_k75015,icd_i21_0,icd_i21_1,icd_i21_2,icd_i21_3,icd_i22_0,icd_i22_1,icd_i22_8,icd_i22_9].dt.max().where(dt > stemi_fd);
            
            ami_icd_null : {coalesce(stemi_fd_icd,nstemi_fd_icd)? => 1};
            
            #doc(,
                {
                    txt:"STEMI vascular region"
                }
            );  
            stemi_anat_0 => eadv.[icd_i21_0,icd_i21_1,icd_i21_2,icd_i21_3].att.first();
            
            stemi_anat : { stemi_anat_0!? => to_number(substr(stemi_anat_0,-1))+1};
            
            #doc(,
                {
                    txt:"AMI complication"
                }
            );
            
            ami_i23 => eadv.[icd_i23].dt.max();
            
            ami : { coalesce(stemi_fd,nstemi_fd,stemi_ld,nstemi_ld,ami_i23)!? => 1},{=>0};
            
            #doc(,
                {
                    txt:"Coronary ischaemia other than AMI"
                }
            );
            
            cad_chronic_icd => eadv.[icd_i24%,icd_i25%].dt.min();
            
            cad_ihd_icpc => eadv.[icpc_k74%,icpc_k76%].dt.min();        
                
            cad_ex_ami :{ coalesce(cad_chronic_icd,cad_ihd_icpc)!? =>1},{=>0};    
            
            cad : { greatest(ami,cad_ex_ami)>0 or cabg!? =>1 },{=>0};
            
            
            
            #doc(,
                {
                    section:"other CVD"
                }
            );
            
            #doc(,
                {
                    txt:"Other atherosclerotic disease"
                }
            );   
            
            
            cva_dt => eadv.[icd_g46%,icpc_k89%,icpc_k90%,icpc_k91%].dt.min();
            
            pvd_dt => eadv.[icd_i70%,icd_i71%,icd_i72%,icd_i73%,icpc_k92%].dt.min();
           
            cva : { cva_dt!? =>1},{=>0};
           
            pvd : { pvd_dt!? =>1},{=>0};
            
            #doc(,
                {
                    txt:"Medication"
                }
            ); 
            
            #doc(,
                {
                    txt: "antiplatelet agents"
                }
            ); 
            
            
            rxn_ap => eadv.[rxnc_b01ac].dt.min().where(val=1);
            
            
            #doc(,
                {
                    txt: "anti-coagulation including NOAC"
                }
            ); 
            
            
            rxn_anticoag => eadv.[rxnc_b01aa,rxnc_b01af,rxnc_b01ae,rxnc_b01ab].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "beta blockers"
                }
            ); 
            
        
            rxn_bb_ag => eadv.rxnc_c07ag.dt.min().where(val=1);
            
            rxn_bb_aa => eadv.rxnc_c07aa.dt.min().where(val=1);
            
            rxn_bb_ab => eadv.rxnc_c07ab.dt.min().where(val=1);
            
            rxn_bb : {. => least_date(rxn_bb_ag,rxn_bb_aa,rxn_bb_ab)};
            
            #doc(,
                {
                    txt: "RAAS blockers"
                }
            ); 
            
            rxn_ace_aa => eadv.rxnc_c09aa.dt.min().where(val=1);
            
            rxn_arb_aa => eadv.rxnc_c09ca.dt.min().where(val=1);
            
            rxn_raas : {. => least_date(rxn_ace_aa, rxn_arb_aa)};
            
            #doc(,
                {
                    txt: "lipid lowering"
                }
            ); 
            
            rxn_statin => eadv.[rxnc_c10aa,rxnc_c10bx,rxnc_c10ba].dt.min().where(val=1);
            
            rxn_c10_ax => eadv.rxnc_c10_ax.dt.min().where(val=1);
           
            rxn : {coalesce(rxn_ap,rxn_anticoag,rxn_bb,rxn_raas,rxn_statin,rxn_c10_ax)!? =>1};
            
            [[rb_id]] : {cad=1 =>1},{=>0};
            
            #define_attribute(
            [[rb_id]],
                {
                    label:"Coronary artery disease",
                    desc:"Presence of Coronary artery disease",
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
   
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_vhd';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac disease  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess cardiac disease",
                version: "0.1.2.1",
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
        
                
            #doc(,
                {
                    section:"VHD"
                }
            );
            #doc(,
                {
                    txt:"rheumatic heart disease based on coding"
                }
            );  
            
            rhd_dt => eadv.[icd_i05%,icd_i06%,icd_i07%,icd_i08%,icd_i09%,icpc_k71%].dt.min();
            
            rhd_aet : {rhd_dt!? => 1},{=>0};
            
            #doc(,
                {
                    txt:"mitral  including rheumatic and non-rheumatic"
                }
            ); 
            
            
            
            mv_s_dt => eadv.[icd_i05_0,icd_i05_2,icd_34_2,icpc_k73006, icpc_k83007,icpc_k71005].dt.min();
            
            mv_i_dt => eadv.[icd_i05_1,icd_i05_2,icd_34_0,icpc_k83004].dt.min();
            
            mv_r_dt => eadv.[icpc_k54009].dt.min();
            
            mv_s : {mv_s_dt!? => 1},{=>0};
            
            mv_i : {mv_i_dt!? => 1},{=>0};
            
            mv_r : {mv_r_dt!? => 1},{=>0};
            
            mv : { greatest(mv_s,mv_i,mv_r)>0 => 1},{=>0};
            
            #doc(,
                {
                    txt:"Aortic  including rheumatic and non-rheumatic"
                }
            ); 
            
                        
            av_s_dt => eadv.[icd_i06_0,icd_35_0, icpc_k83006,icpc_k71008].dt.min();
            
            av_i_dt => eadv.[icd_i06_1,icd_35_1,icpc_k83004].dt.min();
            
            av_r_dt => eadv.[icpc_k54005].dt.min();
            
            av_s : { av_s_dt!? => 1},{=>0};
            
            av_i : { av_i_dt!? => 1},{=>0};
            
            av_r : { av_r_dt!? => 1},{=>0};
            
            av : {greatest(av_s,av_i,av_r)>0 => 1},{=>0};
            
            #doc(,
                {
                    txt:"Tricuspid  including rheumatic and non-rheumatic"
                }
            ); 
            
            tv_s_dt => eadv.[icd_i07_0,icd_36_0].dt.min();
            
            tv_i_dt => eadv.[icd_i07_1,icd_36_1,icpc_k83012].dt.min();
            
            tv_r_dt => eadv.[icpc_k54019].dt.min();
            
            tv_s : { tv_s_dt!? => 1},{=>0};
            
            tv_i : { tv_i_dt!? => 1},{=>0};
            
            tv_r : { tv_r_dt!? => 1},{=>0};
            
            tv : { greatest(tv_s,tv_i,tv_r)>0 => 1},{=>0};
            
           
             #doc(,
                {
                    txt:" infective endocarditis"
                }
            ); 
            
           
            
            
            vhd_ie_icd_dt => eadv.[icd_i33%,icd_i38%,icd_i39%].dt.min();
            
            #doc(,
                {
                    txt:" cardiac outpatient encounters"
                }
            ); 
            
            car_enc_l_dt => eadv.enc_op_car.dt.last();
            
            #doc(,
                {
                    txt:" anticoagulation"
                }
            ); 
            
            rxn_anticoag_dt => rout_cd_cardiac_rx.rxn_anticoag.val.bind();
        
            rxn_anticoag : { rxn_anticoag_dt!? => 1},{=>0};

            vhd : { greatest(mv,av,tv)>0 =>1},{=>0};
            
            
            
            [[rb_id]] : {.=>vhd};
            
            
            #define_attribute(
            [[rb_id]],
                {
                    label:"Valvular heart disease",
                    desc:"Presence of Valvular heart disease",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            mv_s,
                {
                    label:"Mitral valve stenosis",
                    desc:"Presence of Mitral valve stenosis",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            mv_i,
                {
                    label:"Mitral valve insufficiency",
                    desc:"Presence of Mitral valve insufficiency or regurgitation",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            mv_r,
                {
                    label:"Mitral valve replacement",
                    desc:"Presence of Mitral valve replacement",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            av_s,
                {
                    label:"Aortic valve stenosis",
                    desc:"Presence of Aortic valve stenosis",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            av_i,
                {
                    label:"Aortic valve insufficiency",
                    desc:"Presence of Aortic valve insufficiency or regurgitation",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            av_r,
                {
                    label:"Aortic valve replacement",
                    desc:"Presence of Aortic valve replacement",
                    is_reportable:1,
                    type:2
                }
            );
            
            #define_attribute(
            rhd_aet,
                {
                    label:"Rheumatic heart disease",
                    desc:"Presence of Rheumatic heart disease",
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
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_af';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  AF  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a assess chadvas score in AF",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:1,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:3
                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        gender => eadv.dmg_gender.val.last();
        
        
        #doc(,
                {
                    txt:"atrial fibrillation based on coding"
                }
        );  
            
        af_icd => eadv.[icd_i48_%].dt.min();
            
        af_icpc => eadv.[icpc_k78%].dt.min();
            
        af_dt : {.=>least_date(af_icd,af_icpc)};
            
        af : {coalesce(af_icd,af_icpc)!? =>1},{=>0};
        
        vhd => rout_cd_cardiac_vhd.cd_cardiac_vhd.val.bind();
        
        cad =>rout_cd_cardiac_cad.cad.val.bind();
        
        chf =>rout_cd_cardiac_chf.chf.val.bind();
        
        pvd =>rout_cd_cardiac_cad.pvd.val.bind();
        
        cva =>rout_cd_cardiac_cad.cva.val.bind();
        
        htn =>rout_cd_htn.htn.val.bind();
        
        dm =>rout_cd_dm_dx.dm.val.bind();
        
        age : {.=>round((sysdate-dob)/365.25,0)};
        
        rxn_anticoag_dt => rout_cd_cardiac_rx.rxn_anticoag.val.bind();
        
        rxn_anticoag : { rxn_anticoag_dt!? => 1},{=>0};
        
        #doc(,
                {
                    txt: "CHADVASC score"
                }
            ); 
            
        
            
        age_score : {age <65 => 0},{age>75 > 2},{=>1};
            
        gender_score : {.=>gender};
            
        chf_hx_score :{ chf>0 => 1},{=>0};
        
        htn_score : { htn>0 => 1},{=>0};
        
        cva_score : {cva>0 =>2},{=>0};
        
        cvd_score : {cad>0 or pvd>0 =>1},{=>0};
        
        dm_score : { dm>0 => 1},{=>0};
        
        cha2ds2vasc : { af=1 and vhd=0 => age_score + gender_score + chf_hx_score + cva_score +cvd_score + dm_score},{=>0};
        
            
        
        
        [[rb_id]] : {af=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of AF",
                desc:"Presence of AF",
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
   
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_chf';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  CHF  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "This is a assess CHF",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:1,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1
                
            }
        );
        
        #doc(,
                {
                    section:"CHF"
                }
            );
            
        chf_code => eadv.[icd_i50_%],icpc_k77%].dt.min();
            
        chf : {chf_code!? =>1},{=>0};
        
        [[rb_id]] : {chf=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "presence of CHF",
                type : 1001
                
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --

    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_rx';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac medication  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess cardiac medication",
                version: "0.1.2.1",
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
        
           
           #doc(,
            {
                txt: "Medication",
                cite: "cvd_tg_2019,cvd_heart_foundation_2012"
            }
            ); 
            
            
            #doc(,
                {
                    txt: "antiplatelet agents"
                }
            ); 
            
            
            rxn_ap => eadv.[rxnc_b01ac].dt.min().where(val=1);
            
            
            #doc(,
                {
                    txt: "anti-coagulation including NOAC"
                }
            ); 
            
            
            rxn_anticoag => eadv.[rxnc_b01aa,rxnc_b01af,rxnc_b01ae,rxnc_b01ab].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "anti-arrhythmic"
                }
            ); 
            
        
            
            rxn_chrono => eadv.[rxnc_c01%].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "diuretics"
                }
            ); 
            
            rxn_diu_loop => eadv.[rxnc_c03c%].dt.min().where(val=1);
            
            rxn_diu_low_ceil => eadv.[rxnc_c03b%,rxnc_c03a%].dt.min().where(val=1);
            
            rxn_diu_k_sp => eadv.[rxnc_c03d%].dt.min().where(val=1);
            
            #doc(,
                {
                    txt: "lipid lowering"
                }
            ); 
            
            rxn_statin => eadv.[rxnc_c10aa,rxnc_c10bx,rxnc_c10ba].dt.min().where(val=1);
            
            rxn : {coalesce(rxn_statin,rxn_diu_k_sp,rxn_diu_low_ceil,rxn_diu_loop,rxn_chrono,rxn_anticoag,rxn_ap)!? =>1},{=>0};

            
            [[rb_id]] : {rxn=1 =>1},{=>0};
            
            #define_attribute(
            [[rb_id]],
                {
                    label:"Rx cardiac meds",
                    desc:"Presence of cardiac",
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
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_enc';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac encounters  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess cardiac encounters",
                version: "0.1.2.1",
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
        
           car_enc_f_dt => eadv.enc_op_car.dt.first();
           
           car_enc_l_dt => eadv.enc_op_car.dt.last();
           
           [[rb_id]] : {car_enc_l_dt!? => 1},{=>0};
           
            
            #define_attribute(
            [[rb_id]],
                {
                    label:"cardiac outpatient encounter",
                    desc:"Presence of cardiac outpatient encounter",
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





