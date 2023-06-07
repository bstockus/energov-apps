﻿
CREATE PROCEDURE rpt_BL_SR_Business_License_History_Report
@BLLICENSEID AS VARCHAR(36)
AS

SELECT BL.BLLICENSEID,
	BL.LICENSENUMBER,
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
FROM BLLICENSE BL
INNER JOIN HISTORYLICENSEMANAGEMENT H ON BL.BLLICENSEID = H.ID
INNER JOIN USERS U ON H.CHANGEDBY = U.SUSERGUID
WHERE BL.BLLICENSEID = @BLLICENSEID
