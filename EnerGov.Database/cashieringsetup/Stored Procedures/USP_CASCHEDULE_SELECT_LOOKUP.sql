﻿CREATE PROCEDURE [cashieringsetup].[USP_CASCHEDULE_SELECT_LOOKUP]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT		[dbo].[CASCHEDULE].[CASCHEDULEID],
				[dbo].[CASCHEDULE].[NAME]
	FROM		[dbo].[CASCHEDULE]
	ORDER BY	[dbo].[CASCHEDULE].[NAME]
END