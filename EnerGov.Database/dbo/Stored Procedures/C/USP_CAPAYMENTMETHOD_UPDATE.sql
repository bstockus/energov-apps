﻿CREATE PROCEDURE [dbo].[USP_CAPAYMENTMETHOD_UPDATE]
(
	@CAPAYMENTMETHODID CHAR(36),
	@CAPAYMENTTYPEID INT,
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@ISACTIVE BIT,
	@REQUIRESSUPPLIMENTALDATA BIT,
	@REQUIRESCOUNTDOWN BIT,
	@ISREFUNDTYPE BIT,
	@SUPPLIMENTALDATANAME NVARCHAR(50),
	@SUPPLIMENTALDATADESCRIPTION NVARCHAR(MAX),
	@ISSYSTEMMETHOD BIT,
	@ISBONDRELEASEMETHOD BIT,
	@INCLUDEBONDRELEASEINTILL BIT,
	@INCLUDEREFUNDINTILLSESSION BIT,
	@FEEWAIVER BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CAPAYMENTMETHOD] SET
	[CAPAYMENTTYPEID] = @CAPAYMENTTYPEID,
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[ISACTIVE] = @ISACTIVE,
	[REQUIRESSUPPLIMENTALDATA] = @REQUIRESSUPPLIMENTALDATA,
	[REQUIRESCOUNTDOWN] = @REQUIRESCOUNTDOWN,
	[ISREFUNDTYPE] = @ISREFUNDTYPE,
	[SUPPLIMENTALDATANAME] = @SUPPLIMENTALDATANAME,
	[SUPPLIMENTALDATADESCRIPTION] = @SUPPLIMENTALDATADESCRIPTION,
	[ISSYSTEMMETHOD] = @ISSYSTEMMETHOD,
	[ISBONDRELEASEMETHOD] = @ISBONDRELEASEMETHOD,
	[INCLUDEBONDRELEASEINTILL] = @INCLUDEBONDRELEASEINTILL,
	[INCLUDEREFUNDINTILLSESSION] = @INCLUDEREFUNDINTILLSESSION,
	[FEEWAIVER] = @FEEWAIVER,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CAPAYMENTMETHODID] = @CAPAYMENTMETHODID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE