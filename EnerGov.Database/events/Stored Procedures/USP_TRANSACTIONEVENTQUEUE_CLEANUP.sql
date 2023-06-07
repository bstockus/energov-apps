﻿CREATE PROCEDURE [events].[USP_TRANSACTIONEVENTQUEUE_CLEANUP]
@PROCESSEDDATELIMIT DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[TRANSACTIONEVENTQUEUE] 
					WHERE [dbo].[TRANSACTIONEVENTQUEUE].[PROCESSEDDATE] < @PROCESSEDDATELIMIT
		
END