﻿CREATE PROCEDURE [dbo].[USP_RPTTEXTLIB_DELETE]
(
	@RPTTEXTLIBID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[RPTTEXTLIB]
WHERE
	[RPTTEXTLIBID] = @RPTTEXTLIBID AND 
	[ROWVERSION]= @ROWVERSION