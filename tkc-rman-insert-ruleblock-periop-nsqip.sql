CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='periop_nsqip';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  This is a algorithm to apply ACS NSQIP */
        
        #define_ruleblock([[rb_id]],
            {
                description: "algorithm to apply ACS NSQIP ",
                version: "0.0.0.1",
                blockid: "[[rb_id]]",
                target_table:"rout_[[rb_id]]",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:2,
                def_exit_prop:"[[rb_id]]",
                def_predicate:">0",
                exec_order:5
                
            }
        );
        
        dob => eadv.dmg_dob.dt.max();
        
        age : { dob!? => round((sysdate-dob)/365.25,0)};
        
        ca_dt => eadv.[icd_c%,icpc_a79%].dt.max();
        
        cad => rout_cd_cardiac_cad.cd_cardiac_cad.val.bind();
        
        
        
        vhd => rout_cd_cardiac_vhd.cd_cardiac_vhd.val.bind();
        
        htn_0 => rout_cd_htn.htn.val.bind();
        
        htn_rx => rout_cd_htn.htn_rxn.val.bind();
        
        htn : {htn_0=1 and htn_rx=1 =>1},{=>0};
    
        
        pulm => rout_cd_pulm.cd_pulm.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        ckd => rout_ckd.ckd.val.bind();
        
        rx_gs_dt => eadv.rxnc_h02ab.dt.max().where(val=1);
        
        coag_dt => eadv.[icd_d68%,icpc_b83%].dt.max();
        
        obesity => rout_cd_obesity.cd_obesity.val.bind();
        
        low => rout_cd_nutr_low.cd_nutr_low.val.bind();

        
        w_inpt : {.=>0},{=>6};
        
        w_sepsis : {.=>0},{=>4};
        
        w_poor_func : {.=>0},{=>3};
        
        w_ca_diss : { ca_dt!? =>1},{=>0};
        
        w_age : { age<65 => 0},
                { age between 65 and 70 => 0.5},
                { age between 70 and 79 => 1},
                { age>=80 =>2};
        
        w_cardiac : { greatest(cad, vhd,htn)>0=>5},{=>0};   
        
        w_pulm : { pulm=1 =>3},{=>0};
        
        w_renal : { rrt=1 or ckd>2 => 1=>1},{=>0};
        
        w_steroids : {rx_gs_dt!? => 1},{=>0};
        
        w_bleeding : {coag_dt!? => 5},{=>0};
        
        w_dnr : {.=>0},{=>5};
        
        w_low : { low=1 =>1 },{=>0};
        
        w_obesity : { obesity=1 =>-1},{=>0};
        
        pmp_sum : {.=> w_inpt + w_sepsis + w_poor_func + w_ca_diss + w_age 
            + w_cardiac + w_pulm + w_renal + w_steroids 
            + w_bleeding + w_dnr + w_low + w_obesity};
        
        pmp_score : { pmp_sum  between -1 and 5 => 0.1},
                    { pmp_sum  between 6 and 10 => 0.6},
                    { pmp_sum  between 11 and 15 => 2.4},
                    { pmp_sum  between 16 and 20 => 12.6},
                    { pmp_sum  between 21 and 25 => 37.5},
                    { pmp_sum  between 26 and 30 => 40};


        [[rb_id]] : { pmp_score >0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "PMP score"
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







