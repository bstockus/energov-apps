﻿CREATE PROCEDURE [common].[USP_IMINSPECTIONCASE_GETBYIDS]
(
	@INSPECTIONCASELIST RecordIDs READONLY,
	@USERID AS CHAR(36) = NULL,
	@TYPECHECK AS BIT = false
)
AS
BEGIN

	SELECT 
	[IMINSPECTIONCASE].IMINSPECTIONCASEID,
	[IMINSPECTIONCASE].CASENO,
	[IMINSPECTIONCASE].DESCRIPTION,
	[IMINSPECTIONCASETYPE].NAME AS CASETYPENAME,
	[IMINSPECTIONCASESTATUS].NAME AS CASESTATUSNAME,
	[IMINSPECTIONCASE].STARTDATE,
	[IMINSPECTIONCASE].ENDDATE,
	[IMINSPECTIONCASE].LASTINSPECTIONDATE,
	[IMINSPECTIONCASE].NEXTINSPECTIONDATE,
	[IMINSPECTIONCASE].CREATEDATE,
	[IMINSPECTIONCASE].LINKNUMBER,
	[IMINSPECTIONCASE].LINKID,
	[IMINSPECTIONCASE].IMINSPECTIONLINKID AS LINKTYPEID,
	[IMINSPECTIONLINK].NAME AS LINKNAME,
	(SELECT TOP 1 PRPROJECT.NAME FROM PRPROJECT 
		WHERE [PRPROJECT].PRPROJECTID = [IMINSPECTIONCASE].PRPROJECTID) AS PROJECTNAME,
	[IMINSPECTIONCASE].RECURRENCEID,
	PRIMARYINSPECTOR.INSPECTORFIRSTNAME,
	PRIMARYINSPECTOR.INSPECTORLASTNAME,
	[IMINSPECTIONCASE].ROWVERSION
	FROM [IMINSPECTIONCASE]
	INNER JOIN [IMINSPECTIONCASETYPE] ON [IMINSPECTIONCASE].IMINSPECTIONCASETYPEID = [IMINSPECTIONCASETYPE].IMINSPECTIONCASETYPEID
	INNER JOIN [IMINSPECTIONCASESTATUS] ON [IMINSPECTIONCASESTATUS].IMINSPECTIONCASESTATUSID = [IMINSPECTIONCASE].IMINSPECTIONCASESTATUSID
	LEFT OUTER JOIN [IMINSPECTIONLINK] ON [IMINSPECTIONLINK].IMINSPECTIONLINKID = [IMINSPECTIONCASE].IMINSPECTIONLINKID
	INNER JOIN @INSPECTIONCASELIST INSPECTIONCASELIST ON [IMINSPECTIONCASE].IMINSPECTIONCASEID = INSPECTIONCASELIST.RECORDID
	OUTER APPLY (SELECT TOP 1 [USERS].FNAME INSPECTORFIRSTNAME, [USERS].LNAME AS INSPECTORLASTNAME FROM [IMINSPCASEINSPECTORXREF] 
				INNER JOIN [USERS] ON [IMINSPCASEINSPECTORXREF].USERID = [USERS].SUSERGUID
				WHERE [IMINSPCASEINSPECTORXREF].BPRIMARY = 1 AND 
					  [IMINSPCASEINSPECTORXREF].IMINSPECTIONCASEID = [IMINSPECTIONCASE].IMINSPECTIONCASEID) PRIMARYINSPECTOR
	LEFT JOIN [dbo].[RECENTHISTORYINSPECTIONCASE] ON [dbo].[RECENTHISTORYINSPECTIONCASE].INSPECTIONCASEID = INSPECTIONCASELIST.RECORDID AND
			  [dbo].[RECENTHISTORYINSPECTIONCASE].USERID = @USERID
	LEFT JOIN [dbo].GETUSERVISIBLERECORDTYPES(@USERID) u on ([IMINSPECTIONCASE].IMINSPECTIONCASETYPEID = u.RECORDTYPEID)
	where (@TYPECHECK = 0 OR (RECORDTYPEID IS NOT NULL))
	ORDER BY [dbo].[RECENTHISTORYINSPECTIONCASE].LOGGEDDATETIME DESC
	-- get inspection case addresses
	EXEC [common].[USP_IMINSPECTIONCASEADDRESS_GETBYIDS] @INSPECTIONCASELIST

	-- get inspection case recurrences
	DECLARE @RECURRENCEIDS AS RecordIDs
	INSERT INTO @RECURRENCEIDS
	SELECT DISTINCT RECURRENCEID FROM [IMINSPECTIONCASE] 
	INNER JOIN @INSPECTIONCASELIST INSPECTIONCASELIST ON INSPECTIONCASELIST.RECORDID = [IMINSPECTIONCASE].IMINSPECTIONCASEID

	EXEC [common].[USP_RECURRENCE_GETBYIDS] @RECURRENCEIDS

END