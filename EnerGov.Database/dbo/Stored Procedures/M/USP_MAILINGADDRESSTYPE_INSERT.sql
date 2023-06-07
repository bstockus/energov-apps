﻿CREATE PROCEDURE [dbo].[USP_MAILINGADDRESSTYPE_INSERT]
(
	@MAILINGADDRESSTYPEID CHAR(36),
	@MAILINGADDRESSTYPENAME NVARCHAR(30),
	@MAILINGADDRESSDESCRIPTION NVARCHAR(MAX),
	@SYSTEMACTIONID CHAR(36),
	@ISDEFAULT BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[MAILINGADDRESSTYPE](
	[MAILINGADDRESSTYPEID],
	[MAILINGADDRESSTYPENAME],
	[MAILINGADDRESSDESCRIPTION],
	[SYSTEMACTIONID],
	[ISDEFAULT],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@MAILINGADDRESSTYPEID,
	@MAILINGADDRESSTYPENAME,
	@MAILINGADDRESSDESCRIPTION,
	@SYSTEMACTIONID,
	@ISDEFAULT,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE