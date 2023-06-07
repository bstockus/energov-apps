﻿CREATE PROCEDURE [businessmanagementsetup].[USP_TXREMITSTATUS_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[TXREMITSTATUS].[TXREMITSTATUSID],
	[dbo].[TXREMITSTATUS].[NAME],
	[dbo].[TXREMITSTATUS].[DESCRIPTION],
	[dbo].[TXREMITSTATUS].[TXREMITSTATUSSYSTEMID],
	[dbo].[TXREMITSTATUS].[LASTCHANGEDBY],
	[dbo].[TXREMITSTATUS].[LASTCHANGEDON],
	[dbo].[TXREMITSTATUS].[ROWVERSION]
FROM [dbo].[TXREMITSTATUS]
 ORDER BY [dbo].[TXREMITSTATUS].[NAME] ASC

END