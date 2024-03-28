CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;


    

BEGIN
     

   

    
        -- BEGINNING OF RULEBLOCK --

    rb.blockid:='cd_hepb_coded';
    
    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        #define_ruleblock(cd_hepb_coded,{
                description: "Algorithm to detect Chronic hepatitis B from coding",
                is_active:2
        });

        /* Hep B ICPC codes */

        hepb_icpc_code => eadv.[icpc_d72j%].att.last();

        hepb_status : {hepb_icpc_code = `icpc_d72j94` =>20 },
                     {hepb_icpc_code = `icpc_d72j95` =>21},
                     {hepb_icpc_code = `icpc_d72j95` =>21},
                     {hepb_icpc_code = `icpc_d72j93` =>10},
                     {hepb_icpc_code = `icpc_d72j97` =>12},
                     {hepb_icpc_code = `icpc_d72j99` =>13},
                     {hepb_icpc_code = `icpc_d72j92` =>15},
                     {=>0};

        hepb_status_lbl : {hepb_status = 20 => `CHB - Not on Rx`},
                         {hepb_status = 21 => `CHB - on Rx`},
                         {hepb_status = 10 => `HepB Non Immune`},
                         {hepb_status = 11 => `HepB Immune by exposure`},
                         {hepb_status = 12 => `HepB Immune by vaccination`},
                         {hepb_status = 13 => `HepB Immune - NOS`},
                         {hepb_status = 15 => `HepB Immunosuppressed`};

        /* Treatment with Nucleoside and nucleotide reverse transcriptase inhibitors */

        rx_av_ld => eadv.[rxnc_j05af].dt.last().where(val=1);

        rx_av : { rx_av_ld!? =>1},{=>0};
         

        chb : { hepb_status =20 or hepb_status=21 =>1},{=>0};

        chb_on_rx : { hepb_status =21 =>1},{=>0};
        chb_not_on_rx : { hepb_status =20 =>1},{=>0};

        cd_hepb_coded : { hepb_status>0 =>1},{=>0};
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
    
    
    
    INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);

    COMMIT;
    -- END OF RULEBLOCK --
END;







