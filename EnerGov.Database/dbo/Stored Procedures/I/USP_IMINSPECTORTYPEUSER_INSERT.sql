﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTORTYPEUSER_INSERT]
(
	@INSPECTORTYPEID CHAR(36),
	@USERID CHAR(36),
	@PRIMARYINSPECTOR BIT
)
AS

INSERT INTO [dbo].[IMINSPECTORTYPEUSER](
	[INSPECTORTYPEID],
	[USERID],
	[PRIMARYINSPECTOR]
)

VALUES
(
	@INSPECTORTYPEID,
	@USERID,
	@PRIMARYINSPECTOR
)