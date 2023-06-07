﻿

CREATE PROCEDURE [dbo].[rpt_IM_Incomplete_Inspections_By_Actual_End_Date_Reports]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT     IM.INSPECTIONNUMBER AS InspectionNumber, IM.SCHEDULEDSTARTDATE AS ScheduleStartDate, 
                      IM.SCHEDULEDENDDATE AS ScheduleEndDate, IM.ACTUALSTARTDATE AS ActualStartDate, 
                      IM.ACTUALENDDATE AS ActualEndDate, IMINSPECTIONTYPE.NAME AS InspectionType, IMINSPECTIONSTATUS.STATUSNAME AS InspectionStatus, 
                      USERS.FNAME  + ' ' + USERS.LNAME AS Inspector, IM.LINKNUMBER AS CaseNumber,
                      (	SELECT TOP 1   MAILINGADDRESS.ADDRESSLINE1
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS ADDRESSLINE1,
                      (	SELECT TOP 1   MAILINGADDRESS.ADDRESSLINE2
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS ADDRESSLINE2,
                      (	SELECT TOP 1   MAILINGADDRESS.ADDRESSLINE3
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS ADDRESSLINE3,
                      (	SELECT TOP 1   MAILINGADDRESS.CITY
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS CITY,
                      (	SELECT TOP 1   MAILINGADDRESS.POSTALCODE
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS POSTALCODE,
                      (	SELECT TOP 1   MAILINGADDRESS.POSTDIRECTION
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS POSTDIRECTION,
                      (	SELECT TOP 1   MAILINGADDRESS.PREDIRECTION
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS PREDIRECTION,
                      (	SELECT TOP 1   MAILINGADDRESS.STATE
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS STATE,
                      (	SELECT TOP 1   MAILINGADDRESS.STREETTYPE
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS STREETTYPE,
                      (	SELECT TOP 1   MAILINGADDRESS.UNITORSUITE
						FROM      IMINSPECTIONADDRESS INNER JOIN
										MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
						WHERE	IMINSPECTIONADDRESS.MAIN = 'True' AND IMINSPECTIONADDRESS.IMINSPECTIONID = IM.IMINSPECTIONID) AS UNITORSUITE
FROM IMINSPECTION AS IM 
INNER JOIN IMINSPECTORREF ON IM.IMINSPECTIONID = IMINSPECTORREF.INSPECTIONID 
INNER JOIN USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID 
INNER JOIN IMINSPECTIONTYPE ON IM.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID 
INNER JOIN IMINSPECTIONSTATUS ON IM.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID
WHERE IM.ACTUALENDDATE BETWEEN @STARTDATE AND @ENDDATE 
AND IM.COMPLETE = 'False'


