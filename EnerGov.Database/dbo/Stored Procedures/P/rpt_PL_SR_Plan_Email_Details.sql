﻿
CREATE PROCEDURE rpt_PL_SR_Plan_Email_Details
	@PLPLANID AS VARCHAR(36)
AS

BEGIN

SELECT P.PLPLANID, P.PLANNUMBER
	, E.ID, E.EMAILFROM, E.EMAILTO, E.CC, E.BCC, E.[SUBJECT], E.BODY, E.DATESENT,
	(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM PLPLAN P
left JOIN EMAILQUEUE E ON P.PLPLANID = E.UNIQUERECORDID
WHERE P.PLPLANID = @PLPLANID

END
