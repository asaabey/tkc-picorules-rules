CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_c_gn';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
     /* Rule block to determine coded glomerulonephritis */ 
     
     
     #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine CKD by cause",
                is_active:2
                
            }
     );
     
     #doc(,{txt :"
        Chronic glomerular injury or suggestive of
     "});
     
     
          
     #doc(,{txt :"
        N00  U88007 Acute nephritic syndrome
        N01  Rapidly progressive nephritic syndrome
        N02  Recurrent and persistent hematuria
        N03  U88008 Chronic nephritic syndrome
        N04  U88003 U88002  Nephrotic syndrome
        N05  U88005	U88004  Unspecified nephritic syndrome
        N06  Isolated proteinuria with specified morphological lesion
        N07  Hereditary nephropathy not elsewhere classified
        N08  U88001 Glomerular disorders in diseases classified elsewhere
        M32_14  Lupus nephritis
     "});
     
     c_n00 => eadv.[icd_n00%,icpc_u88007].dt.min();
     
     c_n01 => eadv.[icd_n01%].dt.min();
     
     c_n02 => eadv.[icd_n02%].dt.min();
     
     c_n03 => eadv.[icd_n03%,icpc_u88007].dt.min();
     
     c_n04 => eadv.[icd_n04%,icpc_u88003,icpc_u88002].dt.min();
     
     c_n05 => eadv.[icd_n05%,icpc_u88004,icpc_u88005].dt.min();
     
     c_n06 => eadv.[icd_n06%].dt.min();
     
     c_n07 => eadv.[icd_n07%].dt.min();
     
     c_n08 => eadv.[icd_n08%,icpc_u88001].dt.min();
     
     c_u88 => eadv.[icpc_u88005].dt.min();
     
     c_m3214 =>eadv.[icd_m32_14].dt.min(); 
     
     gn : { coalesce(c_n00,c_n01,c_n02,c_n03,c_n04,c_n05,c_n07,c_n08,c_u88,c_m3214)!? =>1},{=>0};
     
     gn_nephritic : { coalesce(c_n00,c_n01,c_n02,c_n03,c_n05,c_n07,c_u88,c_m3214)!? =>1},{=>0};
     
     gn_nephrotic : { coalesce(c_n04,c_n06)!? =>1},{=>0};
     
     gn_chronic : {coalesce(c_n01,c_n02,c_n03,c_n05,c_n06,c_n07,c_n08,c_u88,c_m3214)!? => 1},{=>0};
     
     
     [[rb_id]] : { . => gn};
     
     
     #define_attribute(
            [[rb_id]],
            {
                label:"Glomerulonephritis GN Acute or Chronic",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     
     #define_attribute(
            gn_chronic,
            {
                label:"Glomerulonephritis GN Chronic",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     #define_attribute(
            gn_nephritic,
            {
                label:"Glomerulonephritis GN Nephritic",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     #define_attribute(
            gn_nephrotic,
            {
                label:"Glomerulonephritis GN Nephrotic",
                desc:"Integer [0-1] if found ",
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
    
        
    rb.blockid:='ckd_c_tid';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
     /* Rule block to determine coded tubulointerstitial disease */ 
     
     
     #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine coded tubulointerstitial disease",
                is_active:2
                
            }
     );
     
     #doc(,{txt :"
        Chronic tubulo-interstitial disease
     "});
     
     #doc(,{txt :"
        N11  Chronic tubulo-interstitial nephritis
        N12  Tubulo-interstitial nephritis not specified as acute or chronic
        N13  Obstructive and reflux uropathy
        N14  Drug- and heavy-metal-induced tubulo-interstitial and tubular conditions
        N15  Other renal tubulo-interstitial diseases
        N16  Renal tubulo-interstitial disorders in diseases classified elsewhere
        N25  Disorders resulting from impaired renal tubular function
     "});
     
     
     c_n11 => eadv.[icd_n11%].dt.min();
     
     c_n12 => eadv.[icd_n12%].dt.min();
     
     c_n13 => eadv.[icd_n13%].dt.min();
     
     c_n14 => eadv.[icd_n14%].dt.min();
     
     c_n15 => eadv.[icd_n15%].dt.min();
     
     c_n16 => eadv.[icd_n16%].dt.min();
     
     c_n25 => eadv.[icd_n25%].dt.min();
     
     [[rb_id]] : { coalesce(c_n11,c_n12,c_n13,c_n14,c_n15,c_n16,c_n25)!? =>1 },{=>0};
     
     #define_attribute(
            [[rb_id]],
            {
                label:"Renal Tubulo-interstitial disease Chronic",
                desc:"Integer [0-1] if found ",
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
    
        
    rb.blockid:='ckd_c_rnm';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
     /* Rule block to determine coded conditions leading to reduced nephron mass */ 
     
     
     #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine coded conditions leading to reduced nephron mass",
                is_active:2
                
            }
     );
     
     #doc(,{txt :"
        Chronic tubulo-interstitial disease
     "});
     
     #doc(,{txt :"
        Q60  Renal agenesis and other reduction defects of kidney
        Q61  U85008 U85001 Cystic kidney disease
        Q62  Congenital obstructive defects of renal pelvis and congenital malformations of ureter
        Q63  U85005 U85009 U99020 Other congenital malformations of kidney
        Q64  Other congenital malformations of urinary system
        Z90_5   U28006 Single kidney U52012 partial Nephrectomy U52006 partial Nephrectomy
        C64     U75003 U52014 Renal Neoplasm
        "
     });
     
     c_q60 => eadv.[icd_q60%].dt.min();
     
     c_q61 => eadv.[icd_q61%,icpc_u85008,icpc_u85001].dt.min();
     
     c_q61_2 => eadv.[icd_q61_2,icpc_u85001].dt.min();
     
     c_q62 => eadv.[icd_q62%].dt.min();
     
     c_q63 => eadv.[icd_q63%,icpc_u85005,icpc_u85009,icpc_u99020].dt.min();
     
     c_q64 => eadv.[icd_q64%].dt.min();
     
     c_c64 => eadv.[icd_c64%,icpc_u75003,icpc_u52014].dt.min();
     
     c_z90_5 => eadv.[icd_z90_5,icpc_u52012,icpc_u52006].dt.min();
     
     apkd : { c_q61_2!? => 1},{=>0};
     
     [[rb_id]] : { coalesce(c_q60,c_q61,c_q62,c_q63,c_q64,c_c64,c_z90_5)!? =>1 },{=>0};
     
     #define_attribute(
            [[rb_id]],
            {
                label:"Renal structural anatomical anomaly",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     
     #define_attribute(
            apkd,
            {
                label:"Adult polycystic kidney disease",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     
     
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
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
   
     /*
     gn_ln => eadv.icd_m32_14.dt.count(0); 
     gn_x => eadv.[icd_n0%,icpc_u88%].dt.count(0); 
     */
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
     
     c_n00 => rout_ckd_c_gn.c_n00.val.bind();
     
     c_n01 => rout_ckd_c_gn.c_n01.val.bind();
     
     c_n02 => rout_ckd_c_gn.c_n02.val.bind();
     
     c_n03 => rout_ckd_c_gn.c_n03.val.bind();
     
     c_n04 => rout_ckd_c_gn.c_n04.val.bind();
     
     c_n05 => rout_ckd_c_gn.c_n05.val.bind();
     
     c_n06 => rout_ckd_c_gn.c_n06.val.bind();
     
     c_n07 => rout_ckd_c_gn.c_n07.val.bind();
     
     c_n08 => rout_ckd_c_gn.c_n08.val.bind();
     
     c_u88 => rout_ckd_c_gn.c_u88.val.bind();
     
     c_m3214 => rout_ckd_c_gn.c_m3214.val.bind();
     
     aet_gn : { coalesce(c_n00,c_n01,c_n02,c_n03,c_n04,c_n05,c_n07,c_n08,c_u88,c_m3214)!? =>1};   
     
     #doc(,{txt :"
        N10  Acute pyelonephritis
        N11  Chronic tubulo-interstitial nephritis
        N12  Tubulo-interstitial nephritis not specified as acute or chronic
        N13  Obstructive and reflux uropathy
        N14  Drug- and heavy-metal-induced tubulo-interstitial and tubular conditions
        N15  Other renal tubulo-interstitial diseases
        N16  Renal tubulo-interstitial disorders in diseases classified elsewhere
     "});
     
     c_n11 => rout_ckd_c_tid.c_n11.val.bind();
     
     c_n12 => rout_ckd_c_tid.c_n12.val.bind();
     
     c_n13 => rout_ckd_c_tid.c_n13.val.bind();
     
     c_n14 => rout_ckd_c_tid.c_n14.val.bind();
     
     c_n15 => rout_ckd_c_tid.c_n15.val.bind();
     
     c_n16 => rout_ckd_c_tid.c_n16.val.bind();
     
     c_n25 => rout_ckd_c_tid.c_n25.val.bind();
     
     aet_tid : { coalesce(c_n11,c_n12,c_n13,c_n14,c_n15,c_n16,c_n25)!? =>1 };
     
     
     #doc(,{txt :"
        N17  Acute kidney failure
        N18  Chronic kidney disease (CKD)
        N19  Unspecified kidney failure
     "});

     c_n17 => eadv.[icd_n17%].dt.min();
     
     aet_aki : { c_n17!? => 1};
     
     #doc(,{txt :"
        N20  Calculus of kidney and ureter
        N21  Calculus of lower urinary tract
        N22  Calculus of urinary tract in diseases classified elsewhere
        N23  Unspecified renal colic
     "});
     
     c_n20_n23 => eadv.[icd_n20%,icd_n21%,icd_n22%,icd_n23%].dt.min();
     
     aet_calc : { c_n20_n23!? =>1};
     
     #doc(,{txt :"
        
        N26  Unspecified contracted kidney
        N27  Small kidney of unknown cause
        N28  Other disorders of kidney and ureter not elsewhere classified
        N29  Other disorders of kidney and ureter in diseases classified elsewhere
     "});
     
     c_n26_n27 => eadv.[icd_n26%,icd_n27%].dt.min();
     
     aet_struc : { c_n26_n27!? => 1};
     
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
     
     aet_bladder : { coalesce(c_n30_n39,c_n40)!?  =>1 };
     
     #doc(,{txt :"
        Q60  Renal agenesis and other reduction defects of kidney
        Q61  Cystic kidney disease
        Q62  Congenital obstructive defects of renal pelvis and congenital malformations of ureter
        Q63  Other congenital malformations of kidney
        Q64  Other congenital malformations of urinary system
        "
     });
     
     
     c_q60 => rout_ckd_c_rnm.c_q60.val.bind();
     
     c_q61 => rout_ckd_c_rnm.c_q61.val.bind();
     
     c_q61_2 => rout_ckd_c_rnm.c_q61_2.val.bind();
     
     c_q62 => rout_ckd_c_rnm.c_q62.val.bind();
     
     c_q63 => rout_ckd_c_rnm.c_q63.val.bind();
     
     c_q64 => rout_ckd_c_rnm.c_q64.val.bind();
     
     c_c64 => rout_ckd_c_rnm.c_c64.val.bind();
     
     c_z90_5 => rout_ckd_c_rnm.c_z90_5.val.bind();
     
     esrd : {rrt in (1,2,3,4) =>1},{=>0};
     
     aet_rnm : { coalesce(c_q60,c_q61,c_q62,c_q63,c_q64,c_c64,c_z90_5)!? =>1 };
     
     #doc(,
        {
            txt :"CKD due to structural and Genetic disease needs to be included here"
        }
     );
     
     #doc(,
        {
            txt :"candidate for causality"
        }
     );
     
     canddt : {ckd>0 or rrt>0=>1},{=>0};
     
     aet_dm : {canddt=1 and dm>0 =>1};
        
     #define_attribute(
            aet_dm,
            {
                label:"CKD aetiology likely diabetes",
                desc:"Integer [0-1] if CKD aetiology likely diabetes ",
                is_reportable:1,
                type:2
            }
     );
     
     aet_htn : {canddt=1 and htn>0 and dm=0 =>1};
     
     #define_attribute(
            aet_htn,
            {
                label:"CKD aetiology likely hypertension",
                desc:"Integer [0-1] if CKD aetiology likely hypertension",
                is_reportable:1,
                type:2
            }
     );
     
     aet_gn_ln : {canddt=1 and sle>0 =>1};
     
     #define_attribute(
            aet_gn_ln,
            {
                label:"CKD aetiology likely Lupus nephritis",
                desc:"Integer [0-1] if CKD aetiology likely Lupus nephritis ",
                is_reportable:1,
                type:2
            }
     );
     
     
     
     #define_attribute(
            aet_gn,
            {
                label:"CKD aetiology likely other GN",
                desc:"Integer [0-1] if CKD aetiology likely other GN ",
                is_reportable:1,
                type:2
            }
     );

     aet_cardinality : { canddt=1 => coalesce(aet_dm,0) + coalesce(aet_htn,0) + coalesce(aet_gn_ln,0) + coalesce(aet_gn,0) + coalesce(aet_rnm,0)};
     
     aet_multiple : { canddt=1 and aet_cardinality >1 => 1},{=>0};
     
     #doc(,
        {
            txt :"Determine causality"
        }
        
    );
     
     [[rb_id]] : { coalesce(aet_gn,aet_tid,aet_aki,aet_calc,aet_struc,aet_bladder,aet_rnm,aet_dm,aet_htn,aet_gn_ln)!? => 1},{=>0};
     
     
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
    
END;





