﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCASETYPE_UPDATE]
(
	@IMINSPECTIONCASETYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@IMINSPECTIONTYPEID CHAR(36),
	@ACTIVE BIT,
	@RECURRENCELIMITTYPE INT,
	@IMINSPECTIONCASESTATUSID CHAR(36),
	@RECURRENCELIMIT INT,
	@PREFIX NVARCHAR(10),
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@RECURRENCEID CHAR(36),
	@ASSIGNINSPECTORVIAGIS BIT,
	@NOTSCHEDULEINSPECTION BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[IMINSPECTIONCASETYPE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[IMINSPECTIONTYPEID] = @IMINSPECTIONTYPEID,
	[ACTIVE] = @ACTIVE,
	[RECURRENCELIMITTYPE] = @RECURRENCELIMITTYPE,
	[IMINSPECTIONCASESTATUSID] = @IMINSPECTIONCASESTATUSID,
	[RECURRENCELIMIT] = @RECURRENCELIMIT,
	[PREFIX] = @PREFIX,
	[CUSTOMFIELDLAYOUTID] = @CUSTOMFIELDLAYOUTID,
	[RECURRENCEID] = @RECURRENCEID,
	[ASSIGNINSPECTORVIAGIS] = @ASSIGNINSPECTORVIAGIS,
	[NOTSCHEDULEINSPECTION] = @NOTSCHEDULEINSPECTION,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[IMINSPECTIONCASETYPEID] = @IMINSPECTIONCASETYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE