CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
       
       
            -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_source';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographic source */
        
        #define_ruleblock(dmg_source,
            {
                description: "Algorithm to assess demographic source",
                is_active:2
                
            }
        );
                
        
        rrt => rout_rrt.rrt.val.bind();
        
        phc_loc_f => eadv.[mbs_%].loc.first();
        
        phc_src_f : { phc_loc_f!? => to_number(substr(phc_loc_f,2,2))},{=>0};
        
        loc_def => rout_dmg_loc.loc_def.val.bind();
        
        loc_def_alt => rout_dmg_loc.loc_def_alt.val.bind();
        
        loc_null => rout_dmg_loc.loc_null.val.bind();
        
        loc_mode_n => rout_dmg_loc.loc_mode_n.val.bind();
        
        loc_n => rout_dmg_loc.loc_n.val.bind();
        
        mode_pct => rout_dmg_loc.mode_pct.val.bind();
        
        hrn => rout_dmg_hrn.hrn_last.val.bind();
        
        loc_region => rout_dmg_loc.loc_region.val.bind();
        
        tc_caresys_n => eadv.[icd_%].loc.count().where(substr(loc,2,2)=11);
        
        tc_caresys_ld => eadv.[icd_%].dt.max().where(substr(loc,2,2)=11);
        
        tc_labtrak_n => eadv.[lab_%].dt.count().where(substr(loc,2,2)=12);
        
        tc_labtrak_ld => eadv.[lab_%].dt.max().where(substr(loc,2,2)=12);
        
        pcis_n => eadv.[mbs_%].dt.count().where(substr(loc,2,2)=90);
        
        pcis_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=90);
        
        eacs_n => eadv.[mbs_%].dt.count(0).where(substr(loc,2,2)=22);
        
        eacs_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=22);
        
        laynhapuy_n => eadv.[mbs_%].dt.count(0).where(substr(loc,2,2)=33);
        
        laynhapuy_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=33);
        
        miwatj_n => eadv.[mbs_%].dt.count(0).where(substr(loc,2,2)=34);
        
        miwatj_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=34);
        
        anyinginyi_n => eadv.[mbs_%].dt.count(0).where(substr(loc,2,2)=32);
        
        anyinginyi_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=32);
        
        congress_n => eadv.[mbs_%].dt.count(0).where(substr(loc,2,2) in(37,38,39,41,42));
        
        congress_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2) in(37,38,39,41,42));
        
        wurli_n => eadv.[mbs_%].dt.count(0).where(substr(loc,2,2)=36);
        
        wurli_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=36);
        
        kwhb_n => eadv.[mbs_%].dt.count().where(substr(loc,2,2)=35);
        
        kwhb_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=35);
        
        ampila_n => eadv.[mbs_%].dt.count().where(substr(loc,2,2)=51);
        
        ampila_ld => eadv.[mbs_%].dt.max().where(substr(loc,2,2)=51);
        
        
        phc_0 => eadv.[mbs_%].loc.stats_mode().where(dt > sysdate-1825 and substr(loc,2,2) between 20 and 98);
        
        phc_1 : { phc_0!? => to_number(substr(phc_0,2,2))},
                {phc_src_f!? => phc_src_f },
                {=>0};
        
        phc_pcis : { phc_1=90 => 1 },{=>0};
        
        phc_laynhapuy : { phc_1=33 => 1 },{=>0};
        
        phc_miwatj : { phc_1=34 => 1 },{=>0};
        
        phc_congress : { phc_1 in(36,37,38,39,41,42) => 1 },{=>0};
        
        phc_anyinginyi : { phc_1=32 => 1 },{=>0};
        
        phc_wurli : { phc_1=36 => 1 },{=>0};

        phc_kwhb : { phc_1=35 => 1 },{=>0};
        
        phc_ampila : { phc_1=51 => 1 },{=>0};
        
        tkc_provider : { coalesce(loc_region,0)=1 or phc_1 in(36,37,38,39,41,42) =>1},{=>2};
        
        /* fix201022 if on RRT phc will default to EDW */
        
        dmg_source : {rrt>0 => 900},{ phc_1 > 0 => phc_1 },{=>999};    
        
        
       
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
    
         
    
           
END;





