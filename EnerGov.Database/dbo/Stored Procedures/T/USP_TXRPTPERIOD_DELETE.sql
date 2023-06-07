﻿CREATE PROCEDURE [dbo].[USP_TXRPTPERIOD_DELETE]
(
	@TXRPTPERIODID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[TXRPTPERIOD]
WHERE
	[TXRPTPERIODID] = @TXRPTPERIODID AND 
	[ROWVERSION]= @ROWVERSION