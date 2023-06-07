﻿CREATE FUNCTION DBO.LINKEDBUSINESSLICENSEFROMBUSINESS
(	
	@ENTITY_ID char(36),
	@USER_ID char(36),
	@BLLICENSETYPEMODULE_ID INT

)
RETURNS TABLE 
AS
RETURN 
(		
		select bl.BLLICENSEID from BLLICENSE bl
		INNER JOIN BLGLOBALENTITYEXTENSION blg on bl.BLGLOBALENTITYEXTENSIONID = blg.BLGLOBALENTITYEXTENSIONID
		INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on bl.BLLICENSETYPEID = u.RECORDTYPEID
		INNER JOIN BLLICENSETYPE ON BLLICENSETYPE.BLLICENSETYPEID= bl.BLLICENSETYPEID
		where(blg.BLGLOBALENTITYEXTENSIONID = @ENTITY_ID AND BLLICENSETYPE.BLLICENSETYPEMODULEID=@BLLICENSETYPEMODULE_ID)	 
)