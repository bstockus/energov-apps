﻿CREATE PROCEDURE [dbo].[USP_BLLICENSEREQUIREDFIELD_UPDATE]
(
	@BLREQUIREDCUSTOMFIELD CHAR(36),
	@SORTORDER INT
)
AS

UPDATE [dbo].[BLLICENSEREQUIREDFIELD] 
SET	[SORTORDER] = @SORTORDER

WHERE
	[BLREQUIREDCUSTOMFIELD] = @BLREQUIREDCUSTOMFIELD