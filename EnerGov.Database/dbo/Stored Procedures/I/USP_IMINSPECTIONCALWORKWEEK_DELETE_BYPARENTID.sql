﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCALWORKWEEK_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[IMINSPECTIONCALWORKWEEK]
WHERE
	[IMINSPECTIONCALENDARID] = @PARENTID