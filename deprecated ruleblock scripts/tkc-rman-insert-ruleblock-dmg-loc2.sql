CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    rb          RMAN_RULEBLOCKS%ROWTYPE;

BEGIN

    -- BEGINNING OF RULEBLOCK --

    rb.blockid:='dmg_loc2';

    DELETE FROM rman_ruleblocks WHERE blockid=rb.blockid;
    
    rb.picoruleblock:='
        /* Algorithm to assess demographics */

        #define_ruleblock(dmg_loc2, {
            description: "Algorithm to assess possible location of origin for all TKC clients",
            is_active: 2,
            author: "E. Coccetti"
        });

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

        /*
        The following locality codes are excluded when trying to determine if client is originally from a remote locality.
        This exclusion occurs irrespective of provider. Exclusion also occurs for ACCHOs based in a major centre such as URBAN CONGRESS.

        +---------------+------------------------------+
        | LOCALITY_CODE | Mapped_Geographical_Locality |
        +---------------+------------------------------+
        |         00001 | ALICE SPRINGS                |
        |         00011 | ALICE SPRINGS                |
        |         11460 | ALICE SPRINGS                |
        |         00002 | DARWIN                       |
        |         10857 | DARWIN                       |
        |         10878 | DARWIN                       |
        |         11471 | DARWIN                       |
        |         11479 | DARWIN                       |
        |         10916 | JABIRU                       |
        |         00008 | KATHERINE                    |
        |         00016 | KATHERINE                    |
        |         00018 | KATHERINE                    |
        |         11495 | KATHERINE                    |
        |         90139 | KATHERINE                    |
        |         11547 | NHULUNBUY                    |
        |         00004 | TENNANT CREEK                |
        |         00012 | TENNANT CREEK                |
        |         00019 | TENNANT CREEK                |
        |         00000 | UNKNOWN                      |
        +---------------+------------------------------+
        */

        #doc(,{
            txt:"Most likely location is calculated based on frequent location of services in order of merit
            1. remote primary care location 
            2. any primary care loction
            3. any rural hospital, Tennat Creek or Katherine Hospital
            4. Darwin or Alice Springs hospitals
            
        * An assumption has been made that an MBS item is only recorded by primary health care providers."
        });

        #doc(,{
            txt:"Primary Health visit in remote township/community: Remote location code after stripping parity and source code.
        Based on primary health visit in remote township/community for first clinic, over last 2ys and full timeline"
        });

        frequent_remote_healthcheck => eadv.[mbs_715].loc.stats_mode().where(substr(loc,8,5) not in (`00000`,`00001`,`00002`,`00004`,`00008`,`00011`,`00012`,`00016`,`00018`,`00019`,`10857`,`10878`,`10916`,`11460`,`11471`,`11479`,`11495`,`11547`,`90139`));
        frequent_remote_alltime => eadv.[mbs_%].loc.stats_mode().where(substr(loc,8,5) not in (`00000`,`00001`,`00002`,`00004`,`00008`,`00011`,`00012`,`00016`,`00018`,`00019`,`10857`,`10878`,`10916`,`11460`,`11471`,`11479`,`11495`,`11547`,`90139`));
        frequent_remote_2y => eadv.[mbs_%].loc.stats_mode().where(substr(loc,8,5) not in (`00000`,`00001`,`00002`,`00004`,`00008`,`00011`,`00012`,`00016`,`00018`,`00019`,`10857`,`10878`,`10916`,`11460`,`11471`,`11479`,`11495`,`11547`,`90139`) and (dt > sysdate - 740));

        remote_ph_location : { . => to_number(substr(coalesce(frequent_remote_healthcheck, frequent_remote_2y, frequent_remote_alltime), -12)) };

        #doc(,{
            txt:"Any primary health location, including in major centres such as Darwin, Katherine, Alice Springs and T/CK.
        Location code after stripping parity and source code. Based on primary health visit, over last 2ys and full timeline"
        });

        frequent_ph_alltime  =>   eadv.[mbs_%].loc.stats_mode().where(substr(loc,8,5) not in (`00000`));
        frequent_ph_2y       =>   eadv.[mbs_%].loc.stats_mode().where(substr(loc,8,5) not in (`00000`) and (dt > sysdate - 740));

        any_ph_location  : { .=>  to_number(substr(coalesce(frequent_ph_2y, frequent_ph_alltime), -12)) };

        #doc(,{
            txt:"Tertiary health location Katherine and T/CK. Location code after stripping parity and source code.
        Based on minimum number of services received in Katherine or Tennant Creek during last 5 years.
        Outpatient Clinic given more weight than hospital admissions"
        });

        rural_hospital_enc_n => eadv.[enc_%].dt.distinct_count().where(substr(loc,8,5) in (`00004`,`00008`,`00012`,`00016`)  and (dt > sysdate - 1825));
        rural_hospital_icd_n => eadv.[icd_%].dt.distinct_count().where(substr(loc,8,5) in (`00004`,`00008`,`00012`,`00016`)  and (dt > sysdate - 1825));

        rural_hospital_enc_loc => eadv.[enc_%].loc.stats_mode().where(substr(loc,8,5) in (`00004`,`00008`,`00012`,`00016`));
        rural_hospital_icd_loc => eadv.[icd_%].loc.stats_mode().where(substr(loc,8,5) in (`00004`,`00008`,`00012`,`00016`));

        rural_hospital_enc : { rural_hospital_enc_n > 1 => rural_hospital_enc_loc };
        rural_hospital_icd : { rural_hospital_icd_n > 2 => rural_hospital_icd_loc };

        rural_hospital_location : { .=> to_number(substr(coalesce(rural_hospital_enc, rural_hospital_icd), -12)) };

        #doc(,{
            txt:"Any Tertiary health location. Outpatient Clinic given more weight than hospital admissions"
        });

        tertiary_enc_loc => eadv.[enc_%].loc.stats_mode();
        tertiary_icd_loc => eadv.[icd_%].loc.stats_mode();

        any_hospital_location : { .=> to_number(substr(coalesce(tertiary_enc_loc, tertiary_icd_loc), -12)) };

        #doc(,{
            txt:"Possible location of origin calculated based on type and location of services delivered to client"
        });

        possible_origin_location_1 : { . => coalesce(
            remote_ph_location,
            any_ph_location,
            rural_hospital_location,
            any_hospital_location 
        )};

        possible_origin_location : { . => coalesce(possible_origin_location_1, 700000000000) };
        dmg_loc2 : { possible_origin_location_1!? => 1 }, { => 0 };

        #doc(,{
            txt:"Locality of latest service of type MBS Ite, Outpatient Clinic Encounter or Hospital Admission coding"
        });

        latest_loc_val => eadv.[mbs_%, enc_%, icd_%].loc.last();

        latest_locality : { .=> to_number(substr(latest_loc_val, -12)) };

        #define_attribute(possible_origin_location, {
            label:"Possible location of origin",
            type:2,
            is_reportable:0
        });
    ';
    
    rb.picoruleblock := replace(rb.picoruleblock,'[[rb_id]]',rb.blockid);
    rb.picoruleblock:=rman_pckg.sanitise_clob(rb.picoruleblock);
   INSERT INTO rman_ruleblocks(blockid,picoruleblock) VALUES(rb.blockid,rb.picoruleblock);
    
    -- END OF RULEBLOCK --

END;





