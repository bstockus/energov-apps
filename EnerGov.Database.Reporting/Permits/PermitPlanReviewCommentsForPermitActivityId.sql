CREATE PROCEDURE [dbo].[PermitPlanReviewCommentsForPermitActivityId]
	@PERMITACTIVITYID AS VARCHAR(36)
AS
	
	SELECT 
		pa.PERMITACTIVITYNUMBER AS "PlanReviewNumberNumber",
		pa.CREATEDON AS "PlanReviewDateTime",
		u.FNAME AS "PlanReviewerFirstName",
		u.LNAME AS "PlanReviewerLastName",
		cf.AdditionalPlanReviewComments AS "PlanReviewAdditionalComments",
		prc.ReviewItemTitle AS "PlanReviewCommentTitle",
		prc.ReviewItemContents AS "PlanReviewCommentContents"
	FROM [$(EnerGovDatabase)].[dbo].[PMPERMITACTIVITY] pa 
	INNER JOIN [$(EnerGovDatabase)].[dbo].[USERS] u ON pa.SUSERGUID = u.SUSERGUID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENT] cf ON pa.PMPERMITACTIVITYID = cf.ID
	LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTMS] cfm ON pa.PMPERMITACTIVITYID = cfm.ID
	INNER JOIN [laxreports].[PermitPlanReviewComments] prc ON cfm.CUSTOMFIELDPICKLISTITEMID = prc.CustomFieldPickListItemId AND cfm.CUSTOMFIELDID = prc.CustomFieldId
	WHERE pa.PMPERMITACTIVITYID = @PERMITACTIVITYID

UNION
	
	SELECT
		pa.PERMITACTIVITYNUMBER AS "PlanReviewNumberNumber",
		pa.CREATEDON AS "PlanReviewDateTime",
		u.FNAME AS "PlanReviewerFirstName",
		u.LNAME AS "PlanReviewerLastName",
		cf.AdditionalPlanReviewComments AS "PlanReviewAdditionalComments",
		NULL AS "PlanReviewCommentTitle",
		NULL AS "PlanReviewCommentContents"
	FROM [$(EnerGovDatabase)].[dbo].[PMPERMITACTIVITY] pa 
	INNER JOIN [$(EnerGovDatabase)].[dbo].[USERS] u ON pa.SUSERGUID = u.SUSERGUID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENT] cf ON pa.PMPERMITACTIVITYID = cf.ID
	WHERE pa.PMPERMITACTIVITYID = @PERMITACTIVITYID