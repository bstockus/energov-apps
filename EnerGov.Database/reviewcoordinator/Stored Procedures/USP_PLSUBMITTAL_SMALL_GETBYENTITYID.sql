﻿CREATE PROCEDURE [reviewcoordinator].[USP_PLSUBMITTAL_SMALL_GETBYENTITYID]
	@ENTITYID CHAR(36)
AS
BEGIN

SET NOCOUNT ON;
SELECT TOP 1
	PLSUBMITTAL.PLSUBMITTALID,
	PLSUBMITTALTYPE.TYPENAME
FROM PLSUBMITTAL
INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
WHERE (PLSUBMITTAL.PMPERMITID = @ENTITYID OR PLSUBMITTAL.PLPLANID = @ENTITYID) AND PLSUBMITTAL.COMPLETED = 0
order by PLSUBMITTAL.DUEDATE

END