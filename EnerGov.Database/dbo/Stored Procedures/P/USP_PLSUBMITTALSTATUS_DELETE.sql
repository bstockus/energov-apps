﻿CREATE PROCEDURE [dbo].[USP_PLSUBMITTALSTATUS_DELETE]
(
	@PLSUBMITTALSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[PLSUBMITTALSTATUS]
WHERE
	[PLSUBMITTALSTATUSID] = @PLSUBMITTALSTATUSID AND 
	[ROWVERSION]= @ROWVERSION