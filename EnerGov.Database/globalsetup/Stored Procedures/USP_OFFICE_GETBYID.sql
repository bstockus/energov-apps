﻿CREATE PROCEDURE [globalsetup].[USP_OFFICE_GETBYID]
(
	@OFFICEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[OFFICE].[OFFICEID],
	[dbo].[OFFICE].[NAME],
	[dbo].[OFFICE].[DESCRIPTION],
	[dbo].[OFFICE].[DISTRICTID],
	[dbo].[OFFICE].[PHONE],
	[dbo].[OFFICE].[FAX],
	[dbo].[OFFICE].[TYLERFINANCIALOFFICENAME],
	[dbo].[OFFICE].[LASTCHANGEDBY],
	[dbo].[OFFICE].[LASTCHANGEDON],
	[dbo].[OFFICE].[ROWVERSION],
	[dbo].[OFFICE].[JURISDICTIONID]
FROM [dbo].[OFFICE]
WHERE [dbo].[OFFICE].[OFFICEID] = @OFFICEID  

EXEC [globalsetup].[USP_OFFICE_MAILINGADDRESS_GETBYPARENTID] @OFFICEID
EXEC [globalsetup].[USP_OFFICEHOURS_GETBYPARENTID] @OFFICEID

END