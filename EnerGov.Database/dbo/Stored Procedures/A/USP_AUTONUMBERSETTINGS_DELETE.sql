﻿CREATE PROCEDURE [dbo].[USP_AUTONUMBERSETTINGS_DELETE]
(
@CLASSNAME NVARCHAR(250)
)
AS
DELETE FROM [dbo].[AUTONUMBERSETTINGS]
WHERE
	[CLASSNAME] = @CLASSNAME