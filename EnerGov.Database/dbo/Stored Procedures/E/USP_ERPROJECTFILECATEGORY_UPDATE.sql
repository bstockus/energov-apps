﻿CREATE PROCEDURE [dbo].[USP_ERPROJECTFILECATEGORY_UPDATE]
(
	@ERPROJECTFILECATEGORYID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@ALLOWEDFILETYPES NVARCHAR(MAX),
	@ATTACHMENTGROUPID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT,
	@FILENAMEPREFIX INT = 0,
	@FILENAMEPREFIXCUSTOM NVARCHAR(20) = NULL,
	@FILENAMEBODY INT = 2,
	@FILENAMEBODYCUSTOM NVARCHAR(50) = NULL,
	@FILENAMESUFFIX INT = 0,
	@FILENAMESUFFIXCUSTOM NVARCHAR(20) = NULL
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[ERPROJECTFILECATEGORY] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[ALLOWEDFILETYPES] = @ALLOWEDFILETYPES,
	[ATTACHMENTGROUPID] = @ATTACHMENTGROUPID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1,
	[FILENAMEPREFIX] = @FILENAMEPREFIX,
	[FILENAMEPREFIXCUSTOM] = @FILENAMEPREFIXCUSTOM,
	[FILENAMEBODY] = @FILENAMEBODY,
	[FILENAMEBODYCUSTOM] = @FILENAMEBODYCUSTOM,
	[FILENAMESUFFIX] = @FILENAMESUFFIX,
	[FILENAMESUFFIXCUSTOM] = @FILENAMESUFFIXCUSTOM
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[ERPROJECTFILECATEGORYID] = @ERPROJECTFILECATEGORYID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE