﻿CREATE PROCEDURE [dbo].[USP_ILLICENSEGROUP_INSERT]
(
	@ILLICENSEGROUPID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@MAXCOMMERCIALVALUE MONEY,
	@MAXRESIDENTIALVALUE MONEY,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[ILLICENSEGROUP](
	[ILLICENSEGROUPID],
	[NAME],
	[DESCRIPTION],
	[MAXCOMMERCIALVALUE],
	[MAXRESIDENTIALVALUE],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@ILLICENSEGROUPID,
	@NAME,
	@DESCRIPTION,
	@MAXCOMMERCIALVALUE,
	@MAXRESIDENTIALVALUE,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE