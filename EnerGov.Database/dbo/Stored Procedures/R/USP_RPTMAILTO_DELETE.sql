﻿CREATE PROCEDURE [dbo].[USP_RPTMAILTO_DELETE]
(
@RPTMAILTOID CHAR(36)
)
AS
DELETE FROM [dbo].[RPTMAILTO]
WHERE
	[RPTMAILTOID] = @RPTMAILTOID