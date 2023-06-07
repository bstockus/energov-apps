﻿CREATE PROCEDURE [dbo].[USP_CACPIREFERENCEDATE_UPDATE]
(
	@CACPIREFERENCEDATEID CHAR(36),
	@CAMODULEID INT,
	@DATEOBJECTTYPEID INT,
	@DATEOBJECT NVARCHAR(255),
	@DATEOBJECTFRIENDLYNAME NVARCHAR(500),
	@ISDEFAULT BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CACPIREFERENCEDATE] SET
	[CAMODULEID] = @CAMODULEID,
	[DATEOBJECTTYPEID] = @DATEOBJECTTYPEID,
	[DATEOBJECT] = @DATEOBJECT,
	[DATEOBJECTFRIENDLYNAME] = @DATEOBJECTFRIENDLYNAME,
	[ISDEFAULT] = @ISDEFAULT,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CACPIREFERENCEDATEID] = @CACPIREFERENCEDATEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE