﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEBUSLICTYPE_DELETE]
(
@PMPERMITTYPEBUSLICTYPEID CHAR(36)
)
AS

-- Delete Business license classification type for (permittype,permittypeworkclass)
EXEC [dbo].[USP_PMPERMITTYPEBUSLICTYPEBUSWC_DELETE_BYPARENTID] null, null, @PMPERMITTYPEBUSLICTYPEID

DELETE FROM [dbo].[PMPERMITTYPEBUSLICTYPE]
WHERE
	[PMPERMITTYPEBUSLICTYPEID] = @PMPERMITTYPEBUSLICTYPEID