﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDTEMPLATE_DELETE]
(
	@GCUSTOMFIELDTEMPLATE CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON; 

EXEC [dbo].[USP_CUSTOMFIELDTEMPLATEITEM_DELETE_BYPARENTID] @GCUSTOMFIELDTEMPLATE

SET NOCOUNT OFF;

DELETE FROM [dbo].[CUSTOMFIELDTEMPLATE]
WHERE
	[GCUSTOMFIELDTEMPLATE] = @GCUSTOMFIELDTEMPLATE AND 
	[ROWVERSION]= @ROWVERSION