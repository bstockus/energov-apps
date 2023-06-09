﻿CREATE PROCEDURE [gissetupapp].[USP_PLSUBMITTALTYPE_PLITEMREVIEWTYPE_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT	DISTINCT [dbo].[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID],
			[dbo].[PLSUBMITTALTYPE].[TYPENAME]
FROM		[dbo].[PLSUBMITTALTYPE]
INNER JOIN	[dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX] 
ON			[dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PLSUBMITTALTYPEID] = [dbo].[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID]
WHERE		[dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[AUTOADD] != 1
ORDER BY	[dbo].[PLSUBMITTALTYPE].[TYPENAME]

EXEC [gissetupapp].[USP_PLITEMREVIEWTYPE_SELECT_LOOKUP]