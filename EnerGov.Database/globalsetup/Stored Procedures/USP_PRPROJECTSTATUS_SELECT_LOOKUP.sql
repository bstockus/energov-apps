﻿CREATE PROCEDURE [globalsetup].[USP_PRPROJECTSTATUS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[PRPROJECTSTATUSID],
	[NAME]	
FROM [dbo].[PRPROJECTSTATUS]
ORDER BY [dbo].[PRPROJECTSTATUS].[NAME]
END