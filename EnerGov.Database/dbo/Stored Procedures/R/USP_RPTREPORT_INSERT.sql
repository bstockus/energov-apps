﻿CREATE PROCEDURE [dbo].[USP_RPTREPORT_INSERT]
(
	@RPTREPORTID CHAR(36),
	@RPTFRMTOBUSOBJMAPID CHAR(36),
	@REPORTNAME NVARCHAR(255),
	@FRIENDLYNAME NVARCHAR(255),
	@SYSTEMREPORT BIT,
	@PROMPTINPUT BIT,
	@IDENOBJPROPFRIENDLYNAME NVARCHAR(255),
	@IDENTIFYOBJECTPROPERTYTOKEN NVARCHAR(255),
	@IDENTIFYOBJECTPROPERTYNAME NVARCHAR(255),
	@IDENTIFYOBJECTPROPERTYVALUE NVARCHAR(255),
	@REPORTPREVIEWIMAGE VARBINARY(MAX),
	@MOBILEGOVREPORT BIT,
	@ISSUBFOLDER BIT,
	@RPTREPORTTYPEID INT,
	@REPORTVIRTUALPATH NVARCHAR(255),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATE,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[RPTREPORT](
	[RPTREPORTID],
	[RPTFRMTOBUSOBJMAPID],
	[REPORTNAME],
	[FRIENDLYNAME],
	[SYSTEMREPORT],
	[PROMPTINPUT],
	[IDENOBJPROPFRIENDLYNAME],
	[IDENTIFYOBJECTPROPERTYTOKEN],
	[IDENTIFYOBJECTPROPERTYNAME],
	[IDENTIFYOBJECTPROPERTYVALUE],
	[REPORTPREVIEWIMAGE],
	[MOBILEGOVREPORT],
	[ISSUBFOLDER],
	[RPTREPORTTYPEID],
	[REPORTVIRTUALPATH],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@RPTREPORTID,
	@RPTFRMTOBUSOBJMAPID,
	@REPORTNAME,
	@FRIENDLYNAME,
	@SYSTEMREPORT,
	@PROMPTINPUT,
	@IDENOBJPROPFRIENDLYNAME,
	@IDENTIFYOBJECTPROPERTYTOKEN,
	@IDENTIFYOBJECTPROPERTYNAME,
	@IDENTIFYOBJECTPROPERTYVALUE,
	@REPORTPREVIEWIMAGE,
	@MOBILEGOVREPORT,
	@ISSUBFOLDER,
	@RPTREPORTTYPEID,
	@REPORTVIRTUALPATH,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE