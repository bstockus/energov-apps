﻿CREATE PROCEDURE [dbo].[USP_RPLANDLORDLICENSESTATUS_DELETE]
(
	@RPLANDLORDLICENSESTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[RPLANDLORDLICENSESTATUS]
WHERE
	[RPLANDLORDLICENSESTATUSID] = @RPLANDLORDLICENSESTATUSID AND 
	[ROWVERSION]= @ROWVERSION