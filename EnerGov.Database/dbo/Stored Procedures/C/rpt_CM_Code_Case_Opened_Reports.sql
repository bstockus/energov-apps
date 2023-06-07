﻿

CREATE PROCEDURE [dbo].[rpt_CM_Code_Case_Opened_Reports]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT CMCODECASE.CASENUMBER AS CaseNumber, CMCODECASE.OPENEDDATE AS OpenedDate, CMCASETYPE.NAME AS CaseType, 
       CMCODECASESTATUS.NAME AS CaseStatus, CMCODECASE.CMCODECASEID AS CMCodeCaseID, USERS.FNAME AS FName, USERS.LNAME AS LName,
       CMCODECASE.CLOSEDDATE AS ClosedDate
FROM CMCODECASE 
INNER JOIN CMCASETYPE ON CMCODECASE.CMCASETYPEID = CMCASETYPE.CMCASETYPEID 
INNER JOIN CMCODECASESTATUS ON CMCODECASE.CMCODECASESTATUSID = CMCODECASESTATUS.CMCODECASESTATUSID 
LEFT OUTER JOIN USERS ON CMCODECASE.ASSIGNEDTO = USERS.SUSERGUID
WHERE CMCODECASE.OPENEDDATE BETWEEN @STARTDATE AND @ENDDATE

