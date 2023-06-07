﻿
CREATE PROCEDURE [dbo].[rpt_PL_SR_Plan_Monthly_Listing_Chart]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@FILTER AS VARCHAR(150)
AS


SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT PLPLAN.APPLICATIONDATE, PLPLAN.COMPLETEDATE, PLPLAN.EXPIREDATE, PLPLANTYPE.PLANNAME, PLPLAN.PLPLANID,
--	   (SELECT R.[IMAGE] FROM RPTIMAGELIB R
--		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM   PLPLAN 
INNER JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID

WHERE (CASE @FILTER 
	WHEN 'EXPIRE DATE' THEN PLPLAN.EXPIREDATE
	WHEN 'APPLY DATE' THEN PLPLAN.APPLICATIONDATE
	WHEN 'COMPLETE DATE' THEN PLPLAN.COMPLETEDATE END)
	BETWEEN @STARTDATE AND @ENDDATE


