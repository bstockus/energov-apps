﻿CREATE PROCEDURE [gissetup].[USP_GEORULEENTITY_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[GEORULEENTITY].[GEORULEENTITYID],
	[dbo].[GEORULEENTITY].[GEORYLEENTITYFRIENDLYNAME],
	[dbo].[GEORULEENTITY].[GEORULEENTITYCLASS]
FROM 
	[dbo].[GEORULEENTITY]
ORDER BY 
	[dbo].[GEORULEENTITY].[GEORYLEENTITYFRIENDLYNAME]
END