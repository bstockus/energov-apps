﻿CREATE PROCEDURE [systemsetup].[USP_MODULERECORDTYPE_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT		[dbo].[MODULERECORDTYPE].[MODULERECORDTYPEID],
			[dbo].[MODULERECORDTYPE].[NAME]
FROM		[dbo].[MODULERECORDTYPE]
ORDER BY	[dbo].[MODULERECORDTYPE].[NAME] ASC