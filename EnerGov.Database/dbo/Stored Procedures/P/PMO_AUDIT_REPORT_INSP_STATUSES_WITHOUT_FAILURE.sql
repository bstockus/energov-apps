﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_INSP_STATUSES_WITHOUT_FAILURE]
AS

select  IMINSPECTIONLINK.NAME 
FROM         IMINSPECTIONSTATUS INNER JOIN
                      IMINSPECTIONSTATUSENTITY ON IMINSPECTIONSTATUS.IMINSPECTIONSTATUSENTITYID = IMINSPECTIONSTATUSENTITY.IMINSPECTIONSTATUSENTITYID INNER JOIN
                      IMINSPECTIONLINK ON IMINSPECTIONSTATUSENTITY.IMINSPECTIONLINKID = IMINSPECTIONLINK.IMINSPECTIONLINKID
WHERE IMINSPECTIONLINK.NAME  not in (SELECT   IMINSPECTIONLINK.NAME AS MODULE
									 FROM         IMINSPECTIONSTATUS INNER JOIN
														  IMINSPECTIONSTATUSENTITY ON IMINSPECTIONSTATUS.IMINSPECTIONSTATUSENTITYID = IMINSPECTIONSTATUSENTITY.IMINSPECTIONSTATUSENTITYID INNER JOIN
														  IMINSPECTIONLINK ON IMINSPECTIONSTATUSENTITY.IMINSPECTIONLINKID = IMINSPECTIONLINK.IMINSPECTIONLINKID
									WHERE (REINSPECTIONFLAG=1 AND INVIOLATIONFLAG=1)
									GROUP BY IMINSPECTIONLINK.NAME, IMINSPECTIONSTATUS.INDICATESSUCCESS)
GROUP BY IMINSPECTIONLINK.NAME

