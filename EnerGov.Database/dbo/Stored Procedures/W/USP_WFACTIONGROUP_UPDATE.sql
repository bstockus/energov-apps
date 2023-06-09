﻿CREATE PROCEDURE [dbo].[USP_WFACTIONGROUP_UPDATE]
(
	@WFACTIONGROUPID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@WFENTITYID INT,
	@WFSTEPTYPEID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[WFACTIONGROUP] SET
	[WFACTIONGROUPID] = @WFACTIONGROUPID,
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[WFENTITYID] = @WFENTITYID,
	[WFSTEPTYPEID] = @WFSTEPTYPEID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[WFACTIONGROUPID] = @WFACTIONGROUPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE