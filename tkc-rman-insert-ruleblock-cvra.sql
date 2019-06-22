CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   
    -- BEGINNING OF RULEBLOCK --
    
        
    rb.blockid:='cvra_1_1';
    rb.target_table:='rout_' || rb.blockid;
    rb.environment:='DEV';
    rb.rule_owner:='TKCADMIN';
    rb.is_active:=1 ;
    rb.def_exit_prop:='risk_chd_lev';
    rb.def_predicate:='>0';
    
    DELETE FROM rman_ruleblocks_dep WHERE blockid=rb.blockid;
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Framingham equation*/
        
        
        hdl => eadv.lab_bld_cholesterol_hdl.val.last();
        
        tc => eadv.lab_bld_cholesterol_total.val.last();
        
        sbp => eadv.obs_bp_systolic.val.last();
        
        risk_chd : {nvl(hdl,0)>0 => round(100*(1-EXP(-EXP((LN(10)-(15.5305+(28.4441*(1-0))+(-1.4792*LN(55))+(0*LN(55)*LN(55))+
            (-14.4588*LN(55)*(1-0))+(1.8515*LN(55)*LN(55)*(1-0))+(-0.9119*LN(sbp))+(-0.2767*1)+(-0.7181*LN(tc/hdl))+
            (-0.1759*1)+(-0.1999*1*(1-0))+(-0.5865*0)+(0*0*0)))/(EXP(0.9145)*EXP(-0.2784*(15.5305+(28.4441*(1-0))+
            (-1.4792*LN(55))+(0*LN(55)*LN(55))+(-14.4588*LN(55)*(1-0))+(1.8515*LN(55)*LN(55)*(1-0))+(-0.9119*LN(sbp))+
            (-0.2767*1)+(-0.7181*LN(tc/hdl))+(-0.1759*1)+(-0.1999*1*(1-0))+(-0.5865*0)+(0*0*0))))))),2)
        };
        
        
        
            
    ';
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,target_table,environment,rule_owner,picoruleblock,is_active, def_exit_prop, def_predicate) 
        VALUES(rb.blockid,rb.target_table,rb.environment,rb.rule_owner,rb.picoruleblock,rb.is_active,rb.def_exit_prop,rb.def_predicate);
    
    -- END OF RULEBLOCK --
    
    
END;





