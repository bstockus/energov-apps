﻿CREATE PROCEDURE [dbo].[USP_TXRMTTYPERPTPERIOD_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[TXRMTTYPERPTPERIOD]
WHERE
	[TXREMITTANCETYPEID] = @PARENTID