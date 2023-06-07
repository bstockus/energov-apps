﻿CREATE PROCEDURE [dbo].[USP_EXAMLOCATION_UPDATE]
(
	@EXAMLOCATIONID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@PAPERBASEDSEATS INT,
	@PCBASEDSEATS INT,
	@SITTINGDATEAVAILABILITYID INT,
	@ACTIVE BIT,
	@PROMPTLOCATIONDETAILS BIT,
	@RECURRENCEID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[EXAMLOCATION] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[PAPERBASEDSEATS] = @PAPERBASEDSEATS,
	[PCBASEDSEATS] = @PCBASEDSEATS,
	[SITTINGDATEAVAILABILITYID] = @SITTINGDATEAVAILABILITYID,
	[ACTIVE] = @ACTIVE,
	[PROMPTLOCATIONDETAILS] = @PROMPTLOCATIONDETAILS,
	[RECURRENCEID] = @RECURRENCEID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[EXAMLOCATIONID] = @EXAMLOCATIONID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE