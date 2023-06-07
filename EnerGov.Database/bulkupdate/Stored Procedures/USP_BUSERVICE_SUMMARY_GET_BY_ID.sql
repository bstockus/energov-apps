﻿CREATE PROCEDURE [bulkupdate].[USP_BUSERVICE_SUMMARY_GET_BY_ID]
	@ID char(36)
AS
BEGIN

SELECT
[dbo].[BUSERVICE].[BUSERVICEID], 
		[dbo].[BUSERVICE].[BATCHNUMBER], 
		[dbo].[BUENTITY].[NAME] AS ENTITY, 
		[dbo].[BUSERVICESTATUS].[NAME] AS SERVICESTATUS, 
		BatchRecords.TOTALCOUNT, 
		BatchRecords.PROCESSEDCOUNT, 
		[dbo].[USERS].[FNAME], 
		[dbo].[USERS].[LNAME], 
		[dbo].[BUSERVICE].[CREATEDATE]
		FROM [dbo].[BUSERVICE]
JOIN [bulkupdate].[UDF_GET_BURECORD_COUNTS]() BatchRecords ON [dbo].[BUSERVICE].[BUSERVICEID] = BatchRecords.BUSERVICEID
JOIN [dbo].[USERS] ON [dbo].[BUSERVICE].[CREATEDBY] = [dbo].[USERS].[SUSERGUID]
JOIN [dbo].[BUENTITY] ON [dbo].[BUSERVICE].[ENTITY] = [dbo].[BUENTITY].[BUENTITYID]
JOIN [dbo].[BUSERVICESTATUS] ON [dbo].[BUSERVICE].[SERVICESTATUS] = [dbo].[BUSERVICESTATUS].[BUSERVICESTATUSID]
WHERE [dbo].[BUSERVICE].[BUSERVICEID] = @ID

exec [bulkupdate].[USP_BURECORD_GET_BY_PARENT_ID] @ID

END