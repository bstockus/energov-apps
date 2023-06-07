﻿CREATE PROCEDURE [dbo].[USP_ADVANCEDSEARCHSORTFIELD_UPDATE]
(
	@ADVANCEDSEARCHSORTFIELDID CHAR(36),
	@SEARCHCRITERIAID CHAR(36),
	@FIELDID INT,
	@CUSTOMFIELDID CHAR(36),
	@DESCENDING BIT
)
AS
UPDATE [dbo].[ADVANCEDSEARCHSORTFIELD] SET
	[ADVANCEDSEARCHSORTFIELDID] = @ADVANCEDSEARCHSORTFIELDID,
	[SEARCHCRITERIAID] = @SEARCHCRITERIAID,
	[FIELDID] = @FIELDID,
	[CUSTOMFIELDID] = @CUSTOMFIELDID,
	[DESCENDING] = @DESCENDING

WHERE
	[ADVANCEDSEARCHSORTFIELDID] = @ADVANCEDSEARCHSORTFIELDID