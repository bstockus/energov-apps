﻿CREATE PROCEDURE [dbo].[USP_MEETINGCASETYPE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[MEETINGCASETYPE]
WHERE
	[MEETINGTYPEID] = @PARENTID