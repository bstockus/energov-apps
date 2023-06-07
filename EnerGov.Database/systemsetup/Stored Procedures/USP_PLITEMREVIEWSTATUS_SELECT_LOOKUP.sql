﻿CREATE PROCEDURE [systemsetup].[USP_PLITEMREVIEWSTATUS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PLITEMREVIEWSTATUS].[PLITEMREVIEWSTATUSID],
	[dbo].[PLITEMREVIEWSTATUS].[NAME]
FROM 
	[dbo].[PLITEMREVIEWSTATUS]
ORDER BY 
	[dbo].[PLITEMREVIEWSTATUS].[NAME]
END