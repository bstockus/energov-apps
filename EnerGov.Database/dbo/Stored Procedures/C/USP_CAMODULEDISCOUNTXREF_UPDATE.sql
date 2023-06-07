﻿CREATE PROCEDURE [dbo].[USP_CAMODULEDISCOUNTXREF_UPDATE]
(
	@CAMODULEDISCOUNTXREFID CHAR(36),
	@CAMODULEID INT,
	@CADISCOUNTID CHAR(36)
)
AS

UPDATE [dbo].[CAMODULEDISCOUNTXREF] SET
	[CAMODULEID] = @CAMODULEID,
	[CADISCOUNTID] = @CADISCOUNTID

WHERE
	[CAMODULEDISCOUNTXREFID] = @CAMODULEDISCOUNTXREFID