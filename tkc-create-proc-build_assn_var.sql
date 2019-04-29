PROCEDURE build_assn_var
(
    txtin IN VARCHAR2,
    delim IN VARCHAR2,
    left_tbl_name IN VARCHAR2,
    from_table OUT VARCHAR2,
    avn OUT VARCHAR2

) IS
    used_vars VARCHAR2(4000);
    used_vars_tbl tbl_type;
BEGIN
            
             
            IF INSTR(txtin,delim)>0  AND INSTR(txtin,'(',1,1)>0 THEN
                avn:=SUBSTR(txtin, 1, INSTR(txtin,'(',1,1)-1);
            ELSE
                avn:=SUBSTR(txtin, 1, INSTR(txtin,delim,1,1)-1);
            END IF;
            
            used_vars:=REGEXP_SUBSTR(SUBSTR(txtin,1,INSTR(txtin,delim)-length(delim)), '\((.*)?\)', 1, 1, 'i', 1);

            
            used_vars_tbl:=rman_pckg.splitstr(used_vars,',');
            
                        
            --left_tbl_name := get_cte_name(0);
            
            IF used_vars_tbl.COUNT>0 THEN
                        from_clause :=from_clause || left_tbl_name;                    
                        for i IN 1..used_vars_tbl.LAST LOOP
                  
                            from_clause:=from_clause || ' LEFT OUTER JOIN ' || get_cte_name(vstack(used_vars_tbl(i)))
                                    || ' ON ' || get_cte_name(vstack(used_vars_tbl(i))) || '.' || entity_id_col || '=' 
                                    || left_tbl_name || '.' || entity_id_col || ' ';
                        END LOOP;
                        
            ELSE
                        -- RAISE EXCEPTION
                        DBMS_OUTPUT.PUT(', ');
            END IF;

END build_assn_var;