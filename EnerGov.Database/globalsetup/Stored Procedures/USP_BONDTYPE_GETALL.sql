﻿CREATE PROCEDURE [globalsetup].[USP_BONDTYPE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[BONDTYPE].[BONDTYPEID],
	[dbo].[BONDTYPE].[NAME],
	[dbo].[BONDTYPE].[DESCRIPTION],
	[dbo].[BONDTYPE].[DEFAULTAMOUNT],
	[dbo].[BONDTYPE].[HASTRANSACTION],
	[dbo].[BONDTYPE].[DEFAULTSTATUSID],
	[dbo].[BONDTYPE].[PREFIX],
	[dbo].[BONDTYPE].[DAYSTOEXPIRE],
	[dbo].[BONDTYPE].[ACTIVE],
	[dbo].[BONDTYPE].[AUTONUMBER],
	[dbo].[BONDTYPE].[ISUSERELEASEINTEREST],
	[dbo].[BONDTYPE].[DAYSPRIORTOACCRUAL],
	[dbo].[BONDTYPE].[BONDINTERESTSCHEDULEID],
	[dbo].[BONDTYPE].[LASTCHANGEDBY],
	[dbo].[BONDTYPE].[LASTCHANGEDON],
	[dbo].[BONDTYPE].[ROWVERSION]
FROM [dbo].[BONDTYPE]
ORDER BY
	[dbo].[BONDTYPE].[NAME] ASC
END