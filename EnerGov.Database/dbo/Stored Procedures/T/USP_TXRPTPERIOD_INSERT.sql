﻿CREATE PROCEDURE [dbo].[USP_TXRPTPERIOD_INSERT]
(
	@TXRPTPERIODID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(250),
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[TXRPTPERIOD](
	[TXRPTPERIODID],
	[NAME],
	[DESCRIPTION],
	[CUSTOMFIELDLAYOUTID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@TXRPTPERIODID,
	@NAME,
	@DESCRIPTION,
	@CUSTOMFIELDLAYOUTID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE