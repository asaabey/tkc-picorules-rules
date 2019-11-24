DROP TABLE rman_ruleblocks_citation;
/

CREATE TABLE rman_ruleblocks_citation (
    citation_id     VARCHAR2(100),
    citation_body   VARCHAR2(4000),
    CONSTRAINT pk_rman_ruleblocks_citation PRIMARY KEY ( citation_id )
);
/

INSERT INTO rman_ruleblocks_citation VALUES (
'rrt_hd_icd',
'Weinhandl ED, Kubisiak KM, Wetmore JB. Low Quality of International
Classification of Diseases, 10th Revision, Procedural Coding System Data
Undermines the Validity of the Standardized Transfusion Ratio: Time to Chart a
New Course? Adv Chronic Kidney Dis. 2019 Jul;26(4):237-249. doi:
10.1053/j.ackd.2019.04.006. PubMed PMID: 31477254.
'
);

INSERT INTO rman_ruleblocks_citation VALUES (
'rrt_pd_icd',
'Iliadou VV, Eleftheriadis N. Response to the Letter from Dr. Vermiglio
Regarding Iliadou and Eleftheriadis (2017): CAPD is Classified in ICD-10 as
H93.25. J Am Acad Audiol. 2018 Mar;29(3):264-265. doi: 10.3766/jaaa.17022. PubMed
PMID: 29488877.'
);

INSERT INTO rman_ruleblocks_citation VALUES (
'ckd_ki_ckd_2012',
'Levin A, Stevens PE. Summary of KDIGO 2012 CKD Guideline: behind the scenes,
need for guidance, and a framework for moving forward. Kidney Int. 2014
Jan;85(1):49-61. doi: 10.1038/ki.2013.444. Epub 2013 Nov 27. Review. PubMed PMID:
24284513.'
);
/

INSERT INTO rman_ruleblocks_citation VALUES (
'dm_bmc_ehr_2019',
'Horth RZ, Wagstaff S, Jeppson T, Patel V, McClellan J, Bissonette N,
Friedrichs M, Dunn AC. Use of electronic health records from a statewide health
information exchange to support public health surveillance of diabetes and
hypertension. BMC Public Health. 2019 Aug 14;19(1):1106. doi:
10.1186/s12889-019-7367-z. PubMed PMID: 31412826; PubMed Central PMCID:
PMC6694493.'
);
/


INSERT INTO rman_ruleblocks_citation VALUES (
'dm_rxn',
'^https://mor.nlm.nih.gov/RxClass/'
);
/

INSERT INTO rman_ruleblocks_citation VALUES (
'dm_pcd_2019',
'Van den Bulck SA, Vankrunkelsven P, Goderis G, Broekx L, Dreesen K, Ruijten L,
Mpoukouvalas D, Hermens R. Development of quality indicators for type 2 diabetes,
extractable from the electronic health record of the general physician. A
rand-modified Delphi method. Prim Care Diabetes. 2019 Jun 13. pii:
S1751-9918(19)30108-1. doi: 10.1016/j.pcd.2019.05.002. [Epub ahead of print]
PubMed PMID: 31204263.'
);
/

INSERT INTO rman_ruleblocks_citation VALUES (
'dm_ada_2018',
'American Diabetes Association. Standards of Medical Care in Diabetes-2018
Abridged for Primary Care Providers. Clin Diabetes. 2018 Jan;36(1):14-37. doi:
10.2337/cd17-0119. PubMed PMID: 29382975; PubMed Central PMCID: PMC5775000.'
);
/
INSERT INTO rman_ruleblocks_citation VALUES (
'dm_dmcare_2014',
'Phillips LS, Ratner RE, Buse JB, Kahn SE. We can change the natural history of
type 2 diabetes. Diabetes Care. 2014 Oct;37(10):2668-76. doi: 10.2337/dc14-0817. 
PubMed PMID: 25249668; PubMed Central PMCID: PMC4170125'
);
/

INSERT INTO rman_ruleblocks_citation VALUES (
'dm_dmtech_2019',
'Vigersky RA, McMahon C. The Relationship of Hemoglobin A1C to Time-in-Range in
Patients with Diabetes. Diabetes Technol Ther. 2019 Feb;21(2):81-85. doi:
10.1089/dia.2018.0310. Epub 2018 Dec 21. PubMed PMID: 30575414.'
);
/