﻿CREATE PROCEDURE [dbo].[USP_VALUATIONVARIABLE_INSERT]
(
	@VALUATIONVARIABLEID CHAR(36),
	@VALUATIONTYPEID CHAR(36),
	@VALUATIONGROUPID CHAR(36),
	@VARIABLE NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[VALUATIONVARIABLE](
	[VALUATIONVARIABLEID],
	[VALUATIONTYPEID],
	[VALUATIONGROUPID],
	[VARIABLE],
	[DESCRIPTION],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@VALUATIONVARIABLEID,
	@VALUATIONTYPEID,
	@VALUATIONGROUPID,
	@VARIABLE,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE