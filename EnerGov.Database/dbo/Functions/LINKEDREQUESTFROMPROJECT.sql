﻿CREATE FUNCTION DBO.LINKEDREQUESTFROMPROJECT
(	
	@ENTITY_ID char(36),
	@USER_ID as CHAR(36)
)
RETURNS TABLE 
AS
RETURN 
(
	Select PRPROJECTCITIZENREQUEST.CITIZENREQUESTID FROM PRPROJECTCITIZENREQUEST 
	INNER JOIN CITIZENREQUEST ON PRPROJECTCITIZENREQUEST.CITIZENREQUESTID = CITIZENREQUEST.CITIZENREQUESTID 
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on CITIZENREQUEST.CITIZENREQUESTTYPEID = u.RECORDTYPEID
	WHERE PRPROJECTCITIZENREQUEST.PRPROJECTID = @ENTITY_ID

)