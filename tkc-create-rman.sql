DROP TABLE rman;
CREATE TABLE rman
(
    id INT NOT NULL,
    where_clause VARCHAR2(100),
    from_clause VARCHAR2(4000),
    select_clause VARCHAR2(4000),
    groupby_clause VARCHAR2(100),
    varid VARCHAR2(100),
    is_sub NUMBER(1,0)
);

DROP TABLE rpipe;
CREATE TABLE rpipe
(
    ruleid varchar2(100),
    rulebody varchar2(4000)
)

CREATE OR REPLACE TYPE tbl_type AS TABLE OF VARCHAR2(2000);


