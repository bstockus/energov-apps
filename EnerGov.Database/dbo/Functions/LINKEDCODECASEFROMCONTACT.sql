﻿CREATE FUNCTION DBO.LINKEDCODECASEFROMCONTACT
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT DISTINCT CMCODECASE.CMCODECASEID, 0 AS ISCHILD, 1 AS ISPARENT from CMCODECASECONTACT
	INNER JOIN CMCODECASE ON CMCODECASECONTACT.CMCODECASEID = CMCODECASE.CMCODECASEID
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on CMCODECASE.CMCASETYPEID = u.RECORDTYPEID
	where CMCODECASECONTACT.GLOBALENTITYID = @ENTITY_ID	
)
