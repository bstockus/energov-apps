﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONTYPEGROUP_INSERT]
(
	@IMINSPECTIONTYPEGROUPID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@IVRNUMBER INT,
	@GROUPLIMITATION INT,
	@IMINSPECTIONSYSTEMTYPEID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[IMINSPECTIONTYPEGROUP](
	[IMINSPECTIONTYPEGROUPID],
	[NAME],
	[DESCRIPTION],
	[IVRNUMBER],
	[GROUPLIMITATION],
	[IMINSPECTIONSYSTEMTYPEID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@IMINSPECTIONTYPEGROUPID,
	@NAME,
	@DESCRIPTION,
	@IVRNUMBER,
	@GROUPLIMITATION,
	@IMINSPECTIONSYSTEMTYPEID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE