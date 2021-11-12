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
                is_active:2,
                
            }
        );

        loc_ca_gap_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111710100010132 and dt >= sysdate-30);
        loc_ca_fd_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111710100010122 and dt >= sysdate-30);
        loc_ca_tch_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111710500012022 and dt >= sysdate-30);
        loc_ca_other_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc IN (111710111460001, 111710111460051, 111710410202051) and dt >= sysdate-30);
        loc_te_nru_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111720600013032 and dt >= sysdate-30);
        loc_te_7ad_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111720600015062 and dt >= sysdate-30);
        loc_te_kdh_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc IN (111720900016042, 111720900016052) and dt >= sysdate-30);
        loc_te_pdu_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111720600005012 and dt >= sysdate-30);
        loc_te_tiwi_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc=111721200017012 and dt >= sysdate-30);
        loc_te_other_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc IN (111720600014022, 111720600013012) and dt >= sysdate-30);

        loc_undef_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(loc NOT IN (111710100010132, 111710100010122, 111710500012022, 111710111460001, 111710111460051, 111710410202051, 111720600014022, 111720600013012, 111721200017012, 111720600005012, 111720900016042, 111720900016052, 111720600015062, 111720600013032) and dt >= sysdate-30);

        loc_all_1m_n => eadv.[caresys_1310000,caresys_1310004,icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].dt.distinct_count(0).where(dt >= sysdate-30);

        [[rb_id]] => eadv.[caresys_1310000,caresys_1310004, icpc_u59001,icpc_u59008,icd_z49_1,mbs_13105].loc.last();

        #define_attribute([[rb_id]],
            {
                label:"Latest HD Loc",
                desc:"Location of latest haemodialysis",
                is_reportable:1,
                type:3
            }
        );

    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
   
    COMMIT;
    -- END OF RULEBLOCK --
     
END;
