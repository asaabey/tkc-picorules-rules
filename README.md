Package		    rman_pckg
Version		    0.0.1.9
Creation date	07/04/2019
update on date  05/07/2019
Author		    asaabey@gmail.com

Purpose		
Dynamic rules engine, which converts 'picorules' script to ANSI SQL script. Source table needs to conform to EADV format (entity,attribute,date,value).
Rules are inserted into RPIPE table which is parsed by PARSE_RPIPE procedure to create RMAN table. The get_composite_sql procedure forms the SQL statement with recursive CTE's.

The SQL statement can be dynamically executed using exec_dsql (Method 4 dynamic SQL using the dbms_sql package) or exec_NDS (native dynamic SQL using) 
creating wide tables. Long tables /Datastore (EADV) are generated using exec_dsql_dstore_multi/singlecol functions using dbms_sql.


*/
/*
    +-------------+
    |  ruleblock  |
    +------+------+
           |
           |  execute_active_ruleblocks()
           |  
           |  execute_ruleblock()
           |
           |  parse_ruleblocks()
           |
           v
    +------+------+
    |    rpipe    +------------+-----------+
    +-------------+            |           |
                               |           |
              parse_rpipe()    |           |
                               |           |
                               |           |
         +-----------------+   |  +--------v--------+
         | func_expression +<--+  | cond_expression |
         +-----------------+      +-----------------+
                    |                       |
  build_func_sql()  +----+        +---------+    build_cond_sql()                   
                         |        | 
                    +----v--------v-+
                    |      rstack   |
                    +---------------+
                             +
                             |
                             |   get_composite_sql()
                             |
                             v
                     +-------+--------+
           +---------+  SQL statement +--------+
           |         +------------+---+        |
           |                      |            |
           |                      |            |
           |  exec_dsql() /       |            |   exec_dsql_dstore_multicol()
           |                      |            |
           |  exec_ndsql()        |            |
           |                      |   exec_dsql_dstore_singlecol()
           |                      |            |
           v                      |            v
    +------+-------+              |   +--------+-------+
    |  wide table  |              +-->+    long table  |
    +--------------+                  |      EADV      |
                                      +----------------+

     
     
     
*/
/*
Functional declaration, is a aggregate/analytic function which returns a single row for each entitiy
This creates a handle/pointer to another table (default is eadv). The declaration is defined by the '=>' operator.


varname => object.attribute.property.function(param);

[varname]=> object.[attribute].property.function(param)
[varname]=> object.[attribute%].property.function(param)

Shorthand
LAST() implied
varname=> object.attribute.property

VAL.LAST() implied
varname=> object.attribute

EADV.[att].VAL.LAST() implied
varname=> attribute

Attribute predicates
 [att1,att2,att3%]
 is compiled to
 (ATT = 'att1') OR (ATT = 'att2') OR (ATT LIKE 'att3%')
*/

--Commenting
-- /* comment */

/*
Intermediate variables
 if the assigned name is terminated with an underscore , it will not be displayed in the final ROUT table
  var_

Emplicit variable use
Prior to rman 0.0.0.9 variables had to be passed. Now variables can be used implicitly as they detected by the parser

NVL injection
COUNT aggregate function returned null due to grouping. Now a func param can be passed to inject NVL
 var1 => eadv.att_name.val.count(0)



Conditional declaration
varname(dependent var,..): { sql_case_when_expr => sql_case_then_expr},..,{=> sq_case_else_then_expr}
This can be used to derive any SQL scalar function
varname(dependent var,..):{1=1 => sql_scalar_func()}

External table binding
tbl.att.val.bind()
should only be used were eid->att is 1:1
