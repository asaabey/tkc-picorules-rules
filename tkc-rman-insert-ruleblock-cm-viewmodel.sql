CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cm_vm';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  comorbidity view model  */
        
        #define_ruleblock([[rb_id]], {
                description: "comorbidity view model",
                is_active:2
        });
        
        #doc(,{
                txt:"disease entities"
        });
        
        vax_pf => rout_vacc_covid.vax_pf_dt.val.bind();
        
        vax_az => rout_vacc_covid.vax_az_dt.val.bind();
        
        vax_md => rout_vacc_covid.vax_md_dt.val.bind();
        
        vax_max_dt => rout_vacc_covid.vax_dt.val.bind();
        
        vax_max_val => rout_vacc_covid.vax_val.val.bind();
        
        cmidx_charlson => rout_cmidx_charlson.cmidx_charlson.val.bind();
        
        cmcat_charlson => rout_cmidx_charlson.cci_cat.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        rrt_flag : {rrt>0 =>1},{=>0};
        
        cvra_cat => rout_cvra.cvra_cat.val.bind();
        
        dm => rout_cvra.dm.val.bind();
        
        cad => rout_cd_cardiac_cad.cd_cardiac_cad.val.bind();
        
        
        esrd_risk => rout_cvra.esrd_risk.val.bind();
        
        [[rb_id]] : {coalesce(cmidx_charlson,cvra_cat)!? =>1},{=>0};
                    
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







