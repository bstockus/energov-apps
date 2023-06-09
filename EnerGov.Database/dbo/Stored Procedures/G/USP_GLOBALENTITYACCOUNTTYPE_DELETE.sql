﻿CREATE PROCEDURE [dbo].[USP_GLOBALENTITYACCOUNTTYPE_DELETE]
(
	@GLOBALENTITYACCOUNTTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON

EXEC [USP_GLOBALENTITYACCOUNTTYPEGL_GLOBALENTITYACCOUNTTYPE_DELETE_BYPARENTID] @GLOBALENTITYACCOUNTTYPEID

SET NOCOUNT OFF

DELETE FROM [dbo].[GLOBALENTITYACCOUNTTYPE]
WHERE
	[GLOBALENTITYACCOUNTTYPEID] = @GLOBALENTITYACCOUNTTYPEID AND 
	[ROWVERSION]= @ROWVERSION