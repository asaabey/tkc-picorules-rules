DROP TABLE rman_stack;

DROP TABLE rman_rpipe;

DROP TABLE rman_ruleblocks_log;

DROP TABLE rman_ruleblocks_dep;

DROP TABLE rman_ruleblocks;

CREATE TABLE rman_stack (
    id               INT NOT NULL,
    where_clause     VARCHAR2(4000),
    from_clause      VARCHAR2(4000),
    select_clause    VARCHAR2(4000),
    groupby_clause   VARCHAR2(100),
    varid            VARCHAR2(100),
    is_sub           NUMBER(1, 0),
    agg_func         VARCHAR2(100),
    func_param       VARCHAR2(100)
);
/

CREATE TABLE rman_rpipe (
    ruleid     VARCHAR2(100),
    rulebody   VARCHAR2(4000),
    blockid    VARCHAR2(100),
    CONSTRAINT pk_rpipe PRIMARY KEY ( ruleid )
);
/

CREATE TABLE rman_ruleblocks (
    blockid         VARCHAR2(100),
--    description         VARCHAR2(4000),
    target_table    VARCHAR2(100),
    environment     VARCHAR2(30),
    rule_owner      VARCHAR2(30),
    is_active       NUMBER(1, 0) DEFAULT 0,
    def_exit_prop   VARCHAR2(30),
    def_predicate   VARCHAR2(100),
    exec_order      NUMBER DEFAULT 1,
    out_att         VARCHAR2(4000),
    picoruleblock   CLOB,
    sqlblock        CLOB,
    CONSTRAINT pk_ruleblocks PRIMARY KEY ( blockid )
);
/

CREATE TABLE rman_ruleblocks_dep (
    blockid       VARCHAR2(100),
    dep_table     VARCHAR2(30),
    dep_column    VARCHAR2(100),
    att_name      VARCHAR2(100),
    att_label     VARCHAR2(100),
    att_meta      VARCHAR2(4000),
    dep_att       VARCHAR2(100),
    dep_func      VARCHAR2(100),
    view_exists   NUMBER(1, 0) DEFAULT 0,
    dep_exists    NUMBER(1, 0) DEFAULT 0,
    CONSTRAINT dep_fk_ruleblock FOREIGN KEY ( blockid )
        REFERENCES rman_ruleblocks ( blockid )
            ON DELETE CASCADE,
    CONSTRAINT rman_ruleblocks_dep_json_chk CHECK ( att_meta IS JSON ),
    CONSTRAINT rman_ruleblocks_dep_pk PRIMARY KEY ( blockid,
                                                    att_name )
);
/

CREATE TABLE rman_ruleblocks_log (
    id         RAW(16) DEFAULT sys_guid() PRIMARY KEY,
    moduleid   VARCHAR2(100),
    blockid    VARCHAR2(100),
    log_msg    VARCHAR2(100),
    log_time   TIMESTAMP(2) NOT NULL
    --CONSTRAINT log_fk_ruleblock FOREIGN KEY(blockid) REFERENCES rman_ruleblocks(blockid)
);
/

CREATE OR REPLACE TYPE tbl_type AS
    TABLE OF VARCHAR2(2000);
/

CREATE OR REPLACE TYPE tbl_type2 AS
    TABLE OF VARCHAR2(32767);
/