﻿CREATE PROCEDURE [dbo].[USP_CMCITATIONSTATUS_DELETE]
(
	@CMCITATIONSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[CMCITATIONSTATUS]
WHERE
	[CMCITATIONSTATUSID] = @CMCITATIONSTATUSID AND 
	[ROWVERSION]= @ROWVERSION