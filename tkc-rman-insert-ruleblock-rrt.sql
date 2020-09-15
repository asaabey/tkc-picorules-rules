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
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine RRT status",
                is_active:2
                
            }
        );

        #doc(,
            {
                txt : "Haemodialysis episode ICD proc codes and problem ICPC2p coding",
                cite : "rrt_hd_icd,rrt_pd_icd"
            }
        );
        hd_z49_n => eadv.icd_z49_1.dt.count();
        
        hd_131_n => eadv.[caresys_1310000].dt.count();
        
        hd_z49_1y_n => eadv.icd_z49_1.dt.count().where(dt>sysdate-365);
        
        hd_131_1y_n => eadv.[caresys_1310000].dt.count().where(dt>sysdate-365);
        
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
        tx_dt_icpc => eadv.icpc_u28001.dt.max();
        
        #doc(,
            {
                txt : "Transplant problem ICD coding"
            }
        );
        tx_dt_icd => eadv.icd_z94_0.dt.max();
        
        tx_dt : { . => least_date(tx_dt_icpc,tx_dt_icd)};
        
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
        
        [[rb_id]]:{hd_dt > nvl(greatest_date(pd_dt,tx_dt,homedx_dt),lower__bound__dt) and (hd_z49_1y_n>10 or hd_131_1y_n>10)  and hd_dt>sysdate-365 => 1},
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
        
        rrt_past :  {rrt=1 and coalesce(pd_dt,tx_dt,homedx_dt)!? => 1},
                    {rrt=2 and coalesce(hd_dt,tx_dt,homedx_dt)!? => 1},
                    {rrt=3 and coalesce(pd_dt,hd_dt,homedx_dt)!? => 1},
                    {rrt=4 and coalesce(hd_dt,tx_dt,pd_dt)!? => 1},
                    {=>0};
        ;
        
        #doc(,
            {
                txt:"Current transplant patient based on 2y encounter activity"
            }
        );
        
        tx_current : { rrt_tx=1 and ren_enc>sysdate-731 => 1 },{=>0};
        
        #define_attribute(
            [[rb_id]],
            {
                label:"Prevalent renal replacement therapy category [1=HD, 2=PD, 3=TX, 4=HHD]",
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
        
        #define_attribute(
            hd_incd,
            {
                label:"Incident Haemodialysis",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            pd_incd,
            {
                label:"Incident Peritoneal dialysis",
                is_reportable:1,
                type:2
            }
        );
        
        #define_attribute(
            rrt_incd,
            {
                label:"Incident Peritoneal or haemodialysis",
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
    
        
    rb.blockid:='rrt_1_metrics';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine RRT 1 metrics*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine RRT 1 metrics",
                is_active:2
                
            }
        );

        #doc(,
            {
                txt : "rrt session regularity"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        hd_ld => eadv.icd_z49_1.dt.max();
        
        hd_fd => eadv.icd_z49_1.dt.min();
        
        hd_n => eadv.icd_z49_1.dt.count();
        
        hd0_2w_f : { (sysdate - hd_ld)<14 => 1},{=>0};
        
        tspan : { . => hd_ld-hd_fd };
        
        tspan_y : { .=> round(tspan/365,1) };
        
        hd_oe : { tspan > 1 => round(100*(hd_n /tspan)/0.427,0)},{=>0};
        
        hd_tr => eadv.icd_z49_1.dt.temporal_regularity();
        
        hd_sl : { .=> round(hd_tr*100,0) };
        
        
        
        [[rb_id]] : {rrt=1 =>1};
        
       
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --
    
    
     -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_journey';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine RRT 1 metrics*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine RRT 1 metrics",
                is_active:0
                
            }
        );

        #doc(,
            {
                txt : "rrt session regularity"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        hd_dt => eadv.icd_z49_1.dt.max();
        
        hd_dt_2w => eadv.icd_z49_1.dt.max().where(dt> sysdate-14);

        hd0_2w_f : { hd_dt_2w!? => 1},{=>0};
        
        hd_tr => eadv.icd_z49_1.dt.temporal_regularity();
        
        
        
        [[rb_id]] : {. =>1};
        
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
    
        
    rb.blockid:='rrt_causality';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine RRT causality*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine RRT causality",
                is_active:0
                
            }
        );

        #doc(,
            {
                txt : "rrt session regularity"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        
        
        
        [[rb_id]] : {. =>1};
        
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
    
        
    rb.blockid:='rrt_tx';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Tx metrics*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Tx metrics",
                is_active:2,
                filter: "SELECT eid FROM rout_rrt WHERE rrt=3"
                
            }
        );

        #doc(,
            {
                txt : "Transplant graft status"
            }
        );
        
        tx_dt => rout_rrt.tx_dt.val.bind();
        
        
        cr_min => eadv.lab_bld_creatinine._.minfdv().where(dt > tx_dt);
        
        cr_last => eadv.lab_bld_creatinine._.lastdv().where(dt > tx_dt);
        
        rx_l04ad => eadv.rxnc_l04ad.dt.last().where(val=1);
        
        rx_l04aa => eadv.rxnc_l04aa.dt.last().where(val=1);
        
        rx_l04ax => eadv.rxnc_l04aa.dt.last().where(val=1);
        
        rx_h02ab => eadv.rxnc_l04aa.dt.last().where(val=1);
        
        rxn : { coalesce(rx_l04ad,rx_l04aa,rx_l04ax,rx_h02ab)!? => 1},{=>0};
        
        [[rb_id]] : { cr_min_val!? and rxn>0 =>1},{=>0};
        
        #define_attribute(
            [[rb_id]] ,
            {
                label:"Graft function known and therapy",
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
    
        
    rb.blockid:='rrt_hd_acc_iv';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Fistula intervention*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Tx metrics",
                is_active:2,
                filter: "SELECT eid FROM rout_rrt WHERE rrt IN (1,4)"
                
            }
        );

        #doc(,
            {
                txt : "Intervntion codes from RIS episodes"
            }
        );
        
        rrt => rout_rrt.rrt.val.bind();
        
        avf_us_ld => eadv.ris_code_usavfist.dt.last();
        
        av_gram_ld => eadv.ris_code_dshfist.dt.last();
        
        av_plasty_ld => eadv.ris_code_dshplas1.dt.last();
        
        av_plasty_1_ld => eadv.ris_code_dshplas1.dt.last(1);
        
        av_plasty_fd => eadv.ris_code_dshplas1.dt.first();
        
        av_plasty_n => eadv.ris_code_dshplas1.dt.count();
        
        av_surv_ld : {.=> greatest(avf_us_ld,av_gram_ld,av_plasty_ld)};
        
        plasty_gap : {.=> av_plasty_ld-av_plasty_1_ld};
        
        iv_periodicity : {plasty_gap between 0 and 100 => 3},
                        {plasty_gap between 100 and 200 => 6},
                        {plasty_gap between 200 and 600 => 12},
                        {plasty_gap >400 or plasty_gap?=> 99};
                        
        av_iv : {av_plasty_ld!? => 1},{=>0};
        
        [[rb_id]] : { rrt in (1,4) and av_surv_ld!?=>1},{=>0};
        
        #define_attribute(
            [[rb_id]] ,
            {
                label:"AV fistuloplasty",
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
    
        
    rb.blockid:='rrt_hd_param';

    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to determine Haemodialysis parameters*/
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to determine Haemodialysis parameters",
                is_active:2
                
            }
        );

        
        
        rrt => rout_rrt.rrt.val.bind();
        
        mode => eadv.[psi_hd_param_mode]._.lastdv();
        
        hours => eadv.[psi_hd_param_hrs]._.lastdv();
        
        ibw => eadv.[psi_hd_param_ibw]._.lastdv();
        
        dx => eadv.[psi_hd_param_dx]._.lastdv();        
        
        mode_hdf : {mode_val in (20,22)=>1},{=>0};
        
        
        [[rb_id]] : { rrt in (1,4) and coalesce(mode_val,hours_val,ibw_val,dx_val)!? =>1},{=>0};
        
        #define_attribute(
            mode_hdf,
            {
                label:"Dialysis mode Haemodiafiltration",
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





