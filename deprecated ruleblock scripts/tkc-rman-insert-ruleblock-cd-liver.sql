CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cirrhosis';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to identify cirrhosis e-phenotype  */
        
        #define_ruleblock(cd_cirrhosis,
            {
                description: "Algorithm to identify cirrhosis e-phenotype",
                is_active:2
                
            }
        );
        
        cirr_pbc_fd => eadv.[icpc_d97011,icd_k74_3].dt.min();
        
        cirr_nos_fd => eadv.[icpc_d97005,icd_k74_6].dt.min();
        
        cps_alb => eadv.lab_bld_albumin._.lastdv().where(dt > sysdate-365);
        
        cps_alb_scr : { cps_alb_val < 28 => 3 },{ cps_alb_val < 35 => 2 },{cps_alb_val >=35 =>1},{=>0};
        
        cps_bil => eadv.lab_bld_bilirubin._.lastdv().where(dt > sysdate-365);
        
        cps_bil_scr : { cps_bil_val > 51.3 => 3 },{ cps_bil_val > 34.2 => 2 },{cps_bil_val <= 34.2 =>1},{=>0};
        
        cps_inr => eadv.lab_bld_inr._.lastdv().where(dt > sysdate-365);
        
        cps_inr_scr : { cps_inr_val > 2.2 => 3 },{ cps_inr_val > 1.7 => 2 },{cps_inr_val <= 1.7 =>1},{=>0};
        
        cps_abbr_scr :{. => cps_alb_scr + cps_bil_scr + cps_inr_scr};
        
        cps_abbr_class : { cps_abbr_scr >9 => 3},{cps_abbr_scr >6 => 2},{cps_abbr_scr <=6 => 1};
    
        code_fd : {.=> least_date(cirr_pbc_fd,cirr_nos_fd)};
        
        
        
        cd_cirrhosis : { code_fd!? =>1},{=>0};
        
        #define_attribute(cd_cirrhosis,
            {
                label: "Presence of Cirrhosis",
                is_reportable: 1,
                type: 2
            }
        );
        
        
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --
END;







