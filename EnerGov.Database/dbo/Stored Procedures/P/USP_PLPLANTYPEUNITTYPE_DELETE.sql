﻿CREATE PROCEDURE [dbo].[USP_PLPLANTYPEUNITTYPE_DELETE]
(
@PLPLANTYPEUNITTYPEID CHAR(36)
)
AS
DELETE FROM [dbo].[PLPLANTYPEUNITTYPE]
WHERE
	[PLPLANTYPEUNITTYPEID] = @PLPLANTYPEUNITTYPEID