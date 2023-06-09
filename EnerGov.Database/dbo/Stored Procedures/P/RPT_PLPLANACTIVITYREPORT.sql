﻿



CREATE PROCEDURE [dbo].[RPT_PLPLANACTIVITYREPORT]
@PLANID AS VARCHAR(36)
AS
SELECT     USERS.FNAME, USERS.LNAME, PLPLANACTIVITY.PLPLANACTIVITYID, PLPLANACTIVITY.PLANACTIVITYNAME, PLPLANACTIVITY.PLANACTIVITYNUMBER, 
                      PLPLANACTIVITY.PLANACTIVITYCOMMENTS, PLPLANACTIVITY.CREATEDON, PLPLANACTIVITYTYPE.NAME AS ACTIVITYTYPE, PLPLAN.PLANNUMBER
FROM         PLPLANACTIVITY INNER JOIN
                      PLPLAN ON PLPLANACTIVITY.PLPLANID = PLPLAN.PLPLANID INNER JOIN
                      PLPLANACTIVITYTYPE ON PLPLANACTIVITY.PLPLANACTIVITYTYPEID = PLPLANACTIVITYTYPE.PLPLANACTIVITYTYPEID INNER JOIN
                      USERS ON PLPLANACTIVITY.SUSERGUID = USERS.SUSERGUID
WHERE     (PLPLAN.PLPLANID = @PLANID)



