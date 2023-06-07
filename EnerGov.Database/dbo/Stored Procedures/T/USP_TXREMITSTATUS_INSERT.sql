﻿CREATE PROCEDURE [dbo].[USP_TXREMITSTATUS_INSERT]
(
	@TXREMITSTATUSID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@TXREMITSTATUSSYSTEMID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[TXREMITSTATUS](
	[TXREMITSTATUSID],
	[NAME],
	[DESCRIPTION],
	[TXREMITSTATUSSYSTEMID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@TXREMITSTATUSID,
	@NAME,
	@DESCRIPTION,
	@TXREMITSTATUSSYSTEMID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE