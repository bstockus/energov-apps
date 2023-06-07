﻿CREATE PROCEDURE [dbo].[USP_TXREMITTANCEEVENTQUEUE_UPDATE]
(
@EVENTQUEUEID AS BIGINT,
@EVENTSTATUSID INT
)
AS  
BEGIN  
	SET NOCOUNT ON;
	UPDATE [dbo].[TXREMITTANCEEVENTQUEUE]
	SET 
		PROCESSEDDATE = GETDATE(),
		EVENTSTATUSID = @EVENTSTATUSID
	WHERE [dbo].[TXREMITTANCEEVENTQUEUE].[TXREMITTANCEEVENTQUEUEID] = @EVENTQUEUEID

END