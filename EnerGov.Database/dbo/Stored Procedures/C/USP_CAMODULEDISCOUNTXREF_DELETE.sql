﻿CREATE PROCEDURE [dbo].[USP_CAMODULEDISCOUNTXREF_DELETE]
(
@CAMODULEDISCOUNTXREFID CHAR(36)
)
AS
DELETE FROM [dbo].[CAMODULEDISCOUNTXREF]
WHERE
	[CAMODULEDISCOUNTXREFID] = @CAMODULEDISCOUNTXREFID