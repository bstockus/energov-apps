﻿CREATE PROCEDURE [dbo].[USP_TYLERCASHIERINGUSERUPDATEQUEUE_DELETE_BYPARENTID]
(
	@USERGUID CHAR(36)
)
AS
DELETE FROM [dbo].[TYLERCASHIERINGUSERUPDATEQUEUE]
WHERE 
	[USERGUID] = @USERGUID