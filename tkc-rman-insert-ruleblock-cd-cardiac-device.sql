CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
    
   
   -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_cardiac_device';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
    
        /*  cardiac investigations  */
        
        #define_ruleblock([[rb_id]],
            {
                description: "assess cardiac device",
                is_active:2
                
            }
        );
        
        #doc(,{
                    section:"pacemaker"
        });

        
        ppm_fd => eadv.[icpc_k54001,caresys_38253%].dt.first();
        
        defib_fd => eadv.[caresys_3839002, caresys_3839300].dt.first();
        
        
        
        [[rb_id]] : {coalesce(ppm_fd,defib_fd)!? =>1},{=>0};
        
        #define_attribute([[rb_id]],
            { 
                label: "presence of cardiac device",
                type : 2,
                is_reportable:1
            }
        );

    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

        COMMIT;
    -- END OF RULEBLOCK --

   
END;





