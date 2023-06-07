﻿CREATE PROCEDURE [dbo].[USP_CAMODULEDISCOUNTXREF_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
	DELETE FROM [dbo].[CAMODULEDISCOUNTXREF] 
	WHERE  [dbo].[CAMODULEDISCOUNTXREF].[CADISCOUNTID] =@PARENTID 
END