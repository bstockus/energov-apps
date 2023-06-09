﻿CREATE PROCEDURE [dbo].[USP_CMCASETYPE_INSERT]
(
	@CMCASETYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@CUSTOMFIELDID CHAR(36),
	@WFTEMPLATEID CHAR(36),
	@CAFEETEMPLATEID CHAR(36),
	@ACTIVE BIT,
	@DEFAULTUSER CHAR(36),
	@DEFAULTSTATUS CHAR(36),
	@DESCRIPTION NVARCHAR(MAX),
	@PREFIX NVARCHAR(10),
	@USECASETYPENUMBERING BIT,
	@ONLINECUSTOMFIELDLAYOUTID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CMCASETYPE](
	[CMCASETYPEID],
	[NAME],
	[CUSTOMFIELDID],
	[WFTEMPLATEID],
	[CAFEETEMPLATEID],
	[ACTIVE],
	[DEFAULTUSER],
	[DEFAULTSTATUS],
	[DESCRIPTION],
	[PREFIX],
	[USECASETYPENUMBERING],
	[ONLINECUSTOMFIELDLAYOUTID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CMCASETYPEID,
	@NAME,
	@CUSTOMFIELDID,
	@WFTEMPLATEID,
	@CAFEETEMPLATEID,
	@ACTIVE,
	@DEFAULTUSER,
	@DEFAULTSTATUS,
	@DESCRIPTION,
	@PREFIX,
	@USECASETYPENUMBERING,
	@ONLINECUSTOMFIELDLAYOUTID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE