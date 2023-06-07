﻿CREATE PROCEDURE [dbo].[USP_PMPERMITSTATUS_INSERT]
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

INSERT INTO [dbo].[PMPERMITSTATUS](
	[PMPERMITSTATUSID],
	[NAME],
	[DESCRIPTION],
	[HOLDFLAG],
	[COMPLETEDFLAG],
	[ISSUEDFLAG],
	[FAILUREFLAG],
	[CANCELLEDFLAG],
	[DESCRIPTION_SPANISH],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] 
INTO @output
VALUES
(
	@PMPERMITSTATUSID,
	@NAME,
	@DESCRIPTION,
	@HOLDFLAG,
	@COMPLETEDFLAG,
	@ISSUEDFLAG,
	@FAILUREFLAG,
	@CANCELLEDFLAG,
	@DESCRIPTION_SPANISH,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)

SELECT * FROM @output