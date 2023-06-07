﻿CREATE PROCEDURE [dbo].[USP_PLPLANTYPE_INSERT]
(
	@PLPLANTYPEID CHAR(36),
	@PLPLANTYPEGROUPID CHAR(36),
	@PLANNAME NVARCHAR(50),
	@PREFIX NVARCHAR(10),
	@DAYSTOEXPIRE INT,
	@ACTIVE BIT,
	@TABLENAME NVARCHAR(150),
	@UNLIMITED BIT,
	@REPORTNAME NVARCHAR(50),
	@ALLOWINTERNETSUBMISSION BIT,
	@EXPIRABLE BIT,
	@ASSIGNEDUSER CHAR(36),
	@DEFAULTSTATUS CHAR(36),
	@DEFAULTUSER CHAR(36),
	@SHOWINLICENSING BIT,
	@ALLOWCOMPLETEWITHOPENINVOICE BIT,
	@DAYSTOPLANAPPROVALEXPIRE INT,
	@VALUATION BIT,
	@SQUAREFEET BIT,
	@USINGCLOCK BIT,
	@CLOCKLIMITEDDAYS INT,
	@DEFAULTINTERNETPLPLANSTATUSID CHAR(36),
	@USEPREFIXASSUFFIX BIT,
	@ALLOWOBJECTASSOCIATION BIT,
	@USECASETYPENUMBERING BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT,
	@PLPLANTYPECSSUPLOADSETTINGTYPEID INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[PLPLANTYPE](
	[PLPLANTYPEID],
	[PLPLANTYPEGROUPID],
	[PLANNAME],
	[PREFIX],
	[DAYSTOEXPIRE],
	[ACTIVE],
	[TABLENAME],
	[UNLIMITED],
	[REPORTNAME],
	[ALLOWINTERNETSUBMISSION],
	[EXPIRABLE],
	[ASSIGNEDUSER],
	[DEFAULTSTATUS],
	[DEFAULTUSER],
	[SHOWINLICENSING],
	[ALLOWCOMPLETEWITHOPENINVOICE],
	[DAYSTOPLANAPPROVALEXPIRE],
	[VALUATION],
	[SQUAREFEET],
	[USINGCLOCK],
	[CLOCKLIMITEDDAYS],
	[DEFAULTINTERNETPLPLANSTATUSID],
	[USEPREFIXASSUFFIX],
	[ALLOWOBJECTASSOCIATION],
	[USECASETYPENUMBERING],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION],
	[PLPLANTYPECSSUPLOADSETTINGTYPEID]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@PLPLANTYPEID,
	@PLPLANTYPEGROUPID,
	@PLANNAME,
	@PREFIX,
	@DAYSTOEXPIRE,
	@ACTIVE,
	@TABLENAME,
	@UNLIMITED,
	@REPORTNAME,
	@ALLOWINTERNETSUBMISSION,
	@EXPIRABLE,
	@ASSIGNEDUSER,
	@DEFAULTSTATUS,
	@DEFAULTUSER,
	@SHOWINLICENSING,
	@ALLOWCOMPLETEWITHOPENINVOICE,
	@DAYSTOPLANAPPROVALEXPIRE,
	@VALUATION,
	@SQUAREFEET,
	@USINGCLOCK,
	@CLOCKLIMITEDDAYS,
	@DEFAULTINTERNETPLPLANSTATUSID,
	@USEPREFIXASSUFFIX,
	@ALLOWOBJECTASSOCIATION,
	@USECASETYPENUMBERING,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION,
	@PLPLANTYPECSSUPLOADSETTINGTYPEID
)
SELECT * FROM @OUTPUTTABLE