﻿CREATE PROCEDURE [livelink].[USP_GISLLMAPPING_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[GISLLMAPPING].[GISLLMAPPINGID],
	[GISLLMAPPING].[GISLLDATASOURCE],
	[GISLLMAPPING].[COLUMNORPARAMETER],
	[GISLLMAPPING].[DEFAULTVALUE],
	[GISLLMAPPING].[ISIDENTIFIER],
	[GISLLMAPPING].[USELIKEFORGIS],
	[GISLLMAPPING].[MAPPINGORDER],
	[GISLLMAPPING].[DELIMITER],
	[GISLLMAPPING].[RELATIONSHIP],
	[GISLLMAPPINGFIELD].[TABLENAME],
	[GISLLMAPPINGFIELD].[COLUMNNAME]
FROM 
	[dbo].[GISLLMAPPING] WITH (NOLOCK) 	
	INNER JOIN [dbo].[GISLLMAPPINGFIELD] WITH (NOLOCK) ON  [GISLLMAPPING].[GISLLMAPPINGFIELD]=[GISLLMAPPINGFIELD].[GISLLMAPPINGFIELDID] 
END