﻿CREATE PROCEDURE [dbo].[USP_GISMAPFEATUREXREF_INSERT]
(
	@GISMAPFEATUREXREFID CHAR(36),
	@GMAPID CHAR(36),
	@GISFEATURECLASSID CHAR(36)
)
AS

INSERT INTO [dbo].[GISMAPFEATUREXREF](
	[GISMAPFEATUREXREFID],
	[GMAPID],
	[GISFEATURECLASSID]
)

VALUES
(
	@GISMAPFEATUREXREFID,
	@GMAPID,
	@GISFEATURECLASSID
)