﻿CREATE PROCEDURE [dbo].[USP_WFSTEP_DELETE]
(
@WFSTEPID CHAR(36),
@ROWVERSION INT
)
AS

DELETE FROM [dbo].[WFSTEP]
WHERE
	[WFSTEPID] = @WFSTEPID AND 
	[ROWVERSION]= @ROWVERSION