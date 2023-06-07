﻿CREATE PROCEDURE [dbo].[USP_INTEGRATION_GET_AR_BATCHES_TO_CLOSE]
AS

BEGIN

SELECT DISTINCT CATRANSACTIONARINTEGRATION.BATCHNUMBER
FROM CATRANSACTIONARINTEGRATION
LEFT JOIN CAINTEGRATIONBATCHPROCESS ON CATRANSACTIONARINTEGRATION.BATCHNUMBER = CAINTEGRATIONBATCHPROCESS.BATCH_NUMBER
WHERE CATRANSACTIONARINTEGRATION.BATCHNUMBER IS NOT NULL
AND CAINTEGRATIONBATCHPROCESS.BATCH_NUMBER IS NULL
AND CATRANSACTIONARINTEGRATION.BATCHNUMBER LIKE 'AR-%'

END