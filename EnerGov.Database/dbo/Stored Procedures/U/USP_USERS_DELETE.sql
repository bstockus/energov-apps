﻿CREATE PROCEDURE [dbo].[USP_USERS_DELETE]
(
	@SUSERGUID CHAR(36),
	@ROWVERSION INT
)
AS

SET NOCOUNT ON;

EXEC [dbo].[USP_TYLERCASHIERINGUSERUPDATEQUEUE_DELETE_BYPARENTID] @SUSERGUID
EXEC [dbo].[USP_APPLICATIONALLOWED_DELETE_BYPARENTID] @SUSERGUID
EXEC [dbo].[USP_GISMAPLAYERXREF_DELETE_BYPARENTID] @SUSERGUID
EXEC [dbo].[USP_USERDEPARTMENT_DELETE_BYPARENTID] @SUSERGUID
EXEC [dbo].[USP_IMINSPECTORTYPEUSER_DELETE_BYPARENTID] @SUSERGUID

SET NOCOUNT OFF;

DELETE FROM [dbo].[USERS]
WHERE
	[SUSERGUID] = @SUSERGUID AND 
	[ROWVERSION]= @ROWVERSION