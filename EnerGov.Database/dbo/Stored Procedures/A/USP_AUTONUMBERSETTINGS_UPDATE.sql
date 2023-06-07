﻿CREATE PROCEDURE [dbo].[USP_AUTONUMBERSETTINGS_UPDATE]
(
	@CLASSNAME NVARCHAR(250),
	@FORMATSTRING NVARCHAR(50),
	@PADWITHZEROSTOLENGTH INT,
	@NEXTVALUE INT,
	@USERESET BIT,
	@LASTRESET DATETIME
)
AS
UPDATE [dbo].[AUTONUMBERSETTINGS] SET
	[FORMATSTRING] = @FORMATSTRING,
	[PADWITHZEROSTOLENGTH] = @PADWITHZEROSTOLENGTH,
	[NEXTVALUE] = @NEXTVALUE,
	[USERESET] = @USERESET,
	[LASTRESET] = @LASTRESET
WHERE
	[CLASSNAME] = @CLASSNAME