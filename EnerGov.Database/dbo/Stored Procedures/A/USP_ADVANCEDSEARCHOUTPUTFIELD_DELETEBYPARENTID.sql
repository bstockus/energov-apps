﻿CREATE PROCEDURE [dbo].[USP_ADVANCEDSEARCHOUTPUTFIELD_DELETEBYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[ADVANCEDSEARCHOUTPUTFIELD]
WHERE
	[SEARCHCRITERIAID] = @PARENTID