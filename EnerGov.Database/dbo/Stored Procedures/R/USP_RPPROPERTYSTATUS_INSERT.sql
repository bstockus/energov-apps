﻿CREATE PROCEDURE [dbo].[USP_RPPROPERTYSTATUS_INSERT]
(
	@RPPROPERTYSTATUSID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@RPPROPERTYSYSSTATUSID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[RPPROPERTYSTATUS](
	[RPPROPERTYSTATUSID],
	[NAME],
	[DESCRIPTION],
	[RPPROPERTYSYSSTATUSID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@RPPROPERTYSTATUSID,
	@NAME,
	@DESCRIPTION,
	@RPPROPERTYSYSSTATUSID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE