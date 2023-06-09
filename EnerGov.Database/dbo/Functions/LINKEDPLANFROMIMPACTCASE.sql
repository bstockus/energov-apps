﻿CREATE FUNCTION [dbo].[LINKEDPLANFROMIMPACTCASE]
(
	@ENTITY_ID char(36),
	@USER_ID char(36)
)
RETURNS TABLE 
AS 
RETURN
(
	SELECT DISTINCT IPCASEPLANXREF.PLPLANID, 1 AS ISCHILD, 0 AS ISPARENT FROM IPCASEPLANXREF
	INNER JOIN PLPLAN ON IPCASEPLANXREF.PLPLANID = PLPLAN.PLPLANID
	INNER JOIN GETUSERVISIBLERECORDTYPES(@USER_ID) u ON PLPLAN.PLPLANTYPEID = u.RECORDTYPEID	
	WHERE IPCASEPLANXREF.IPCASEID = @ENTITY_ID
)