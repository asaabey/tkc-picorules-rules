CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE

    
    strsql      CLOB;
    
    
    
    rb          RMAN_RULEBLOCKS%ROWTYPE;
    
    bid         RMAN_RULEBLOCKS.blockid%TYPE;

BEGIN
   
    DELETE FROM rman_rpipe;
    DELETE FROM rman_stack;
    
    bid:='ckd-qa-dx-iq-1-1';
    
    rman_pckg.parse_ruleblocks(bid);
    
    rman_pckg.parse_rpipe(strsql);
    
    UPDATE rman_ruleblocks SET sqlblock=strsql WHERE blockid=bid;
    
    SELECT * INTO rb FROM rman_ruleblocks WHERE blockid=bid;
   
    DBMS_OUTPUT.PUT_LINE('RMAN execution -->' || chr(10));
    DBMS_OUTPUT.PUT_LINE('Rule block id : ' || rb.blockid || chr(10));
    DBMS_OUTPUT.PUT_LINE('Target tbl    : ' || rb.target_table || chr(10));
    DBMS_OUTPUT.PUT_LINE('Environment   : ' || rb.environment || chr(10));
    
    rman_pckg.exec_dsql(rb.sqlblock,rb.target_table);
    
  
    
    
    
END;



