﻿


CREATE PROCEDURE [dbo].[rpt_CM_Code_Detail_Report]
@CODECASEID AS VARCHAR(36)
AS

SELECT CMCODECASE.CMCODECASEID, CMCODECASE.CASENUMBER, CMCASETYPE.NAME AS CASETYPE, CMCODECASESTATUS.NAME AS STATUS, 
       CMCODECASE.OPENEDDATE, CMCODECASE.CLOSEDDATE, CMCODECASE.DESCRIPTION, DISTRICT.NAME AS DISTRICT, PRPROJECT.NAME AS PROJECT, 
       USERS.FNAME, USERS.LNAME,CMCODE.CODENUMBER, CMCODE.DESCRIPTION AS CodeDescription,
       CMVIOLATION.CMVIOLATIONID,CMVIOLATION.COMPLIANCEDATE,CMVIOLATION.RESOLVEDDATE,CMVIOLATION.CMCODEID,CMVIOLATION.CITATIONISSUEDATE, CMVIOLATION.CORRECTIVEACTION,
       IMINSPECTION.IMINSPECTIONSTATUSID, COALESCE(IMINSPECTION.ACTUALENDDATE, IMINSPECTION.SCHEDULEDENDDATE) AS INSPECTIONDATE,
       IMINSPECTIONSTATUS.STATUSNAME,IMINSPECTIONCHECKLISTXREF.COMMENTS
FROM  CMCODECASE 
INNER JOIN CMCASETYPE ON CMCODECASE.CMCASETYPEID = CMCASETYPE.CMCASETYPEID
INNER JOIN CMCODECASESTATUS ON CMCODECASE.CMCODECASESTATUSID = CMCODECASESTATUS.CMCODECASESTATUSID
LEFT OUTER JOIN USERS ON  USERS.SUSERGUID = CMCODECASE.ASSIGNEDTO
LEFT OUTER JOIN DISTRICT ON CMCODECASE.DISTRICTID = DISTRICT.DISTRICTID
LEFT OUTER JOIN PRPROJECTCODECASE ON PRPROJECTCODECASE.CMCODECASEID = CMCODECASE.CMCODECASEID
LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTCODECASE.PRPROJECTID
LEFT OUTER JOIN CMCODEWFSTEP ON CMCODECASE.CMCODECASEID = CMCODEWFSTEP.CMCODECASEID
LEFT OUTER JOIN CMCODEWFACTIONSTEP ON CMCODEWFSTEP.CMCODEWFSTEPID = CMCODEWFACTIONSTEP.CMCODEWFSTEPID
LEFT OUTER JOIN CMVIOLATION ON CMVIOLATION.CMCODEWFACTIONID = CMCODEWFACTIONSTEP.CMCODEWFACTIONSTEPID
LEFT OUTER JOIN IMINSPECTION ON CMCODECASE.CASENUMBER = IMINSPECTION.LINKNUMBER
LEFT OUTER JOIN IMINSPECTIONCHECKLISTXREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONCHECKLISTXREF.IMINSPECTIONID
LEFT OUTER JOIN IMINSPECTIONSTATUS ON IMINSPECTION.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID
LEFT OUTER JOIN CMCODE ON CMCODEWFACTIONSTEP.CMCODEID = CMCODE.CMCODEID
WHERE CMCODECASE.CMCODECASEID = @CODECASEID 

