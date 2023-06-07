﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPELICENSETYPE_DELETE_BYPARENTID]  
(  
@PERMITTYPEID CHAR(36),
@PERMITWORKCLASSID CHAR(36)
)  
AS

-- Delete certification classification for (permittype,permitworkclass)
EXEC [dbo].[USP_PMWCCERTCLASS_DELETE_BYPARENTID] @PERMITTYPEID, @PERMITWORKCLASSID, null

DELETE [dbo].[PMPERMITTYPELICENSETYPE] FROM [dbo].[PMPERMITTYPELICENSETYPE]
WHERE
	[dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITTYPEID] = @PERMITTYPEID AND (@PERMITWORKCLASSID IS NULL OR [dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITWORKCLASSID] = @PERMITWORKCLASSID)