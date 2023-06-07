﻿CREATE PROCEDURE [common].[USP_HISTORYOBJECTMANAGEMENT_INSERT]
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
DECLARE @OUTPUTTABLE as TABLE([HISTORYOBJECTMANAGEMENTID] int)
INSERT INTO [dbo].[HISTORYOBJECTMANAGEMENT](
	[ID],
	[ROWVERSION],
	[CHANGEDON],
	[CHANGEDBY],
	[FIELDNAME],
	[OLDVALUE],
	[NEWVALUE],
	[ADDITIONALINFO]
)
OUTPUT inserted.[HISTORYOBJECTMANAGEMENTID] INTO @OUTPUTTABLE
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