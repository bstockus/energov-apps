﻿CREATE PROCEDURE [dbo].[USP_CAFEE_DELETE]
(
	@CAFEEID CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON;

EXEC [dbo].[USP_CAFEEADJUSTABLECALC_DELETE_BYPARENTID] @CAFEEID
EXEC [dbo].[USP_CAFEESETUP_DELETE_BYPARENT_FEEID] @CAFEEID
EXEC [dbo].[USP_CAMODULEFEEXREF_DELETE_BYPARENTID] @CAFEEID
EXEC [dbo].[USP_CAFEEGLACCOUNTXREF_DELETE_BYPARENTID] @CAFEEID
EXEC [dbo].[USP_CAFEETIMETRACKINGTYPEXREF_DELETE_BYPARENTID] @CAFEEID

SET NOCOUNT OFF;
DELETE FROM [dbo].[CAFEE]
WHERE
	[CAFEEID] = @CAFEEID AND 
	[ROWVERSION]= @ROWVERSION