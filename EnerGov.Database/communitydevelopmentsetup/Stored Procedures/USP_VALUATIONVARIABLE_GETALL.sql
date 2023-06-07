﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_VALUATIONVARIABLE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[VALUATIONVARIABLE].[VALUATIONVARIABLEID],
	[dbo].[VALUATIONVARIABLE].[VALUATIONTYPEID],
	[dbo].[VALUATIONVARIABLE].[VALUATIONGROUPID],
	[dbo].[VALUATIONVARIABLE].[VARIABLE],
	[dbo].[VALUATIONVARIABLE].[DESCRIPTION],
	[dbo].[VALUATIONVARIABLE].[LASTCHANGEDBY],
	[dbo].[VALUATIONVARIABLE].[LASTCHANGEDON],
	[dbo].[VALUATIONVARIABLE].[ROWVERSION]
FROM [dbo].[VALUATIONVARIABLE] ORDER BY [dbo].[VALUATIONVARIABLE].[VARIABLE]
END