﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCODECASESTATUS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CMCODECASESTATUS].[CMCODECASESTATUSID],
	[dbo].[CMCODECASESTATUS].[NAME]	
FROM [dbo].[CMCODECASESTATUS]
ORDER BY [dbo].[CMCODECASESTATUS].[NAME] ASC
END