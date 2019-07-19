CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
      -- BEGINNING OF RULEBLOCK --

    rb.blockid:='qa_data_geom';
    rb.target_table:='rout_qa_data_geom';
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=2 ;
    rb.def_exit_prop:='qa_data_geom';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  data qa  */
        
        dmg => eadv.[dmg_%].dt.count(0);
        
        lab => eadv.[lab_%].dt.count(0);
        
        obs => eadv.[obs_%].dt.count(0);
        
        enc => eadv.[enc_%].dt.count(0);
        
        icd => eadv.[icd_%].dt.count(0);
        
        icpc => eadv.[icpc_%].dt.count(0);
        
        rxn => eadv.[rxnc_%].dt.count(0);
        
        mbs => eadv.[mbs_%].dt.count(0);
                
        dt_min_ => eadv.lab_bld_creatinine.dt.min();
        
        dt_max_ => eadv.lab_bld_creatinine.dt.max();
        
        tn_: {dt_min_ is not null => (dt_max_-dt_min_)/365};
        
        lab_t_ : {tn_>0 => lab/tn_},{=>0};
        
        obs_t_ : {tn_>0 => obs/tn_},{=>0};
        
        icd_t_ : {tn_>0 => icd/tn_},{=>0};
        
        icpc_t_ : {tn_>0 => icpc/tn_},{=>0};
        
        rxn_t_ : {tn_>0 => rxn/tn_},{=>0};
        
        mbs_t_ : {tn_>0 => mbs/tn_},{=>0};
        
            
        lab_rnk : {nvl(lab_t_,0)> 0 => ceil(log(10,lab_t_))}{=>0};
        
        obs_rnk : {nvl(obs_t_,0)> 0 => ceil(log(10,obs_t_))}{=>0};
        
        icd_rnk : {nvl(icd_t_,0)> 0 => ceil(log(10,icd_t_))+2}{=>0};
        
        icpc_rnk : {nvl(icpc_t_,0)> 0 => ceil(log(10,icpc_t_))+2}{=>0};
        
        rxn_rnk : {nvl(rxn_t_,0)> 0 => ceil(log(10,rxn_t_))+1}{=>0};
        
        mbs_rnk : {nvl(mbs_t_,0)> 0 => ceil(log(10,mbs_t_))+1}{=>0};
        
        qa_data_geom : {coalesce(dmg,lab,obs,enc,icd,icpc,rxn,mbs) is not null =>1},{=>0};

    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate,exec_order) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate,1);

    COMMIT;
    -- END OF RULEBLOCK --
    
END;





