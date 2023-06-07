﻿CREATE PROCEDURE [livelink].[USP_GISLLDATASOURCE_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[GISLLDATASOURCE].[GISLLDATASOURCEID],
	[GISLLDATASOURCE].[ISADDRESSLAYER],
	[GISLLDATASOURCE].[ISPARCELLAYER],
	[GISLLDATASOURCE].[ARCGISLAYER],
	[GISLLDATASOURCE].[USELIKEFORGIS]
FROM 
	[dbo].[GISLLDATASOURCE] WITH (NOLOCK)	
END