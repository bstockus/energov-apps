﻿CREATE PROCEDURE [systemsetup].[USP_FTPSETUP_GETALL]
AS
BEGIN
SET NOCOUNT ON;
	SELECT 
		[dbo].[FTPSETUP].[FTPSETUPID],
		[dbo].[FTPSETUP].[NAME],	
		[dbo].[FTPSETUP].[DESCRIPTION],
		[dbo].[FTPSETUP].[URL],
		[dbo].[FTPSETUP].[USERNAME],
		[dbo].[FTPSETUP].[PASSWORD],
		[dbo].[FTPSETUP].[FTPTYPEID],
		[dbo].[FTPSETUP].[PORT],
		[dbo].[FTPSETUP].[LASTCHANGEDBY],
		[dbo].[FTPSETUP].[LASTCHANGEDON],
		[dbo].[FTPSETUP].[ROWVERSION]
	FROM [dbo].[FTPSETUP] 
	ORDER BY [dbo].[FTPSETUP].[NAME] ASC
END