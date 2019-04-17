
DECLARE 
    TYPE RMAN_REC_TYPE IS RECORD 
    (
        ID              RMAN.ID%TYPE,
        WHERE_CLAUSE    RMAN.WHERE_CLAUSE%TYPE,
        FROM_CLAUSE     RMAN.FROM_CLAUSE%TYPE,
        SELECT_CLAUSE   RMAN.SELECT_CLAUSE%TYPE,
        GROUPBY_CLAUSE  RMAN.GROUPBY_CLAUSE%TYPE
    );
    
    TYPE RMAN_TBL_TYPE IS TABLE OF RMAN_REC_TYPE;
    
    rmanObj RMAN_TBL_TYPE;
    
    CMPSTAT NVARCHAR2(2000);
    
BEGIN
    SELECT ID, where_clause, from_clause, select_clause, groupby_clause
    BULK COLLECT INTO rmanObj
    FROM rman;
    
    FOR i IN rmanObj.FIRST..rmanObj.LAST
    LOOP
        CMPSTAT := 'SELECT ' || rmanobj(i).select_clause || ' FROM ' || rmanobj(i).from_clause ||
                    ' WHERE ' || rmanobj(i).where_clause || ' GROUP BY ' || rmanobj(i).groupby_clause;
        DBMS_OUTPUT.PUT_LINE('Composite statement : ' || CMPSTAT);
    END LOOP;
    
END;