﻿CREATE PROCEDURE [dbo].[USP_RPPROPERTYSTATUS_DELETE]
(
	@RPPROPERTYSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[RPPROPERTYSTATUS]
WHERE
	[RPPROPERTYSTATUSID] = @RPPROPERTYSTATUSID AND 
	[ROWVERSION]= @ROWVERSION