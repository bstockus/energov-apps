﻿

--[dbo].[RPT_PL_PLAN_PLANNING_ACTIVITY_REPORT] '01/01/2012 00:00:00'

CREATE PROCEDURE [dbo].[rpt_PL_PlanReviewItems_ByDepartment]
@STARTDATE DATETIME,
@ENDDATE DATETIME

AS

BEGIN

SELECT PLSubmittalType.TYPENAME, PLPlan.PLANNUMBER, PLItemReview.ASSIGNEDDATE, Department.NAME AS DeparmentName
       , PLSubmittal.RECEIVEDDATE, PLItemReviewType.NAME AS ReviewType, PRProject.NAME AS ProjectName, 
       CASE PLItemReview.PASSED WHEN 1 THEN 'Yes' ELSE 'No' END AS PASSED, PLItemReview.COMMENTS


FROM PLPLAN
LEFT OUTER JOIN PRPROJECTPLAN ON PLPLAN.PLPLANID = PRPROJECTPLAN.PLPLANID
LEFT OUTER JOIN PLSUBMITTAL ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
LEFT OUTER JOIN PLSUBMITTALTYPE ON PLSUBMITTAL.PLSUBMITTALTYPEID = PLSUBMITTALTYPE.PLSUBMITTALTYPEID
LEFT OUTER JOIN PLITEMREVIEW ON PLSUBMITTAL.PLSUBMITTALID = PLITEMREVIEW.PLSUBMITTALID 
LEFT OUTER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEW.PLITEMREVIEWTYPEID = PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID
LEFT OUTER JOIN DEPARTMENT ON PLITEMREVIEWTYPE.DEPARTMENTID = DEPARTMENT.DEPARTMENTID 
LEFT OUTER JOIN PRPROJECT ON PRPROJECTPLAN.PRPROJECTID = PRPROJECT.PRPROJECTID

WHERE PLSUBMITTAL.RECEIVEDDATE BETWEEN @STARTDATE AND @ENDDATE 
ORDER BY PLPLAN.PLANNUMBER, DEPARTMENT.NAME 

END

