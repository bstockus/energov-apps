﻿
CREATE PROCEDURE [dbo].[rpt_IM_SR_Year_Over_Year_Inspection_Report]
@YEAR AS INT
AS
BEGIN
SELECT IMINSPECTIONTYPE.NAME AS InspectionType, IMINSPECTION.INSPECTIONNUMBER AS InspectionNumber, 
       IMINSPECTION.SCHEDULEDSTARTDATE AS ScheduledStartDate, IMINSPECTION.SCHEDULEDENDDATE AS ScheduledEndDate, 
       IMINSPECTION.ACTUALSTARTDATE AS ActualStartDate, IMINSPECTION.ACTUALENDDATE AS ActualEndDate,
	   --(SELECT R.[IMAGE] FROM RPTIMAGELIB R
	   -- WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM IMINSPECTION 
INNER JOIN IMINSPECTIONTYPE ON IMINSPECTION.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID

END