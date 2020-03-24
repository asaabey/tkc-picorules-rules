CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine RRT status*/
        
        #define_ruleblock(rrt,
            {
                description: "Rule block to determine RRT status",
                version: "0.0.2.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:1,
                filter: "SELECT eid FROM rout_core_info_entropy WHERE icd=1 or icpc=1"
                
            }
        );

        #doc(,
            {
                txt : "Haemodialysis episode ICD proc codes and problem ICPC2p coding",
                cite : "rrt_hd_icd,rrt_pd_icd"
            }
        );
        hd_z49_n => eadv.icd_z49_1.dt.count();
        
        hd_z49_1y_n => eadv.icd_z49_1.dt.count().where(dt>sysdate-365);
        
        hd_dt0 => eadv.[caresys_1310000,icpc_u59001,icpc_u59008,icd_z49_1].dt.max(); 
        hd_dt => eadv.icd_z49_1.dt.max(); 
        
        hd_dt_min => eadv.icd_z49_1.dt.min();
        
        #doc(,
            {   
                txt : "Peritoneal episode ICD and problem ICPC2p coding"
            }
        );
        
        pd_dt => eadv.[caresys_1310006,caresys_1310007,caresys_1310008,icpc_u59007,icpc_u59009,icd_z49_2].dt.max();
        
        pd_dt_min => eadv.[caresys_1310006,caresys_1310007,caresys_1310008,icpc_u59007,icpc_u59009,icd_z49_2].dt.min();
        
        #doc(,
            {
                txt : "Transplant problem ICPC2p coding"
            }
        );
        tx_dt => eadv.icpc_u28001.dt.max();
        
        #doc(,
            {
                txt : "Transplant problem ICD coding"
            }
        );
        tx_dt_icd => eadv.icd_z94_0.dt.max();
        
        #doc(,
            {
                txt : "Home-haemodialysis ICPC2p coding"
            }
        );
        homedx_dt => eadv.[icpc_u59j99].dt.max();
        
        
        ren_enc => eadv.enc_op_renal.dt.max();
        
        #doc(,
            {
                txt: "Determine RRT category based on chronology. RRT cat 1 [HD] requires more than 10 sessions within last year"
            }
        );
        
        [[rb_id]]:{hd_dt > nvl(greatest_date(pd_dt,tx_dt,homedx_dt),lower__bound__dt) and hd_z49_1y_n>10  and hd_dt>sysdate-365 => 1},
            {pd_dt > nvl(greatest_date(hd_dt,tx_dt,homedx_dt),lower__bound__dt) => 2},
            {tx_dt > nvl(greatest_date(hd_dt,pd_dt,homedx_dt),lower__bound__dt) => 3},
            {homedx_dt > nvl(greatest_date(hd_dt,pd_dt,tx_dt),lower__bound__dt) => 4},
            {=>0};
        #doc(,
            {
                txt: "Generate binary variables for rrt categories"
            }
        );
            
        rrt_hd : {rrt=1 => 1},{=>0};
        
        rrt_pd : {rrt=2 => 1},{=>0};
        
        rrt_tx : {rrt=3 => 1},{=>0};
        
        rrt_hhd : {rrt=4 => 1},{=>0};
        
        hd_incd : {hd_dt_min > sysdate-365 and hd_z49_n>=10 => 1},{=>0};
          
        pd_incd : {pd_dt_min > sysdate-365 => 1},{=>0};
        
        rrt_incd : { hd_incd=1 or pd_incd=1 => 1},{=>0};
        
        #doc(,
            {
                txt:"Current transplant patient based on 2y encounter activity"
            }
        );
        
        tx_current : { rrt_tx=1 and ren_enc>sysdate-731 => 1 },{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Renal replacement therapy category.",
                desc:"Integer [1-4] where 1=HD, 2=PD, 3=TX, 4=HHD",
                is_reportable:0,
                type:2
            }
        );
        
        #define_attribute(
            rrt_hd,
            {
                label:"RRT Haemodialysis",
                is_reportable:1,
                type:2
            }
        );
        
         #define_attribute(
            rrt_pd,
            {
                label:"RRT Peritoneal dialysis",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            rrt_tx,
            {
                label:"RRT Renal transplant",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            rrt_hhd,
            {
                label:"RRT Home haemodialysis",
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
    
        
    rb.blockid:='ckd';

    

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to stage CKD */
        
          #define_ruleblock(ckd,
            {
                description: "Rule block to stage CKD",
                version: "0.0.2.3",
                blockid: "ckd",
                target_table:"rout_ckd",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckd",
                def_predicate:">0",
                exec_order:2
                
            }
        );
        
        #doc(,
            {
                txt:"Gather RRT details for exclusion and check assumption violation"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();        
        
        #doc(,
            {
                txt:"Calculate information quantity [iq]"
            }
        );
                
        
        iq_uacr => eadv.lab_ua_acr.val.count(0);
        iq_egfr => eadv.lab_bld_egfr_c.val.count(0);
        iq_coding => eadv.[icd_%,icpc_%].dt.count(0);
        
        iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4},
                {least(iq_egfr,iq_uacr)>=2 => 3},
                {least(iq_egfr,iq_uacr)>=1 => 2},
                {iq_egfr>0 or iq_uacr>0 => 1},
                {=>0};
        
        
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
        
        
        egfr_l => eadv.lab_bld_egfr_c.val.lastdv();
        
        egfr_l1 => eadv.lab_bld_egfr_c.val.lastdv().where(dt<egfr_l_dt-90 and dt>egfr_l_dt-365);
        
        egfr_f => eadv.lab_bld_egfr_c.val.firstdv();
        
        
        egfr_single:{ iq_egfr=1 =>1},{=>0};
        egfr_multiple:{ iq_egfr>1 =>1},{=>0};
        egfr_outdated:{ (sysdate-egfr_l_dt>730) =>1},{=>0};
        
        egfr_tspan : {1=1 => egfr_l_dt-egfr_f_dt};
        
        #doc(,
            {
                txt : "Check for 1 year egfr assumption violation"
            }
        );
        
        egfr_1y_delta : {egfr_l1_val is not null => egfr_l_val-egfr_l1_val};
        
        asm_viol_1y : {abs(egfr_1y_delta)>20 => 1},{=> 0};
        
        #doc(,
            {
                txt : "Check for 1 month egfr assumption violation"
            }
        );
        
        egfr_1m_n2 => eadv.lab_bld_egfr_c.val.count(0).where(dt>egfr_l_dt-30);
        egfr_1m_mu => eadv.lab_bld_egfr_c.val.avg().where(dt>egfr_l_dt-30);
        
        egfr_1m_qt : {egfr_1m_n2>=2 => round(egfr_l_val/egfr_1m_mu,2)};
        
        asm_viol_1m : {nvl(egfr_1m_qt,1)>1.2 or nvl(egfr_1m_qt,1)<0.8  => 1},{=> 0};
               
        #doc(,
            {
                txt : "calculate egfr slope and related metrics"
            }
        );

        
        
        
        egfr_max => eadv.lab_bld_egfr_c.val.maxldv();
        
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
                txt : "calculate uacr metrics"
            }
        );
        
       
        acr_l => eadv.lab_ua_acr.val.lastdv();
        
        
        acr_outdated : {sysdate-acr_l_dt > 730 =>1},{=>0};
        
        #doc(,
            {
                txt : "check for eGFR and uACR persistence based on KDIGO persistence definition "
            }
        );
        
        
        
        
        
        egfr_3m_n => eadv.lab_bld_egfr_c.val.count(0).where(dt<egfr_l_dt-90 and val<60);
        acr_3m_n => eadv.lab_ua_acr.val.count(0).where(dt<acr_l_dt-30 and val>3);
        
        pers : {least(egfr_3m_n,acr_3m_n)>0 => 1},{=>0};
        
        
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
        
        
        
        ckd_stage :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => `1`},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => `2`},
                {cga_g=`G3A` => `3A`},
                {cga_g=`G3B` => `3B`},
                {cga_g=`G4` => `4`},
                {cga_g=`G5` => `5`},
                {=> null};
        #doc(,
            {
                txt : "KDIGO 2012 numeric composite attribute"
            }
        );
        
        
        
        ckd :{cga_g=`G1` and cga_a in (`A2`,`A3`,`A4`) => 1},
                {cga_g=`G2` and cga_a in (`A2`,`A3`,`A4`) => 2},
                {cga_g=`G3A` => 3},
                {cga_g=`G3B` => 4},
                {cga_g=`G4` => 5},
                {cga_g=`G5` => 6},
                {=> 0};
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
        
        cp_l => eadv.careplan_h9_v1.val.lastdv();
        
        cp_ckd : {cp_l_val is not null => to_number(substr(to_char(cp_l_val),-5,1))},{=>0};
        
        cp_ckd_ld : {cp_l_dt is not null => cp_l_dt};
        
        #doc(,
            {
                txt : "Gather ICPC2+ coding from EHR, note that val has to set to ordered rank"
            }
        );
        
        
        dx_ckd0_  => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039,icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j95,6].val.last();
        
        dx_ckd : { 1=1 => nvl(dx_ckd0_,0)};
        
        
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
        
        enc_n => eadv.enc_op_renal.dt.count();
        enc_ld => eadv.enc_op_renal.dt.max();
        enc_fd => eadv.enc_op_renal.dt.min();
        
        enc_null : {nvl(enc_n,0)=0 => 0},{=>1};
        
        #doc(,
            {
                txt : "Access formation"
            }
        );
        
        avf => eadv.caresys_3450901.dt.max();
        
        cp_mis :{cp_ckd>0 and (ckd - cp_ckd)>=2 => 1},{=>0};
        
        avf_has : { avf is not null =>1},{=>0};
        
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
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_cause';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
     /* Rule block to determine causality for CKD */ 
     
     
     #define_ruleblock(ckd_cause,
            {
                description: "Rule block to determine causality for CKD",
                version: "0.0.2.2",
                blockid: "ckd_cause",
                target_table:"rout_ckd_cause",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckd_cause",
                def_predicate:">0",
                exec_order:3
                
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
     
     #doc(,
        {
            txt :"Calculate information quantity [IQ]"
        }
        
    );
     
     
     /* 
     iq_uacr => eadv.lab_ua_acr.val.count(0).where(dt>sysdate-730); 
     iq_egfr => eadv.lab_bld_egfr_c.val.count(0).where(dt>sysdate-730); 
     iq_coding => eadv.[icd_%,icpc_%].dt.count(0); 
     iq_tier: {iq_coding>1 and least(iq_egfr,iq_uacr)>=2 => 4}, {least(iq_egfr,iq_uacr)>=2 => 3}, {least(iq_egfr,iq_uacr)>=1 => 2}, {iq_egfr>0 or iq_uacr>0 => 1}, {=>0}; 
     */ 
    
     
     gn_ln => eadv.icd_m32_14.dt.count(0); 
     gn_x => eadv.[icd_n0%,icpc_u88%].dt.count(0); 
     
     c_n00 => eadv.[icd_n00%].dt.min();
     
     c_n01 => eadv.[icd_n01%].dt.min();
     
     c_n03 => eadv.[icd_n03%].dt.min();
     
     c_n04 => eadv.[icd_n04%].dt.min();
     
     c_n05 => eadv.[icd_n05%].dt.min();
     
     c_n07 => eadv.[icd_n07%].dt.min();
     
     c_n08 => eadv.[icd_n08%].dt.min();
     
     c_n10_n16 => eadv.[icd_n10%,icd_n11%,icd_n12%,icd_n13%,icd_n14%,icd_n15%,icd_n16%].dt.min();
     
     c_n17 => eadv.[icd_n17%].dt.min();
     
     c_n20_n23 => eadv.[icd_n20%,icd_n21%,icd_n22%,icd_n23%].dt.min();
     
     c_n26_n27 => eadv.[icd_n26%,icd_n27%].dt.min();
     
     c_n30_n39 => eadv.[icd_n3%].dt.min();
     
     c_n40 => eadv.[icd_n40%].dt.min();
     
     c_q60 => eadv.[icd_q60%].dt.min();
     
     c_q61 => eadv.[icd_q61%].dt.min();
     
     c_q62 => eadv.[icd_q62%].dt.min();
     
     c_q63 => eadv.[icd_q63%].dt.min();
     
     c_q64 => eadv.[icd_q64%].dt.min();
     
     
     
     
     
     
     
     aet_dm : {ckd>0 and dm>0 =>1},{=>0};
     
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
     
     aet_htn : {ckd>0 and htn>0 and dm=0 =>1},{=>0};
     
     #define_attribute(
            aet_htn,
            {
                label:"CKD aetiology likely hypertension",
                desc:"Integer [0-1] if CKD aetiology likely hypertension",
                is_reportable:1,
                type:2
            }
     );
     
     aet_gn_ln : {ckd>0 and gn_ln>0 =>1},{=>0};
     
     #define_attribute(
            aet_gn_ln,
            {
                label:"CKD aetiology likely Lupus nephritis",
                desc:"Integer [0-1] if CKD aetiology likely Lupus nephritis ",
                is_reportable:1,
                type:2
            }
     );
     
     aet_gn_x : {ckd>0 and gn_x>0 and dm=0 =>1},{=>0};
     
     #define_attribute(
            aet_gn_x,
            {
                label:"CKD aetiology likely other GN",
                desc:"Integer [0-1] if CKD aetiology likely other GN ",
                is_reportable:1,
                type:2
            }
     );

     aet_cardinality : { ckd>0 => aet_dm + aet_htn + aet_gn_ln + aet_gn_x };
     
     aet_multiple : { ckd>0 and aet_cardinality >1 => 1},{=>0};
     
     #doc(,
        {
            txt :"Determine causality"
        }
        
    );
     
     ckd_cause : { ckd>0 and greatest(aet_dm,aet_htn,aet_gn_ln,aet_gn_x)>0 => 1},{=>0};
     
     
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
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_journey';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine journey of CKD */
        
         #define_ruleblock(ckd_journey,
            {
                description: "Rule block to determine journey of CKD",
                version: "0.0.2.1",
                blockid: "ckd_journey",
                target_table:"rout_ckd_journey",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckdj",
                def_predicate:">0",
                exec_order:3
                
            }
    );
        
        #doc(,
            {
                txt :"Get CKD status"
            }
        );
        
        
        
               
        ckd => rout_ckd.ckd.val.bind();       
        
        #doc(,
            {
                txt : "Gather encounter procedure and careplan"
            }
        );
          
        enc_n => eadv.enc_op_renal.dt.count();
        enc_ld => eadv.enc_op_renal.dt.max();
        enc_fd => eadv.enc_op_renal.dt.min();
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
        
        ckdj : { coalesce(edu_init, edu_rv,enc_fd) is not null => 1},{=>0};
        
        #define_attribute(
            ckdj,
            {
                label:"Renal services interaction",
                desc:"Integer [0-1] if Renal services interaction found",
                is_reportable:1,
                type:2
            }
        );
        
        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_diagnostics';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine diagnostics */
        
        #define_ruleblock(ckd_diagnostics,
            {
                description: "Rule block to determine diagnostics",
                version: "0.0.2.1",
                blockid: "ckd_diagnostics",
                target_table:"rout_ckd_diagnostics",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckd_dx",
                def_predicate:">0",
                exec_order:3
                
            }
        );
             
        
        ckd => rout_ckd.ckd.val.bind();
        
        #doc(,
            {
                txt:"Gather lab workup"
            }
        );
        
        
        
        acr_lv => eadv.lab_ua_acr.val.last();
        
        
        ua_rbc_lv => eadv.[lab_ua_rbc,lab_ua_poc_rbc].val.last();
        ua_rbc_ld => eadv.[lab_ua_rbc,lab_ua_poc_rbc].dt.max();
        
        ua_wcc_lv => eadv.[lab_ua_leucocytes,lab_ua_poc_leucocytes].val.last();
        ua_wcc_ld => eadv.[lab_ua_leucocytes,lab_ua_poc_leucocytes].dt.max();
                
        sflc_kappa_lv => eadv.lab_bld_sflc_kappa.val.last();
        sflc_lambda_lv => eadv.lab_bld_sflc_lambda.val.last();
        sflc_kappa_ld => eadv.lab_bld_sflc_kappa.dt.max();
        sflc_lambda_ld => eadv.lab_bld_sflc_lambda.dt.max();
        
        paraprot_lv => eadv.lab_bld_spep_paraprotein.val.last();
        paraprot_ld => eadv.lab_bld_spep_paraprotein.dt.max();
        
        pr3_lv => eadv.lab_bld_anca_pr3.val.last();
        mpo_lv => eadv.lab_bld_anca_mpo.val.last();
        pr3_ld => eadv.lab_bld_anca_pr3.dt.max();
        mpo_ld => eadv.lab_bld_anca_mpo.dt.max();
        
        dsdna_lv => eadv.lab_bld_dsdna.val.last();
        dsdna_ld => eadv.lab_bld_dsdna.dt.max();
        
        c3_lv => eadv.lab_bld_complement_c3.val.last();
        c4_lv => eadv.lab_bld_complement_c4.val.last();
        
        c3_ld => eadv.lab_bld_complement_c3.dt.max();
        c4_ld => eadv.lab_bld_complement_c4.dt.max();
        
        ris_usk_ld => eadv.enc_ris_usk.dt.max();
        ris_bxk_ld => eadv.enc_ris_bxk.dt.max();
        
        c3_pos : { nvl(c3_lv,0)<0.2 and nvl(c3_lv,0)>0 => 1},{=>0};
        c4_pos : { nvl(c4_lv,0)<0.2 and nvl(c4_lv,0)>0 => 1},{=>0};
        
        dsdna_pos : { nvl(dsdna_lv,0)>6 => 1},{=>0};
        sflc_ratio : { nvl(sflc_lambda_lv,0)>0 => round(nvl(sflc_kappa_lv,0)/sflc_lambda_lv,2)},{=1};
        
        sflc_ratio_abn : {sflc_ratio<0.26 or sflc_ratio>1.65 =>1 },{=>0};
        
        ua_rbc_pos : {nvl(ua_rbc_lv,0)>=30 =>1},{=>0};
        ua_wcc_pos : {nvl(ua_wcc_lv,0)>=30 =>1},{=>0};
        ua_acr_pos : {nvl(acr_lv,0)>30 =>1},{=>0};
        
        ua_null : { ua_rbc_ld is null => 1},{=>0};
        sflc_null : { sflc_kappa_ld is null =>1},{=>0};
        spep_null : { paraprot_ld is null =>1},{=>0};
        dsdna_null : { dsdna_ld is null =>1},{=>0};
        anca_null : {  pr3_ld is null =>1},{=>0};
        c3c4_null : {  c3_ld is null =>1},{=>0};
        
        
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
        
        
        
        bxk_null : { ris_bxk_ld is null =>1},{=>0};
        
        
        ckd_dx : {ckd>=1 => 1},{=>0};
     
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='ckd_complications';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine CKD complications */
        
        #define_ruleblock(ckd_complications,
            {
                description: "Rule block to determine CKD complications",
                version: "0.0.2.2",
                blockid: "ckd_complications",
                target_table:"rout_ckd_complications",
                environment:"PROD",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:2,
                def_exit_prop:"ckd_compx",
                def_predicate:">0",
                exec_order:3
                
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
        
        esa_null : { esa_lv is null=>1},{=>0};
        
        esa_state : { esa_null=0 and esa_lv=1 => 1},{ esa_null=0 and esa_lv=0 => 2},{=>0};
        
        #doc(,
            {
                txt:"Determine CKD-MBD complications"
            }
        );
        
        
        
        phos_null : {phos_lv is null =>1},{=>0};
        phos_high : {phos_null=0 and phos_lv>=2 =>1},{=>0};
        
        pth_null : {pth_lv is null =>1},{=>0};
        pth_high : {pth_null=0 and pth_lv>=63 =>1},{=>0};
        
        #doc(,
            {
                txt:"Determine CKD electrolyte and acid base complications"
            }
        );
        
        
        k_null : {k_lv is null =>1},{=>0};
        k_high : {k_null=0 and k_lv>=6 =>1},{=>0};      
        
        #doc(,
            {
                txt:"Need to include bicarbonate therapy"
            }
        );
        
        
        hco3_null : {hco3_lv is null =>1},{=>0};
        hco3_low : {hco3_null=0 and hco3_lv<22 =>1},{=>0};
        
        ckd_compx : {ckd>=3 and greatest(hco3_low,k_high,pth_high,phos_high)>0=> 1},{=>0};
        
        #define_attribute(
            ckd_compx,
            {
                label:"CKD complication present",
                desc:"Integer [0-1] if CKD current complication present",
                is_reportable:1,
                type:2
            }
        );
     
    ';
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
                version: "0.0.2.1",
                blockid: "egfr_fit",
                target_table:"rout_egfr_fit",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                rule_author:"asaabey@gmail.com",
                is_active:0,
                def_exit_prop:"egfr_fit",
                def_predicate:">0",
                exec_order:1
                
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
       
       uacr_min => eadv.lab_ua_acr.val.minldv();
       uacr_max => eadv.lab_ua_acr.val.maxldv();
       
      
       sodium1 => eadv.lab_bld_sodium.val.lastdv().where(dt>sysdate-730);
       sodium2 => eadv.lab_bld_sodium.val.lastdv(1).where(dt>sysdate-730);
       sodium3 => eadv.lab_bld_sodium.val.lastdv(2).where(dt>sysdate-730);
       
       sodium_min => eadv.lab_bld_sodium.val.minldv();
       sodium_max => eadv.lab_bld_sodium.val.maxldv();
       
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
       
       potassium_min => eadv.lab_bld_potassium.val.minldv();
       potassium_max => eadv.lab_bld_potassium.val.maxldv();
       
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
       
       bicarb_min => eadv.lab_bld_bicarbonate.val.minldv();
       bicarb_max => eadv.lab_bld_bicarbonate.val.maxldv();
       
       calcium1 => eadv.lab_bld_calcium.val.lastdv().where(dt>sysdate-730);
       calcium2 => eadv.lab_bld_calcium.val.lastdv(1).where(dt>sysdate-730);
       calcium3 => eadv.lab_bld_calcium.val.lastdv(2).where(dt>sysdate-730);
       
       calcium_min => eadv.lab_bld_calcium.val.minldv();
       calcium_max => eadv.lab_bld_calcium.val.maxldv();

       phos1 => eadv.lab_bld_phosphate.val.lastdv().where(dt>sysdate-730);
       phos2 => eadv.lab_bld_phosphate.val.lastdv(1).where(dt>sysdate-730);
       phos3 => eadv.lab_bld_phosphate.val.lastdv(2).where(dt>sysdate-730);
       
       phos_min => eadv.lab_bld_phosphate.val.minldv();
       phos_max => eadv.lab_bld_phosphate.val.maxldv();
       
       hb1 => eadv.lab_bld_hb.val.lastdv().where(dt>sysdate-730);
       hb2 => eadv.lab_bld_hb.val.lastdv(1).where(dt>sysdate-730);
       hb3 => eadv.lab_bld_hb.val.lastdv(2).where(dt>sysdate-730);
       
       hb_min => eadv.lab_bld_hb.val.minldv();
       hb_max => eadv.lab_bld_hb.val.maxldv();
       
       
       ferritin1 => eadv.lab_bld_ferritin.val.lastdv().where(dt>sysdate-730);
       ferritin2 => eadv.lab_bld_ferritin.val.lastdv(1).where(dt>sysdate-730);
       ferritin3 => eadv.lab_bld_ferritin.val.lastdv(2).where(dt>sysdate-730);
       
       ferritin_min => eadv.lab_bld_phosphate.val.minldv();
       ferritin_max => eadv.lab_bld_phosphate.val.maxldv();

       ckd_labs : {nvl(egfr1_val,0)>0 and nvl(egfr2_val,0)>0 => 1 },{=>0};
       
       
     
    ';
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
        
        
        
        u88_att => eadv.[
                            icpc_u88j91,
                            icpc_u88j92,
                            icpc_u88j93,
                            icpc_u88j94,
                            icpc_u88j95,
                            icpc_u88j96
                        ].att.last();
        
        u88_dt => eadv.[icpc_u88j91,icpc_u88j92,icpc_u88j93,icpc_u88j94,icpc_u88j95,icpc_u88j96].dt.last();
        
        u99_att => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].att.last();
        
        u99_dt => eadv.[icpc_u99035,icpc_u99036,icpc_u99037,icpc_u99043,icpc_u99044,icpc_u99038,icpc_u99039].dt.last();
        
        u99f : { u99_att!? => to_number(substr(u99_att,-2))};
        
        u99v : { u99f=35 => 1},{ u99f=36 => 2},{ u99f=37 => 3},{ u99f=43 => 3},{ u99f=44 => 4},{ u99f=38 => 5},{ u99f=39 => 6},{=> 0};
        
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
    
END;





