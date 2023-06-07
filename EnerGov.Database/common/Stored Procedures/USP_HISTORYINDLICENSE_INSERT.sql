﻿CREATE PROCEDURE [common].[USP_HISTORYINDLICENSE_INSERT]
(
	@ID CHAR(36),
	@ROWVERSION INT,
	@CHANGEDON DATETIME,
	@CHANGEDBY CHAR(36),
	@FIELDNAME NVARCHAR(250),
	@OLDVALUE NVARCHAR(MAX),
	@NEWVALUE NVARCHAR(MAX),
	@ADDITIONALINFO NVARCHAR(MAX)
)
AS
DECLARE @OUTPUTTABLE as TABLE([HISTORYINDLICENSEID] int)
INSERT INTO [dbo].[HISTORYINDLICENSE](
	[ID],
	[ROWVERSION],
	[CHANGEDON],
	[CHANGEDBY],
	[FIELDNAME],
	[OLDVALUE],
	[NEWVALUE],
	[ADDITIONALINFO]
)
OUTPUT inserted.[HISTORYINDLICENSEID] INTO @OUTPUTTABLE
VALUES
(
	@ID,
	@ROWVERSION,
	@CHANGEDON,
	@CHANGEDBY,
	@FIELDNAME,
	@OLDVALUE,
	@NEWVALUE,
	@ADDITIONALINFO
)
SELECT * FROM @OUTPUTTABLE