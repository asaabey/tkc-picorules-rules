CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;

BEGIN

        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='rrt_assert_wip';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /* Algorithm to assess demographics */
        
        #define_ruleblock(rrt_assert_wip,
            {
                description: "(work in progress at 2024 03 20) - Algorithm to assess RRT level assertion criteria ",
                is_active: 2,
	author: "E. Coccetti"
            }
        );
        
        #doc(,{
            txt:"
        If Tx At Any Stage                     1*100,000   -- Calculated by icpc codes
        If PD at Any stage                  1* 10,000   -- Calculated by icpc codes or clinic attendances
        If HomeD At Any Stage                     1*  1,000   -- Calculated by icpc codes or clinic attendances
        
            Above Guarantees RRT client         
            If nothing exists above, then below could mean RRT, New Start RRT or Acute only HD
        
        If HD At Any Stage                     1*   100   -- Count of Z49.1s or 13100-00? First is same day only, second includes acute dialysis.
        If HD count > 30  all time             1*    10   -- Count of Z49.1s or 13100-00? First is same day only, second includes acute dialysis.   
        If HD in last 3 Months                 1*     1 
        
            Calculations
        
        If rrt_assert >= 111                   Then Definitely RRT Client as current client with 30 or more HD procedures in total (If counting z49.1 and not 13100-00s then 30 or more same day outpatient type HD procedures)
        
        If rrt_assert  = 110                   Away from NT? No DoD? Lots of Acute only Dialysis?
        If rrt_assert  = 101                   Potential New Start or current Acute only 
        If rrt_assert  = 100                   Possible Acute only at some stage in past? "
        
        });
        
        #doc(,{
            txt:"rrt assertion is calculated only when a client has been assigned a modality by the rrt ruleblock, rout.rrt table.
                         1. import results already calculated in rrt ruleblock "
                         
        });
        
        
        
        rrt => rout_rrt.rrt.val.bind();
        tx_dt  => rout_rrt.tx_dt.val.bind();
        pd_dt  => rout_rrt.pd_dt.val.bind();
        homedx_dt  => rout_rrt.homedx_dt.val.bind();
        hd_dt => rout_rrt.hd_dt.val.bind(); 
        hd_z49_n => rout_rrt.hd_z49_n.val.bind();
        pd_enc_ld => rout_rrt.pd_enc_ld.val.bind();
        homedx_enc_ld => rout_rrt.homedx_enc_ld.val.bind();
        
        
        #doc(,{
            txt:"rrt assertion is calculated only when a client has been assigned a modality by the rrt ruleblock, rout.rrt table.
                         2. Assign rrt assertion level based on imported calculations"
        });
        
        
        tx_any_stage : { tx_dt!?  =>1 },{=>0}; 
        pd_any_stage : { pd_dt!?  =>1 },{=>0};                                           
        homed_any_stage : { homedx_dt!?  =>1 },{=>0};                                                                       
        hd_any_stage : { hd_dt!?  =>1 },{=>0};                                        
        hd_30plus  : { hd_dt!? and hd_z49_n > 29 =>1},{=>0};                          
        hd_120days : { hd_dt!? and hd_dt > sysdate-150 =>1},{=>0};                    
        
        
        rrt_assert : { rrt > 0 => ( tx_any_stage * 100000) + (pd_any_stage  * 10000) + (homed_any_stage * 1000) + (hd_any_stage * 100) + (hd_30plus * 10) + (hd_120days * 1 ) },{=>0};
        
        
        pd_assert : { pd_enc_ld!? and pd_enc_ld > sysdate-50 =>1},{=>0};
        homed_assert : { homedx_enc_ld!? and homedx_enc_ld > sysdate-50 =>1},{=>0};
        
        
        #define_attribute(
            rrt_assert,
            {
                label:"rrt assertion level",
                type:2,
                is_reportable:0
            }
        );
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







