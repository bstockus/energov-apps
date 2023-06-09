﻿CREATE PROCEDURE [gissetupapp].[USP_GISZONEREVIEWITEMMAPPING_GETALL]
AS
BEGIN

SET NOCOUNT ON;
SELECT 
	[dbo].[GISZONEREVIEWITEMMAPPING].[GISZONEREVIEWITEMMAPPINGID],
	[dbo].[GISZONEREVIEWITEMMAPPING].[SOURCENAME],
	[dbo].[GISZONEREVIEWITEMMAPPING].[ARCGISURL],
	[dbo].[GISZONEREVIEWITEMMAPPING].[ARCGISLAYERNAME],
	[dbo].[GISZONEREVIEWITEMMAPPING].[ARCGISFIELDNAME],
	[dbo].[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDBY],
	[dbo].[GISZONEREVIEWITEMMAPPING].[LASTCHANGEDON],
	[dbo].[GISZONEREVIEWITEMMAPPING].[ROWVERSION]
FROM [dbo].[GISZONEREVIEWITEMMAPPING]
ORDER BY [dbo].[GISZONEREVIEWITEMMAPPING].[SOURCENAME] ASC

EXEC [gissetupapp].[USP_GISZONEREVIEWITEMVALUE_GETALL] 
EXEC [gissetupapp].[USP_GISZONETOREVIEWITEMDESIG_GETALL]

END