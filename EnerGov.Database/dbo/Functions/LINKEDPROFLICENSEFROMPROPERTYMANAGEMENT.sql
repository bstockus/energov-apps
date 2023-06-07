﻿CREATE FUNCTION DBO.LINKEDPROFLICENSEFROMPROPERTYMANAGEMENT
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
		SELECT license.ILLICENSEID FROM ILLICENSEPARCEL licenseParcel 
		INNER JOIN ILLICENSE license ON licenseParcel.ILLICENSEID = license.ILLICENSEID
		INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u ON license.ILLICENSETYPEID = u.RECORDTYPEID
		WHERE licenseParcel.PARCELID = @ENTITY_ID
)