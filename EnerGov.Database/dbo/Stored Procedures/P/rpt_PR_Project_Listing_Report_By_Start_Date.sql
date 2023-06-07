﻿

CREATE PROCEDURE [dbo].[rpt_PR_Project_Listing_Report_By_Start_Date]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT PRPROJECT.NAME AS Project, PRPROJECT.PROJECTNUMBER, PRPROJECT.STARTDATE AS StartDate, PRPROJECT.EXPECTEDENDDATE AS ExpectedEndDate, 
       PRPROJECT.COMPLETEDATE AS CompleteDate, PRPROJECT.DESCRIPTION AS Description, PRPROJECTTYPE.NAME AS ProjectType, 
       PRPROJECTSTATUS.NAME AS ProjectStatus, PRPROJECT.PRPROJECTID
FROM PRPROJECT 
INNER JOIN PRPROJECTTYPE ON PRPROJECT.PRPROJECTTYPEID = PRPROJECTTYPE.PRPROJECTTYPEID 
INNER JOIN PRPROJECTSTATUS ON PRPROJECT.PRPROJECTSTATUSID = PRPROJECTSTATUS.PRPROJECTSTATUSID
WHERE PRPROJECT.STARTDATE BETWEEN @STARTDATE AND @ENDDATE

