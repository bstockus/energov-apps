﻿CREATE PROCEDURE [businessmanagementsetup].[USP_ILLICENSESTATUSSYSTEM_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[ILLICENSESTATUSSYSTEM].[ILLICENSESTATUSSYSTEMID],
		[dbo].[ILLICENSESTATUSSYSTEM].[NAME]
	FROM [dbo].[ILLICENSESTATUSSYSTEM]
	ORDER BY [dbo].[ILLICENSESTATUSSYSTEM].[NAME] ASC