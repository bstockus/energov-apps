﻿



CREATE PROCEDURE [dbo].[RPT_PM_PERMIT_INSPECTION_HISTORY_REPORT]
@PERMITID AS VARCHAR(36)
AS
SELECT     PMPERMIT.PERMITNUMBER, IMINSPECTION.INSPECTIONNUMBER, IMINSPECTIONTYPE.NAME AS INSPTYPE, 
                      IMINSPECTIONSTATUS.STATUSNAME AS INSPECTIONSTATUS, PMPERMITSTATUS.NAME AS PERMITSTATUS, PMPERMITWORKCLASS.NAME AS WORKCLASS, 
                      PMPERMITTYPE.NAME AS PERMITTYPE, PMPERMIT.APPLYDATE, PMPERMIT.EXPIREDATE, PMPERMIT.ISSUEDATE, PMPERMIT.PMPERMITID, 
                      IMINSPECTION.SCHEDULEDSTARTDATE, IMINSPECTION.COMPLETE, IMINSPECTION.ISREINSPECTION, IMINSPECTION.IMINSPECTIONID, USERS.FNAME, 
                      USERS.LNAME, WORKFLOWSTATUS.NAME AS WORKFLOWSTATUS
FROM         IMINSPECTION INNER JOIN
                      IMINSPECTIONACTREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONACTREF.IMINSPECTIONID INNER JOIN
                      IMINSPECTIONTYPE ON IMINSPECTION.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID INNER JOIN
                      IMINSPECTIONSTATUS ON IMINSPECTION.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID INNER JOIN
                      PMPERMIT INNER JOIN
                      PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID INNER JOIN
                      PMPERMITWFACTIONSTEP ON PMPERMITWFSTEP.PMPERMITWFSTEPID = PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID ON 
                      IMINSPECTIONACTREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID INNER JOIN
                      PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID INNER JOIN
                      PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID INNER JOIN
                      PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID INNER JOIN
                      IMINSPECTORREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTORREF.INSPECTIONID INNER JOIN
                      USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID INNER JOIN
                      WORKFLOWSTATUS ON PMPERMITWFACTIONSTEP.WORKFLOWSTATUSID = WORKFLOWSTATUS.WORKFLOWSTATUSID
WHERE PMPERMIT.PMPERMITID = @PERMITID AND IMINSPECTORREF.BPRIMARY = 'TRUE'



