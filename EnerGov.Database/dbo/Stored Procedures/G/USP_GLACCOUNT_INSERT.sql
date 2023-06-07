﻿CREATE PROCEDURE [dbo].[USP_GLACCOUNT_INSERT]
(
	@GLACCOUNTID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@ACCOUNTNUMBER NVARCHAR(500),
	@ACTIVE BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT,
	@DYNAMICACCOUNT BIT,
	@DYNAMICACCOUNTSQLFUNCTIONNAME NVARCHAR(500)
)
AS
DECLARE @output AS TABLE ([RowVersion] INT)

INSERT INTO [dbo].[GLACCOUNT](
	[GLACCOUNTID],
	[NAME],
	[DESCRIPTION],
	[ACCOUNTNUMBER],
	[ACTIVE],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION],
	[DYNAMICACCOUNT],
	[DYNAMICACCOUNTSQLFUNCTIONNAME]
)
OUTPUT inserted.[ROWVERSION]
INTO @output
VALUES
(
	@GLACCOUNTID,
	@NAME,
	@DESCRIPTION,
	@ACCOUNTNUMBER,
	@ACTIVE,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION,
	@DYNAMICACCOUNT,
	@DYNAMICACCOUNTSQLFUNCTIONNAME
)

SELECT * FROM @output