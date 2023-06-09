﻿CREATE PROCEDURE [energovhub].[USP_PLITEMREVIEW_INCOMPLETE_LOOKUP_BY_USERID]
	@USERID CHAR(36)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		[dbo].[PLITEMREVIEW].PMPERMITID,
		[dbo].[PLITEMREVIEW].PLPLANID,
		[dbo].[PLITEMREVIEW].BLLICENSEID,
		[dbo].[PLITEMREVIEW].ILLICENSEID,
		[dbo].[PMPERMIT].PERMITNUMBER,
		[dbo].[PLPLAN].PLANNUMBER,
		[dbo].[BLLICENSE].LICENSENUMBER BLNUMBER,
		[dbo].[ILLICENSE].LICENSENUMBER PLNUMBER,
		[dbo].[PLITEMREVIEW].PLITEMREVIEWID,
		[dbo].[PLSUBMITTALTYPE].TYPENAME AS SUBMITTALTYPENAME,
		[dbo].[PLITEMREVIEWTYPE].[NAME] AS ITEMREVIEWTYPENAME,
		[dbo].[PLITEMREVIEWSTATUS].[NAME] AS ITEMREVIEWSTATUSNAME,
		[dbo].[PLITEMREVIEW].ASSIGNEDDATE,
		[dbo].[PLITEMREVIEW].DUEDATE,
		[dbo].[DEPARTMENT].[NAME] AS DEPARTMENT
	FROM [dbo].[PLITEMREVIEW]
	JOIN [dbo].[PLSUBMITTAL] ON [dbo].[PLITEMREVIEW].PLSUBMITTALID = [dbo].[PLSUBMITTAL].PLSUBMITTALID
	JOIN [dbo].[PLSUBMITTALTYPE] ON [dbo].[PLSUBMITTAL].PLSUBMITTALTYPEID = [dbo].[PLSUBMITTALTYPE].PLSUBMITTALTYPEID
	JOIN [dbo].[PLITEMREVIEWTYPE] ON [dbo].[PLITEMREVIEW].PLITEMREVIEWTYPEID = [dbo].[PLITEMREVIEWTYPE].PLITEMREVIEWTYPEID
	JOIN [dbo].[PLITEMREVIEWSTATUS] ON [dbo].[PLITEMREVIEW].PLITEMREVIEWSTATUSID = [dbo].[PLITEMREVIEWSTATUS].PLITEMREVIEWSTATUSID
	LEFT JOIN [dbo].[USERS] ON [dbo].[PLITEMREVIEW].ASSIGNEDUSERID = [dbo].[USERS].SUSERGUID
	LEFT JOIN [dbo].[DEPARTMENT] ON [dbo].[PLITEMREVIEWTYPE].DEPARTMENTID = [dbo].[DEPARTMENT].DEPARTMENTID
	LEFT JOIN [dbo].[PMPERMIT] ON [dbo].[PLITEMREVIEW].PMPERMITID = [dbo].[PMPERMIT].PMPERMITID
	LEFT JOIN [dbo].[PLPLAN] ON [dbo].[PLITEMREVIEW].PLPLANID = [dbo].[PLPLAN].PLPLANID
	LEFT JOIN [dbo].[BLLICENSE] ON [dbo].[PLITEMREVIEW].BLLICENSEID = [dbo].[BLLICENSE].BLLICENSEID
	LEFT JOIN [dbo].[ILLICENSE] ON [dbo].[PLITEMREVIEW].ILLICENSEID = [dbo].[ILLICENSE].ILLICENSEID
	WHERE [dbo].[PLITEMREVIEW].ASSIGNEDUSERID = @USERID AND [dbo].[PLITEMREVIEW].[COMPLETED] = 0 AND [dbo].[PLITEMREVIEW].[NOTREQUIRED] = 0
	ORDER BY [dbo].[PLITEMREVIEW].DUEDATE ASC

END