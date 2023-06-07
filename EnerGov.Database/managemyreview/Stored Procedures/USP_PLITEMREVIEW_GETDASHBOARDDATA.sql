﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETDASHBOARDDATA]
(
	@ASSIGNEDUSERLIST RecordIDs READONLY
)
AS
BEGIN
SET NOCOUNT ON

SELECT			DISTINCT PLITEMREVIEWID,
				VERSIONNUMBER,
				DUEDATE,
				ASSIGNEDUSERID,
				ASSIGNEDUSERFIRSTNAME, 
				ASSIGNEDUSERLASTNAME
FROM
(
SELECT			PLITEMREVIEW.PLITEMREVIEWID,
				BLLICENSEWFACTIONSTEP.VERSIONNUMBER,
				PLITEMREVIEW.DUEDATE,
				PLITEMREVIEW.ASSIGNEDUSERID,
				USERS.FNAME AS ASSIGNEDUSERFIRSTNAME, 
				USERS.LNAME AS ASSIGNEDUSERLASTNAME,
				BLLICENSEWFACTIONSTEP.WORKFLOWSTATUSID,
				PLITEMREVIEW.PRIORITYORDER,
				PLITEMREVIEW.COMPLETED,
				PLSUBMITTAL.COMPLETED AS SUBMITTALCOMPLETED,
				PLSUBMITTAL.PLSUBMITTALID,
				PLITEMREVIEW.NOTREQUIRED
FROM			PLITEMREVIEW 
INNER JOIN		PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
INNER JOIN		BLLICENSEWFACTIONSTEP ON BLLICENSEWFACTIONSTEP.BLLICENSEWFACTIONSTEPID = PLSUBMITTAL.BLLICENSEWFACTIONSTEPID
INNER JOIN		USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
UNION ALL
SELECT			PLITEMREVIEW.PLITEMREVIEWID,
				ILLICENSEWFACTIONSTEP.VERSIONNUMBER,
				PLITEMREVIEW.DUEDATE,
				PLITEMREVIEW.ASSIGNEDUSERID,
				USERS.FNAME AS ASSIGNEDUSERFIRSTNAME, 
				USERS.LNAME AS ASSIGNEDUSERLASTNAME,
				ILLICENSEWFACTIONSTEP.WORKFLOWSTATUSID,
				PLITEMREVIEW.PRIORITYORDER,
				PLITEMREVIEW.COMPLETED,
				PLSUBMITTAL.COMPLETED AS SUBMITTALCOMPLETED,
				PLSUBMITTAL.PLSUBMITTALID,
				PLITEMREVIEW.NOTREQUIRED
FROM			PLITEMREVIEW 
INNER JOIN		PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
INNER JOIN		ILLICENSEWFACTIONSTEP ON ILLICENSEWFACTIONSTEP.ILLICENSEWFACTIONSTEPID = PLSUBMITTAL.ILLICENSEWFACTIONSTEPID
INNER JOIN		USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
UNION ALL
SELECT			PLITEMREVIEW.PLITEMREVIEWID,
				PLPLANWFACTIONSTEP.VERSIONNUMBER,
				PLITEMREVIEW.DUEDATE,
				PLITEMREVIEW.ASSIGNEDUSERID,
				USERS.FNAME AS ASSIGNEDUSERFIRSTNAME, 
				USERS.LNAME AS ASSIGNEDUSERLASTNAME,
				PLPLANWFACTIONSTEP.WORKFLOWSTATUSID,
				PLITEMREVIEW.PRIORITYORDER,
				PLITEMREVIEW.COMPLETED,
				PLSUBMITTAL.COMPLETED AS SUBMITTALCOMPLETED,
				PLSUBMITTAL.PLSUBMITTALID,
				PLITEMREVIEW.NOTREQUIRED
FROM			PLITEMREVIEW 
INNER JOIN		PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
INNER JOIN		PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
INNER JOIN		USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
UNION ALL
SELECT			PLITEMREVIEW.PLITEMREVIEWID,
				PMPERMITWFACTIONSTEP.VERSIONNUMBER,
				PLITEMREVIEW.DUEDATE,
				PLITEMREVIEW.ASSIGNEDUSERID,
				USERS.FNAME AS ASSIGNEDUSERFIRSTNAME, 
				USERS.LNAME AS ASSIGNEDUSERLASTNAME,
				PMPERMITWFACTIONSTEP.WORKFLOWSTATUSID,
				PLITEMREVIEW.PRIORITYORDER,
				PLITEMREVIEW.COMPLETED,
				PLSUBMITTAL.COMPLETED AS SUBMITTALCOMPLETED,
				PLSUBMITTAL.PLSUBMITTALID,
				PLITEMREVIEW.NOTREQUIRED
FROM			PLITEMREVIEW 
INNER JOIN		PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
INNER JOIN		PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
INNER JOIN		USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
) AS tblTemp
WHERE			COMPLETED = 0
AND				SUBMITTALCOMPLETED = 0
AND				PRIORITYORDER <= (SELECT MIN(PRIORITYORDER) FROM PLITEMREVIEW WHERE PLITEMREVIEW.PLSUBMITTALID = tblTemp.PLSUBMITTALID AND COMPLETED = 0)
AND				WORKFLOWSTATUSID = 5
AND				NOTREQUIRED = 0
AND				ASSIGNEDUSERID IN (SELECT RECORDID FROM @ASSIGNEDUSERLIST)


END