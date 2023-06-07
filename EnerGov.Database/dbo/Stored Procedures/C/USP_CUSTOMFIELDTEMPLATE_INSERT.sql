﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDTEMPLATE_INSERT]
(
	@GCUSTOMFIELDTEMPLATE CHAR(36),
	@FKCUSTOMFIELDLAYOUTCONTROLTYPE INT,
	@TEMPLATENAME NVARCHAR(50),
	@SDEFAULTVALUE NVARCHAR(50),
	@SFIELDTIP NVARCHAR(MAX),
	@ISACTIVE BIT,
	@BALLOWMULTIPLESELECTIONS BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CUSTOMFIELDTEMPLATE](
	[GCUSTOMFIELDTEMPLATE],
	[FKCUSTOMFIELDLAYOUTCONTROLTYPE],
	[TEMPLATENAME],
	[SDEFAULTVALUE],
	[SFIELDTIP],
	[ISACTIVE],
	[BALLOWMULTIPLESELECTIONS],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@GCUSTOMFIELDTEMPLATE,
	@FKCUSTOMFIELDLAYOUTCONTROLTYPE,
	@TEMPLATENAME,
	@SDEFAULTVALUE,
	@SFIELDTIP,
	@ISACTIVE,
	@BALLOWMULTIPLESELECTIONS,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE