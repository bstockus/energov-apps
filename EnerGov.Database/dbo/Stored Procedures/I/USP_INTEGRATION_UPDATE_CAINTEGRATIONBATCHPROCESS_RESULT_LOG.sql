﻿CREATE PROCEDURE [dbo].[USP_INTEGRATION_UPDATE_CAINTEGRATIONBATCHPROCESS_RESULT_LOG]
	@RESULT_LOG AS VARBINARY(MAX),
	@PROCESSED_DATE AS DATETIME,
	@BATCH_ID AS NVARCHAR(50)
AS

BEGIN

UPDATE CAINTEGRATIONBATCHPROCESS 
SET 
RESULT_LOG = @RESULT_LOG, 
PROCESSED_DATE = @PROCESSED_DATE 
WHERE FINANCEBATCHID = @BATCH_ID

END