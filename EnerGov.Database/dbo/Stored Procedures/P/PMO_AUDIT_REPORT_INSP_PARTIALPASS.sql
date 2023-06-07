﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_INSP_PARTIALPASS]
AS

SELECT    IMINSPECTIONLINK.NAME AS MODULE, IMINSPECTIONSTATUS.STATUSNAME
FROM         IMINSPECTIONSTATUS INNER JOIN
                      IMINSPECTIONSTATUSENTITY ON IMINSPECTIONSTATUS.IMINSPECTIONSTATUSENTITYID = IMINSPECTIONSTATUSENTITY.IMINSPECTIONSTATUSENTITYID INNER JOIN
                      IMINSPECTIONLINK ON IMINSPECTIONSTATUSENTITY.IMINSPECTIONLINKID = IMINSPECTIONLINK.IMINSPECTIONLINKID
WHERE    PARTIALPASS=1 AND REINSPECTIONFLAG=0

