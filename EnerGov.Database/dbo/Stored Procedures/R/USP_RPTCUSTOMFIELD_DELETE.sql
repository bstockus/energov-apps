﻿CREATE PROCEDURE [dbo].[USP_RPTCUSTOMFIELD_DELETE]
	@RPTCUSTOMFIELDID char(36)
AS
	DELETE FROM [dbo].[RPTCUSTOMFIELD]
	WHERE [RPTCUSTOMFIELDID] = @RPTCUSTOMFIELDID