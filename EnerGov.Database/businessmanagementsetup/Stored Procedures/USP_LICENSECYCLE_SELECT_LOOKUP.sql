﻿CREATE PROCEDURE [businessmanagementsetup].[USP_LICENSECYCLE_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[LICENSECYCLE].[LICENSECYCLEID],
	[dbo].[LICENSECYCLE].[NAME]
FROM [dbo].[LICENSECYCLE]
ORDER BY [dbo].[LICENSECYCLE].[NAME]