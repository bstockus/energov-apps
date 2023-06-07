﻿CREATE FUNCTION DBO.LINKEDRENEWALCASEFROMPERMIT
(	
	@ENTITY_ID char(36),
	@USER_ID as CHAR(36)
)
RETURNS TABLE 
AS
RETURN 
(
	select PMRENEWALCASEPERMIT.PMRENEWALCASEID from PMRENEWALCASEPERMIT 
	INNER JOIN PMRENEWALCASE ON PMRENEWALCASEPERMIT .PMRENEWALCASEID = PMRENEWALCASE.PMRENEWALCASEID 
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on PMRENEWALCASE.PMRENEWALCASETYPEID = u.RECORDTYPEID
	where PMPERMITID = @ENTITY_ID
)
