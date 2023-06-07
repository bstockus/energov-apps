﻿CREATE PROCEDURE [incidentrequest].[USP_CITIZENREQUESTNOTE_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[TEXT],
	[USERS].[FNAME]+' '+[USERS].[LNAME],
	[CREATEDDATE]
FROM [dbo].[CITIZENREQUESTNOTE]
LEFT JOIN [USERS] ON [USERS].[SUSERGUID] = [CITIZENREQUESTNOTE].[CREATEDBY]
WHERE
	CITIZENREQUESTID= @PARENTID 

END