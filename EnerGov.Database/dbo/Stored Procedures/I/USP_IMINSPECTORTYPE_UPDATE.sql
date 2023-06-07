﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTORTYPE_UPDATE]
(
	@IMINSPECTORTYPEID CHAR(36),
	@SNAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[IMINSPECTORTYPE] SET
	[dbo].[IMINSPECTORTYPE].[SNAME] = @SNAME,
	[dbo].[IMINSPECTORTYPE].[DESCRIPTION] = @DESCRIPTION,
	[dbo].[IMINSPECTORTYPE].[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[dbo].[IMINSPECTORTYPE].[LASTCHANGEDON] = @LASTCHANGEDON,
	[dbo].[IMINSPECTORTYPE].[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[dbo].[IMINSPECTORTYPE].[IMINSPECTORTYPEID] = @IMINSPECTORTYPEID AND 
	[dbo].[IMINSPECTORTYPE].[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE