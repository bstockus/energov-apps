﻿CREATE PROCEDURE [common].[USP_ILLICENSEGROUP_SELECT_LOOKUP]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT		[dbo].[ILLICENSEGROUP].[ILLICENSEGROUPID],
				[dbo].[ILLICENSEGROUP].[NAME]
	FROM		[dbo].[ILLICENSEGROUP]
	ORDER BY	[dbo].[ILLICENSEGROUP].[NAME]
END