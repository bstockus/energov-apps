﻿CREATE PROCEDURE [dbo].[USP_TXRMTTYPERPTPERIOD_UPDATE]
(
	@TXRMTTYPERPTPERIODID CHAR(36),
	@TXRPTPERIODID CHAR(36),
	@TXREMITTANCETYPEID CHAR(36),
	@DEFAULTPERIOD BIT
)
AS

UPDATE [dbo].[TXRMTTYPERPTPERIOD] SET
	[TXRPTPERIODID] = @TXRPTPERIODID,
	[TXREMITTANCETYPEID] = @TXREMITTANCETYPEID,
	[DEFAULTPERIOD] = @DEFAULTPERIOD

WHERE
	[TXRMTTYPERPTPERIODID] = @TXRMTTYPERPTPERIODID