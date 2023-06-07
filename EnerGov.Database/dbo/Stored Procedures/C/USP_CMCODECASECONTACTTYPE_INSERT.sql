﻿CREATE PROCEDURE [dbo].[USP_CMCODECASECONTACTTYPE_INSERT]
(
	@CMCODECASECONTACTTYPEID CHAR(36),
	@NAME VARCHAR(50),
	@DESCRIPTION VARCHAR(MAX),
	@CMCONTACTTYPESYSTEMID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CMCODECASECONTACTTYPE](
	[CMCODECASECONTACTTYPEID],
	[NAME],
	[DESCRIPTION],
	[CMCONTACTTYPESYSTEMID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CMCODECASECONTACTTYPEID,
	@NAME,
	@DESCRIPTION,
	@CMCONTACTTYPESYSTEMID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE