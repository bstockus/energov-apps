﻿
CREATE PROCEDURE rpt_IL_SR_Professional_License_History_Report
@ILLICENSEID AS VARCHAR(36)
AS

SELECT IL.ILLICENSEID,
	IL.LICENSENUMBER,
	H.[ROWVERSION],
	H.CHANGEDON,
	H.FIELDNAME,
	H.OLDVALUE,
	H.NEWVALUE,
	H.ADDITIONALINFO,
	U.FNAME + ' ' + U.LNAME CHANGEDBY,
	(SELECT R.[IMAGE] FROM RPTIMAGELIB R	WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM ILLICENSE IL
INNER JOIN HISTORYINDLICENSE H ON IL.ILLICENSEID = H.ID
INNER JOIN USERS U ON H.CHANGEDBY = U.SUSERGUID
WHERE IL.ILLICENSEID = @ILLICENSEID

