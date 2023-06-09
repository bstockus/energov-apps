﻿CREATE PROCEDURE [dbo].[USP_HEARINGTYPE_UPDATE]
(
	@HEARINGTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@DEFAULTSUBJECT VARCHAR(255),
	@DEFAULTLOCATION VARCHAR(255),
	@DEFAULTCOMMENT VARCHAR(MAX),
	@STIME DATETIME,
	@ETIME DATETIME,
	@RECURRENCEID CHAR(36),
	@CONTENTLIMIT INT,
	@LIMIT INT,
	@DEFAULTSTATUSID CHAR(36),
	@AVAILINCAP BIT,
	@AVAILINCAPCONTACTS BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[HEARINGTYPE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[CUSTOMFIELDLAYOUTID] = @CUSTOMFIELDLAYOUTID,
	[DEFAULTSUBJECT] = @DEFAULTSUBJECT,
	[DEFAULTLOCATION] = @DEFAULTLOCATION,
	[DEFAULTCOMMENT] = @DEFAULTCOMMENT,
	[STIME] = @STIME,
	[ETIME] = @ETIME,
	[RECURRENCEID] = @RECURRENCEID,
	[CONTENTLIMIT] = @CONTENTLIMIT,
	[LIMIT] = @LIMIT,
	[DEFAULTSTATUSID] = @DEFAULTSTATUSID,
	[AVAILINCAP] = @AVAILINCAP,
	[AVAILINCAPCONTACTS] = @AVAILINCAPCONTACTS,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[HEARINGTYPEID] = @HEARINGTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE