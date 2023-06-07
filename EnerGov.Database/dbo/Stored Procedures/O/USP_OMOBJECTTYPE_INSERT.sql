﻿CREATE PROCEDURE [dbo].[USP_OMOBJECTTYPE_INSERT]
(
	@OMOBJECTTYPEID CHAR(36),
	@PREFIX NVARCHAR(10),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@AUTONUMBER BIT,
	@DEFAULTOBJECTSTATUSID CHAR(36),
	@ACTIVE BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[OMOBJECTTYPE](
	[OMOBJECTTYPEID],
	[PREFIX],
	[NAME],
	[DESCRIPTION],
	[AUTONUMBER],
	[DEFAULTOBJECTSTATUSID],
	[ACTIVE],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@OMOBJECTTYPEID,
	@PREFIX,
	@NAME,
	@DESCRIPTION,
	@AUTONUMBER,
	@DEFAULTOBJECTSTATUSID,
	@ACTIVE,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE