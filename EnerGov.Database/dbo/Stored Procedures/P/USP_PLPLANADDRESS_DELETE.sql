﻿CREATE PROCEDURE [dbo].[USP_PLPLANADDRESS_DELETE]
(
	@PLPLANADDRESSID CHAR(36)
)
AS
BEGIN
DELETE [dbo].[PLPLANADDRESS] 
		WHERE [PLPLANADDRESSID] = @PLPLANADDRESSID
END