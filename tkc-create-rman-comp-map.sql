--------------------------------------------------------
--  File created - Wednesday-July-03-2019   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table RMAN_COMP_MAP
--------------------------------------------------------
  
  DROP TABLE "TKC_REGISTRY"."RMAN_COMP_MAP";
--------------------------------------------------------
--  DDL for Table RMAN_COMP_MAP
--------------------------------------------------------

CREATE TABLE "TKC_REGISTRY"."RMAN_COMP_MAP" 
   (	"KEY" VARCHAR2(50 BYTE), 
	"NAME" NVARCHAR2(500), 
	"ID" NUMBER(*,0), 
	"NCOMP" VARCHAR2(100 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT)
  TABLESPACE "OAK" ;
REM INSERTING into TKC_REGISTRY.RMAN_COMP_MAP
SET DEFINE OFF;
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('CVR5F','Cardiovascular Risk: 5 Year (Framingham)',11,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('SmokingStatus','Smoking Status',62,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Referral','Referral',60,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Education','CKD Education',22,'enc_op_renal_edu');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Weight','Weight',77,'obs_weight');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Height','Height',31,'obs_height');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('SYSTOLIC','Systolic Blood Presure Measurement',61,'obs_bp_systolic');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('DIASTOLIC','Diastolic Blood Pressure Measurement',19,'obs_bp_diastolic');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Transferrin','Transferrin',67,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('HBA1C%','HbA1c (NGSP)',26,'lab_bld_hba1c_ngsp');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('eGFR','Estimated Glomerular Filtration Rate Code',78,'lab_bld_egfr');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Creatinine','Creatinine',18,'lab_bld_creatinine');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('ACR','ACR (Alb/Creat Ratio)',1,'lab_ua_acr');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('TotalCholesterolLevelHdlRatio','Total cholesterol/HDL ratio',66,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Triglyceride','Triglyceride level',68,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('TotalCholesterolLevel','Total Cholesterol Level',65,'lab_bld_cholesterol_total');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('HDL','HDL Level',27,'lab_bld_cholesterol_hdl');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('LDL','LDL Level',34,'lab_bld_cholesterol_ldl');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urea Nitrogen','Urea (Urea Nitrogen)',69,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Iron','Iron',32,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('HbA1c IFCC','HbA1c (IFCC)',29,'lab_bld_hba1c_ifcc');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Haemoglobin','Hb (Haemoglobin)',28,'lab_bld_hb');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Sodium','Sodium in Serum',63,'lab_bld_sodium');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Potassium','Potassium in Serum',51,'lab_bld_potassium');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Calcium Corrected','Calcium corrected for albumin in Serum',13,'lab_bld_calcium_corrected');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Magnesium','Magnesium in Serum',43,'lab_bld_magnesium');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Phosphate','Phosphate in Serum',49,'lab_bld_phosphate');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Bicarbonate','Bicarbonate in Serum',6,'lab_bld_bicarbonate');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Bilirubin','Bilirubin in Serum',7,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Albumin','Albumin in Serum',3,'lab_bld_albumin');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Total Protein','Protein in Serum',64,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Eosinophils','Eosinophil #',23,'lab_bld_wcc_eosinophils');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Lymphocytes','Lymphocytes',38,'lab_bld_wcc_lymphocytes');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Monocytes','Monocyte #',44,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Neutrophils','Neutrophils',45,'lab_bld_wcc_neutrophils');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Platelets','Platelets',50,'lab_bld_platelets');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('MCHC RBC Auto-mCnc','Erythrocyte mean corpuscular hemoglobin concentration',40,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('MCV RBC Auto','Erythrocyte mean corpuscular volume',41,'lab_bld_rbc_mcv');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('RDW RBC Auto-Rto','Erythrocyte distribution width',59,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Erythrocytes','Erythrocytes',24,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Albumin Ur-mCnc','Albumin in Urine',4,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Calcium SerPl-sCnc','Calcium in Serum',14,'lab_bld_calcium');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Chloride SerPl-sCnc','Chloride in Serum',16,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Iron/TIBC SerPl','Iron binding capacity is Serum',33,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Hct VFr Bld Auto','Hematocrit of Blood',30,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('WBC # Bld Auto','Leukocytes in Blood',76,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Creat Ur-sCnc','Creatinine in Urine',17,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urea SerPl-sCnc','Urea in Serum',70,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('PTH','Parathyrin intact',48,'lab_bld_pth');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Ferritin SerPl-mCnc','Ferritin in Serum',25,'lab_bld_ferritin');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Proteinase-3','Proteinase-3 (PR3) Antibodies',57,'lab_bld_anca_pr3');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('BJ Protein Ur-Imp','Bence Jones Protein in Urine',5,'lab_ua_bjp');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('CRP SerPl-mCnc','C REACTIVE PROTEIN',10,'lab_bld_crp');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Ca-I SerPl ISE-sCnc','CALCIUM IONISED',12,'lab_bld_calcium_ionized');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Leucocytes Urine','Leucocytes in Urine',37,'lab_ua_leucocytes');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('LYMPHOCYTE KAPPA','LYMPHOCYTE KAPPA',35,'lab_bld_sflc_kappa');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('LYMPHOCYTE LAMBDA','LYMPHOCYTE LAMBDA',36,'lab_bld_sflc_lambda');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Prostate Specific Antigen','Total PSA',54,'lab_bld_psa');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('paraprotein','paraprotein',79,'lab_bld_spep_paraprotein');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Protein in Urine','Protein in Urine',56,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Protein Creatinine ratio','Protein/Creatinine ratio',55,'lab_ua_pcr');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('RBC #/area UrnS HPF','Erythrocytes in Urine sediment',58,'lab_ua_rbc');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urinalysis Blood','Urinalysis: Blood',71,'lab_ua_poc_rbc');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urinalysis Leukocytes','Urinalysis: Leukocytes',72,'lab_ua_poc_leucocytes');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urinalysis Nitrites','Urinalysis: Nitrites',73,'lab_ua_poc_nitrites');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urinalysis Protein','Urinalysis: Protein',75,'lab_ua_poc_protein');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Urinalysis PH','Urinalysis: PH',74,'lab_ua_poc_ph');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Diagnosis','Diagnosis',21,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Prescription','Prescription',52,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Careplan','Care Plan',15,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Procedure','Procedure',53,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('C3 SerPl-mCnc','Complement C3 in Serum',8,'lab_bld_complement_c3');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('C4 SerPl-mCnc','Complement C4 in Serum',9,'lab_bld_complement_c4');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('MBS','Medical Benefits Scheme',39,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Outpatient Episode','Outpatient Episode',47,null);
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('DSDNA AB SER-ACNC','DNA double Strand Anti-body [UNITS/VOLUME] in serum',20,'lab_bld_dsdna');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('MYELOPEROXIDASE IGG SER-ACNC','Myeloperoxidase IgG Ab [Units/volume] in Serum',42,'lab_bld_anca_mpo');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('ASO AB SERPL-ACNC','Streptolysin O Ab [Units/volume] in Serum or Plasma',2,'lab_bld_asot');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Nuclear Ab','Nuclear Ab [Titer] in Serum by Immunofluorescence',46,'lab_bld_ana');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('Imaging Episode','Patient has attended an imaging/radiology session',80,'enc_ris_');
Insert into TKC_REGISTRY.RMAN_COMP_MAP (KEY,NAME,ID,NCOMP) values ('BMI','Body mass index kg/m2',170,'obs_bmi');
--------------------------------------------------------
--  Constraints for Table RMAN_COMP_MAP
--------------------------------------------------------

  ALTER TABLE "TKC_REGISTRY"."RMAN_COMP_MAP" MODIFY ("NAME" NOT NULL ENABLE);
  ALTER TABLE "TKC_REGISTRY"."RMAN_COMP_MAP" MODIFY ("KEY" NOT NULL ENABLE);

