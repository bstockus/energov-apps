﻿CREATE PROCEDURE [dbo].[USP_TIMETRACKINGTYPE_DELETE]
(
	@TIMETRACKINGTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[TIMETRACKINGTYPE]
WHERE
	[TIMETRACKINGTYPEID] = @TIMETRACKINGTYPEID AND 
	[ROWVERSION]= @ROWVERSION