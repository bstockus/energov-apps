﻿CREATE FUNCTION DBO.LINKEDPERMITFROMBUSINESSLICENSE
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
	Select PMPERMIT.PMPERMITID, 1 AS ISCHILD, 0 AS ISPARENT FROM BLLICENSEWFSTEP  
	INNER JOIN BLLICENSEWFACTIONSTEP ON BLLICENSEWFSTEP.BLLICENSEWFSTEPID = BLLICENSEWFACTIONSTEP.BLLICENSEWFSTEPID  
	INNER JOIN BLLICENSE ON  BLLICENSEWFSTEP.BLLICENSEID = BLLICENSE.BLLICENSEID  
	INNER JOIN PMPERMITACTIONREF ON BLLICENSEWFACTIONSTEP.BLLICENSEWFACTIONSTEPID = PMPERMITACTIONREF.OBJECTID 
	INNER JOIN PMPERMIT ON PMPERMITACTIONREF.PMPERMITID = PMPERMIT.PMPERMITID 
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on PMPERMIT.PMPERMITTYPEID = u.RECORDTYPEID
	WHERE(BLLICENSE.BLLICENSEID  = @ENTITY_ID)  
	UNION ALL SELECT PMPERMIT.PMPERMITID, 0 AS ISCHILD, 1 AS ISPARENT FROM BLLICENSEACTIONREF  
	INNER JOIN BLLICENSE on BLLICENSEACTIONREF.BLLICENSEID = BLLICENSE.BLLICENSEID  
	INNER JOIN PMPERMITWFACTIONSTEP ON BLLICENSEACTIONREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID  
	INNER JOIN PMPERMITWFSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID  
	INNER JOIN PMPERMIT ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID  
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on PMPERMIT.PMPERMITTYPEID = u.RECORDTYPEID
	WHERE(BLLICENSEACTIONREF.BLLICENSEID = @ENTITY_ID)
	 
)