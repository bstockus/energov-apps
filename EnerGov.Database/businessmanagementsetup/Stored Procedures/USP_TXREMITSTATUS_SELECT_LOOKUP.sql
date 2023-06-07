﻿CREATE PROCEDURE [businessmanagementsetup].[USP_TXREMITSTATUS_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[TXREMITSTATUS].[TXREMITSTATUSID],
	[dbo].[TXREMITSTATUS].[NAME]
FROM [dbo].[TXREMITSTATUS]
ORDER BY [dbo].[TXREMITSTATUS].[NAME] ASC