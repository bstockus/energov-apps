﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDWORKSHEETITEM_UPDATE]
(
	@GCUSTOMFIELDWORKSHEETITEM CHAR(36),
	@FKGCUSTOMFIELDWORKSHEET CHAR(36),
	@SVALUE VARCHAR(50),
	@IORDER INT
)
AS

UPDATE [dbo].[CUSTOMFIELDWORKSHEETITEM] SET
	[FKGCUSTOMFIELDWORKSHEET] = @FKGCUSTOMFIELDWORKSHEET,
	[SVALUE] = @SVALUE,
	[IORDER] = @IORDER

WHERE
	[GCUSTOMFIELDWORKSHEETITEM] = @GCUSTOMFIELDWORKSHEETITEM