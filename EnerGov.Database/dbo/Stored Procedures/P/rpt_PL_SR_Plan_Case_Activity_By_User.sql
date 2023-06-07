﻿

CREATE PROCEDURE [dbo].[rpt_PL_SR_Plan_Case_Activity_By_User]
@STARTDATE DATETIME,
@ENDDATE DATETIME
AS

BEGIN

SELECT HistoryPlanManagement.CHANGEDON, HistoryPlanManagement.FIELDNAME, Users.FNAME, Users.LNAME, PLPlan.PLANNUMBER, PLPlan.PLPLANID, 
       HistoryPlanManagement.OLDVALUE, HistoryPlanManagement.NEWVALUE, HistoryPlanManagement.ADDITIONALINFO, HistoryPlanManagement.FIELDNAME,
--	   (SELECT R.[IMAGE] FROM RPTIMAGELIB R
--		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM PLPLAN 
INNER JOIN HISTORYPLANMANAGEMENT ON PLPLAN.PLPLANID = HISTORYPLANMANAGEMENT.ID
INNER JOIN USERS ON USERS.SUSERGUID = HISTORYPLANMANAGEMENT.CHANGEDBY 
WHERE HISTORYPLANMANAGEMENT.CHANGEDON BETWEEN @STARTDATE AND @ENDDATE
ORDER BY HISTORYPLANMANAGEMENT.CHANGEDON

END
