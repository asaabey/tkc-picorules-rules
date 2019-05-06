    DROP TABLE rman_stack;
    
    
    CREATE TABLE rman_stack(
        id INT NOT NULL,
        where_clause VARCHAR2(4000),
        from_clause VARCHAR2(4000),
        select_clause VARCHAR2(4000),
        groupby_clause VARCHAR2(100),
        varid VARCHAR2(100),
        is_sub NUMBER(1,0)
    );
    
    DROP TABLE rman_rpipe;
    CREATE TABLE rman_rpipe(
        ruleid varchar2(100),
        rulebody varchar2(4000),
        CONSTRAINT pk_rpipe PRIMARY KEY(ruleid)
    );
    
    DROP TABLE rman_ruleblocks;
    CREATE TABLE rman_ruleblocks(
        blockid         varchar2(100),
        picoruleblock   clob,
        sqlblock        clob,
        target_table    VARCHAR2(100),
        environment     VARCHAR2(30),
        rule_owner      VARCHAR2(30),
        CONSTRAINT pk_ruleblocks PRIMARY KEY(blockid)
    );

    DROP TABLE rman_config;    
    CREATE TABLE rman_config(
        id              INTEGER,
        config_var      VARCHAR2(100),
        config_val      VARCHAR2(1000)
    );
    
    DROP TABLE rman_log;
    CREATE TABLE rman_log(
        id              INTEGER,
        logmsg          VARCHAR2(4000),
        log_ts          TIMESTAMP
    );
    
    CREATE OR REPLACE TYPE tbl_type AS TABLE OF VARCHAR2(2000);
    
    CREATE OR REPLACE TYPE tbl_type2 AS TABLE OF VARCHAR2(32767);
    /
    




