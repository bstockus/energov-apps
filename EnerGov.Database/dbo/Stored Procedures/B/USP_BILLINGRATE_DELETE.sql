﻿CREATE PROCEDURE [dbo].[USP_BILLINGRATE_DELETE]
(
	@BILLINGRATEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[BILLINGRATE]
WHERE
	[BILLINGRATEID] = @BILLINGRATEID AND 
	[ROWVERSION]= @ROWVERSION