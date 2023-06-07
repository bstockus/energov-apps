﻿CREATE PROCEDURE [dbo].[USP_CMVIOLATIONSTATUS_DELETE]
(
	@CMVIOLATIONSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[CMVIOLATIONSTATUS]
WHERE
	[CMVIOLATIONSTATUSID] = @CMVIOLATIONSTATUSID AND 
	[ROWVERSION]= @ROWVERSION