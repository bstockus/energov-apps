﻿CREATE PROCEDURE [dbo].[USP_PMPERMITSTATUS_DELETE]
(
	@PMPERMITSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[PMPERMITSTATUS]
WHERE
	[PMPERMITSTATUSID] = @PMPERMITSTATUSID AND 
	[ROWVERSION]= @ROWVERSION