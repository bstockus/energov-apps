﻿CREATE PROCEDURE [dbo].[USP_PLAPPLICATIONACTIVITYTYPE_DELETE]
(
	@PLAPPLICATIONACTIVITYTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[PLAPPLICATIONACTIVITYTYPE]
WHERE
	[PLAPPLICATIONACTIVITYTYPEID] = @PLAPPLICATIONACTIVITYTYPEID AND 
	[ROWVERSION]= @ROWVERSION