﻿CREATE PROCEDURE [dbo].[USP_GISZONEEXTERNALVALUE_INSERT]
(
	@GISZONEEXTERNALVALUEID CHAR(36),
	@GISZONEMAPPINGID CHAR(36),
	@VALUE VARCHAR(250),
	@IMINSPECTIONZONEID CHAR(36)
)
AS

INSERT INTO [dbo].[GISZONEEXTERNALVALUE](
	[GISZONEEXTERNALVALUEID],
	[GISZONEMAPPINGID],
	[VALUE],
	[IMINSPECTIONZONEID]
)

VALUES
(
	@GISZONEEXTERNALVALUEID,
	@GISZONEMAPPINGID,
	@VALUE,
	@IMINSPECTIONZONEID
)