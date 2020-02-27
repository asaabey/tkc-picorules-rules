# Picorules

## Introduction
Picorule syntax is designed to author clinical logic targetting an EADV information model based table. The script is compiled SQL at run-time allowing dynamic SQL execution. The syntax abstracts subquery factoring and allows the author to use variables and boolean logic in a simplified manner. 

Authors can assemble complex incremental logic without worrying about grouping, self-joins or select statements.
The light weight compiler it self is written in PL/SQL.

## Structure

A set of instructions is compartmentalized into a rule block. There are just two type of statements in picorules

- Functional statements : Used to retrieve data from EADV data schema. A statement always returns one row per patient, and are essentially SQL aggregate or windowing functions.
- Conditional statements : operate on variables created by functional statements.
  
All statements must end with a semi-colon

**example functional statement**  

```javascript
hb_last => eadv.lab_bld_haemoglobin.val.last();
```
This is compiled into the following SQL statement

```sql
cte001 AS (
    SELECT
        eadv.eid,
        val,
        ROW_NUMBER() OVER(
            PARTITION BY eadv.eid
            ORDER BY
                eadv.eid, dt DESC
        ) AS rank
    FROM
        eadv
    WHERE
        ( att = 'lab_bld_hb' )
), cte002 AS (
    SELECT
        eid,
        val AS hb_last
    FROM
        cte001
    WHERE
        rank = 1
```

**example conditional statement**  

```javascript
is_anaemic : { hb_last < 120 => 1},{=>0};
```

This is compiled into the following SQL statement

```sql
cte003 AS (
    SELECT
        CASE
            WHEN hb_last < 120 THEN
                1
            ELSE
                0
        END AS is_anaemic,
        cte000.eid
    FROM
        cte000
        LEFT OUTER JOIN cte002 ON cte002.eid = cte000.eid
```

The combined picorule statement 
```javascript
hb_last => eadv.lab_bld_haemoglobin.val.last();

is_anaemic : { hb_last < 120 => 1},{=>0};
```

when compiled to a fully executional SQL statement result in the following statement.

```sql
WITH cte000 AS (
    SELECT
        eid
    FROM
        eadv
    WHERE
        1 = 1
    GROUP BY
        eid
), cte001 AS (
    SELECT
        eadv.eid,
        val,
        ROW_NUMBER() OVER(
            PARTITION BY eadv.eid
            ORDER BY
                eadv.eid, dt DESC
        ) AS rank
    FROM
        eadv
    WHERE
        ( att = 'lab_bld_hb' )
), cte002 AS (
    SELECT
        eid,
        val AS hb_last
    FROM
        cte001
    WHERE
        rank = 1
), cte003 AS (
    SELECT
        CASE
            WHEN hb_last < 120 THEN
                1
            ELSE
                0
        END AS is_anaemic,
        cte000.eid
    FROM
        cte000
        LEFT OUTER JOIN cte002 ON cte002.eid = cte000.eid
), cte004 AS (
    SELECT
        CASE
            WHEN 1 = 1 THEN
                1
        END AS test2,
        cte000.eid
    FROM
        cte000
)
SELECT
    cte000.eid,
    cte002.hb_last,
    cte003.is_anaemic,
    cte004.test2
FROM
    cte000
    LEFT OUTER JOIN cte002 ON cte002.eid = cte000.eid
    LEFT OUTER JOIN cte003 ON cte003.eid = cte000.eid
    LEFT OUTER JOIN cte004 ON cte004.eid = cte000.eid;
```



## Comparison between functional and conditional statements


| Functional statement | Conditional statement |
| -------------------- | --------------------- |
| variable name followed by '=>' operator | variable name followed by ':' operator |
| - | Must be preceeded by functional statements |
| reads from eadv table | transforms variables or applies boolean logic |
| references attributes (and hyper-attributes if .where() function used) | references only hyper attributes |
| compiled to  SELECT * FROM eadv | compiled to SELECT * CASE WHEN ELSE FROM cte |
| results in a single hyper-attribute | results in a single hyper-attribute |



