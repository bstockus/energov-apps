﻿CREATE PROCEDURE [gissetupapp].[USP_GEORULEMULTIRETURN_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT		[dbo].[GEORULEMULTIRETURN].[GEORULEMULTIRETURNID],
			[dbo].[GEORULEMULTIRETURN].[NAME]
FROM		[dbo].[GEORULEMULTIRETURN]
ORDER BY	[dbo].[GEORULEMULTIRETURN].[NAME]