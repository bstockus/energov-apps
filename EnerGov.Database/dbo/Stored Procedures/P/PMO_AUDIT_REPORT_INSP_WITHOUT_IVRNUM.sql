﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_INSP_WITHOUT_IVRNUM]
AS

SELECT NAME AS INSPECTION_TYPE, IVRNUMBER
FROM IMINSPECTIONTYPE
WHERE IVRNUMBER IS NULL or IVRNUMBER=''
