﻿CREATE PROCEDURE [systemsetup].[USP_GISMAPLAYER_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[GISMAPLAYER].[GISMAPLAYERID],
	[dbo].[GISMAPLAYER].[NAME]
FROM [dbo].[GISMAPLAYER]
ORDER BY 
	[dbo].[GISMAPLAYER].[NAME] ASC