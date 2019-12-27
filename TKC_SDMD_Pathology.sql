SELECT
     pathology.pathology_person.client_id,
--     codebook.sex.sex_dsc,
--     codebook.indigenous_status.indigenous_status_dsc,
     pathology.test_result_value.test_cde,
     pathology.test_result_value.result_value,
     pathology_test_type2.result_value_unit
 FROM
     pathology.std_result_and_test_result_val,
     pathology.test_group,
     pathology.pathology_event,
     pathology.test_result_value,
     pathology.pathology_person,
     pathology.test_type pathology_test_type2
 WHERE
     pathology_person.client_id = '0931873' AND ROWNUM<10 
     AND ( pathology.pathology_person.person_id = pathology.pathology_event.person_id )
--     AND ( codebook.sex.sex_cde = pathology.pathology_person.sex_cde )
     AND ( pathology.pathology_event.event_no = pathology.test_group.event_no )
     AND ( pathology.test_group.event_no = pathology.std_result_and_test_result_val.event_no
           AND pathology.test_group.test_group_cde = pathology.std_result_and_test_result_val.test_group_cde
           AND pathology.test_group.test_group_seq_no = pathology.std_result_and_test_result_val.test_group_seq_no )
     AND ( pathology.std_result_and_test_result_val.event_no = pathology.test_result_value.event_no
           AND pathology.std_result_and_test_result_val.test_cde = pathology.test_result_value.test_cde
           AND pathology.std_result_and_test_result_val.test_group_cde = pathology.test_result_value.test_group_cde
           AND pathology.std_result_and_test_result_val.test_group_seq_no = pathology.test_result_value.test_group_seq_no )
     
     AND ( pathology_test_type2.test_type_cde = pathology.test_result_value.test_cde
           AND pathology_test_type2.test_name_cde = pathology.test_result_value.test_group_cde )