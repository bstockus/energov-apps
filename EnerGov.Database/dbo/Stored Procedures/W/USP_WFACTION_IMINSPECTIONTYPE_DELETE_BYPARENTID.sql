﻿CREATE PROCEDURE [dbo].[USP_WFACTION_IMINSPECTIONTYPE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[WFACTION]
WHERE
	[dbo].[WFACTION].[IMINSPECTIONTYPEID] = @PARENTID