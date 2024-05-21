CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     
     
  

       -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='rrt_hd_loc';
   
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Rule block to count RRT presentations */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Rule block to count RRT HD presentations",
                is_active:0,
                
            }
        );

        loc_ca_gap_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc=111711800010132 and dt >= sysdate-30);
        loc_ca_fd_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc=111711800010122 and dt >= sysdate-30);
        loc_ca_tch_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc=111711800010122 and dt >= sysdate-30);
        loc_ca_all_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count()
                                .where(substr(loc,1,5)=`11171` and dt >= sysdate-30);
                                
        loc_ca_other_1m_n : {coalesce(loc_ca_all_1m_n,0) > coalesce(loc_ca_gap_1m_n,loc_ca_fd_1m_n, loc_ca_fd_1m_n, loc_ca_tch_1m_n, loc_ca_all_1m_n,0) => loc_ca_all_1m_n };
        
        loc_te_nru_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc=111721600013032 and dt >= sysdate-30);
        loc_te_7ad_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc in(111721600015062,111721600006002) and dt >= sysdate-30);
        loc_te_kdh_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc IN (111721500016042, 111721500008032) and dt >= sysdate-30);
        loc_te_pdu_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc=111721600014022 and dt >= sysdate-30);
        loc_te_tiwi_1m_n => eadv.[caresys_1310000].dt.distinct_count()
                                .where(loc=111721600017012 and dt >= sysdate-30);
        loc_te_all_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count()
                                .where(substr(loc,1,5)=`11172` and dt >= sysdate-30);
        loc_te_other_1m_n : {coalesce(loc_te_all_1m_n,0) > coalesce(loc_te_nru_1m_n,loc_te_7ad_1m_n, loc_te_kdh_1m_n, loc_te_pdu_1m_n, loc_te_tiwi_1m_n,0) => loc_te_all_1m_n };

        loc_prplhouse_1m_n => eadv.[mbs_13105].dt.distinct_count()
                                .where(substr(loc,1,5)=`11571`and dt >= sysdate-30);
        loc_miwatj_1m_n => eadv.[mbs_13105].dt.distinct_count()
                                .where(substr(loc,1,5)=`13472`and dt >= sysdate-30);
                                            
        loc_all_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count()
                                .where(dt >= sysdate-30);
        
        loc_mode_1m => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].loc.stats_mode()
                                .where(dt >= sysdate-90);
                                
        loc_mode_1m_txt : {loc_mode_1m = 111711800010132  => `CA-GAP`},
                    {loc_mode_1m = 111721600013032   => `TEHS-NRU`},
                    {loc_mode_1m = 111711800010122   => `CA-FD`},
                    {loc_mode_1m  = 111711800010122  => `CA-TCH`},
                    {loc_mode_1m in(111721600015062,111721600006002) => `TEHS-7AD`},
                    {loc_mode_1m in (111721500016042, 111721500008032) => `TEHS-KDH`},
                    {loc_mode_1m = 111721600014022 => `TEHS-PDU`},
                    {loc_mode_1m = 111721600017012  => `TEHS-TIW`},
                    {substr(loc_mode_1m,1,5)=`11171` =>`CA-OTHER`},
                    {substr(loc_mode_1m,1,5)=`11172`=>`TEHS-OTHER`},
                    {substr(loc_mode_1m,1,5)=`11571`=>`PURPLE_HOUSE`},
                    {substr(loc_mode_1m,1,5)=`13472`=>`MIWATJ`},
                    {loc_all_1m_n > 0=>`UNDETERMINED`}
                    ;

        [[rb_id]] => eadv.[caresys_1310000,caresys_1310004, icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].loc.last();

        #define_attribute([[rb_id]],
            {
                label:"Latest HD Loc",
                desc:"Location of latest haemodialysis",
                is_reportable:1,
                type:1002
            }
        );

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
   
    COMMIT;
    -- END OF RULEBLOCK --
     
END;
