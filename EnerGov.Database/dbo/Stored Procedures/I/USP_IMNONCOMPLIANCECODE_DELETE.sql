﻿CREATE PROCEDURE [dbo].[USP_IMNONCOMPLIANCECODE_DELETE]
(
	@IMNONCOMPLIANCECODEID CHAR(36),
	@ROWVERSION INT
)
AS

SET NOCOUNT ON;

EXEC USP_IMNONCOMPLIANCECODEREVISION_DELETE_BYPARENTID @IMNONCOMPLIANCECODEID

SET NOCOUNT OFF;

DELETE FROM [dbo].[IMNONCOMPLIANCECODE]
WHERE
	[IMNONCOMPLIANCECODEID] = @IMNONCOMPLIANCECODEID AND 
	[ROWVERSION]= @ROWVERSION