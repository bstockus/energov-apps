﻿CREATE PROCEDURE [common].[USP_CMCODECASESTATUS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CMCODECASESTATUS].[CMCODECASESTATUSID],
	[dbo].[CMCODECASESTATUS].[NAME],
	[dbo].[CMCODECASESTATUS].[SUCCESSFLAG],
	[dbo].[CMCODECASESTATUS].[FAILUREFLAG]
FROM [dbo].[CMCODECASESTATUS] 
ORDER BY [dbo].[CMCODECASESTATUS].[NAME] 
END