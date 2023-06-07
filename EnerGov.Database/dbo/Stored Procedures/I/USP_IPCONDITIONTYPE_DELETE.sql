﻿CREATE PROCEDURE [dbo].[USP_IPCONDITIONTYPE_DELETE]
(
	@IPCONDITIONTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[IPCONDITIONTYPE]
WHERE
	[IPCONDITIONTYPEID] = @IPCONDITIONTYPEID AND 
	[ROWVERSION]= @ROWVERSION