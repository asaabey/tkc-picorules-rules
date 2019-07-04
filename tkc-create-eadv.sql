DROP TABLE EADV;
/
CREATE TABLE EADV
(
    eid NUMBER(12,0) NOT NULL,
    att VARCHAR2(32) NOT NULL,
    dt DATE NOT NULL,
    val NUMBER(15,2)

);
DROP INDEX eadv_att_idx;
DROP INDEX eadv_eid_idx;

CREATE INDEX eadv_att_idx ON EADV(att) compute statistics ;
CREATE INDEX eadv_eid_idx ON EADV(eid) compute statistics;

ANALYZE TABLE EADV COMPUTE STATISTICS;

ALTER INDEX eadv_att_idx rebuild;
ALTER INDEX eadv_eid_idx rebuild;