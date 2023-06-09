﻿CREATE PROCEDURE [dbo].[USP_GLACCOUNT_UPDATE]
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

UPDATE [dbo].[GLACCOUNT] SET	
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[ACCOUNTNUMBER] = @ACCOUNTNUMBER,
	[ACTIVE] = @ACTIVE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[DYNAMICACCOUNT] = @DYNAMICACCOUNT,
	[DYNAMICACCOUNTSQLFUNCTIONNAME] = @DYNAMICACCOUNTSQLFUNCTIONNAME,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @output
WHERE
	[GLACCOUNTID] = @GLACCOUNTID AND 
	[ROWVERSION]= @ROWVERSION

	
SELECT * FROM @output