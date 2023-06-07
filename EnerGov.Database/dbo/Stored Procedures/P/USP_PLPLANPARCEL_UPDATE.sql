﻿CREATE PROCEDURE [dbo].[USP_PLPLANPARCEL_UPDATE]
(
	@PLPLANPARCELID CHAR(36),
	@MAIN BIT,
	@PARCELSPLITPROCESS BIT
)
AS
BEGIN
UPDATE [dbo].[PLPLANPARCEL] SET [MAIN] = @MAIN,[PARCELSPLITPROCESS] = @PARCELSPLITPROCESS
		WHERE [PLPLANPARCELID] = @PLPLANPARCELID
END