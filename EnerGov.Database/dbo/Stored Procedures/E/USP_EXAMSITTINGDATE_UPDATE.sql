﻿CREATE PROCEDURE [dbo].[USP_EXAMSITTINGDATE_UPDATE]
(
	@EXAMSITTINGDATEID CHAR(36),
	@EXAMOBJECTID CHAR(36),
	@STARTDATE DATETIME,
	@ENDDATE DATETIME,
	@CUTOFFDATE DATETIME
)
AS

UPDATE [dbo].[EXAMSITTINGDATE] SET
	[EXAMOBJECTID] = @EXAMOBJECTID,
	[STARTDATE] = @STARTDATE,
	[ENDDATE] = @ENDDATE,
	[CUTOFFDATE] = @CUTOFFDATE

WHERE
	[EXAMSITTINGDATEID] = @EXAMSITTINGDATEID