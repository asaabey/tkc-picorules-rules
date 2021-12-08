CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
       
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess demographics */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess demographics",
                is_active:2
                
            }
        );
        
        /*
        Key index
        01   source         (3 digits)
             1 digit : parity
             2 digits: Source table code
        02   state          (1 digits 7 default)
        03   region         (1 digit)
        04   district       (2 digits)
        06   locality       (5 digits)
        11   sub-locality   (2 digits)
        13   level of care  (1 digit P=1,T=2)
        
        */
        
        
        mode_24_ => eadv.[mbs%].loc.stats_mode().where(dt > sysdate - 730 and substr(loc,-1)=1);
        
        
        
        mode_full_ => eadv.[mbs%].loc.stats_mode().where(substr(loc,-1)=1);
        
        
        
        
        loc_mode_24 : {.=> to_number(substr(mode_24_,4))};
        
        loc_mode : {.=> to_number(substr(mode_full_,4))};
        
        loc_active : {loc_mode_24!? => 1},{=>0};
        
        loc_mode_def : {loc_mode_24!? => loc_mode_24},{loc_mode!? => loc_mode};
        
        last_val => eadv.[mbs%].loc.last().where(substr(loc,-1)=1);
        
        last_dt => eadv.[mbs%].dt.last().where(substr(loc,-1)=1);
        
        last_t_val => eadv.[mbs%].loc.last().where(substr(loc,-1)<>1);
        
        loc_last_val : {.=> to_number(substr(last_val,4))};       
        
        loc_last_t_val : {.=> to_number(substr(last_t_val,4))};  
        
        last_1_val => eadv.[mbs%].loc.last(1).where(substr(loc,-1)=1);
        
        last_1_dt => eadv.[mbs%].dt.last(1).where(substr(loc,-1)=1);
        
        loc_last_1_val : {.=> to_number(substr(last_1_val,4))};       
        
        loc_n => eadv.[mbs%].loc.count().where(substr(loc,-1)=1);
        
        loc_mode_n => eadv.[mbs%].loc.count().where(substr(loc,4)=loc_mode_def);
        
        loc_last_n => eadv.[mbs%].loc.count().where(substr(loc,4)=loc_last_val);

        loc_def : {loc_last_val=loc_last_1_val and last_dt-last_1_dt>90 => loc_last_val},{=> loc_mode_def};

        loc_def_alt : {loc_def? =>loc_last_t_val};      
        
        loc_null : {coalesce(loc_def,loc_def_alt)?=>1},{=>0};
        
        loc_def_fd => eadv.[mbs%].dt.min().where(substr(loc,4)=loc_last_val);
        
        loc_region : {loc_def!? => to_number(substr(loc_def,2,1))};
        
        loc_district : {loc_def!? => to_number(substr(loc_def,6,2))};
        
        loc_locality : {loc_def!? => to_number(substr(loc_def,8,5))};
        
        
        diff_last_mode : {loc_mode_def<>loc_last_val =>1},{=>0};
        
        
        mode_pct : {loc_n>0 => round(loc_mode_n/loc_n,2)*100};
        
       
        episode_single : { loc_n=1 => 1},{=>0};
        
        loc_single : { mode_pct=1 =>1},{=>0}; 
        
        [[rb_id]] : { coalesce(loc_def,0)>0 =>loc_def },{ coalesce(loc_def_alt,0)>0 => loc_def_alt},{=>0};    
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
         
END;





