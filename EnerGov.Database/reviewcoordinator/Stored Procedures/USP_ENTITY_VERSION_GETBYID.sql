﻿CREATE PROCEDURE [reviewcoordinator].[USP_ENTITY_VERSION_GETBYID]
	@ID CHAR(36)
AS
BEGIN

SET NOCOUNT ON;

SELECT PMPERMITID ENTITYID, ROWVERSION FROM PMPERMIT WHERE PMPERMITID = @ID
UNION ALL
SELECT PLPLANID ENTITYID, ROWVERSION FROM PLPLAN WHERE PLPLANID = @ID

END