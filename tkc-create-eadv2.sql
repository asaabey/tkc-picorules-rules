DROP TABLE EADV2;
/
CREATE TABLE EADV2
(
    eid NUMBER(12,0) NOT NULL,
    att VARCHAR2(32) NOT NULL,
    dt DATE NOT NULL,
    val NUMBER(15,2)

);
DROP INDEX eadv2_att_idx;
DROP INDEX eadv2_eid_idx;



/*  Valid for XE 18c and 12.1 EE*/
CREATE BITMAP INDEX eadv2_att_idx ON EADV2(att);
CREATE BITMAP INDEX eadv2_eid_idx ON EADV2(eid);