--INSERT INTO rman VALUES (1,'ATT=''ACR''','EADV','EID,MAX(VAL) AS MAXVAL','ATT,EID',0);
--INSERT INTO rman VALUES (2,'ATT=''eGFR''','EADV','eid,val,ROW_NUMBER() OVER(PARTITION BY eid,att ORDER BY eid,dt desc) AS rank','',1);
--INSERT INTO rman VALUES (3,'rank=1','cte00002','eid,val','',0);

DELETE FROM rman;
INSERT INTO rman VALUES (1,'ATT=`ACR`','EADV','EID,MAX(VAL) AS MAXVAL','ATT,EID',0);
INSERT INTO rman VALUES (2,'ATT=`eGFR`','EADV','eid,val,ROW_NUMBER() OVER(PARTITION BY eid,att ORDER BY eid,dt desc) AS rank','',1);
INSERT INTO rman VALUES (3,'rank=1','cte00002','eid,val','',0);


INSERT INTO rman VALUES (1,'ATT=''ACR''','EADV','EID,MAX(VAL) AS ACRMAX','ATT,EID',0);
INSERT INTO rman VALUES (2,'ATT=''eGFR''','EADV','EID,VAL,ROW_NUMBER() OVER(PARTITION BY EID,ATT ORDER BY EID,DT DESC) AS rank','',1);
INSERT INTO rman VALUES (3,'rank=1','cte00002','EID,VAL','',0);




--need to fix indexing 

INSERT INTO rman VALUES (1,'ATT=''ACR''','EADV','EID,MAX(VAL) AS MAXVAL','ATT,EID',0);
INSERT INTO rman VALUES (2,'ATT=''eGFR''','EADV','eid,val,ROW_NUMBER() OVER(PARTITION BY eid,att ORDER BY eid,dt desc) AS rank','',1);
INSERT INTO rman VALUES (3,'rank=1','cte00002','eid,val','',0);


