﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONLIMITSOVERRIDE_UPDATE]
(
	@IMINSPECTIONLIMITSOVERRIDEID CHAR(36),
	@IMINSPECTIONTYPEGROUPID CHAR(36),
	@IMINSPECTIONCATEGORYID CHAR(36),
	@OVERRIDESTARTDATE DATETIME,
	@OVERRIDEENDDATE DATETIME,
	@NEWLIMITVALUE INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[IMINSPECTIONLIMITSOVERRIDE] SET
	[IMINSPECTIONTYPEGROUPID] = @IMINSPECTIONTYPEGROUPID,
	[IMINSPECTIONCATEGORYID] = @IMINSPECTIONCATEGORYID,
	[OVERRIDESTARTDATE] = @OVERRIDESTARTDATE,
	[OVERRIDEENDDATE] = @OVERRIDEENDDATE,
	[NEWLIMITVALUE] = @NEWLIMITVALUE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[IMINSPECTIONLIMITSOVERRIDEID] = @IMINSPECTIONLIMITSOVERRIDEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE