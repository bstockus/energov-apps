﻿CREATE PROCEDURE [dbo].[USP_CADISCOUNTSETUP_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
	DELETE FROM [dbo].[CADISCOUNTSETUP] 
	WHERE  [dbo].[CADISCOUNTSETUP].[CADISCOUNTID] =@PARENTID 
END