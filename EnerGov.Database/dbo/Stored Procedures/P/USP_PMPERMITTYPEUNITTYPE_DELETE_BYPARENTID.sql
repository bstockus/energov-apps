﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEUNITTYPE_DELETE_BYPARENTID]  
(  
@PERMITTYPEID CHAR(36),
@PERMITWORKCLASSID CHAR(36) 
)  
AS  
DELETE FROM [dbo].[PMPERMITTYPEUNITTYPE]
WHERE
	[PMPERMITTYPEID] = @PERMITTYPEID AND (@PERMITWORKCLASSID IS NULL OR [PMPERMITWORKCLASSID] = @PERMITWORKCLASSID)