﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEWORKCLASS_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
EXEC [dbo].[USP_PMPERMITTYPEUNITTYPE_DELETE_BYPARENTID] @PARENTID, null

EXEC [dbo].[USP_PMCONTACTTYPEREF_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_ATTACHMENTREQFILEREF_PMPERMITTYPE_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_PMPERMITTYPEILLICTYPE_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_PMPERMITTYPELICENSETYPE_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_PMPERMITTYPEBUSLICTYPE_DELETE_BYPARENTID] @PARENTID, null
EXEC [common].[USP_SYSTEMTASKTYPEWORKCLASS_DELETE_BYPARENTID] @PARENTID, null

DELETE FROM [dbo].[PMPERMITTYPEWORKCLASS]
WHERE
	[PMPERMITTYPEID] = @PARENTID