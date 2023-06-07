﻿CREATE FUNCTION DBO.LINKEDINSPECTIONFROMCONTACT
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT IMINSPECTION.IMINSPECTIONID from IMINSPECTIONCONTACT 
	INNER JOIN IMINSPECTION ON IMINSPECTIONCONTACT.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID 
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on IMINSPECTION.IMINSPECTIONTYPEID = u.RECORDTYPEID
	where IMINSPECTIONCONTACT.GLOBALENTITYID = @ENTITY_ID	
)

