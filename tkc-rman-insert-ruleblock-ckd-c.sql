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
     
     c_m3214 =>eadv.icd_m32_14.dt.min(); 
     
     gn : { coalesce(c_n00,c_n01,c_n02,c_n03,c_n04,c_n05,c_n07,c_n08,c_u88,c_m3214)!? =>1},{=>0};
     
     gn_nephritic : { coalesce(c_n00,c_n01,c_n02,c_n03,c_n05,c_n07,c_u88,c_m3214)!? =>1},{=>0};
     
     gn_nephrotic : { coalesce(c_n04,c_n06)!? =>1},{=>0};
     
     gn_chronic : {coalesce(c_n01,c_n02,c_n03,c_n05,c_n06,c_n07,c_n08,c_u88,c_m3214)!? => 1},{=>0};
     
     
     [[rb_id]] : { . => gn};
     
     
     #define_attribute(
            [[rb_id]],
            {
                label:"Glomerulonephritis (GN) Acute or Chronic",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     
     #define_attribute(
            gn_chronic,
            {
                label:"Glomerulonephritis (GN) Chronic",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     #define_attribute(
            gn_nephritic,
            {
                label:"Glomerulonephritis (GN) Nephritic",
                desc:"Integer [0-1] if found ",
                is_reportable:1,
                type:2
            }
     );
     #define_attribute(
            gn_nephrotic,
            {
                label:"Glomerulonephritis (GN) Nephrotic",
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
        Z90_5   U28006 Single kidney
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
     
     apkd : { c_q61_2!? => 1},{=>0};
     
     [[rb_id]] : { coalesce(c_q60,c_q61,c_q62,c_q63,c_q64,c_c64)!? =>1 },{=>0};
     
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
    
END;





