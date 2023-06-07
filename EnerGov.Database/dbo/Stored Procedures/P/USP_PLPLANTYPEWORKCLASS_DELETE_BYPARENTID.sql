﻿CREATE PROCEDURE [dbo].[USP_PLPLANTYPEWORKCLASS_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS

EXEC [dbo].[USP_PLPLANTYPEUNITTYPE_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_PLCONTACTTYPEREF_PLPLANTYPE_DELETE_BYPARENTID] @PARENTID, null

EXEC [dbo].[USP_ATTACHMENTREQFILEREF_PLPLANTYPE_DELETE_BYPARENTID] @PARENTID, null

EXEC [common].[USP_SYSTEMTASKTYPEWORKCLASS_DELETE_BYPARENTID] @PARENTID, null

DELETE FROM [dbo].[PLPLANTYPEWORKCLASS]
WHERE
	[PLPLANTYPEID] = @PARENTID