﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_WF_SUBMITTAL_SUCCESS_STATUS]
AS

SELECT * FROM PLSUBMITTALSTATUS
WHERE SUCCESSFLAG=1
