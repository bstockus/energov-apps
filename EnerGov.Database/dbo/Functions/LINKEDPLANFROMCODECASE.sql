﻿CREATE FUNCTION DBO.LINKEDPLANFROMCODECASE
(	
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT PLPLAN.PLPLANID,0 as ISCHILD , 1 as ISPARENT	FROM CMCODECASEACTIONREF
	INNER JOIN PLPLANWFACTIONSTEP ON CMCODECASEACTIONREF.CMCODECASEACTIONREFID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID 
	INNER JOIN PLPLANWFSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
	INNER JOIN PLPLAN ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
	INNER JOIN CMCODECASE ON CMCODECASEACTIONREF.CMCODECASEID = CMCODECASE.CMCODECASEID
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on PLPLAN.PLPLANTYPEID = u.RECORDTYPEID
	WHERE (CMCODECASEACTIONREF.CMCODECASEID = @ENTITY_ID)
	UNION ALL 
	SELECT PLPLAN.PLPLANID,1 as ISCHILD , 0 as ISPARENT	FROM CMCODECASE
	INNER JOIN CMCODEWFSTEP ON CMCODECASE.CMCODECASEID = CMCODEWFSTEP.CMCODECASEID
	INNER JOIN CMCODEWFACTIONSTEP ON CMCODEWFSTEP.CMCODEWFSTEPID = CMCODEWFACTIONSTEP.CMCODEWFSTEPID
	INNER JOIN PLPLANACTIONREF ON CMCODEWFACTIONSTEP.CMCODEWFACTIONSTEPID = PLPLANACTIONREF.OBJECTID
	INNER JOIN PLPLAN ON PLPLANACTIONREF.PLPLANID = PLPLAN.PLPLANID
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u on PLPLAN.PLPLANTYPEID = u.RECORDTYPEID
	WHERE (CMCODECASE.CMCODECASEID = @ENTITY_ID)
)