﻿CREATE FUNCTION DBO.LINKEDBUSINESSLICENSEFROMPLAN
(	
	@ENTITY_ID char(36),
	@USER_ID char(36),
	@BLLICENSETYPEMODULE_ID INT
)
RETURNS TABLE 
AS
RETURN 
(		
		select license.BLLICENSEID from PLPLANACTIONREF xref
		INNER JOIN BLLICENSEWFACTIONSTEP blActionStep on xref.OBJECTID = blActionStep.BLLICENSEWFACTIONSTEPID
		INNER JOIN BLLICENSEWFSTEP blStep on blActionStep.BLLICENSEWFSTEPID = blStep.BLLICENSEWFSTEPID
		INNER JOIN BLLICENSE license on blStep.BLLICENSEID = license.BLLICENSEID
		INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on license.BLLICENSETYPEID = u.RECORDTYPEID
		INNER JOIN BLLICENSETYPE ON BLLICENSETYPE.BLLICENSETYPEID= license.BLLICENSETYPEID
		where(xref.PLPLANID = @ENTITY_ID AND BLLICENSETYPE.BLLICENSETYPEMODULEID=@BLLICENSETYPEMODULE_ID)	 
)