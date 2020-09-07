CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
    
        
    rb.blockid:='ckd_cause';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
     /* Rule block to determine causality for CKD */ 
     
     
     #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine causality for CKD",
                is_active:2
                
            }
     );
     
     #doc(,
        {
            txt :"Gather coding supporting DM2 HTN LN and other GN",
            cite : "ckd_cause_ref1, ckd_cause_ref2",
        }
        
     );
     
     dm => rout_cd_dm_dx.dm.val.bind(); 
     htn => rout_cd_htn.htn.val.bind();
     ckd => rout_ckd.ckd.val.bind();
     rrt => rout_rrt.rrt.val.bind();
   
     
     gn_ln => eadv.icd_m32_14.dt.count(0); 
     gn_x => eadv.[icd_n0%,icpc_u88%].dt.count(0); 
     
     sle => rout_cd_rheum_sle.cd_rheum_sle.val.bind();
     
     #doc(,{txt :"
        N00  Acute nephritic syndrome
        N01  Rapidly progressive nephritic syndrome
        N02  Recurrent and persistent hematuria
        N03  Chronic nephritic syndrome
        N04  Nephrotic syndrome
        N05  Unspecified nephritic syndrome
        N06  Isolated proteinuria with specified morphological lesion
        N07  Hereditary nephropathy not elsewhere classified
        N08  Glomerular disorders in diseases classified elsewhere
     "});
     
     c_n00 => eadv.[icd_n00%].dt.min();
     
     c_n01 => eadv.[icd_n01%].dt.min();
     
     c_n03 => eadv.[icd_n03%].dt.min();
     
     c_n04 => eadv.[icd_n04%].dt.min();
     
     c_n05 => eadv.[icd_n05%].dt.min();
     
     c_n07 => eadv.[icd_n07%].dt.min();
     
     c_n08 => eadv.[icd_n08%].dt.min();
     
     #doc(,{txt :"
        N10  Acute pyelonephritis
        N11  Chronic tubulo-interstitial nephritis
        N12  Tubulo-interstitial nephritis not specified as acute or chronic
        N13  Obstructive and reflux uropathy
        N14  Drug- and heavy-metal-induced tubulo-interstitial and tubular conditions
        N15  Other renal tubulo-interstitial diseases
        N16  Renal tubulo-interstitial disorders in diseases classified elsewhere
     "});
     
     
     c_n10_n16 => eadv.[icd_n10%,icd_n11%,icd_n12%,icd_n13%,icd_n14%,icd_n15%,icd_n16%].dt.min();
     
     
     #doc(,{txt :"
        N17  Acute kidney failure
        N18  Chronic kidney disease (CKD)
        N19  Unspecified kidney failure
     "});

     c_n17 => eadv.[icd_n17%].dt.min();
     
     
     #doc(,{txt :"
        N20  Calculus of kidney and ureter
        N21  Calculus of lower urinary tract
        N22  Calculus of urinary tract in diseases classified elsewhere
        N23  Unspecified renal colic
     "});
     
     c_n20_n23 => eadv.[icd_n20%,icd_n21%,icd_n22%,icd_n23%].dt.min();
     
     #doc(,{txt :"
        N25  Disorders resulting from impaired renal tubular function
        N26  Unspecified contracted kidney
        N27  Small kidney of unknown cause
        N28  Other disorders of kidney and ureter not elsewhere classified
        N29  Other disorders of kidney and ureter in diseases classified elsewhere
     "});
     
     c_n26_n27 => eadv.[icd_n26%,icd_n27%].dt.min();
     
     #doc(,{txt :"
        N30  Cystitis
        N31  Neuromuscular dysfunction of bladder not elsewhere classified
        N32  Other disorders of bladder
        N33  Bladder disorders in diseases classified elsewhere
        N34  Urethritis and urethral syndrome
        N35  Urethral stricture
        N36  Other disorders of urethra
        N37  Urethral disorders in diseases classified elsewhere
        N39  Other disorders of urinary system
     "});
     
     
     c_n30_n39 => eadv.[icd_n3%].dt.min();
     
     #doc(,{txt :"
        N40  Benign prostatic hyperplasia
     "}); 
     
     c_n40 => eadv.[icd_n40%].dt.min();
     
     #doc(,{txt :"
        Q60  Renal agenesis and other reduction defects of kidney
        Q61  Cystic kidney disease
        Q62  Congenital obstructive defects of renal pelvis and congenital malformations of ureter
        Q63  Other congenital malformations of kidney
        Q64  Other congenital malformations of urinary system
        "
     });
     
     c_q60 => eadv.[icd_q60%].dt.min();
     
     c_q61 => eadv.[icd_q61%].dt.min();
     
     c_q62 => eadv.[icd_q62%].dt.min();
     
     c_q63 => eadv.[icd_q63%].dt.min();
     
     c_q64 => eadv.[icd_q64%].dt.min();
     
     canddt : {ckd>0 or rrt>0=>1},{=>0};
     
     aet_dm : {canddt=1 and dm>0 =>1},{=>0};
     
     #doc(,
        {
            txt :"CKD due to structural and Genetic disease needs to be included here"
        }
        
     );
     
     
     #define_attribute(
            aet_dm,
            {
                label:"CKD aetiology likely diabetes",
                desc:"Integer [0-1] if CKD aetiology likely diabetes ",
                is_reportable:1,
                type:2
            }
     );
     
     aet_htn : {canddt=1 and htn>0 and dm=0 =>1},{=>0};
     
     #define_attribute(
            aet_htn,
            {
                label:"CKD aetiology likely hypertension",
                desc:"Integer [0-1] if CKD aetiology likely hypertension",
                is_reportable:1,
                type:2
            }
     );
     
     aet_gn_ln : {canddt=1 and (gn_ln>0 or sle>0) =>1},{=>0};
     
     #define_attribute(
            aet_gn_ln,
            {
                label:"CKD aetiology likely Lupus nephritis",
                desc:"Integer [0-1] if CKD aetiology likely Lupus nephritis ",
                is_reportable:1,
                type:2
            }
     );
     
     aet_gn_x : {canddt=1 and (gn_x>0 or sle>0) =>1},{=>0};
     
     #define_attribute(
            aet_gn_x,
            {
                label:"CKD aetiology likely other GN",
                desc:"Integer [0-1] if CKD aetiology likely other GN ",
                is_reportable:1,
                type:2
            }
     );

     aet_cardinality : { canddt=1 => aet_dm + aet_htn + aet_gn_ln + aet_gn_x };
     
     aet_multiple : { canddt=1 and aet_cardinality >1 => 1},{=>0};
     
     #doc(,
        {
            txt :"Determine causality"
        }
        
    );
     
     [[rb_id]] : { greatest(aet_dm,aet_htn,aet_gn_ln,aet_gn_x)>0 => 1},{=>0};
     
     
     #define_attribute(
            ckd_cause,
            {
                label:"CKD cause",
                desc:"Integer [0-1] if CKD aetiology found ",
                is_reportable:0,
                type:2
            }
    );
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_journey';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine journey of CKD */
        
         #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine journey of CKD",
                is_active:2
                
            }
        );
        
        #doc(,
            {
                txt :"Get CKD status"
            }
        );
        
        
        rrt => rout_rrt.rrt.val.bind();
               
        ckd => rout_ckd.ckd.val.bind();       
        
        #doc(,
            {
                txt : "Gather encounter procedure and careplan"
            }
        );
          
        enc_n => eadv.[enc_op_ren,enc_op_rdu].dt.count();
        enc_ld => eadv.[enc_op_ren,enc_op_rdu].dt.max();
        enc_fd => eadv.[enc_op_ren,enc_op_rdu].dt.min();
        
        avf => eadv.caresys_3450901.dt.max();
        
        cp_l => eadv.careplan_h9_v1.val.lastdv();
        
        #doc(,
            {
                txt : "Extract renal specific careplan"
            }
        );
        
       
        cp_ckd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_ckd_ld : {cp_l_dt is not null => cp_l_dt};
        
        #doc(,
            {
                txt :"Gather Nursing and allied health encounters"
            }
        );
        
        
        
        
        edu_init => eadv.enc_op_renal_edu.dt.min().where(val=31);
        
        edu_rv => eadv.enc_op_renal_edu.dt.max().where(val=32);
        
        edu_n => eadv.enc_op_renal_edu.dt.count().where(val=31 or val=32);
        
        
        dietn => eadv.enc_op_renal_edu.dt.max().where(val=61);
        
        sw => eadv.enc_op_renal_edu.dt.max().where(val=51);
        
        enc_multi : { nvl(enc_n,0)>1 =>1},{=>0};
        
        [[rb_id]] : { coalesce(edu_init, edu_rv,enc_fd)!? and rrt=0 => 1},{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Renal services interaction",
                desc:"Integer [0-1] if Renal services interaction found",
                is_reportable:1,
                type:2
            }
        );
        
        
        
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_diagnostics';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine diagnostics */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine diagnostics",
                is_active:2
            }
        );
             
        
        ckd => rout_ckd.ckd.val.bind();
        
        #doc(,
            {
                txt:"Gather lab workup"
            }
        );
        
        
        
        acr => eadv.lab_ua_acr._.lastdv();
        
                
        ua_rbc => eadv.[lab_ua_rbc,lab_ua_poc_rbc]._.lastdv();
        
                
        ua_wcc => eadv.[lab_ua_leucocytes,lab_ua_poc_leucocytes]._.lastdv();
                
        sflc_kappa => eadv.[lab_bld_sflc_kappa,lab_code_c332x]._.lastdv();
        sflc_lambda => eadv.[lab_bld_sflc_lambda,lab_code_c332x]._.lastdv();
        
        spep => eadv.[lab_bld_spep_paraprotein,lab_code_c331n]._.lastdv();
        
        pr3 => eadv.[lab_bld_anca_pr3,lab_code_c314v]._.lastdv();
        mpo => eadv.[lab_bld_anca_mpo,lab_code_c314v]._.lastdv();
        
        anca => eadv.[lab_code_c314v]._.lastdv();
        
        ana => eadv.[lab_code_316b]._.lastdv();
        dsdna => eadv.[lab_bld_dsdna,lab_code_c331b]._.lastdv();
        
        c3 => eadv.lab_bld_complement_c3._.lastdv();
        c4 => eadv.lab_bld_complement_c4._.lastdv();
        
        b2gpa => eadv.[lab_code_c319x]._.lastdv();
        aca => eadv.[lab_code_c323b]._.lastdv();
        
        cryo => eadv.[lab_code_c327t]._.lastdv();
        
        gbma => eadv.[lab_code_c333n]._.lastdv();
        
        asot => eadv.[lab_code_s2136]._.lastdv();
        
        
        ris_usk_ld => eadv.[enc_ris_usk,ris_code_uskidney].dt.max();
        ris_bxk_ld => eadv.[enc_ris_bxk,lab_code_t141,ris_code_usbiokidney].dt.max();
        
        
        
        c3_pos : { nvl(c3_val,0)<0.2 and nvl(c3_val,0)>0 => 1},{=>0};
        c4_pos : { nvl(c4_val,0)<0.2 and nvl(c4_val,0)>0 => 1},{=>0};
        
         
        
        dsdna_pos : { nvl(dsdna_val,0)>6 => 1},{=>0};
        sflc_ratio : { nvl(sflc_lambda_val,0)>0 => round(nvl(sflc_kappa_val,0)/sflc_lambda_val,2)},{=1};
        
        sflc_ratio_abn : {sflc_ratio<0.26 or sflc_ratio>1.65 =>1 },{=>0};
        
        ua_rbc_pos : {nvl(ua_rbc_val,0)>=30 =>1},{=>0};
        ua_wcc_pos : {nvl(ua_wcc_val,0)>=30 =>1},{=>0};
        ua_acr_pos : {nvl(acr_val,0)>30 =>1},{=>0};
        
          
        
        ua_pos : { ua_rbc_pos=1 and ua_wcc_pos=0 and ua_acr_pos=1 =>1 },
                { ua_rbc_pos=1 and ua_wcc_pos=1 => 2 },
                {=>0};
        
        #doc(,
            {
                txt:"Determine radiology (regional imaging) encounters"
            }
        );
        
        
        usk_null : { ris_usk_ld is null =>1},{=>0};
        
        #doc(,
            {
                txt: "Determine renal biopsy status"
            }
        );
        
        bxk : { ris_bxk_ld!? =>1},{=>0};  
        
        bxk_null : { ris_bxk_ld?  =>1},{=>0};
        
        canddt : {coalesce(ua_rbc_dt,spep_dt,ana_dt,dsdna_dt,anca_dt,c3_dt,asot_dt,aca_dt,b2gpa_dt,cryo_dt,ris_usk_ld,ris_bxk_ld)!? =>1},{=>0};
        
        canddt_gn_wu : {ckd>0 and canddt=1 =>1},{=>0};
        
        canddt_bx : {canddt=1 =>1},{=>0};
        
        [[rb_id]] : {greatest(canddt_gn_wu,canddt_bx)>0 => 1},{=>0};
        
        #define_attribute(
            bxk,
            {
                label:"Native kidney biopsy",
                desc:"Native kidney biopsy",
                is_reportable:1,
                type:2
            }
        );
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_complications';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine CKD complications */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine CKD complications",
                is_active:2                
            }
        );
                
        #doc(,
            {
                txt:"Complications including Hb low, metabolic bone, and electrolyte disturbances",
                cite : "ckd_complications_ref1, ckd_complications_ref2"
            }
        );        
        
        ckd => rout_ckd.ckd.val.bind(); 
        
        #doc(,
            {
                txt:"Haematenics"
            }
        );
        
        
        
        hb_lv => eadv.lab_bld_hb.val.last();
        hb_ld => eadv.lab_bld_hb.dt.max();
        
        plt_lv => eadv.lab_bld_platelets.val.last();
        
        wcc_neut_lv => eadv.lab_bld_wcc_neutrophils.val.last();
        wcc_eos_lv => eadv.lab_bld_wcc_eosinophils.val.last();
        
        rbc_mcv_lv => eadv.lab_bld_rbc_mcv.val.last();
        
        
        
        esa_lv => eadv.rxnc_b03xa.val.last();
        esa_ld => eadv.rxnc_b03xa.dt.max();
        
        b05_ld => eadv.[rxnc_b05cb,rxnc_b05xa].dt.max().where(val=1);
        
        #doc(,
            {
                txt:"Electrolytes"
            }
        );
        
        
        
        k_lv => eadv.lab_bld_potassium.val.last();
        k_ld => eadv.lab_bld_potassium.dt.max();
        
        
        ca_lv => eadv.lab_bld_calcium_corrected.val.last();
        ca_ld => eadv.lab_bld_calcium_corrected.val.last();
        
        phos_lv => eadv.lab_bld_phosphate.val.last();
        hco3_lv => eadv.lab_bld_bicarbonate.val.last();
        
        alb_lv => eadv.lab_bld_albumin.val.last();
        
        
        pth_lv => eadv.lab_bld_pth.val.last();
        pth_ld => eadv.lab_bld_pth.val.last();
        
        fer_lv => eadv.lab_bld_ferritin.val.last();
        fer_ld => eadv.lab_bld_ferritin.dt.max();
        
        #doc(,
            {
                txt:"Determine haematenic complications"
            }
        );
        
        
        hb_state : { nvl(hb_lv,0)>0 and nvl(hb_lv,0)<100 =>1},
                    { nvl(hb_lv,0)>=100 and nvl(hb_lv,0)<180 =>2},
                    { nvl(hb_lv,0)>180 =>3},
                    {=>0};
                    
        mcv_state : { hb_state=1 and nvl(rbc_mcv_lv,0)>0 and nvl(rbc_mcv_lv,0)<70 => 11 },
                    { hb_state=1 and nvl(rbc_mcv_lv,0)>=70 and nvl(rbc_mcv_lv,0)<80 => 12 },
                    { hb_state=1 and nvl(rbc_mcv_lv,0)>=80 and nvl(rbc_mcv_lv,0)<=100 => 20 },
                    { hb_state=1 and nvl(rbc_mcv_lv,0)>=100 => 31 },{ =>0};
                    
        iron_low : { hb_state=1 and nvl(fer_lv,0)>0 and nvl(fer_lv,0)<250 => 1},{=>0};
        
        thal_sig : {mcv_state=11 =>1 },{=>0};
        
        esa_null : { esa_lv? =>1},{=>0};
        
        esa_state : { esa_null=0 and esa_lv=1 => 1},{ esa_null=0 and esa_lv=0 => 2},{=>0};
        
        #doc(,
            {
                txt:"Determine CKD-MBD complications"
            }
        );
        
        
        
        phos_null : {phos_lv? =>1},{=>0};
        phos_high : {phos_null=0 and phos_lv>=2 =>1},{=>0};
        
        pth_null : {pth_lv? =>1},{=>0};
        pth_high : {pth_null=0 and pth_lv>=63 =>1},{=>0};
        
        #doc(,
            {
                txt:"Determine CKD electrolyte and acid base complications"
            }
        );
        
        
        k_null : {k_lv? =>1},{=>0};
        k_high : {k_null=0 and k_lv>=6 =>1},{=>0};      
        
        #doc(,
            {
                txt:"Need to include bicarbonate therapy"
            }
        );
        
        
        hco3_null : {hco3_lv? =>1},{=>0};
        hco3_low : {hco3_null=0 and hco3_lv<22 =>1},{=>0};
        
        rcm_bicarb : {hco3_low=1 and b05_ld? => 1},{=>0};
        
        [[rb_id]] : {ckd>=3 and greatest(hco3_low,k_high,pth_high,phos_high)>0=> 1},{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"CKD complication present",
                desc:"Integer [0-1] if CKD current complication present",
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
    
        
    rb.blockid:='egfr_fit';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine egfr fit */
        
        #define_ruleblock(egfr_fit,
            {
                description: "Rule block to determine egfr fit",
                is_active:0
                
            }
        );

       egfr_max => eadv.lab_bld_egfr_c.val.maxldv();
       
       egfr_min => eadv.lab_bld_egfr_c.val.minldv();
       
       egfr_first => eadv.lab_bld_egfr_c.val.firstdv();
       
       egfr_last => eadv.lab_bld_egfr_c.val.lastdv();
       
       egfr_n => eadv.lab_bld_egfr_c.val.count(0);
       
       egfr_b0_ => eadv.lab_bld_egfr_c.val.regr_slope();
       
       egfr_c0_ => eadv.lab_bld_egfr_c.val.regr_intercept();
       
       egfrs => eadv.lab_bld_egfr_c.val.serializedv(val~dt);
       
       egfr_b : { egfr_b0_ is not null => round(egfr_b0_,1)},{=>0};
       
       egfr_c : { egfr_c0_ is not null => round(egfr_c0_,0)},{=>0};
       
       dspan : { 1=1 => egfr_last_dt - egfr_first_dt};
       
       egfr_fit : { egfr_n >0 =>1},{=>0};
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_labs';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to gather lab tests */
        
        #define_ruleblock(ckd_labs,
            {
                description: "Rule block to gather lab tests",
                version: "0.0.2.1",
                blockid: "ckd_labs",
                target_table:"rout_ckd_labs",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckd_labs",
                def_predicate:">0",
                exec_order:1
                
            }
        );


       egfr1 => eadv.lab_bld_egfr_c.val.lastdv().where(dt>sysdate-730);
       egfr2 => eadv.lab_bld_egfr_c.val.lastdv(1).where(dt>sysdate-730);
       egfr3 => eadv.lab_bld_egfr_c.val.lastdv(2).where(dt>sysdate-730);
       
       creat1 => eadv.lab_bld_creatinine.val.lastdv().where(dt>sysdate-730);
       creat2 => eadv.lab_bld_creatinine.val.lastdv(1).where(dt>sysdate-730);
       creat3 => eadv.lab_bld_creatinine.val.lastdv(2).where(dt>sysdate-730);
       

       
       uacr1 => eadv.lab_ua_acr.val.lastdv().where(dt>sysdate-730);
       uacr2 => eadv.lab_ua_acr.val.lastdv(1).where(dt>sysdate-730);
       uacr3 => eadv.lab_ua_acr.val.lastdv(2).where(dt>sysdate-730);
       
       uacr_min => eadv.lab_ua_acr.val.minldv().where(dt>sysdate-730);
       uacr_max => eadv.lab_ua_acr.val.maxldv().where(dt>sysdate-730);
       
      
       sodium1 => eadv.lab_bld_sodium.val.lastdv().where(dt>sysdate-730);
       sodium2 => eadv.lab_bld_sodium.val.lastdv(1).where(dt>sysdate-730);
       sodium3 => eadv.lab_bld_sodium.val.lastdv(2).where(dt>sysdate-730);
       
       sodium_min => eadv.lab_bld_sodium.val.minldv().where(dt>sysdate-730);
       sodium_max => eadv.lab_bld_sodium.val.maxldv().where(dt>sysdate-730);
       
       sodium_ref_u : {1=1 =>140};
       sodium_ref_l : {1=1 =>130};
       sodium_mu : {1=1 => (sodium_ref_u + sodium_ref_l)/2};
       
       sodium1_x : { 1=1 => round(( 200/sodium_mu) * sodium1_val,0)};
       sodium2_x : { 1=1 => round(( 200/sodium_mu) * sodium2_val,0)};
       
       sodium_min_x : { 1=1 => round(( 200/sodium_mu) * sodium_min_val,0)};
       sodium_max_x : { 1=1 => round(( 200/sodium_mu) * sodium_max_val,0)};
       
       potassium1 => eadv.lab_bld_potassium.val.lastdv().where(dt>sysdate-730);
       potassium2 => eadv.lab_bld_potassium.val.lastdv(1).where(dt>sysdate-730);
       potassium3 => eadv.lab_bld_potassium.val.lastdv(2).where(dt>sysdate-730);
       
       potassium_min => eadv.lab_bld_potassium.val.minldv().where(dt>sysdate-730);
       potassium_max => eadv.lab_bld_potassium.val.maxldv().where(dt>sysdate-730);
       
       potassium_ref_u : {1=1 =>5.5};
       potassium_ref_l : {1=1 =>3.5};
       potassium_mu : {1=1 => (potassium_ref_u + potassium_ref_l)/2};
       
       potassium1_x : { 1=1 => round(( 200/potassium_mu) * potassium1_val,0)};
       potassium2_x : { 1=1 => round(( 200/potassium_mu) * potassium2_val,0)};
       
       potassium_min_x : { 1=1 => round(( 200/potassium_mu) * potassium_min_val,0)};
       potassium_max_x : { 1=1 => round(( 200/potassium_mu) * potassium_max_val,0)};
       
       bicarb1 => eadv.lab_bld_bicarbonate.val.lastdv().where(dt>sysdate-730);
       bicarb2 => eadv.lab_bld_bicarbonate.val.lastdv(1).where(dt>sysdate-730);
       bicarb3 => eadv.lab_bld_bicarbonate.val.lastdv(2).where(dt>sysdate-730);
       
       bicarb_min => eadv.lab_bld_bicarbonate.val.minldv().where(dt>sysdate-730);
       bicarb_max => eadv.lab_bld_bicarbonate.val.maxldv().where(dt>sysdate-730);
       
       calcium1 => eadv.lab_bld_calcium.val.lastdv().where(dt>sysdate-730);
       calcium2 => eadv.lab_bld_calcium.val.lastdv(1).where(dt>sysdate-730);
       calcium3 => eadv.lab_bld_calcium.val.lastdv(2).where(dt>sysdate-730);
       
       calcium_min => eadv.lab_bld_calcium.val.minldv().where(dt>sysdate-730);
       calcium_max => eadv.lab_bld_calcium.val.maxldv().where(dt>sysdate-730);

       phos1 => eadv.lab_bld_phosphate.val.lastdv().where(dt>sysdate-730);
       phos2 => eadv.lab_bld_phosphate.val.lastdv(1).where(dt>sysdate-730);
       phos3 => eadv.lab_bld_phosphate.val.lastdv(2).where(dt>sysdate-730);
       
       phos_min => eadv.lab_bld_phosphate.val.minldv().where(dt>sysdate-730);
       phos_max => eadv.lab_bld_phosphate.val.maxldv().where(dt>sysdate-730);
       
       hb1 => eadv.lab_bld_hb.val.lastdv().where(dt>sysdate-730);
       hb2 => eadv.lab_bld_hb.val.lastdv(1).where(dt>sysdate-730);
       hb3 => eadv.lab_bld_hb.val.lastdv(2).where(dt>sysdate-730);
       
       hb_min => eadv.lab_bld_hb.val.minldv().where(dt>sysdate-730);
       hb_max => eadv.lab_bld_hb.val.maxldv().where(dt>sysdate-730);
       
       
       ferritin1 => eadv.lab_bld_ferritin.val.lastdv().where(dt>sysdate-730);
       ferritin2 => eadv.lab_bld_ferritin.val.lastdv(1).where(dt>sysdate-730);
       ferritin3 => eadv.lab_bld_ferritin.val.lastdv(2).where(dt>sysdate-730);
       
       ferritin_min => eadv.lab_bld_phosphate.val.minldv().where(dt>sysdate-730);
       ferritin_max => eadv.lab_bld_phosphate.val.maxldv().where(dt>sysdate-730);

       ckd_labs : {nvl(egfr1_val,0)>0 and nvl(egfr2_val,0)>0 => 1 },{=>0};
       
       
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    COMMIT;
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --

    rb.blockid:='ckd_coded_dx';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Evaluate existing coded ckd diagnoses  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Evaluate existing coded ckd diagnoses",
                is_active:2
            }
        );
        
        #doc(,
            {
                txt : "Gather ICPC2+ coding from EHR"
            }
        );
        
        
        u88_att => eadv.[
                            icpc_u88j91,
                            icpc_u88j92,
                            icpc_u88j93,
                            icpc_u88j94,
                            icpc_u88j95,
                            icpc_u88j96
                        ].att.last();
        
        u88_dt => eadv.[icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j96].dt.last();
        
        u99_att => eadv.[
                            icpc_u99035,
                            icpc_u99036,
                            icpc_u99037,
                            icpc_u99043,
                            icpc_u99044,
                            icpc_u99038,
                            icpc_u99039
                        ].att.last();
        
        u99_dt => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].dt.last();
        
        u99f : { u99_att!? => to_number(substr(u99_att,-2))};
        
        u99v :  { u99f=35 => 1},
                { u99f=36 => 2},
                { u99f=37 => 3},
                { u99f=43 => 3},
                { u99f=44 => 4},
                { u99f=38 => 5},
                { u99f=39 => 6},
                {=> 0};
        
        u88v : { u88_att!? => to_number(substr(u88_att,-1))},{=>0};
        
        [[rb_id]] : { u99_dt > u88_dt => u99v },{ u88_dt > u99_dt => u88v},{ => greatest(u88v,u99v)};
        
        
        #define_attribute([[rb_id]],
            { 
                label: "Existing coded ckd diagnoses"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_egfr_metrics';

    

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to Calculate egfr metrics */
        
          #define_ruleblock([[rb_id]],
            {
                description: "Rule block to Calculate egfr metrics",
                is_active:2                
            }
        );
        
        
                
        #doc(,
            {
                txt : "Calculate egfr metrics"
            }
        );
        
        #doc(,
            {
                txt : "Gather last first and penultimate within 3-12 month windows with cardinality"
            }
        );
        
        
        egfr_l => eadv.lab_bld_egfr_c._.lastdv();
        
        egfr_l1 => eadv.lab_bld_egfr_c._.lastdv().where(dt<egfr_l_dt-90 and dt>egfr_l_dt-365);
        
        egfr_l2 => eadv.lab_bld_egfr_c._.lastdv().where(dt < egfr_l_dt-365);
        
        egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
        
        egfr_outdated:{ (sysdate-egfr_l_dt>730) =>1},{=>0};
        
        
        #doc(,
            {
                txt : "Check for 30 day egfr assumption violation with a threshold of 20% change between last and 30 days avg"
            }
        );
        
        egfr_30_n2 => eadv.lab_bld_egfr_c.val.count().where(dt>egfr_l_dt-30);
        egfr_30_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfr_l_dt-30);
        
        egfr_30_qt : {egfr_30_n2>=2 => round(egfr_l_val/egfr_30_mu,2)};
        
        asm_viol_30 : {nvl(egfr_30_qt,1)>1.2 or nvl(egfr_30_qt,1)<0.8  => 1},{=> 0};
        
        

        #doc(,
            {
                txt : "Check for 1 year egfr assumption violation with absolute 20 units change"
            }
        );
        
        egfr_1y_delta : {egfr_l1_val!? => egfr_l_val-egfr_l1_val};
        
        asm_viol_1y : {abs(egfr_1y_delta)>20 => 1},{=> 0};
        
        
        #doc(,
            {
                txt : "Composite Assumption violation "
            }
        );
        
        g_asm_viol_ex : { asm_viol_1y=1 or asm_viol_30=1 =>0},{=>1};
               
        #doc(,
            {
                txt : "calculate egfr slope and related metrics"
            }
        );

        
        
        egfr_max => eadv.lab_bld_egfr_c._.maxldv();
        
        egfr_ld_max_n => eadv.lab_bld_egfr_c.dt.count(0).where(dt>egfr_max_dt and dt < egfr_l_dt);
        
        #doc(,
            {
                txt : "Slope between last and last maximum value, assuming last max represents baseline"
            }
        );
        
        
        
        egfr_slope2 : {egfr_l_dt > egfr_max_dt => round((egfr_l_val-egfr_max_val)/((egfr_l_dt-egfr_max_dt)/365),2)};
        
        egfr_decline : {egfr_l_dt - egfr_max_dt >365 and egfr_ld_max_n >2 and egfr_max_val - egfr_l_val>=20 => 1},{=>0};
        
        egfr_rapid_decline : { egfr_decline=1 and egfr_slope2<-10 =>1},{=>0};
        
        
        
        
        #doc(,
            {
                txt : "Check for 90 day egfr persistence"
            }
        );
        
        
        g_pers : { egfr_l1_val<90 and egfr_l_val<60 => 1},{ egfr_l2_val<90 and egfr_l_val<60 =>1},{=>0};
        
        #doc(,
            {
                txt : "Check for 1y egfr progression"
            }
        );
        
        ckd_prog : { egfr_l2_val!? =>1},{=>0};
   
        l_l2_delta : { egfr_l2_val!? => egfr_l_val-egfr_l2_val};
        
        g_stage_prog : {l_l2_delta < -15 =>1},{=>0};

        #doc(,
            {
                txt : "Apply KDIGO 2012 staging",
                cite: "ckd_ref1, ckd_ref2"
            }
        );
        
        
        
        [[rb_id]]:  {egfr_l_val>=90 => 1},
                {egfr_l_val<90 AND egfr_l_val>=60 => 2},
                {egfr_l_val<60 AND egfr_l_val>=45 => 3},
                {egfr_l_val<45 AND egfr_l_val>=30 => 4},
                {egfr_l_val<30 AND egfr_l_val>=15 => 5},
                {egfr_l_val<15 => 6},
                {=>0};

        
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
      -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_uacr_metrics';

    

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to Calculate uacr metrics */
        
          #define_ruleblock([[rb_id]],
            {
                description: "Rule block to Calculate uacr metrics",
                is_active:2
                
            }
        );
        
        #doc(,
            {
                txt : "calculate uacr metrics"
            }
        );
        
       
        acr_l => eadv.lab_ua_acr._.lastdv();
        
        
        acr_outdated : {sysdate-acr_l_dt > 730 =>1},{=>0};
        
        #doc(,
            {
                txt : "check for uACR persistence based on KDIGO persistence definition "
            }
        );
        
        
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt<acr_l_dt-30 and val>3);
        
        a_pers : {acr_3m_n>0 => 1},{=>0};
        
        #doc(,
            {
                txt : "check for uACR assumption violation"
            }
        );
        
        
        a_asm_viol_ex : { . =>1};
        #doc(,
            {
                txt : "Apply KDIGO 2012 staging",
                cite: "ckd_ref1, ckd_ref2"
            }
        );
        
            
        [[rb_id]]: {acr_l_val<3 => 1},
                {acr_l_val<30 AND acr_l_val>=3 => 2},
                {acr_l_val<300 AND acr_l_val>=30 => 3},
                {acr_l_val>300 => 4},{=>0};
                

            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_access';

    

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to stage CKD */
        
          #define_ruleblock([[rb_id]],
            {
                description: "Rule block to stage CKD",
                is_active:2
                
            }
        );
        
       #doc(,
            {
                txt : "Access formation"
            }
        );
        
        avf => eadv.[caresys_3450901,caresys_3451200,caresys_3451800,icpc_k99049].dt.max();
        
        
        avf_has : { avf!?  =>1},{=>0};
        
        [[rb_id]] :{ avf!? =>1},{=>0};
                
        #define_attribute(
            avf_has,
            {
                label:"AVF present",
                is_reportable:0,
                type:2
            }
        );

            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_careplan';

    

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to assess careplan */
        
          #define_ruleblock([[rb_id]],
            {
                description: "Rule block to assess careplan",
                is_active:2
                
            }
        );
        
       #doc(,
            {
                txt : "Gather careplan info and extract CKD specific component"
            }
        );
        
        cp_l => eadv.careplan_h9_v1.val.lastdv();
        
        cp_ckd_val : {cp_l_val!? => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_ckd_ld : {cp_l_dt!? => cp_l_dt};
        
        #doc(,
            {
                txt : " Encounters with specialist services"
            }
        );
        
        enc_n => eadv.enc_op_renal.dt.count();
        enc_ld => eadv.enc_op_renal.dt.max();
        enc_fd => eadv.enc_op_renal.dt.min();
        
        enc_null : {nvl(enc_n,0)=0 => 0},{=>1};

        [[rb_id]] : {. => cp_ckd_val};  
            
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
     
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd';

    

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to stage CKD */
        
          #define_ruleblock([[rb_id]],
            {
                description: "Rule block to stage CKD",
                is_active:2
                
            }
        );
        
       rrt => rout_rrt.rrt.val.bind();
       
       hd_131_n => rout_rrt.hd_131_n.val.bind();
       
       #doc(,
            {
                txt : "Gather egfr metrics "
            }
        );
        
        egfr_l_val => rout_ckd_egfr_metrics.egfr_l_val.val.bind();
        egfr_l_dt => rout_ckd_egfr_metrics.egfr_l_dt.val.bind();
        
        egfr_outdated => rout_ckd_egfr_metrics.egfr_outdated.val.bind();
        /*
        egfr_single => rout_ckd_egfr_metrics.egfr_single.val.bind();
        */
        egfr_decline => rout_ckd_egfr_metrics.egfr_decline.val.bind();
        egfr_rapid_decline => rout_ckd_egfr_metrics.egfr_rapid_decline.val.bind();
        egfr_slope2 => rout_ckd_egfr_metrics.egfr_slope2.val.bind();
        
        
        #doc(,
            {
                txt : "Check for egfr and uacr assumption violation exclusion "
            }
        );
        
        
        g_asm_viol_ex => rout_ckd_egfr_metrics.g_asm_viol_ex.val.bind();
               
        a_asm_viol_ex => rout_ckd_uacr_metrics.a_asm_viol_ex.val.bind();
        
        asm_viol_ex : { g_asm_viol_ex=1 and a_asm_viol_ex=1 =>1},{=>0};
        
        #doc(,
            {
                txt : "Gather uacr metrics"
            }
        );
        
       
        acr_l_dt => rout_ckd_uacr_metrics.acr_l_dt.val.bind();
        
        acr_l_val => rout_ckd_uacr_metrics.acr_l_val.val.bind();
        
        acr_outdated : {sysdate-acr_l_dt > 730 =>1},{=>0};
        
        #doc(,
            {
                txt : "check for eGFR and uACR persistence based on KDIGO persistence definition "
            }
        );
        
        g_pers => rout_ckd_egfr_metrics.g_pers.val.bind();
        
        a_pers => rout_ckd_uacr_metrics.a_pers.val.bind();
        
        pers : {greatest(g_pers,a_pers)>0 => 1},{=>0};
        
        #doc(,
            {
                txt : "Evidence of renal injury satisfying ckd without G and A"
            }
        );
        
        c_gn => rout_ckd_c_gn.ckd_c_gn.val.bind();
        
        c_tid => rout_ckd_c_tid.ckd_c_tid.val.bind();
        
        c_rnm => rout_ckd_c_rnm.ckd_c_rnm.val.bind();
        
        c_crit : { greatest(c_gn,c_tid,c_rnm)>0 =>1},{=>0};
        
        #doc(,
            {
                txt : "Apply KDIGO 2012 staging",
                cite: "ckd_ref1, ckd_ref2"
            }
        );
        
        
        
        cga_g:  {egfr_l_val>=90 AND rrt=0 => `G1`},
                {egfr_l_val<90 AND egfr_l_val>=60  AND rrt=0 => `G2`},
                {egfr_l_val<60 AND egfr_l_val>=45  AND rrt=0 => `G3A`},
                {egfr_l_val<45 AND egfr_l_val>=30  AND rrt=0 => `G3B`},
                {egfr_l_val<30 AND egfr_l_val>=15  AND rrt=0 => `G4`},
                {egfr_l_val<15 AND rrt=0 => `G5`},
                {=>`NA`};
                
                
        cga_g_val:  {egfr_l_val>=90 AND rrt=0 => 1},
                {egfr_l_val<90 AND egfr_l_val>=60  AND rrt=0 => 2},
                {egfr_l_val<60 AND egfr_l_val>=45  AND rrt=0 => 3},
                {egfr_l_val<45 AND egfr_l_val>=30  AND rrt=0 => 4},
                {egfr_l_val<30 AND egfr_l_val>=15  AND rrt=0 => 5},
                {egfr_l_val<15 AND rrt=0 => 6},
                {=>0};
            
        cga_a: {acr_l_val<3 => `A1`},
                {acr_l_val<30 AND acr_l_val>=3 => `A2`},
                {acr_l_val<300 AND acr_l_val>=30 => `A3`},
                {acr_l_val>300 => `A4`},{=>`NA`};
                
        cga_a_val: {acr_l_val<3 => 1},
                {acr_l_val<30 AND acr_l_val>=3 => 2},
                {acr_l_val<300 AND acr_l_val>=30 => 3},
                {acr_l_val>300 => 4},{=>0};
        
        #doc(,
            {
                txt : "KDIGO 2012 string composite attribute"
            }
        );
        
        ckd_stage :{cga_g_val=1 and (cga_a_val>1 or c_crit=1) => `1`},
                {cga_g_val=2 and (cga_a_val>1 or c_crit=1) => `2`},
                {cga_g_val=3 => `3A`},
                {cga_g_val=4 => `3B`},
                {cga_g_val=5 => `4`},
                {cga_g_val=6 => `5`},
                {=> null};
        
                
        ckd_stage_val :{cga_g_val=1 and (cga_a_val>1 or c_crit=1) => 1},
                {cga_g_val=2 and (cga_a_val>1 or c_crit=1) => 2},
                {cga_g_val=3 => 3},
                {cga_g_val=4 => 4},
                {cga_g_val=5 => 5},
                {cga_g_val=6 => 6},
                {=> 0};
            
        #doc(,
            {
                txt : "KDIGO 2012 numeric composite attribute"
            }
        );
        
        
        
        [[rb_id]] : {. => ckd_stage_val};
        
        assert_level : {. => 100000 + pers*10000 + asm_viol_ex*1000};
        
        #doc(,
            {
                txt : "KDIGO 2012 binary attributes"
            }
        );
        
                
        ckd_stage_1 : { ckd=1 => 1},{=>0}; 
        
        ckd_stage_2 : { ckd=2 => 1},{=>0};
        
        ckd_stage_3a : { ckd=3 => 1},{=>0};
        
        ckd_stage_3b : { ckd=4 => 1},{=>0};
        
        ckd_stage_4 : { ckd=5 => 1},{=>0};
        
        ckd_stage_5 : { ckd=6 => 1},{=>0};
             
        #define_attribute(
            ckd_stage,
            {
                label:"CKD stage as string as per KDIGO 2012",
                desc:"VARCHAR2 corresponding to stage. eg.3A",
                is_reportable:0,
                type:1
            }
        );
        
        #define_attribute(
            ckd,
            {
                label:"CKD stage as number as per KDIGO 2012",
                desc:"Integer [1-6] corresponding to ordinal value",
                is_reportable:0,
                type:2
            }
        );
        
        #define_attribute(
            ckd_stage_1,
            {

                label:"CKD stage 1",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            ckd_stage_2,
            {
                label:"CKD stage 2",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            ckd_stage_3a,
            {
                label:"CKD stage 3A",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            ckd_stage_3b,
            {
                label:"CKD stage 3B",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            ckd_stage_4,
            {
                label:"CKD stage 4",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            ckd_stage_5,
            {
                label:"CKD stage 5",
                is_reportable:1,
                type:2
            }
        );
        
        
        #doc(,
            {
                txt : "Gather careplan info and extract CKD specific component"
            }
        );
        
        
        
        cp_ckd_val => rout_ckd_careplan.cp_ckd_val.val.bind();
        
        cp_ckd_ld => rout_ckd_careplan.cp_ckd_ld.val.bind();
        
        #doc(,
            {
                txt : "Gather ICPC2+ coding from EHR"
            }
        );
        
        
        dx_ckd => rout_ckd_coded_dx.ckd_coded_dx.val.bind();
        
        dx_ckd_stage :{dx_ckd=1 => `1`},
                {dx_ckd=2 => `2`},
                {dx_ckd=3 => `3A`},
                {dx_ckd=4 => `3B`},
                {dx_ckd=5 => `4`},
                {dx_ckd=6 => `5`},
                {dx_ckd=0 => `0`};
                
        #define_attribute(
            dx_ckd_stage,
            {
                label:"CKD stage on EHR as per ICPC2+ Code",
                desc:"VARCHAR2 corresponding to stage. eg 3A",
                is_reportable:0,
                type:1
            }
        );
        
        dx_ckd_diff :{abs(ckd-dx_ckd)>=2 => 1 },{=>0};
        
        #define_attribute(
            dx_ckd_diff,
            {
                label:"Difference between coded and calculated",
                desc:"Algebraic difference between numeric stages ",
                is_reportable:0,
                type:2
            }
        );
        
        #doc(,
            {
                txt : " Encounters with specialist services"
            }
        );
        
        enc_n => rout_ckd_careplan.enc_n.val.bind();
        enc_ld => rout_ckd_careplan.enc_ld.val.bind();
        enc_fd => rout_ckd_careplan.enc_fd.val.bind();
        
        enc_null : {nvl(enc_n,0)=0 => 0},{=>1};
        
        #doc(,
            {
                txt : "Access formation"
            }
        );
        
        
        
        cp_mis :{cp_ckd_val>0 and (ckd - cp_ckd_val)>=2 => 1},{=>0};
        
        avf_has => rout_ckd_access.avf_has.val.bind();
        
        #define_attribute(
            cp_mis,
            {
                label:"Misclassifcation occured",
                desc:"Integer [0-1]",
                is_reportable:0,
                type:2
            }
        );
        
        #define_attribute(
            avf_has,
            {
                label:"AVF present",
                is_reportable:1,
                type:2
            }
        );
        
        mm1 : { ckd>3 and coalesce(hd_131_n,0)>0 =>1},{=>0};
        
        
        ';
            rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
        
    -- END OF RULEBLOCK --
END;





