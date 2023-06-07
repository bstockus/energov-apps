﻿CREATE PROCEDURE [gissetupapp].[USP_GISLLMAPPING_GETALL]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT		[dbo].[GISLLMAPPING].[GISLLMAPPINGID],
				[dbo].[GISLLMAPPING].[GISLLMAPPINGFIELD],
				[dbo].[GISLLMAPPING].[GISLLDATASOURCE],
				[dbo].[GISLLMAPPING].[ISIDENTIFIER],
				[dbo].[GISLLMAPPING].[COLUMNORPARAMETER],
				[dbo].[GISLLMAPPING].[MAPPINGORDER],
				[dbo].[GISLLMAPPING].[DELIMITER],
				[dbo].[GISLLMAPPING].[DEFAULTVALUE],
				[dbo].[GISLLMAPPING].[USELIKEFORGIS],
				[dbo].[GISLLMAPPING].[RELATIONSHIP],
				[dbo].[GISLLMAPPINGFIELD].[COLUMNNAME]
	FROM		[dbo].[GISLLMAPPING]
				JOIN [dbo].[GISLLDATASOURCE] ON [dbo].[GISLLDATASOURCE].[GISLLDATASOURCEID] = [dbo].[GISLLMAPPING].[GISLLDATASOURCE]
				JOIN [dbo].[GISLLMAPPINGFIELD] ON [dbo].[GISLLMAPPINGFIELD].[GISLLMAPPINGFIELDID] = [dbo].[GISLLMAPPING].[GISLLMAPPINGFIELD]
	WHERE		([dbo].[GISLLDATASOURCE].[ISPARCELLAYER] = 1
					AND [dbo].[GISLLDATASOURCE].[ISADDRESSLAYER] <> 1
					AND [dbo].[GISLLDATASOURCE].[ISADDRESSLAYER] IS NOT NULL)
				OR ([dbo].[GISLLDATASOURCE].[ISADDRESSLAYER] = 1
					AND [dbo].[GISLLDATASOURCE].[ISPARCELLAYER] <> 1
					AND [dbo].[GISLLDATASOURCE].[ISPARCELLAYER] IS NOT NULL)
	ORDER BY	[dbo].[GISLLDATASOURCE].[ARCGISLAYER], [dbo].[GISLLMAPPINGFIELD].[COLUMNNAME]
END