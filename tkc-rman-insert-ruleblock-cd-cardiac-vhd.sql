CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
    
    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_vhd';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess cardiac disease  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess cardiac disease",
                is_active:2
                
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
                is_active:2
                
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
        
        htn =>rout_cd_htn.cd_htn.val.bind();
        
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
        
        nv_af : { af=1 and vhd=0 =>1},{=>0};
        
        cha2ds2vasc : { nv_af=1 => age_score + gender_score + chf_hx_score + cva_score +cvd_score + dm_score},{=>0};
        
           
        
        
        [[rb_id]] : {af=1 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "Presence of AF",
                desc:"Presence of AF",
                is_reportable:1,
                type:2
                
            }
        );
        
        #define_attribute(nv_af,
            { 
                label: "Presence of Non-Valvular AF",
                desc:"Presence of Non-Valvular AF",
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

    rb.blockid:='cd_cardiac_rhd';

    
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess rheumatic heart disease  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess rheumatic heart disease",
                is_active:2
                
            }
        );
        
            #doc(,
                {
                    txt:"rheumatic heart disease based on coding"
                }
            );  
            
            rhd_dt => eadv.[icd_i05%,icd_i06%,icd_i07%,icd_i08%,icd_i09%,icpc_k71%].dt.min();
            
            rhd_aet : {rhd_dt!? => 1},{=>0};
           
            [[rb_id]] : {. => rhd_aet};
            
            #define_attribute(
            [[rb_id]],
                {
                    label:"rheumatic heart disease",
                    desc:"Presence of rheumatic heart disease",
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





