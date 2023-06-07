﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONTYPEGROUP_UPDATE]
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
UPDATE [dbo].[IMINSPECTIONTYPEGROUP] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[IVRNUMBER] = @IVRNUMBER,
	[GROUPLIMITATION] = @GROUPLIMITATION,
	[IMINSPECTIONSYSTEMTYPEID] = @IMINSPECTIONSYSTEMTYPEID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[IMINSPECTIONTYPEGROUPID] = @IMINSPECTIONTYPEGROUPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE