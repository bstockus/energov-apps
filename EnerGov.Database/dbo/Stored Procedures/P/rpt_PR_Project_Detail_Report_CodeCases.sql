﻿


CREATE PROCEDURE [dbo].[rpt_PR_Project_Detail_Report_CodeCases]
@PROJECTID AS VARCHAR(36)
AS
SELECT     CMCODECASE.CASENUMBER, CMCODECASE.OPENEDDATE, CMCODECASE.CLOSEDDATE, CMCASETYPE.NAME AS CaseType, 
                      CMCODECASESTATUS.NAME AS caseStatus, USERS.FNAME, USERS.LNAME
FROM         CMCASETYPE INNER JOIN
                      CMCODECASE ON CMCASETYPE.CMCASETYPEID = CMCODECASE.CMCASETYPEID INNER JOIN
                      CMCODECASESTATUS ON CMCODECASE.CMCODECASESTATUSID = CMCODECASESTATUS.CMCODECASESTATUSID INNER JOIN
                      PRPROJECTCODECASE ON CMCODECASE.CMCODECASEID = PRPROJECTCODECASE.CMCODECASEID LEFT OUTER JOIN
                      USERS ON CMCODECASE.ASSIGNEDTO = USERS.SUSERGUID
WHERE PRPROJECTCODECASE.PRPROJECTID = @PROJECTID


