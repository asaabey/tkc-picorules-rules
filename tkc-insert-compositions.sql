REM INSERTING into TKC.RMAN_RPT_COMPOSITIONS
TRUNCATE TABLE RMAN_RPT_COMPOSITIONS;

SET DEFINE OFF;
Insert into RMAN_RPT_COMPOSITIONS (ID,COMPOSITION_NAME,COMPOSITION_DESC) values (1,'neph002_html','Nephrologists standard composition');
Insert into RMAN_RPT_COMPOSITIONS (ID,COMPOSITION_NAME,COMPOSITION_DESC) values (2,'card001_html','Cardiologists standard composition');
Insert into RMAN_RPT_COMPOSITIONS (ID,COMPOSITION_NAME,COMPOSITION_DESC) values (3,'ckdedu001_html','CKD Nurse educational composition');
Insert into RMAN_RPT_COMPOSITIONS (ID,COMPOSITION_NAME,COMPOSITION_DESC) values (4,'masked001_html','Masked blank composition');
Insert into RMAN_RPT_COMPOSITIONS (ID,COMPOSITION_NAME,COMPOSITION_DESC) values (5,'cse_corres_html','CSE correspondence');
Insert into RMAN_RPT_COMPOSITIONS (ID,COMPOSITION_NAME,COMPOSITION_DESC) values (6,'neph004_rtf','Nephrologists RTF compatible composition');
