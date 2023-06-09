﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_NOTE_GETBYPARENTID] 
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[GLOBALENTITYNOTE].[TEXT],
	[GLOBALENTITYNOTE].[CREATEDDATE],
	[GLOBALENTITYNOTE].[CREATEDBY]
FROM [GLOBALENTITYNOTE]
INNER JOIN [GLOBALENTITY]
ON [GLOBALENTITYNOTE].GLOBALENTITYID = [GLOBALENTITY].GLOBALENTITYID
WHERE
	[GLOBALENTITY].[GLOBALENTITYID] = @PARENTID
END