select 
        att_name , 
        JSON_VALUE(att_meta,'$.label' RETURNING VARCHAR2) as LABEL,
        JSON_VALUE(att_meta,'$.is_reportable' RETURNING NUMBER) as IS_REPORTABLE,
        JSON_VALUE(att_meta,'$.is_trigger' RETURNING NUMBER) as is_trigger
from rman_ruleblocks_dep
where 
    JSON_EXISTS(att_meta,'$.is_reportable' FALSE ON ERROR)
    AND JSON_EXISTS(att_meta,'$.is_trigger' FALSE ON ERROR);