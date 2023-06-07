﻿CREATE PROCEDURE [common].[USP_BLLICENSESTATUSSYSTEM_SELECT_LOOKUP]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT		[dbo].[BLLICENSESTATUSSYSTEM].[BLLICENSESTATUSSYSTEMID],
				[dbo].[BLLICENSESTATUSSYSTEM].[NAME]
	FROM		[dbo].[BLLICENSESTATUSSYSTEM]
	ORDER BY	[dbo].[BLLICENSESTATUSSYSTEM].[NAME]
END