﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDTABLECOLUMNREF_INSERT]
(
	@CUSTOMFIELDTABLECOLUMNREFID CHAR(36),
	@CUSTOMFIELDTABLEID CHAR(36),
	@CUSTOMFIELDCOLUMNTEMPLATEID CHAR(36),
	@DISPLAYNAME NVARCHAR(50),
	@IORDER INT,
	@RETIRED BIT,
	@SDEFAULTVALUE NVARCHAR(50),
	@BISREQUIRED BIT,
	@FORMULA NVARCHAR(MAX),
	@SHOWONMOBILE BIT
)
AS

INSERT INTO [dbo].[CUSTOMFIELDTABLECOLUMNREF](
	[CUSTOMFIELDTABLECOLUMNREFID],
	[CUSTOMFIELDTABLEID],
	[CUSTOMFIELDCOLUMNTEMPLATEID],
	[DISPLAYNAME],
	[IORDER],
	[RETIRED],
	[SDEFAULTVALUE],
	[BISREQUIRED],
	[FORMULA],
	[SHOWONMOBILE]
)

VALUES
(
	@CUSTOMFIELDTABLECOLUMNREFID,
	@CUSTOMFIELDTABLEID,
	@CUSTOMFIELDCOLUMNTEMPLATEID,
	@DISPLAYNAME,
	@IORDER,
	@RETIRED,
	@SDEFAULTVALUE,
	@BISREQUIRED,
	@FORMULA,
	@SHOWONMOBILE
)