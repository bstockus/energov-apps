﻿CREATE PROCEDURE [dbo].[USP_PLPLANPARCEL_DELETE]
(
	@PLPLANPARCELID CHAR(36)
)
AS
BEGIN
DELETE [dbo].[PLPLANPARCEL] 
		WHERE [PLPLANPARCELID] = @PLPLANPARCELID
END