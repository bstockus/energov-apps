﻿CREATE PROCEDURE [dbo].[USP_PMPERMITSTATUS_UPDATE]
(
	@PMPERMITSTATUSID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@HOLDFLAG BIT,
	@COMPLETEDFLAG BIT,
	@ISSUEDFLAG BIT,
	@FAILUREFLAG BIT,
	@CANCELLEDFLAG BIT,
	@DESCRIPTION_SPANISH NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @output AS TABLE ([RowVersion] INT)

UPDATE [dbo].[PMPERMITSTATUS] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[HOLDFLAG] = @HOLDFLAG,
	[COMPLETEDFLAG] = @COMPLETEDFLAG,
	[ISSUEDFLAG] = @ISSUEDFLAG,
	[FAILUREFLAG] = @FAILUREFLAG,
	[CANCELLEDFLAG] = @CANCELLEDFLAG,
	[DESCRIPTION_SPANISH] = @DESCRIPTION_SPANISH,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @output
WHERE
	[PMPERMITSTATUSID] = @PMPERMITSTATUSID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @output