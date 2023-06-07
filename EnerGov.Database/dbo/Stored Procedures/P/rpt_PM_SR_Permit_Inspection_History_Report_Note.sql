﻿
CREATE PROCEDURE rpt_PM_SR_Permit_Inspection_History_Report_Note
@INSPECTIONID AS VARCHAR(36)
AS
BEGIN
SELECT     IMINSPECTIONNOTE.TEXT, IMINSPECTIONNOTE.CREATEDDATE, USERS.FNAME, USERS.LNAME, IMINSPECTIONNOTE.IMINSPECTIONNOTEID
FROM         IMINSPECTIONNOTE INNER JOIN
                      USERS ON IMINSPECTIONNOTE.CREATEDBY = USERS.SUSERGUID
WHERE IMINSPECTIONNOTE.IMINSPECTIONID = @INSPECTIONID
END
