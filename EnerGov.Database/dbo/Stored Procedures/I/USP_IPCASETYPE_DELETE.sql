﻿CREATE PROCEDURE [dbo].[USP_IPCASETYPE_DELETE]
(
	@IPCASETYPEID CHAR(36),
	@ROWVERSION INT
)
AS
BEGIN
SET NOCOUNT ON

EXEC [USP_IPCASEALLOWEDCONTACTTYPE_DELETE_BYPARENTID] @IPCASETYPEID

SET NOCOUNT OFF
DELETE FROM [dbo].[IPCASETYPE]
WHERE
	[IPCASETYPEID] = @IPCASETYPEID AND 
	[ROWVERSION]= @ROWVERSION

END