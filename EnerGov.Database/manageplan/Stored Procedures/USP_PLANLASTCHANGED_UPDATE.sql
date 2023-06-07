﻿CREATE PROCEDURE [manageplan].[USP_PLANLASTCHANGED_UPDATE]
(
	@PLPLANID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
BEGIN
UPDATE [dbo].[PLPLAN] SET 
			[ROWVERSION] = [ROWVERSION] + 1, 
			[LASTCHANGEDON] = @LASTCHANGEDON,
			[LASTCHANGEDBY] = @LASTCHANGEDBY
		OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
		WHERE [PLPLANID] = @PLPLANID
SELECT * FROM @OUTPUTTABLE
END