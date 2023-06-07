﻿CREATE PROCEDURE [dbo].[USP_RPTAUTOMAIL_DELETE]
(
	@RPTAUTOMAILID CHAR(36),
	@ROWVERSION INT
)
AS
BEGIN

SET NOCOUNT ON;

EXEC [USP_RPTMAILTO_DELETE_BYPARENTID] @RPTAUTOMAILID

EXEC [dbo].[USP_RPTPRINTTO_DELETE_BYPARENTID] @RPTAUTOMAILID
SET NOCOUNT OFF;
DELETE FROM [dbo].[RPTAUTOMAIL]
WHERE
	[RPTAUTOMAILID] = @RPTAUTOMAILID AND 
	[ROWVERSION]= @ROWVERSION

END