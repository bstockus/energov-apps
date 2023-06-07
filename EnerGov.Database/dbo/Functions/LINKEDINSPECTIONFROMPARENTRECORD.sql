﻿CREATE FUNCTION DBO.LINKEDINSPECTIONFROMPARENTRECORD
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT IMINSPECTIONID from IMINSPECTION 
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on IMINSPECTION.IMINSPECTIONTYPEID = u.RECORDTYPEID
	where IMINSPECTION.LINKID = @ENTITY_ID
)

