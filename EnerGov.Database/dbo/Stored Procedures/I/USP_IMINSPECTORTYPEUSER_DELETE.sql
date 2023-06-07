﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTORTYPEUSER_DELETE]
(
	@INSPECTORTYPEID CHAR(36),
	@USERID CHAR(36)
)
AS

DELETE FROM [dbo].[IMINSPECTORTYPEUSER]
WHERE
	[INSPECTORTYPEID] = @INSPECTORTYPEID AND 
	[USERID] = @USERID