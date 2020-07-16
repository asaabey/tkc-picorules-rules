- Acknowledgments
    - Primary Author
    - Contributors
    - Support
    - Trademarks
- Preface
    - Purpose
        - Picorules is a language for expressing decision support logic
    - Status
        - beta
- Overview
    - Background
        - Expressing and sharing computerized clinical decision support (CDS) content across languages and technical platforms has been an evasive goal for a long time. 
        - Lack of commonly shared clinical information models and flexible support for various terminology resources have been identified as two main challenges for sharing decision logic across sites. 
    - Scope
        - The scope of Picorules is to express clinical logic as production rules. 
        - Discrete Picorules rules, each containing 'when-then' statements, can be combined together as building blocks to support single decision making and more complex, chained decision-making processes. 
        - The Picorules ruleblocks can be used to drive at-point-of-care decision support applications as well as retrospective populational analytics.
        - The use cases of Picorules include, but are not limited to:
            - Prompts, alerts & reminders;
            - Interactive single-screen decision support applications;
            - Detailed order-sets and care process support;
            - Algorithm-based calculators;
            - Generate and update personalized care plans as part of more complex care process support;
            - Retrospective treatment compliance check, and outcome measures.
    - Example
        - The following Picorules ruleblock demonstrates the application of 
        - A set of instructions is compartmentalized into a rule block. There are just two type of statements in picorules
            - Functional statements : Used to retrieve data from EADV data schema. A statement always returns one row per patient, and are essentially SQL aggregate or windowing functions.
            - Conditional statements : operate on variables created by functional statements.
        - All statements must end with a semi-colon
        - example functional statement
        - ```javascript
hb_last => eadv.lab_bld_haemoglobin.val.last();```
        - 
        - This is compiled into the following SQL statement
        - ```cte001 AS (
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
        rank = 1```
        - example conditional statement
        - ```is_anaemic : { hb_last < 120 => 1},{=>0};```
        - This is compiled into the following SQL statement
        - ```cte003 AS (
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
        LEFT OUTER JOIN cte002 ON cte002.eid = cte000.eid```
        - The combined picorule statement
        - ```hb_last => eadv.lab_bld_haemoglobin.val.last();

is_anaemic : { hb_last < 120 => 1},{=>0};```
        - when compiled to a fully executional SQL statement result in the following statement.
        - ```WITH cte000 AS (
    SELECT
        eid
    FROM
        eadv
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
    cte003.is_anaemicFROM
    cte000
    LEFT OUTER JOIN cte002 ON cte002.eid = cte000.eid
    LEFT OUTER JOIN cte003 ON cte003.eid = cte000.eid;```
        - ## 
        - Functional statementConditional statement
        - variable name followed by '=>' operatorvariable name followed by ':' operator
        - -Must be preceeded by functional statements
        - reads from eadv tabletransforms variables or applies boolean logic
        - references attributes (and hyper-attributes if .where() function used)references only hyper attributes
        - compiled to SELECT * FROM eadvcompiled to SELECT * CASE WHEN ELSE FROM cte
        - results in a single hyper-attributeresults in a single hyper-attribute
- Requirements
    - Clinical information model
        - EADV model
            - Clinical information 
                - diverse
                - heterogenous
                - sparse
            - EAV is a extension of key-value pairs
            - Derived from EAV which is widely used in this domain
                - Advantages
            - EAV frequently stored in SQL based RDBMS 
            - 
        - Querying EADV model
            - Steps
                - Subquery factoring
                - Self joins
                - normalization to EADV
            - Method
                - Dynamic SQL
    - Language
        - Agnostic ?
    - Reference terminology support
    - Identification and meta-data
    - Rule execution
        - Chaining
        - Cross reference
    - Output object
    - Local variables
- Picorules semantics
    - Rule structure
    - Execution model
    - language elements
        - Syntax
        - Pre-conditions
        - Rules
        - Expression elements
        - Local variables
    - reporting
- Picorules object model
    - package structure
        - UML
            - Package EADV
                - ENTITY Class
                - ATTRIBUTE Class
                - HYPER_ATTRIBUTE Class
                - EADV Class
                - EADVX Class
            - Package RMAN
                - RULEBLOCK  Class
                    - To_Compiler_Pipeline()
                - COMPILER_PIPELINE Class
                    - To_Compiler_Stack()
                    - Extract_Compiler_Directive_Expression()
                - COMPILER_STACK Class
                    - To_Dynamic_SQL_Expression()
                - COMPILER_DIRECTIVE_EXPRESSION Class
                - FUNCTIONAL_EXPRESSION Class
                - CONDITIONAL_EXPRESSION Class
                - DYNAMIC_SQL_EXPRESSION Class
            - 
        - compiler directives
            - Compiler directives are used to define meta-data describing ruleblock and attribute properties. These statements are not compiled to SQL, but define how compilation is performed. The statements are identified by the following form.
            - ```clojure
#<compiler_directive>(<ruleblock id>,<json object>);```
            - Picorules supports the following compiler directives
                - define_ruleblock
                - define_attribute
                - doc
            - define_ruleblock()
                - This compiler directive is mandatory and defines meta-data used for compilation
                - ```clojure
#define_ruleblock(test1,
            {
                description: "This is a test algorithm",
                version: "0.0.0.1",
                blockid: "test1",
                target_table:"rout_test1",
                environment:"DEV_2",
                rule_owner:"TKCADMIN",
                is_active:1,
                def_exit_prop:"test1",
                def_predicate:">0",
                exec_order:1,
                out_att : "test1",
                filter : "6811"
                
            }
        );```
                - The json object has the following properties
                    - description
                        - datatype : string
                    - version
                    - blockid: "test1",
                    - target_table:"rout_test1",
                    - environment:"DEV_2",
                    - rule_owner:"TKCADMIN",
                    - is_active:1,
                    - def_exit_prop:"test1",
                    - def_predicate:">0",
                    - exec_order:1,
                    - out_att : "test1",
                    - filter : "6811"
            - define_attribute()
                - This compiler directive is used to define hyper-attributes
                - ```clojure
#define_attribute(
            test_attribute,
            {

                label:"description of test attribute",
                is_reportable:1,
                type:2
            }
        );
```
                - The json object has the following properties
                    label:"description of test attribute",
                    is_reportable:1,
                    type:2
            - doc()
                - This compiler directive is used to add documentation and citations
        - functional statements
            - variable name followed by '=>' operator
            - reads from eadv table
            - references attributes (and hyper-attributes if .where() function used)
            - compiled to SELECT * FROM eadv
            - results in a single hyper-attribute
        - conditional statements
            - variable name followed by ':' operator
            - Must be preceeded by functional statements
            - transforms variables or applies boolean logic
            - references only hyper attributes
            - compiled to SELECT * CASE WHEN ELSE FROM cte
            - results in a single hyper-attribute
- Syntax specification
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTIzMzEzNDU2NV19
-->