﻿CREATE PROCEDURE [common].[USP_PRPROJECTSTATUS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PRPROJECTSTATUS].[PRPROJECTSTATUSID],
	[dbo].[PRPROJECTSTATUS].[NAME]
FROM [dbo].[PRPROJECTSTATUS] 
ORDER BY [dbo].[PRPROJECTSTATUS].[NAME] 
END