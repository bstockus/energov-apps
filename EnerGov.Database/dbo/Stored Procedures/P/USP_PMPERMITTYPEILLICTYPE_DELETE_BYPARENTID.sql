﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEILLICTYPE_DELETE_BYPARENTID]  
(  
@PERMITTYPEID CHAR(36),
@PERMITTYPEWORKCLASSID CHAR(36)
)  
AS 

-- Delete Professional license classification for (permittype,permittypeworkclass)
EXEC [dbo].[USP_PMPERMITTYPEILLICTYPEILWC_DELETE_BYPARENTID] @PERMITTYPEID, @PERMITTYPEWORKCLASSID, null

-- Delete Professional license classification type for (permittype,permittypeworkclass)
EXEC [dbo].[USP_PMPERMITTYPEILLICTYPEILWCT_DELETE_BYPARENTID] @PERMITTYPEID, @PERMITTYPEWORKCLASSID,null

DELETE [dbo].[PMPERMITTYPEILLICTYPE] FROM [dbo].[PMPERMITTYPEILLICTYPE]
INNER JOIN [dbo].[PMPERMITTYPEWORKCLASS] ON [dbo].[PMPERMITTYPEILLICTYPE].[PMPERMITTYPEWORKCLASSID] = [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID]
WHERE
	[dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID] = @PERMITTYPEID AND (@PERMITTYPEWORKCLASSID IS NULL OR [dbo].[PMPERMITTYPEILLICTYPE].[PMPERMITTYPEWORKCLASSID] = @PERMITTYPEWORKCLASSID)