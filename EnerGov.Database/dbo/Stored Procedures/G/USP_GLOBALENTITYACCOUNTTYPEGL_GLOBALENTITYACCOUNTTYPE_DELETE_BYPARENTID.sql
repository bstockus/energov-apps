﻿CREATE PROCEDURE [dbo].[USP_GLOBALENTITYACCOUNTTYPEGL_GLOBALENTITYACCOUNTTYPE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
	DELETE FROM [dbo].[GLOBALENTITYACCOUNTTYPEGL] 
		WHERE [dbo].[GLOBALENTITYACCOUNTTYPEGL].[GLOBALENTITYACCOUNTTYPEID] = @PARENTID 
END