﻿CREATE PROCEDURE [dbo].[USP_TXRMTTYPERPTPERIOD_INSERT]
(
	@TXRMTTYPERPTPERIODID CHAR(36),
	@TXRPTPERIODID CHAR(36),
	@TXREMITTANCETYPEID CHAR(36),
	@DEFAULTPERIOD BIT
)
AS

INSERT INTO [dbo].[TXRMTTYPERPTPERIOD](
	[TXRMTTYPERPTPERIODID],
	[TXRPTPERIODID],
	[TXREMITTANCETYPEID],
	[DEFAULTPERIOD]
)

VALUES
(
	@TXRMTTYPERPTPERIODID,
	@TXRPTPERIODID,
	@TXREMITTANCETYPEID,
	@DEFAULTPERIOD
)