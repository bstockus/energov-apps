﻿

CREATE PROCEDURE [dbo].[rpt_CM_SR_Code_Case_Detailed_Report]
@CMCODECASEID AS VARCHAR(36)
AS

SELECT CMCODECASE.CMCODECASEID, CMCODECASE.CASENUMBER, CMCASETYPE.NAME AS CASETYPE, CMCODECASESTATUS.NAME AS STATUS, 
       CMCODECASE.OPENEDDATE, CMCODECASE.CLOSEDDATE, CMCODECASE.DESCRIPTION, DISTRICT.NAME AS DISTRICT, PRPROJECT.NAME AS PROJECT, 
       USERS.FNAME, USERS.LNAME,
	   (SELECT R.[IMAGE] FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
       
FROM  CMCODECASE 
INNER JOIN CMCASETYPE ON CMCODECASE.CMCASETYPEID = CMCASETYPE.CMCASETYPEID
INNER JOIN CMCODECASESTATUS ON CMCODECASE.CMCODECASESTATUSID = CMCODECASESTATUS.CMCODECASESTATUSID
INNER JOIN DISTRICT ON CMCODECASE.DISTRICTID = DISTRICT.DISTRICTID
LEFT OUTER JOIN USERS ON  USERS.SUSERGUID = CMCODECASE.ASSIGNEDTO
LEFT OUTER JOIN PRPROJECTCODECASE ON PRPROJECTCODECASE.CMCODECASEID = CMCODECASE.CMCODECASEID
LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTCODECASE.PRPROJECTID
WHERE CMCODECASE.CMCODECASEID = @CMCODECASEID
