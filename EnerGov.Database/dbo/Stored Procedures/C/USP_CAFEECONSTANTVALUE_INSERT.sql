﻿CREATE PROCEDURE [dbo].[USP_CAFEECONSTANTVALUE_INSERT]
(
	@CAFEECONSTANTVALUEID CHAR(36),
	@CAFEECONSTANTID CHAR(36),
	@VALUE NVARCHAR(MAX),
	@CASCHEDULEID CHAR(36)
)
AS

INSERT INTO [dbo].[CAFEECONSTANTVALUE](
	[CAFEECONSTANTVALUEID],
	[CAFEECONSTANTID],
	[VALUE],
	[CASCHEDULEID]
)

VALUES
(
	@CAFEECONSTANTVALUEID,
	@CAFEECONSTANTID,
	@VALUE,
	@CASCHEDULEID
)