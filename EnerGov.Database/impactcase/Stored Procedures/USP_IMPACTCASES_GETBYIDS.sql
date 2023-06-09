﻿CREATE PROCEDURE [impactcase].[USP_IMPACTCASES_GETBYIDS]
	 @IMPACTCASELIST RecordIDs READONLY,
	 @USERID AS CHAR(36) = NULL
AS
	BEGIN

	SELECT [dbo].IPCASE.IPCASEID, 
	[dbo].IPCASE.CASENUMBER, 
	[dbo].IPCASETYPE.NAME AS CASETYPE, 
	[dbo].IPCASESTATUS.NAME AS CASESTATUS, 
	[dbo].IPCASE.SOURCECASEID,	
	[dbo].IPCASE.SOURCECASENUMBER,
	[dbo].IPCASE.APPROVALDATE,
	[dbo].IPCASE.APPROVALEXPIREDDATE,
	[dbo].IPCASE.ROWVERSION,
	[dbo].DISTRICT.NAME AS DISTRICTNAME,
	[dbo].IPCASE.DESCRIPTION,
	[dbo].IPCASE.CREATEDDATE,
	[dbo].IPCASE.SOURCECASEENTITY
	FROM [dbo].IPCASE
	JOIN [dbo].IPCASETYPE on [dbo].IPCASE.IPCASETYPEID = [dbo].IPCASETYPE.IPCASETYPEID
	JOIN [dbo].IPCASESTATUS on [dbo].IPCASE.IPCASESTATUSID = [dbo].IPCASESTATUS.IPCASESTATUSID
	JOIN [dbo].DISTRICT ON [dbo].IPCASE.DISTRICTID = [dbo].DISTRICT.DISTRICTID
	JOIN @IMPACTCASELIST IMPACTCASELIST ON [dbo].IPCASE.IPCASEID = IMPACTCASELIST.RECORDID
	LEFT JOIN [dbo].RECENTHISTORYIMPACTCASE ON [dbo].RECENTHISTORYIMPACTCASE.IMPACTCASEID = [dbo].IPCASE.IPCASEID AND [dbo].RECENTHISTORYIMPACTCASE.USERID = @USERID
	ORDER BY [dbo].RECENTHISTORYIMPACTCASE.LOGGEDDATETIME DESC

	EXEC [impactcase].[USP_IMPACTCASEADDRESS_GETBYIDS] @IMPACTCASELIST	

	END