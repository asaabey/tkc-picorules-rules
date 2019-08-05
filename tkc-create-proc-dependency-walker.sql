CLEAR SCREEN;

DECLARE
    s VARCHAR2(4000);

    PROCEDURE dependency_walker (
        rb_in_str    IN           VARCHAR2,
        dep_rb_str   OUT          VARCHAR2
    ) AS

        TYPE blockid_tbl_t IS
            TABLE OF rman_ruleblocks.blockid%TYPE;
        TYPE exec_order_tbl_t IS
            TABLE OF rman_ruleblocks.exec_order%TYPE;
        rb_in_tbl              tbl_type;
        TYPE uq_blockid_tbl_t IS
            TABLE OF INTEGER(1) INDEX BY VARCHAR2(100);
        uq_blockid_tbl         uq_blockid_tbl_t;
        uq_blockid_tbl_empty   uq_blockid_tbl_t;
        pre_str                VARCHAR2(4000);
        post_str               VARCHAR2(4000);
        rb_out_str             VARCHAR2(4000);

        PROCEDURE get_dep_blockids (
            bid_in VARCHAR2
        ) AS
            tmp_str          VARCHAR2(100);
            blockid_tbl      blockid_tbl_t;
            exec_order_tbl   exec_order_tbl_t;
        BEGIN
            SELECT
                r.blockid,
                r.exec_order
            BULK COLLECT
            INTO
                blockid_tbl,
                exec_order_tbl
            FROM
                rman_ruleblocks_dep   d
                JOIN rman_ruleblocks       r ON r.target_table = d.dep_table
            WHERE
                d.blockid = bid_in
                AND nvl(d.dep_table, '') <> 'EADV';

            FOR i IN 1..blockid_tbl.count LOOP uq_blockid_tbl(blockid_tbl(i)) := exec_order_tbl(i);
            END LOOP;

        END get_dep_blockids;

        FUNCTION serialize_stack RETURN VARCHAR2 AS
            idx   VARCHAR2(100);
            ret   VARCHAR2(4000) := '';
        BEGIN
            idx := uq_blockid_tbl.first;
            WHILE ( idx IS NOT NULL ) LOOP
                ret := ret
                       || ','
                       || idx;
                idx := uq_blockid_tbl.next(idx);
            END LOOP;

            ret := trim(BOTH ',' FROM ret);
            RETURN ret;
        END serialize_stack;

        PROCEDURE process_stack AS
            idx VARCHAR2(100);
        BEGIN
            idx := uq_blockid_tbl.first;
            WHILE ( idx IS NOT NULL ) LOOP
                get_dep_blockids(idx);
                idx := uq_blockid_tbl.next(idx);
            END LOOP;

        END process_stack;

        PROCEDURE fetch_rb (
            rb_in_tbl        IN               tbl_type,
            blockid_tbl      OUT              blockid_tbl_t,
            exec_order_tbl   OUT              exec_order_tbl_t
        ) AS
        BEGIN
            SELECT
                r.blockid,
                r.exec_order
            BULK COLLECT
            INTO
                blockid_tbl,
                exec_order_tbl
            FROM
                rman_ruleblocks r
            WHERE
                r.blockid IN (
                    SELECT
                        *
                    FROM
                        TABLE ( rb_in_tbl )
                )
            ORDER BY
                r.exec_order;

        END fetch_rb;

        PROCEDURE init_stack (
            rb_in_str    IN           VARCHAR2,
            rb_out_str   OUT          VARCHAR2
        ) AS
            blockid_tbl      blockid_tbl_t;
            exec_order_tbl   exec_order_tbl_t;
        BEGIN
            rb_in_tbl := rman_pckg.splitstr(rb_in_str, ',');
            fetch_rb(rb_in_tbl, blockid_tbl, exec_order_tbl);
            uq_blockid_tbl := uq_blockid_tbl_empty;
            FOR i IN 1..blockid_tbl.count LOOP
                uq_blockid_tbl(blockid_tbl(i)) := exec_order_tbl(i);
                rb_out_str := rb_out_str
                              || ','
                              || blockid_tbl(i);
            END LOOP;

            rb_out_str := trim(BOTH ',' FROM rb_out_str);
        END init_stack;

    BEGIN
        init_stack(rb_in_str, rb_out_str);
        LOOP
            pre_str := serialize_stack;
            process_stack;
            post_str := serialize_stack;
            IF ( pre_str = post_str ) THEN
                EXIT;
            END IF;
        END LOOP;

        init_stack(post_str, rb_out_str);
        dep_rb_str := rb_out_str;
    END dependency_walker;

    PROCEDURE get_min_dep_att_str (
        rb                IN                VARCHAR2,
        rb_add_tbl        IN                tbl_type,
        min_dep_att_str   OUT               VARCHAR2
    ) AS
    BEGIN
        WITH t1 AS (
            SELECT
                d.blockid,
                att_name AS att
            FROM
                rman_ruleblocks_dep d
            WHERE
                d.dep_exists = 1
                OR d.blockid
                   || '.'
                   || d.att_name IN (
                    SELECT
                        *
                    FROM
                        TABLE ( rb_add_tbl )
                )
            UNION
            SELECT
                r.blockid,
                r.def_exit_prop AS att
            FROM
                rman_ruleblocks r
        )
        SELECT
            LISTAGG(att, ',') WITHIN GROUP(
                ORDER BY
                    t1.blockid
            )
        INTO min_dep_att_str
        FROM
            t1
        WHERE
            t1.blockid = rb
        GROUP BY
            t1.blockid;

    END get_min_dep_att_str;

    PROCEDURE cube_in_rbstack (
        rb_att_str IN VARCHAR2
    ) AS
        rb_att_tbl tbl_type;
        rb_full_tbl tbl_type;
        rb_str  varchar2(4000);
    BEGIN
        rb_att_tbl := rman_pckg.splitstr(rb_att_str, ',');
        for i in 1..rb_att_tbl.count
        loop
            rb_str:=rb_str || ',' || substr(rb_att_tbl(i),1,instr(rb_att_tbl(i),'.')-1);
        end loop;
        
        rb_str:=trim(leading ',' from rb_str);
        
        
        DBMS_OUTPUT.PUT_LINE('pass 1 -> '|| rb_str);
        
        dependency_walker(rb_str, rb_str);
        
        DBMS_OUTPUT.PUT_LINE('pass 2 -> '|| rb_str);
        rb_full_tbl:= rman_pckg.splitstr(rb_str, ',');

        
        for i in 1..rb_full_tbl.count
        loop
            get_min_dep_att_str(rb_full_tbl(i),rb_att_tbl,rb_str);
            DBMS_OUTPUT.PUT_LINE('pass 3 -> '|| '(' || i || ') -> ' || rb_full_tbl(i) || ' -> ' || rb_str);
        end loop;
        
        
        
        
    END cube_in_rbstack;

BEGIN
--    dependency_walker('rrt,ckd,cvra,pcd', s);
--    dbms_output.put_line('**->' || s);
    
--    get_min_deP_att_str('cd_htn',s);
--    dbms_output.put_line('**(2)->' || s);
    cube_in_rbstack('cd_dm.dm,cvra.cvra,cvra.cabg');
END;