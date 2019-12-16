DROP TABLE rman_term_dict;
/

CREATE TABLE rman_term_dict (
    key   VARCHAR2(100),
    val   VARCHAR2(400),
    CONSTRAINT pk_rman_term_dict PRIMARY KEY ( key )
);
/

INSERT INTO rman_term_dict VALUES (
    'BIND',
    'External table'
);

--'MAX',
--                    'MIN',
--                    'COUNT',
--                    'SUM',
--                    'AVG',
--                    'MEDIAN',
--                    'STATS_MODE'


INSERT INTO rman_term_dict VALUES ('BIND','External table');
INSERT INTO rman_term_dict VALUES ('MAX','External table');
INSERT INTO rman_term_dict VALUES ('MIN','External table');
INSERT INTO rman_term_dict VALUES ('COUNT','External table');
INSERT INTO rman_term_dict VALUES ('SUM','External table');
INSERT INTO rman_term_dict VALUES ('AVG','External table');
INSERT INTO rman_term_dict VALUES ('MEDIAN','External table');
INSERT INTO rman_term_dict VALUES ('STATS_MODE','External table');


/