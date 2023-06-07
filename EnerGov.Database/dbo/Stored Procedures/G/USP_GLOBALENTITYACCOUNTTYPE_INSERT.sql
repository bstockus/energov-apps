﻿CREATE PROCEDURE [dbo].[USP_GLOBALENTITYACCOUNTTYPE_INSERT]
(
	@GLOBALENTITYACCOUNTTYPEID CHAR(36),
	@TYPENAME NVARCHAR(30),
	@ISBONDTYPE BIT,
	@ISLICENSETYPE BIT,
	@ISAUTONUMBER BIT,
	@PREFIX NVARCHAR(10),
	@DESCRIPTION NVARCHAR(MAX),
	@CHARGECODE NVARCHAR(100),
	@ISFEEWAIVERACCOUNT BIT,
	@JURISDICTIONID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[GLOBALENTITYACCOUNTTYPE](
	[GLOBALENTITYACCOUNTTYPEID],
	[TYPENAME],
	[ISBONDTYPE],
	[ISLICENSETYPE],
	[ISAUTONUMBER],
	[PREFIX],
	[DESCRIPTION],
	[CHARGECODE],
	[ISFEEWAIVERACCOUNT],
	[JURISDICTIONID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@GLOBALENTITYACCOUNTTYPEID,
	@TYPENAME,
	@ISBONDTYPE,
	@ISLICENSETYPE,
	@ISAUTONUMBER,
	@PREFIX,
	@DESCRIPTION,
	@CHARGECODE,
	@ISFEEWAIVERACCOUNT,
	@JURISDICTIONID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE