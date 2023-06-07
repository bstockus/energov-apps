﻿CREATE PROCEDURE [dbo].[USP_EXAMTYPE_UPDATE]
(
	@EXAMTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@FRIENDLYNAME NVARCHAR(150),
	@DESCRIPTION NVARCHAR(MAX),
	@EXAMFORMATID INT,
	@DEFAULTEXAMSTATUSID CHAR(36),
	@DEFAULTEXAMLOCATIONID CHAR(36),
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@PREFIX NVARCHAR(20),
	@DAYSUNTILEXPIRE INT,
	@ACTIVE BIT,
	@UNLIMITEDEXPIRATION BIT,
	@SITTINGDATEAVAILABILITYID INT,
	@RECURRENCEID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[EXAMTYPE] SET
	[NAME] = @NAME,
	[FRIENDLYNAME] = @FRIENDLYNAME,
	[DESCRIPTION] = @DESCRIPTION,
	[EXAMFORMATID] = @EXAMFORMATID,
	[DEFAULTEXAMSTATUSID] = @DEFAULTEXAMSTATUSID,
	[DEFAULTEXAMLOCATIONID] = @DEFAULTEXAMLOCATIONID,
	[CUSTOMFIELDLAYOUTID] = @CUSTOMFIELDLAYOUTID,
	[PREFIX] = @PREFIX,
	[DAYSUNTILEXPIRE] = @DAYSUNTILEXPIRE,
	[ACTIVE] = @ACTIVE,
	[UNLIMITEDEXPIRATION] = @UNLIMITEDEXPIRATION,
	[SITTINGDATEAVAILABILITYID] = @SITTINGDATEAVAILABILITYID,
	[RECURRENCEID] = @RECURRENCEID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[EXAMTYPEID] = @EXAMTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE