﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEBUSLICTYPEBUSWC_DELETE_BYPARENTID]  
(  
@PERMITTYPEID CHAR(36),
@PERMITTYPEWORKCLASSID CHAR(36),
@PMPERMITTYPEBUSLICTYPEID CHAR(36)
)  
AS
DELETE [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC] FROM [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC]
INNER JOIN [dbo].[PMPERMITTYPEBUSLICTYPE] ON [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC].[PMPERMITTYPEBUSLICTYPEID] = [dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEBUSLICTYPEID]
INNER JOIN [dbo].[PMPERMITTYPEWORKCLASS] ON [dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEWORKCLASSID] = [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID]
WHERE
	(@PMPERMITTYPEBUSLICTYPEID IS NULL OR [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC].[PMPERMITTYPEBUSLICTYPEID] = @PMPERMITTYPEBUSLICTYPEID)
	AND (@PERMITTYPEID IS NULL OR [dbo].[PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID] = @PERMITTYPEID) 
	AND (@PERMITTYPEWORKCLASSID IS NULL OR [dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEWORKCLASSID] = @PERMITTYPEWORKCLASSID)