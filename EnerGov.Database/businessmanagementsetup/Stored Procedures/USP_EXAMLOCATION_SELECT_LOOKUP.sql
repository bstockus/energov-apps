﻿CREATE PROCEDURE [businessmanagementsetup].[USP_EXAMLOCATION_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[EXAMLOCATION].[EXAMLOCATIONID],
	[dbo].[EXAMLOCATION].[NAME]
FROM [dbo].[EXAMLOCATION]
ORDER BY [dbo].[EXAMLOCATION].[NAME] ASC