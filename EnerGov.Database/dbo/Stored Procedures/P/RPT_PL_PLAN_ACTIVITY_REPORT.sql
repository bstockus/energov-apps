﻿


CREATE PROCEDURE [dbo].[RPT_PL_PLAN_ACTIVITY_REPORT]
@PLANID AS VARCHAR(36)
AS
SELECT USERS.FNAME, USERS.LNAME, PLPLANACTIVITY.PLPLANACTIVITYID, PLPLANACTIVITY.PLANACTIVITYNAME, PLPLANACTIVITY.PLANACTIVITYNUMBER, 
       PLPLANACTIVITY.PLANACTIVITYCOMMENTS, PLPLANACTIVITY.CREATEDON, PLPLANACTIVITYTYPE.NAME AS ACTIVITYTYPE, PLPLAN.PLANNUMBER,
       CONVERT(DATETIME,PLPLANACTIVITY.CREATEDON) AS CreateDate
FROM PLPLANACTIVITY 
INNER JOIN PLPLAN ON PLPLANACTIVITY.PLPLANID = PLPLAN.PLPLANID 
INNER JOIN PLPLANACTIVITYTYPE ON PLPLANACTIVITY.PLPLANACTIVITYTYPEID = PLPLANACTIVITYTYPE.PLPLANACTIVITYTYPEID 
INNER JOIN USERS ON PLPLANACTIVITY.SUSERGUID = USERS.SUSERGUID
WHERE (PLPLAN.PLPLANID = @PLANID)

