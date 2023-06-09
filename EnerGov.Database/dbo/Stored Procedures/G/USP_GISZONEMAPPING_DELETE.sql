﻿CREATE PROCEDURE [dbo].[USP_GISZONEMAPPING_DELETE]
(
	@GISZONEMAPPINGID CHAR(36),
	@ROWVERSION INT
)
AS
BEGIN
SET NOCOUNT ON

EXEC [USP_GISZONETOINSPECTORDESIG_DELETE_BYPARENTID] @GISZONEMAPPINGID
EXEC [USP_GISZONEEXTERNALVALUE_DELETE_BYPARENTID] @GISZONEMAPPINGID

SET NOCOUNT OFF

DELETE FROM [dbo].[GISZONEMAPPING]
WHERE
	[GISZONEMAPPINGID] = @GISZONEMAPPINGID AND 
	[ROWVERSION]= @ROWVERSION

END