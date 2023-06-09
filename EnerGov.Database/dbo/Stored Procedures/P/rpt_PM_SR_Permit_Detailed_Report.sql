﻿

CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Detailed_Report]
@PMPERMITID AS VARCHAR(36)
AS

SELECT PMPERMIT.PERMITNUMBER, PMPERMIT.APPLYDATE, PMPERMIT.EXPIREDATE, PMPERMIT.ISSUEDATE, PMPERMIT.FINALIZEDATE, PMPERMIT.VALUE, PMPERMIT.SQUAREFEET, 
PMPERMIT.DESCRIPTION, PMPERMITSTATUS.NAME AS STATUS, PMPERMITTYPE.NAME AS PERMITTYPE, DISTRICT.NAME AS DISTRICT, PMPERMITWORKCLASS.NAME AS WORKCLASS, 
PMPERMIT.PMPERMITID, PRPROJECT.NAME AS PROJECT,
(SELECT R.[IMAGE] FROM RPTIMAGELIB R	WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM PMPERMIT 
INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID 
INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID 
INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID 
LEFT OUTER JOIN DISTRICT ON PMPERMIT.DISTRICTID = DISTRICT.DISTRICTID
LEFT OUTER JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID 
LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPERMIT.PRPROJECTID
WHERE PMPERMIT.PMPERMITID = @PMPERMITID

