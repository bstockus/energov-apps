﻿CREATE PROCEDURE [dbo].[USP_MEETINGTYPEDATTENDEE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[MEETINGTYPEDATTENDEE]
WHERE
	[MEETINGTYPEID] = @PARENTID