﻿CREATE FUNCTION DBO.LINKEDIMPACTCASESFROMCONTACT
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(				
		SELECT DISTINCT oneImpactCase.IPCASEID FROM IPCASECONTACT xref	
		INNER JOIN IPCASE oneImpactCase ON xref.IPCASEID = oneImpactCase.IPCASEID
		INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u ON oneImpactCase.IPCASETYPEID = u.RECORDTYPEID		
		WHERE xref.GLOBALENTITYID = @ENTITY_ID
)