﻿CREATE PROCEDURE [dbo].[USP_PENDING_CAP_CONTACT_UPDATE]
(
	@GLOBALENTITYID CHAR(36),	
	@ROWVERSION INT,	
	@ISACTIVE BIT,
	@LASTCHANGEDBY CHAR(36),	
	@LASTCHANGEDON DATETIME
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[GLOBALENTITY] SET	
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[ROWVERSION] = @ROWVERSION + 1,	
	[ISACTIVE] = @ISACTIVE
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[GLOBALENTITYID] = @GLOBALENTITYID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE