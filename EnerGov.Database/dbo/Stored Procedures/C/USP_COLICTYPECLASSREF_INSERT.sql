﻿CREATE PROCEDURE [dbo].[USP_COLICTYPECLASSREF_INSERT]
(
	@COLICTYPEID CHAR(36),
	@CLASSIFICATIONID CHAR(36)
)
AS

INSERT INTO [dbo].[COLICTYPECLASSREF](
	[COLICTYPEID],
	[CLASSIFICATIONID]
)

VALUES
(
	@COLICTYPEID,
	@CLASSIFICATIONID
)