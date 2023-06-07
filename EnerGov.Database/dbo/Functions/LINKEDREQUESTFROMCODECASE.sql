﻿CREATE FUNCTION DBO.LINKEDREQUESTFROMCODECASE
(	
	@ENTITY_ID char(36),
	@USER_ID as CHAR(36)
)
RETURNS TABLE 
AS
RETURN 
(
SELECT list.CITIZENREQUESTID
FROM CITIZENREQUESTATTACHEDCASELIST  list
INNER JOIN CITIZENREQUEST request on list.CITIZENREQUESTID = request.CITIZENREQUESTID
INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on request.CITIZENREQUESTTYPEID = u.RECORDTYPEID
WHERE REQUESTATTACHEDCASETYPEID = 'BF1483A4-C57A-4463-ADC1-5F3B9293B3D4'
AND ATTACHEDCASEID = @ENTITY_ID
)