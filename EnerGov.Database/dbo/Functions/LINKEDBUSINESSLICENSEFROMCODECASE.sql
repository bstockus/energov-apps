﻿CREATE FUNCTION DBO.LINKEDBUSINESSLICENSEFROMCODECASE
(	
	@ENTITY_ID char(36),
	@USER_ID char(36),
	@BLLICENSETYPEMODULE_ID INT
)
RETURNS TABLE 
AS
RETURN 
(
		select license.BLLICENSEID from CMCODECASEACTIONREF xref
		INNER JOIN BLLICENSE license on xref.PARENTCASEID = license.BLLICENSEID		
		INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on license.BLLICENSETYPEID = u.RECORDTYPEID
		INNER JOIN BLLICENSETYPE ON BLLICENSETYPE.BLLICENSETYPEID= license.BLLICENSETYPEID
		where xref.CMCODECASEID = @ENTITY_ID AND BLLICENSETYPE.BLLICENSETYPEMODULEID=@BLLICENSETYPEMODULE_ID	 
)