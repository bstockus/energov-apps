﻿CREATE PROCEDURE [dbo].[USP_ATTACHMENTREQFILEREF_PMPERMITTYPE_DELETE_BYPARENTID]  
(  
@PERMITTYPEID CHAR(36),
@PERMITTYPEWORKCLASSID CHAR(36)
)  
AS  
DELETE [dbo].[ATTACHMENTREQFILEREF] FROM [dbo].[ATTACHMENTREQFILEREF]
INNER JOIN [dbo].[PMPERMITTYPEWORKCLASS] ON [dbo].[ATTACHMENTREQFILEREF].[OBJECTTYPEID] = [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID]
WHERE
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID] = @PERMITTYPEID AND (@PERMITTYPEWORKCLASSID IS NULL OR [dbo].[ATTACHMENTREQFILEREF].[OBJECTTYPEID] = @PERMITTYPEWORKCLASSID)