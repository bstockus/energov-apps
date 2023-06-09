﻿CREATE PROCEDURE [incidentrequest].[USP_CITIZENREQUESTCALLERXREF_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[GLOBALENTITY].[GLOBALENTITYNAME],
	[GLOBALENTITY].[FIRSTNAME],
	[GLOBALENTITY].[LASTNAME],
	[GLOBALENTITY].[EMAIL],
	[GLOBALENTITY].[MOBILEPHONE],
	[CMCODECASECONTACTTYPE].[NAME],
	[GLOBALENTITY].[CONTACTID],
	[GLOBALENTITY].[GLOBALENTITYID]
FROM [CITIZENREQUESTCALLERXREF]
	INNER JOIN [GLOBALENTITY] ON [GLOBALENTITY].[GLOBALENTITYID] = [CITIZENREQUESTCALLERXREF].[GLOBALENTITYID]
	LEFT JOIN [CMCODECASECONTACTTYPE] ON [CMCODECASECONTACTTYPE].[CMCODECASECONTACTTYPEID] =[CITIZENREQUESTCALLERXREF].[CMCODECASECONTACTTYPEID]
WHERE 
	[CITIZENREQUESTCALLERXREF].CITIZENREQUESTID = @PARENTID  

END