﻿
CREATE PROCEDURE [dbo].[mg_Query_PlanParentHistory]
	@ParentId char(36)
AS
BEGIN
SELECT    IMINSPECTION.IMINSPECTIONID, IMINSPECTION.INSPECTIONNUMBER, IMINSPECTION.SCHEDULEDSTARTDATE, IMINSPECTIONTYPE.NAME TYPENAME, IMINSPECTION.IMINSPECTIONSTATUSID, IMINSPECTIONSTATUS.STATUSNAME,		   USERS.LNAME, USERS.FNAME, IMINSPECTION.COMMENTS
                                    FROM         PLPLANWFACTIONSTEP INNER JOIN PLPLANWFSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID =PLPLANWFSTEP.PLPLANWFSTEPID 
                                       INNER JOIN IMINSPECTIONTYPE ON PLPLANWFACTIONSTEP.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID
                                       INNER JOIN IMINSPECTIONACTREF ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = IMINSPECTIONACTREF.OBJECTID
										 INNER JOIN IMINSPECTION ON IMINSPECTIONACTREF.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID
										 INNER JOIN IMINSPECTIONSTATUS ON IMINSPECTION.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID
								 LEFT JOIN IMINSPECTORREF ON IMINSPECTORREF.INSPECTIONID = IMINSPECTION.IMINSPECTIONID
								 LEFT JOIN USERS ON USERS.SUSERGUID = IMINSPECTORREF.USERID
                                    WHERE     (PLPLANWFSTEP.PLPLANID = @ParentId) AND (PLPLANWFACTIONSTEP.WFACTIONTYPEID = 6)
                                   -- AND (PLPLANWFACTIONSTEP.WORKFLOWSTATUSID = 0 OR (PLPLANWFACTIONSTEP.WORKFLOWSTATUSID = 5) OR PLPLANWFACTIONSTEP.WORKFLOWSTATUSID =1)
                                    AND (IMINSPECTORREF.BPRIMARY = 1 OR ( IMINSPECTORREF.BPRIMARY IS NULL))
		   	
END

