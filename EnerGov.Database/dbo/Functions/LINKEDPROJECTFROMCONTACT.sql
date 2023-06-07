﻿CREATE FUNCTION DBO.LINKEDPROJECTFROMCONTACT
(	
	@ENTITY_ID char(36),
	@USER_ID as CHAR(36)	
)
RETURNS TABLE 
AS
RETURN 
(
	select DISTINCT PRPROJECTCONTACT.PRPROJECTID from PRPROJECTCONTACT
	INNER JOIN PRPROJECT ON PRPROJECTCONTACT.PRPROJECTID = PRPROJECT.PRPROJECTID
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on PRPROJECT.PRPROJECTTYPEID = u.RECORDTYPEID
	where PRPROJECTCONTACT.GLOBALENTITYID  = @ENTITY_ID
)