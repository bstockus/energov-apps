CREATE PROCEDURE [dbo].[rpt_Code_OfficialContactLetter]
	@CODECASEID AS VARCHAR(36)
AS

	SELECT 
		cc.CMCODECASEID,
		cc.CASENUMBER AS "CaseNumber",
		vlc.DepartmentHeaderId AS "DepartmentHeaderType",
		dh.LeftLogoType AS "DepartmentHeaderLeftLogoType",
		dh.RightLogoType AS "DepartmentHeaderRightLogoType",
		dh.MainText AS "DepartmentHeaderMainText",
		dh.SubMainText AS "DepartmentHeaderSubMainText",
		dh.LeftTextLine1 AS "DepartmentHeaderLeftTextLine1",
		dh.LeftTextLine2 AS "DepartmentHeaderLeftTextLine2",
		dh.RightTextLine1 AS "DepartmentHeaderRightTextLine1",
		dh.RightTextLine2 AS "DepartmentHeaderRightTextLine2",
		vlc.LetterText,
		vlc.LetterTitle,
		cv.CORRECTIVEACTION,
		cv.CITATIONISSUEDATE,
		cv.COMPLIANCEDATE,
		(SELECT TOP 1 SVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMFIELDPICKLISTITEM] WHERE [GCUSTOMFIELDPICKLISTITEM] = cmvcf.MethodOfServing) AS "MethodOfServing",
		cmvcf.DateOTCMailed AS "DateOTCMailed",
		(SELECT TOP 1 ins.InspectorSignatureImage FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			INNER JOIN laxreports.InspectorSignatures ins ON cwfas.LASTCHANGEDBY = ins.InspectorUserId 
			WHERE cwfas.NAME = 'Issue Official Contact Letter' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID) AS "InspectorSignatureImage",
		(SELECT TOP 1 cwfas.ENDDATE FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			WHERE cwfas.NAME = 'Issue Official Contact Letter' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID) AS "PermitApprovedDate",
		(SELECT TOP 1 u.FNAME FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			INNER JOIN [$(EnerGovDatabase)].dbo.USERS u ON cwfas.LASTCHANGEDBY = u.SUSERGUID 
			WHERE cwfas.NAME = 'Issue Official Contact Letter' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID) AS "InspectorFirstName",
		(SELECT TOP 1 u.LNAME FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			INNER JOIN [$(EnerGovDatabase)].dbo.USERS u ON cwfas.LASTCHANGEDBY = u.SUSERGUID 
			WHERE cwfas.NAME = 'Issue Official Contact Letter' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID) AS "InspectorLastName",
		(SELECT TOP 1 u.PHONE FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			INNER JOIN [$(EnerGovDatabase)].dbo.USERS u ON cwfas.LASTCHANGEDBY = u.SUSERGUID 
			WHERE cwfas.NAME = 'Issue Official Contact Letter' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID) AS "InspectorPhoneNumber",
		(SELECT TOP 1 u.EMAIL FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			INNER JOIN [$(EnerGovDatabase)].dbo.USERS u ON cwfas.LASTCHANGEDBY = u.SUSERGUID 
			WHERE cwfas.NAME = 'Issue Official Contact Letter' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID) AS "InspectorEmailAddress",
		cmvcf.OfficialContactLetterPremise,
		cmvcf.OfficialContactLetterInspectionDate
	FROM [$(EnerGovDatabase)].[dbo].[CMCODECASE] cc
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CMCODEWFSTEP] cwfs ON cc.CMCODECASEID = cwfs.CMCODECASEID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CMCODEWFACTIONSTEP] cwfas ON cwfs.CMCODEWFSTEPID = cwfas.CMCODEWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CMVIOLATION] cv ON cwfas.CMCODEWFACTIONSTEPID = cv.CMCODEWFACTIONID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERCODEMANAGEMENT] cmcf ON cc.CMCODECASEID = cmcf.ID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERCODEMANAGEMENT] cmvcf ON cv.CMVIOLATIONID = cmvcf.ID
	LEFT OUTER JOIN laxreports.ViolationLetterContents vlc ON cv.CMCODEREVISIONID = vlc.CodeRevisionId
	LEFT OUTER JOIN laxreports.DepartmentHeaders dh ON vlc.DepartmentHeaderId = dh.Id
	WHERE cc.CMCODECASEID = @CODECASEID AND cv.CMVIOLATIONSTATUSID = 'f336bf7b-2b26-4812-9153-2be8b43ee87a'; -- Filters only for Violations with a status of "Issued OTC"
GO


