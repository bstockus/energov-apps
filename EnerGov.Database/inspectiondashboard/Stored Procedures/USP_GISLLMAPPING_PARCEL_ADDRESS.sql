﻿CREATE PROCEDURE [inspectiondashboard].[USP_GISLLMAPPING_PARCEL_ADDRESS]
(
	@IS_PARCEL BIT
)
AS

SET NOCOUNT ON;

SELECT TOP 1
	[dbo].[GISLLMAPPING].[COLUMNORPARAMETER],
	[dbo].[GISLLDATASOURCE].[ARCGISLAYER],
	[dbo].[GISLLMAPPINGFIELD].[COLUMNNAME]
FROM [dbo].[GISLLMAPPING]
INNER JOIN [dbo].[GISLLMAPPINGFIELD] ON [dbo].[GISLLMAPPINGFIELD].[GISLLMAPPINGFIELDID] = [dbo].[GISLLMAPPING].[GISLLMAPPINGFIELD]
INNER JOIN [dbo].[GISLLDATASOURCE] ON [dbo].[GISLLDATASOURCE].[GISLLDATASOURCEID] = [dbo].[GISLLMAPPING].[GISLLDATASOURCE]
WHERE 
	[dbo].[GISLLMAPPINGFIELD].[TABLENAME] = CASE @IS_PARCEL WHEN 1 THEN 'PARCEL' ELSE 'PARCELADDRESS' END AND
	CAST(
		CASE @IS_PARCEL 
			WHEN 1 THEN [dbo].[GISLLDATASOURCE].[ISPARCELLAYER] 
			ELSE [dbo].[GISLLDATASOURCE].[ISADDRESSLAYER] 
		END 
	AS BIT) = 1 AND
	[dbo].[GISLLMAPPING].[ISIDENTIFIER] = 1
ORDER BY [dbo].[GISLLMAPPING].[MAPPINGORDER]