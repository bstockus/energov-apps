﻿CREATE PROCEDURE [dbo].[USP_RPTCUSTOMFIELD_UPDATE]
	@RPTCUSTOMFIELDID char(36),
	@ORDER int
AS
	UPDATE [dbo].[RPTCUSTOMFIELD]
	SET [ORDER] = @ORDER
	WHERE [RPTCUSTOMFIELDID] = @RPTCUSTOMFIELDID