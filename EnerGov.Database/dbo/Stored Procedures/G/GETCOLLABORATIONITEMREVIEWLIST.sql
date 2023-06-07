﻿CREATE PROCEDURE [dbo].[GETCOLLABORATIONITEMREVIEWLIST]
-- Add the parameters for the stored procedure here
@AssignedUserID char(36)	
AS
BEGIN	
	SELECT	DISTINCT PLITEMREVIEW.PLITEMREVIEWID,  
			PLITEMREVIEW.PLPLANID AS CASEID,
			PLPLAN.PLANNUMBER AS CASENUMBER,
			PLPLANWFACTIONSTEP.NAME AS SUBMITTALNAME,
			PLPLANWFACTIONSTEP.VERSIONNUMBER AS SUBMITTALVERSION,
			PLITEMREVIEWTYPE.NAME AS ITEMREVIEWTYPENAME,
			PLITEMREVIEW.ASSIGNEDDATE,
			1 AS MODULEID				
	FROM PLITEMREVIEW	
	INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID		
	INNER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
	INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
	INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLITEMREVIEW.PLPLANID
	INNER JOIN COLLABORATION ON COLLABORATION.PLITEMREVIEWID = PLITEMREVIEW.PLITEMREVIEWID		
	WHERE (PLITEMREVIEW.ASSIGNEDUSERID = @AssignedUserID)	
	UNION
	SELECT	DISTINCT PLITEMREVIEW.PLITEMREVIEWID,  
			PLITEMREVIEW.PMPERMITID AS CASEID,
			PMPERMIT.PERMITNUMBER AS CASENUMBER,
			PMPERMITWFACTIONSTEP.NAME AS SUBMITTALNAME,
			PMPERMITWFACTIONSTEP.VERSIONNUMBER AS SUBMITTALVERSION,
			PLITEMREVIEWTYPE.NAME AS ITEMREVIEWTYPENAME,
			PLITEMREVIEW.ASSIGNEDDATE,
			2 AS MODULEID				
	FROM PLITEMREVIEW	
	INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID		
	INNER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
	INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
	INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLITEMREVIEW.PMPERMITID
	INNER JOIN COLLABORATION ON COLLABORATION.PLITEMREVIEWID = PLITEMREVIEW.PLITEMREVIEWID		
	WHERE (PLITEMREVIEW.ASSIGNEDUSERID = @AssignedUserID)
	ORDER BY PLITEMREVIEW.ASSIGNEDDATE DESC
END