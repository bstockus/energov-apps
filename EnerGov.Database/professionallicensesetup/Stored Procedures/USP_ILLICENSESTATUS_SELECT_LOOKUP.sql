﻿CREATE PROCEDURE [professionallicensesetup].[USP_ILLICENSESTATUS_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;

	SELECT		[dbo].[ILLICENSESTATUS].[ILLICENSESTATUSID],
				[dbo].[ILLICENSESTATUS].[NAME]
	FROM		[dbo].[ILLICENSESTATUS]
	ORDER BY	[dbo].[ILLICENSESTATUS].[NAME]