﻿CREATE PROCEDURE [dbo].[USP_OMOBJECTCLASSIFICATION_DELETE]
(
	@OMOBJECTCLASSIFICATIONID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[OMOBJECTCLASSIFICATION]
WHERE
	[OMOBJECTCLASSIFICATIONID] = @OMOBJECTCLASSIFICATIONID AND 
	[ROWVERSION]= @ROWVERSION