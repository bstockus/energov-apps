﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_INSP_STATUSES_WITHOUT_SUCCESS]
AS

select  IMINSPECTIONLINK.NAME 
FROM         IMINSPECTIONSTATUS INNER JOIN
                      IMINSPECTIONSTATUSENTITY ON IMINSPECTIONSTATUS.IMINSPECTIONSTATUSENTITYID = IMINSPECTIONSTATUSENTITY.IMINSPECTIONSTATUSENTITYID INNER JOIN
                      IMINSPECTIONLINK ON IMINSPECTIONSTATUSENTITY.IMINSPECTIONLINKID = IMINSPECTIONLINK.IMINSPECTIONLINKID
WHERE IMINSPECTIONLINK.NAME  not in (SELECT   IMINSPECTIONLINK.NAME AS MODULE
									 FROM         IMINSPECTIONSTATUS INNER JOIN
														  IMINSPECTIONSTATUSENTITY ON IMINSPECTIONSTATUS.IMINSPECTIONSTATUSENTITYID = IMINSPECTIONSTATUSENTITY.IMINSPECTIONSTATUSENTITYID INNER JOIN
														  IMINSPECTIONLINK ON IMINSPECTIONSTATUSENTITY.IMINSPECTIONLINKID = IMINSPECTIONLINK.IMINSPECTIONLINKID
									WHERE (INDICATESSUCCESS=1 AND OUTOFVIOLATIONFLAG=1)
									GROUP BY IMINSPECTIONLINK.NAME, IMINSPECTIONSTATUS.INDICATESSUCCESS)
GROUP BY IMINSPECTIONLINK.NAME


