﻿CREATE PROCEDURE [businesslicensesetup].[USP_BLLICENSESTATUS_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;

	SELECT		[dbo].[BLLICENSESTATUS].[BLLICENSESTATUSID],
				[dbo].[BLLICENSESTATUS].[NAME]
	FROM		[dbo].[BLLICENSESTATUS]
	ORDER BY	[dbo].[BLLICENSESTATUS].[NAME]