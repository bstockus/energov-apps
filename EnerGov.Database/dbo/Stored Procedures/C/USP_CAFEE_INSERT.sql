﻿CREATE PROCEDURE [dbo].[USP_CAFEE_INSERT]
(
	@CAFEEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@ACTIVE BIT,
	@ROWVERSION INT,
	@LASTCHANGEDON DATETIME,
	@LASTCHANGEDBY CHAR(36),
	@CACOMPUTATIONTYPEID INT,
	@NOTES NVARCHAR(MAX),
	@ISTIMETRACKING BIT,
	@ISTAXFEE BIT,
	@ISCPIFEE BIT,
	@ISPRORATEFEE BIT,
	@ISARFEE BIT,
	@ARCREDITACCOUNTID CHAR(36),
	@ARDEBITACCOUNTID CHAR(36),
	@ARFEECODE NVARCHAR(100),
	@SETTLEMENTCODE NVARCHAR(100),
	@APPLYPRORATIONONRENEWAL BIT,
	@ISSUBJECTTOEXTERNALINVOICE BIT,
	@DAYSUNTILEXTERNALINVOICEEXPORT INT,
	@ISEXEMPTFROMFEEWAIVER BIT,
	@JURISDICTIONID CHAR(36),
	@ISCOMPOUNDINGINTERESTFEE BIT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CAFEE](
	[CAFEEID],
	[NAME],
	[DESCRIPTION],
	[ACTIVE],
	[ROWVERSION],
	[LASTCHANGEDON],
	[LASTCHANGEDBY],
	[CACOMPUTATIONTYPEID],
	[NOTES],
	[ISTIMETRACKING],
	[ISTAXFEE],
	[ISCPIFEE],
	[ISPRORATEFEE],
	[ISARFEE],
	[ARCREDITACCOUNTID],
	[ARDEBITACCOUNTID],
	[ARFEECODE],
	[SETTLEMENTCODE],
	[APPLYPRORATIONONRENEWAL],
	[ISSUBJECTTOEXTERNALINVOICE],
	[DAYSUNTILEXTERNALINVOICEEXPORT],
	[ISEXEMPTFROMFEEWAIVER],
	[JURISDICTIONID],
	[ISCOMPOUNDINGINTERESTFEE]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CAFEEID,
	@NAME,
	@DESCRIPTION,
	@ACTIVE,
	@ROWVERSION,
	@LASTCHANGEDON,
	@LASTCHANGEDBY,
	@CACOMPUTATIONTYPEID,
	@NOTES,
	@ISTIMETRACKING,
	@ISTAXFEE,
	@ISCPIFEE,
	@ISPRORATEFEE,
	@ISARFEE,
	@ARCREDITACCOUNTID,
	@ARDEBITACCOUNTID,
	@ARFEECODE,
	@SETTLEMENTCODE,
	@APPLYPRORATIONONRENEWAL,
	@ISSUBJECTTOEXTERNALINVOICE,
	@DAYSUNTILEXTERNALINVOICEEXPORT,
	@ISEXEMPTFROMFEEWAIVER,
	@JURISDICTIONID,
	@ISCOMPOUNDINGINTERESTFEE
)
SELECT * FROM @OUTPUTTABLE