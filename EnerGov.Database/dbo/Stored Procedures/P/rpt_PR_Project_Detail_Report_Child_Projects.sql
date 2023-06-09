﻿

CREATE PROCEDURE [dbo].[rpt_PR_Project_Detail_Report_Child_Projects]
@PROJECTID AS VARCHAR(36)
AS
SELECT     PRPROJECT.NAME AS ProjectName, PRPROJECT.PROJECTNUMBER AS ProjectNumber, PRPROJECTSTATUS.NAME AS Status, 
                      PRPROJECTTYPE.NAME AS ProjectType, PRPROJECT.STARTDATE, PRPROJECT.EXPECTEDENDDATE
FROM         PRPROJECT INNER JOIN
                      PRPROJECTTYPE ON PRPROJECT.PRPROJECTTYPEID = PRPROJECTTYPE.PRPROJECTTYPEID INNER JOIN
                      PRPROJECTSTATUS ON PRPROJECT.PRPROJECTSTATUSID = PRPROJECTSTATUS.PRPROJECTSTATUSID
WHERE PRPROJECT.PRPROJECTPARENTID = @PROJECTID

