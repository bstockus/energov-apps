﻿

CREATE PROCEDURE [dbo].[rpt_IM_Inspection_Worksheet_Inspector]
@INSPECTIONID AS VARCHAR(36)
AS
SELECT USERS.FNAME + ' ' + USERS.LNAME AS Inspector, IMINSPECTORREF.BPRIMARY AS MainInspector
FROM IMINSPECTORREF 
INNER JOIN USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID
WHERE IMINSPECTORREF.INSPECTIONID = @INSPECTIONID

