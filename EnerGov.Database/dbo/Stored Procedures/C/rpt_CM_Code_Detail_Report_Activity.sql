﻿


CREATE PROCEDURE [dbo].[rpt_CM_Code_Detail_Report_Activity]
@CODECASEID AS VARCHAR(36)
AS
SELECT CMCODEACTIVITY.CMCODEACTIVITYID, CMCODEACTIVITY.CODEACTIVITYNAME, CMCODEACTIVITY.CODEACTIVITYNUMBER, CMCODEACTIVITYTYPE.NAME AS ACTIVITYTYPE, 
       USERS.FNAME, USERS.LNAME, CMCODEACTIVITY.CREATEDON
FROM CMCODEACTIVITY 
INNER JOIN CMCODEACTIVITYTYPE ON CMCODEACTIVITY.CMCODEACTIVITYTYPEID = CMCODEACTIVITYTYPE.CMCODEACTIVITYTYPEID
INNER JOIN USERS ON CMCODEACTIVITY.SUSERGUID = USERS.SUSERGUID 
WHERE CMCODEACTIVITY.CMCODECASEID = @CODECASEID


