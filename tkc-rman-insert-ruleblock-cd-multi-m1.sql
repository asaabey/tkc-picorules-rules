CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

    
    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_multi_m1';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  Algorithm to define multi disease m1 level viewmodel  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to define multi disease m1 level viewmodel",
                is_active:0
                
            }
        );
        
        ckd => rout_ckd.ckd.val.bind();
        
        rrt => rout_rrt.rrt.val.bind();
        
        dm_type => rout_cd_dm_dx.dm_type.val.bind();
        
        dm_fd_year => rout_cd_dm_dx.dm_fd_year.val.bind();
        
        dm1_mm => rout_cd_dm_dx.dm1_mm.val.bind();
        
        dm2_mm_1 => rout_cd_dm_dx.dm2_mm_1.val.bind();
        
        dm2_mm_2 => rout_cd_dm_dx.dm2_mm_2.val.bind();
        
        dm2_mm_3 => rout_cd_dm_dx.dm2_mm_3.val.bind();
        
        dm2_mm_4 => rout_cd_dm_dx.dm2_mm_4.val.bind();
        
        htn_fd => rout_cd_htn.htn_fd.val.bind();
        
        htn_yr : {htn_fd!? => extract(year from htn_fd)};
        
        cad_fd => rout_cd_cardiac_cad.cad_fd.val.bind();
        
        cad_yr : { cad_fd!? => extract(year from cad_fd) };
        
        cva => rout_cd_cardiac_cad.cva.val.bind();
        
        pvd => rout_cd_cardiac_cad.pvd.val.bind();
        
        obesity => rout_cd_obesity.cd_obesity.val.bind();
        
        rhd_fd => rout_cd_cardiac_rhd.rhd_dt.val.bind();
        
        rhd_yr : { rhd_fd!? => extract(year from rhd_fd)};
        
        hepb => rout_cd_hepb.cd_hepb.val.bind();
        
        cd_cirrhosis_fd => rout_cd_cirrhosis.code_fd.val.bind();
        
        cd_cirrhosis_yr : { cd_cirrhosis_fd!? => extract(year from cd_cirrhosis_fd) };
        
        cps_abbr_class => rout_cd_cirrhosis.cps_abbr_class.val.bind();
        
        ca_breast => rout_ca_breast.ca_breast.val.bind();
        
        ca_breast_fd => rout_ca_breast.code_fd.val.bind();
        
        ca_breast_yr : { ca_breast_fd!? => extract(year from ca_breast_fd) };
        
        cd_pulm_copd_fd => rout_cd_pulm_copd.code_copd_dt.val.bind();
        
        cd_pulm_copd_yr : { cd_pulm_copd_fd!? => extract(year from cd_pulm_copd_fd)};
        
        cd_pulm_bt_fd => rout_cd_pulm_bt.bt_fd.val.bind();
        
        cd_pulm_bt_yr : { cd_pulm_bt_fd!? => extract(year from cd_pulm_bt_fd)};
        
        [[rb_id]] : { dm_type>0 =>1},{=>0};
        
        #define_attribute([[rb_id]],
            {
                label: "Multimorb M1",
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







