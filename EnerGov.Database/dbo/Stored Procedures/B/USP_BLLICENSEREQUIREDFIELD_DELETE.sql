﻿CREATE PROCEDURE [dbo].[USP_BLLICENSEREQUIREDFIELD_DELETE]
(
@BLREQUIREDCUSTOMFIELD CHAR(36)
)
AS
DELETE FROM [dbo].[BLLICENSEREQUIREDFIELD]
WHERE
	[BLREQUIREDCUSTOMFIELD] = @BLREQUIREDCUSTOMFIELD