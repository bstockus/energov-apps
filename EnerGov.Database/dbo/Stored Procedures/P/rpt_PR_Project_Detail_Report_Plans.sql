﻿

CREATE PROCEDURE [dbo].[rpt_PR_Project_Detail_Report_Plans]
@PROJECTID AS VARCHAR(36)
AS
SELECT     PLPLAN.APPLICATIONDATE, PLPLAN.COMPLETEDATE, PLPLAN.EXPIREDATE, PLPLANWORKCLASS.NAME AS WorkClass, 
                      PLPLANSTATUS.NAME AS Status, PLPLANTYPE.PLANNAME AS PlanType, PLPLAN.PLANNUMBER
FROM         PLPLAN INNER JOIN
                      PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID INNER JOIN
                      PLPLANWORKCLASS ON PLPLAN.PLPLANWORKCLASSID = PLPLANWORKCLASS.PLPLANWORKCLASSID INNER JOIN
                      PLPLANSTATUS ON PLPLAN.PLPLANSTATUSID = PLPLANSTATUS.PLPLANSTATUSID INNER JOIN
                      PRPROJECTPLAN ON PLPLAN.PLPLANID = PRPROJECTPLAN.PLPLANID
WHERE PRPROJECTPLAN.PRPROJECTID = @PROJECTID

