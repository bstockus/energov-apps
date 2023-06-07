﻿CREATE PROCEDURE [dbo].[USP_TXREMITTANCETYPE_DELETE]
(
	@TXREMITTANCETYPEID CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON;

EXEC [dbo].[USP_TXRMTTYPERPTPERIOD_DELETE_BYPARENTID] @TXREMITTANCETYPEID

EXEC [dbo].[USP_TXRMTCONTACTTYPEREF_DELETE_BYPARENTID] @TXREMITTANCETYPEID

EXEC [dbo].[USP_TXREMALLOWEDACTIVITY_DELETE_BYPARENTID] @TXREMITTANCETYPEID

SET NOCOUNT OFF;


DELETE FROM [dbo].[TXREMITTANCETYPE]
WHERE
	[TXREMITTANCETYPEID] = @TXREMITTANCETYPEID AND 
	[ROWVERSION]= @ROWVERSION