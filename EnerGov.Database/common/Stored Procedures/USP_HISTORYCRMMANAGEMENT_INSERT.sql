﻿CREATE PROCEDURE [common].[USP_HISTORYCRMMANAGEMENT_INSERT]
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
DECLARE @OUTPUTTABLE as TABLE([HISTORYCRMMANAGEMENTID] int)
INSERT INTO [dbo].[HISTORYCRMMANAGEMENT](
	[ID],
	[ROWVERSION],
	[CHANGEDON],
	[CHANGEDBY],
	[FIELDNAME],
	[OLDVALUE],
	[NEWVALUE],
	[ADDITIONALINFO]
)
OUTPUT inserted.[HISTORYCRMMANAGEMENTID] INTO @OUTPUTTABLE
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