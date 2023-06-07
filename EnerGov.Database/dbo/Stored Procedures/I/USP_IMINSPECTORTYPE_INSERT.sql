﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTORTYPE_INSERT]
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
INSERT INTO [dbo].[IMINSPECTORTYPE](
	[dbo].[IMINSPECTORTYPE].[IMINSPECTORTYPEID],
	[dbo].[IMINSPECTORTYPE].[SNAME],
	[dbo].[IMINSPECTORTYPE].[DESCRIPTION],
	[dbo].[IMINSPECTORTYPE].[LASTCHANGEDBY],
	[dbo].[IMINSPECTORTYPE].[LASTCHANGEDON],
	[dbo].[IMINSPECTORTYPE].[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@IMINSPECTORTYPEID,
	@SNAME,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE