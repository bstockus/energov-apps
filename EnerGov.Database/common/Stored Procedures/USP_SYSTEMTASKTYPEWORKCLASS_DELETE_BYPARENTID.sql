﻿CREATE PROCEDURE [common].[USP_SYSTEMTASKTYPEWORKCLASS_DELETE_BYPARENTID]  
(  
@PARENTTYPEID CHAR(36),
@PARENTTYPEWORKCLASSID CHAR(36)
)  
AS  
DELETE [dbo].[SYSTEMTASKTYPEWORKCLASS] FROM [dbo].[SYSTEMTASKTYPEWORKCLASS]
LEFT JOIN [dbo].[PMPERMITTYPEWORKCLASS] ON [dbo].[SYSTEMTASKTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID]
LEFT JOIN [dbo].[PLPLANTYPEWORKCLASS] ON [dbo].[SYSTEMTASKTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [dbo].[PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID]
WHERE
([dbo].[PLPLANTYPEWORKCLASS].[PLPLANTYPEID] = @PARENTTYPEID 
	AND (@PARENTTYPEWORKCLASSID IS NULL OR [dbo].[SYSTEMTASKTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = @PARENTTYPEWORKCLASSID))
OR ([dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID] = @PARENTTYPEID 
	AND (@PARENTTYPEWORKCLASSID IS NULL OR [dbo].[SYSTEMTASKTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = @PARENTTYPEWORKCLASSID))