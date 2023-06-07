﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDTABLECOLUMNREF_UPDATE]
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

UPDATE [dbo].[CUSTOMFIELDTABLECOLUMNREF] SET
	[CUSTOMFIELDTABLEID] = @CUSTOMFIELDTABLEID,
	[CUSTOMFIELDCOLUMNTEMPLATEID] = @CUSTOMFIELDCOLUMNTEMPLATEID,
	[DISPLAYNAME] = @DISPLAYNAME,
	[IORDER] = @IORDER,
	[RETIRED] = @RETIRED,
	[SDEFAULTVALUE] = @SDEFAULTVALUE,
	[BISREQUIRED] = @BISREQUIRED,
	[FORMULA] = @FORMULA,
	[SHOWONMOBILE] = @SHOWONMOBILE

WHERE
	[CUSTOMFIELDTABLECOLUMNREFID] = @CUSTOMFIELDTABLECOLUMNREFID