﻿CREATE PROCEDURE [dbo].[USP_ILLICENSECLASSTYPE_DELETE]
(
	@ILLICENSECLASSTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[ILLICENSECLASSTYPE]
WHERE
	[ILLICENSECLASSTYPEID] = @ILLICENSECLASSTYPEID AND 
	[ROWVERSION]= @ROWVERSION