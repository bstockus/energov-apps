﻿CREATE PROCEDURE [dbo].[USP_ROLERECORDTYPEXREF_DELETE_BYUSERROLEID]
(
	@ROLEID CHAR(36)
)
AS
DELETE FROM [dbo].[ROLERECORDTYPEXREF]
WHERE
	[ROLEID] = @ROLEID