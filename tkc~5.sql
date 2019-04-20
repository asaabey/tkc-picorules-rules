SELECT
    system_rules_attribute_id,
    classification_like,
    code_like
FROM
    system_rules_codes
WHERE 
    SYSTEM_RULES_ATTRIBUTE_ID IN ('RRT.HD.Px.Tertiary','RRT.HD.Dx.ICD') ;

SELECT ATT, COUNT(*),EID
FROM eadv
WHERE (ATT LIKE 'icd_Z49%' ESCAPE '!')
--WHERE ATT IN ('E08')
GROUP BY ATT,EID
ORDER BY EID;



SELECT ATT, COUNT(*)
FROM eadv
WHERE (ATT LIKE '%!%%' ESCAPE '!')
--WHERE ATT IN ('E08')
GROUP BY ATT;

UPDATE EADV
SET att='icd_' || att
WHERE (ATT LIKE '%!_%' ESCAPE '!');

UPDATE EADV
SET att=REPLACE(att,'%','_DFCC')
WHERE (ATT LIKE '%!%%' ESCAPE '!');