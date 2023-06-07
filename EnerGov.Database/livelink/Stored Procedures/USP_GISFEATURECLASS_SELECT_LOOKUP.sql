﻿CREATE PROCEDURE [livelink].[USP_GISFEATURECLASS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
	SELECT 
		[GISFEATURECLASS].[GISFEATURECLASSID],
		[GISFEATURECLASS].[ATTRIBUTEFIELD],
		[GISFEATURECLASS].[LAYERNUMBER],
		[GISFEATURECLASS].[LAYERNAME],
		[GISFEATURECLASS].[ALIAS],
		[GISFEATURECLASS].[LAYERURL]
	FROM [dbo].[GISFEATURECLASS] WITH (NOLOCK)
	
END