﻿CREATE PROCEDURE [dbo].[USP_GISHISTORYQUEUE_RESET_RETRY_COUNT]
(
	@RETRYCOUNT INT,
	@SENTTOBUS BIT,
	@ISWRITTENTOGIS BIT
)
AS
UPDATE [dbo].[GISHISTORYQUEUE] SET
	[RETRYCOUNT] = @RETRYCOUNT,
	[SENTTOBUS] = @SENTTOBUS
WHERE
	[ISWRITTENTOGIS] = @ISWRITTENTOGIS