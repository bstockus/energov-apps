﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEUNITTYPE_DELETE]
(
@PMPERMITTYPEIPUNITTYPEID CHAR(36)
)
AS
DELETE FROM [dbo].[PMPERMITTYPEUNITTYPE]
WHERE
	[PMPERMITTYPEIPUNITTYPEID] = @PMPERMITTYPEIPUNITTYPEID