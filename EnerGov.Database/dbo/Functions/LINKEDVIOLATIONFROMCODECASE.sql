﻿CREATE FUNCTION DBO.LINKEDVIOLATIONFROMCODECASE
(	
	@ENTITY_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
		select CMVIOLATIONID from CMCODEWFSTEP wfstep INNER JOIN
		CMCODECASE codecase on wfstep.CMCODECASEID = codecase.CMCODECASEID 
		inner join CMVIOLATION violation on wfstep.CMCODEWFSTEPID = violation.CMCODEWFSTEPID
		where codecase.CMCODECASEID = @ENTITY_ID
)