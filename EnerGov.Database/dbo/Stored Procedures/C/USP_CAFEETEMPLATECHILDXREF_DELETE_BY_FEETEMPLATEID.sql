﻿CREATE PROCEDURE [dbo].[USP_CAFEETEMPLATECHILDXREF_DELETE_BY_FEETEMPLATEID]
(
@CAFEETEMPLATEID CHAR(36)
)
AS
DELETE FROM [dbo].[CAFEETEMPLATECHILDXREF]
WHERE
	[PARENTFEETEMPLATEID] = @CAFEETEMPLATEID