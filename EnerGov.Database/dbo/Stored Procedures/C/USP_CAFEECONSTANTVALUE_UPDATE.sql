﻿CREATE PROCEDURE [dbo].[USP_CAFEECONSTANTVALUE_UPDATE]
(
	@CAFEECONSTANTVALUEID CHAR(36),
	@CAFEECONSTANTID CHAR(36),
	@VALUE NVARCHAR(MAX),
	@CASCHEDULEID CHAR(36)
)
AS

UPDATE [dbo].[CAFEECONSTANTVALUE] SET
	[CAFEECONSTANTID] = @CAFEECONSTANTID,
	[VALUE] = @VALUE,
	[CASCHEDULEID] = @CASCHEDULEID

WHERE
	[CAFEECONSTANTVALUEID] = @CAFEECONSTANTVALUEID