﻿CREATE PROCEDURE [gissetupapp].[USP_GISMAPFEATUREXREF_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT		[dbo].[GISMAPFEATUREXREF].[GISMAPFEATUREXREFID],
			[dbo].[GISMAPFEATUREXREF].[GMAPID],
			[dbo].[GISMAPFEATUREXREF].[GISFEATURECLASSID],
			[dbo].[GISFEATURECLASS].[ALIAS]
FROM		[dbo].[GISMAPFEATUREXREF]
	JOIN	[dbo].[GISFEATURECLASS]	ON [dbo].[GISFEATURECLASS].[GISFEATURECLASSID] = [dbo].[GISMAPFEATUREXREF].[GISFEATURECLASSID]
WHERE		[dbo].[GISMAPFEATUREXREF].[GMAPID] =  @PARENTID  

END