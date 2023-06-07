﻿CREATE PROCEDURE [dbo].[SP_CLEANUP_FTPQUEUE]
	@maxProcessedDate DATETIME
AS
BEGIN
	DELETE FROM [dbo].[FTPQUEUE] 
	WHERE [dbo].[FTPQUEUE].[PROCESSEDDATE] < @maxProcessedDate
	AND [FTPQUEUE].[FTPSTATUSID] = 3
		
END