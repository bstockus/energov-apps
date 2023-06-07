CREATE PROCEDURE [dbo].[rpt_Code_OrderToCorrect]
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
		ISNULL(cmvcf.DateOTCMailed, cv.CITATIONISSUEDATE) AS "DateOTCMailed",
		(SELECT TOP 1 ins.InspectorSignatureImage FROM laxreports.InspectorSignatures ins
			WHERE ins.InspectorUserId = ISNULL(vlc.OverrideSignature, (SELECT TOP 1 cwfas.LASTCHANGEDBY FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID
			WHERE cwfas.NAME = 'Issue OTC' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID))) AS "InspectorSignatureImage",
		ISNULL((SELECT TOP 1 cwfas.ENDDATE FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID 
			WHERE cwfas.NAME = 'Issue OTC' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID), cv.CITATIONISSUEDATE) AS "PermitApprovedDate",
		(SELECT TOP 1 u.FNAME FROM [$(EnerGovDatabase)].dbo.USERS u
			WHERE u.SUSERGUID = ISNULL(vlc.OverrideSignature, (SELECT TOP 1 cwfas.LASTCHANGEDBY FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID
			WHERE cwfas.NAME = 'Issue OTC' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID))) AS "InspectorFirstName",
		(SELECT TOP 1 u.LNAME FROM [$(EnerGovDatabase)].dbo.USERS u
			WHERE u.SUSERGUID = ISNULL(vlc.OverrideSignature, (SELECT TOP 1 cwfas.LASTCHANGEDBY FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID
			WHERE cwfas.NAME = 'Issue OTC' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID))) AS "InspectorLastName",
		(SELECT TOP 1 u.PHONE FROM [$(EnerGovDatabase)].dbo.USERS u
			WHERE u.SUSERGUID = ISNULL(vlc.OverrideSignature, (SELECT TOP 1 cwfas.LASTCHANGEDBY FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID
			WHERE cwfas.NAME = 'Issue OTC' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID))) AS "InspectorPhoneNumber",
		(SELECT TOP 1 u.EMAIL FROM [$(EnerGovDatabase)].dbo.USERS u
			WHERE u.SUSERGUID = ISNULL(vlc.OverrideSignature, (SELECT TOP 1 cwfas.LASTCHANGEDBY FROM [$(EnerGovDatabase)].dbo.CMCODEWFACTIONSTEP cwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.CMCODEWFSTEP cwfs ON cwfas.CMCODEWFSTEPID = cwfs.CMCODEWFSTEPID
			WHERE cwfas.NAME = 'Issue OTC' AND cwfas.WORKFLOWSTATUSID = 1 AND cwfs.CMCODECASEID = @CODECASEID))) AS "InspectorEmailAddress",
		cmvcf.AdministrativeCodeSection,
		cmvcf.AdditionalOTCText,
		(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENTMS cscmms 
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cscmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
			WHERE cscmms.ID = cv.CMVIOLATIONID AND cscmms.CUSTOMFIELDPICKLISTITEMID = '448583f5-2cf8-43c6-bd94-9b321a0fe714') AS "GarbageSection1",
		(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENTMS cscmms 
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cscmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
			WHERE cscmms.ID = cv.CMVIOLATIONID AND cscmms.CUSTOMFIELDPICKLISTITEMID = '9a601e4f-d816-450a-9e2e-ea8a251ed4eb') AS "GarbageSection2",
		(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENTMS cscmms 
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cscmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
			WHERE cscmms.ID = cv.CMVIOLATIONID AND cscmms.CUSTOMFIELDPICKLISTITEMID = 'b6eff5ae-aef0-4c3d-a6b2-b90a0d06f656') AS "GarbageSection3",
		(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENTMS cscmms 
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cscmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
			WHERE cscmms.ID = cv.CMVIOLATIONID AND cscmms.CUSTOMFIELDPICKLISTITEMID = 'ec867c1d-a359-4834-ba95-f3a7d8b2965c') AS "GarbageSection4",
		(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERCODEMANAGEMENTMS cscmms 
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cscmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
			WHERE cscmms.ID = cv.CMVIOLATIONID AND cscmms.CUSTOMFIELDPICKLISTITEMID = cmvcf.NotarizedBy) AS "NotarizedBy",
		cmcf.RentalProperty AS "RentalProperty"
	FROM [$(EnerGovDatabase)].[dbo].[CMCODECASE] cc
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CMCODEWFSTEP] cwfs ON cc.CMCODECASEID = cwfs.CMCODECASEID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CMCODEWFACTIONSTEP] cwfas ON cwfs.CMCODEWFSTEPID = cwfas.CMCODEWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].[dbo].[CMVIOLATION] cv ON cwfas.CMCODEWFACTIONSTEPID = cv.CMCODEWFACTIONID
	LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERCODEMANAGEMENT] cmcf ON cc.CMCODECASEID = cmcf.ID
	LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERCODEMANAGEMENT] cmvcf ON cv.CMVIOLATIONID = cmvcf.ID
	LEFT OUTER JOIN laxreports.ViolationLetterContents vlc ON cv.CMCODEREVISIONID = vlc.CodeRevisionId
	LEFT OUTER JOIN laxreports.DepartmentHeaders dh ON vlc.DepartmentHeaderId = dh.Id
	WHERE cc.CMCODECASEID = @CODECASEID; --AND cv.CMVIOLATIONSTATUSID = 'f336bf7b-2b26-4812-9153-2be8b43ee87a'; -- Filters only for Violations with a status of "Issued OTC"
GO
