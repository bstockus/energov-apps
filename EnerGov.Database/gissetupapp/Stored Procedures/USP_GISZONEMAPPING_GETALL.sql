﻿CREATE PROCEDURE [gissetupapp].[USP_GISZONEMAPPING_GETALL]
AS
BEGIN

SET NOCOUNT ON;
SELECT 
	[dbo].[GISZONEMAPPING].[GISZONEMAPPINGID],
	[dbo].[GISZONEMAPPING].[SOURCENAME],
	[dbo].[GISZONEMAPPING].[ARCGISURL],
	[dbo].[GISZONEMAPPING].[ARCGISLAYERNAME],
	[dbo].[GISZONEMAPPING].[ARCGISFIELDNAME],
	[dbo].[GISZONEMAPPING].[LASTCHANGEDBY],
	[dbo].[GISZONEMAPPING].[LASTCHANGEDON],
	[dbo].[GISZONEMAPPING].[ROWVERSION]
FROM [dbo].[GISZONEMAPPING]
ORDER BY [dbo].[GISZONEMAPPING].[SOURCENAME] ASC	

EXEC [gissetupapp].[USP_GISZONEEXTERNALVALUE_GETALL] 
EXEC [gissetupapp].[USP_GISZONETOINSPECTORDESIG_GETALL]

END