﻿CREATE PROCEDURE [dbo].[USP_QUERYACTIONHOLDTYPE_DELETE]
(
	@QUERYACTIONHOLDTYPEID CHAR(36)
)
AS
DELETE FROM [dbo].[QUERYACTIONHOLDTYPE]
WHERE
	[QUERYACTIONHOLDTYPEID] = @QUERYACTIONHOLDTYPEID