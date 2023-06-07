


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_FAIL_SUBMITTAL]
AS

Select *
From Settings
where NAME='SubmittalItemReviewCompletionType' and INTVALUE <>'2'

