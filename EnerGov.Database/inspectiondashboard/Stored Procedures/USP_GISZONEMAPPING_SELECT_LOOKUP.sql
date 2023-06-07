﻿CREATE PROCEDURE [inspectiondashboard].[USP_GISZONEMAPPING_SELECT_LOOKUP]
	@ID CHAR(36)
AS

SET NOCOUNT ON;

SELECT 
	[dbo].[GISZONEMAPPING].[GISZONEMAPPINGID], 
	[dbo].[GISZONEMAPPING].[SOURCENAME], 
	[dbo].[GISZONEMAPPING].[ARCGISURL], 
	[dbo].[GISZONEMAPPING].[ARCGISLAYERNAME], 
	[dbo].[GISZONEMAPPING].[ARCGISFIELDNAME]
FROM [dbo].[GISZONEMAPPING]
WHERE [dbo].[GISZONEMAPPING].[GISZONEMAPPINGID] = @ID