﻿CREATE PROCEDURE [dbo].[USP_CMCODEACTIVITYTYPE_INSERT]
(
	@CMCODEACTIVITYTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@CANEDIT BIT,
	@CREATEID BIT,
	@PREFIXID NVARCHAR(20),
	@ALLOWDUPLICATE BIT,
	@CUSTOMFIELDID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CMCODEACTIVITYTYPE](
	[CMCODEACTIVITYTYPEID],
	[NAME],
	[DESCRIPTION],
	[CANEDIT],
	[CREATEID],
	[PREFIXID],
	[ALLOWDUPLICATE],
	[CUSTOMFIELDID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CMCODEACTIVITYTYPEID,
	@NAME,
	@DESCRIPTION,
	@CANEDIT,
	@CREATEID,
	@PREFIXID,
	@ALLOWDUPLICATE,
	@CUSTOMFIELDID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE