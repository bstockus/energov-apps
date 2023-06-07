﻿CREATE PROCEDURE [dbo].[USP_CAFEETEMPLATE_DELETE]
(
	@CAFEETEMPLATEID CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON;
	EXEC [dbo].[USP_FEETEMPLATEINPUTTRANSLATION_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
	EXEC [dbo].[USP_FEETEMPLATEINPUT_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
	EXEC [dbo].[USP_CAFEETEMPLATEFEEPRORATEDATE_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
	EXEC [dbo].[USP_CATEMPLATEFEEDISCOUNTXREF_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
	EXEC [dbo].[USP_CAFEETEMPLATEFEE_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
	EXEC [dbo].[USP_CAFEETEMPLATEDISCOUNT_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
	EXEC [dbo].[USP_CAFEETEMPLATECHILDXREF_DELETE_BY_FEETEMPLATEID] @CAFEETEMPLATEID;
SET NOCOUNT OFF;

DELETE FROM [dbo].[CAFEETEMPLATE]
WHERE	[CAFEETEMPLATEID] = @CAFEETEMPLATEID AND 
		[ROWVERSION]= @ROWVERSION