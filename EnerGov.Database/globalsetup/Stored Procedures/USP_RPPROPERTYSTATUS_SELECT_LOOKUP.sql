﻿CREATE PROCEDURE [globalsetup].[USP_RPPROPERTYSTATUS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[RPPROPERTYSTATUSID],
	[NAME]	
FROM [dbo].[RPPROPERTYSTATUS]
ORDER BY [dbo].[RPPROPERTYSTATUS].[NAME]
END