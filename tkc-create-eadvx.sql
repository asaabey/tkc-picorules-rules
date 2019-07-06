DROP TABLE EADVX;
/
CREATE TABLE EADVX
(
    id      NUMBER GENERATED ALWAYS AS IDENTITY,
    eid     NUMBER(*,0) NOT NULL,
    att     VARCHAR2(32) NOT NULL,
    dt      DATE NOT NULL,
    valn    NUMBER(*,0),
    valc    VARCHAR2(4000),
    vald    DATE,
    evhash  VARCHAR2(32),
    typ     NUMBER(*,0),
    src     VARCHAR2(100),  
    
--    CONSTRAINT EADVX_PK PRIMARY KEY (id),
    CONSTRAINT EADVX_UC UNIQUE (eid,evhash)
);
/
--DROP SEQUENCE EADVX_seq;
--CREATE SEQUENCE EADVX_seq
--  MINVALUE 1
--  START WITH 1
--  INCREMENT BY 1
--  CACHE 20;
--/
--DROP TRIGGER EADVX_tg;
--CREATE TRIGGER EADVX_tg
--BEFORE INSERT ON EADVX
--FOR EACH ROW
--WHEN (new.id IS NULL)
--BEGIN
--   SELECT EADVX_seq.NEXTVAL
--   INTO   :new.id
--   FROM   dual;
--END;

DROP INDEX eadvx_att_idx;
/
CREATE INDEX eadvx_att_idx ON EADVX(att);