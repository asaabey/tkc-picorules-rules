CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
    
                 -- BEGINNING OF RULEBLOCK --

    rb.blockid:='vacc_covid';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /* Algorithm to assess covid 19 vaccination  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "Algorithm to assess covid 19 vaccination ",
                is_active:2
                
            }
        );
        
       
        vax_pf => eadv.vacc_covid_comirnaty._.lastdv();
        
        vax_az => eadv.vacc_covid_astrazeneca._.lastdv();
        
        vax_md => eadv.vacc_covid_moderna._.lastdv();
        
        vax => eadv.[vacc_covid_moderna,vacc_covid_astrazeneca,vacc_covid_comirnaty]._.maxldv();
        
        [[rb_id]] : { coalesce(vax_pf_dt, vax_az_dt, vax_md_dt)!? => 1},{=>0};
        
                
        #define_attribute(
            [[rb_id]],{
                label:"Major abdominal colorectal surgery",
                type:2,
                is_reportable:0
        });
       
        
        
                
    ';
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);

    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    
    -- END OF RULEBLOCK 
    
      

END;





