﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_PLAN_STATUSES_WITHOUT_DESCR]
AS

SELECT NAME AS STATUS, DESCRIPTION
FROM PLPLANSTATUS
WHERE DESCRIPTION IS NULL or DESCRIPTION=''

