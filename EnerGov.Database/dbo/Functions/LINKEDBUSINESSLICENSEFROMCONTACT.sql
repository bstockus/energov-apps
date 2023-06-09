﻿CREATE FUNCTION DBO.LINKEDBUSINESSLICENSEFROMCONTACT
(	
	@ENTITY_ID char(36),
	@USER_ID char(36),
	@BLLICENSETYPEMODULE_ID INT
)
RETURNS TABLE 
AS
RETURN 
(		
	SELECT DISTINCT bl.BLLICENSEID from BLLICENSECONTACT blc
	INNER JOIN BLLICENSE bl on blc.BLLICENSEID = bl.BLLICENSEID	
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on bl.BLLICENSETYPEID = u.RECORDTYPEID
	INNER JOIN BLLICENSETYPE ON BLLICENSETYPE.BLLICENSETYPEID= bl.BLLICENSETYPEID
	where blc.GLOBALENTITYID = @ENTITY_ID AND BLLICENSETYPE.BLLICENSETYPEMODULEID=@BLLICENSETYPEMODULE_ID	 
)