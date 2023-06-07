﻿CREATE PROCEDURE [dbo].[USP_ATTACHMENTGROUPROLEXREF_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
	DELETE FROM [dbo].[ATTACHMENTGROUPROLEXREF]
	WHERE [dbo].[ATTACHMENTGROUPROLEXREF].[ROLEID] = @PARENTID 
END