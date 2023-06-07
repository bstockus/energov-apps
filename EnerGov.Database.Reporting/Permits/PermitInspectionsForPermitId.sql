CREATE PROCEDURE [dbo].[PermitInspectionsForPermitId]
	@PERMITID AS VARCHAR(36)
AS

	SELECT
		'MAIN' AS "PermitAttachment",
		it.NAME AS "InspectionTypeName",
		i.INSPECTIONNUMBER AS "InspectionNumber",
		i.IMINSPECTIONID AS "InspectionId",
		i.REQUESTEDDATE AS "InspectionRequestedDate",
		i.SCHEDULEDSTARTDATE AS "InspectionScheduledStartDate",
		i.ACTUALSTARTDATE AS "InspectionActualStartDate",
		ins.STATUSNAME AS "InspectionStatusName",
		u.FNAME AS "InspectorFirstName",
		u.LNAME AS "InspectorLastName",
		u.PHONE AS "InspectorPhone",
		u.EMAIL AS "InspectorEmail",
		ISNULL((SELECT TOP 1 si.Information FROM [laxreports].[PermitTypeWorkClassInformationSelectors] ptwcis 
			INNER JOIN [laxreports].[SelectedInformations] si ON si.[Type] = 'INSPINFO' AND ptwcis.SelectorId = si.Id
			WHERE ptwcis.PermitTypeId = p.PMPERMITTYPEID AND ptwcis.PermitWorkClassId = p.PMPERMITWORKCLASSID AND ptwcis.SelectorType = 'INSPINFO'
			ORDER BY ptwcis.SelectorSortOrder),
			(SELECT TOP 1 si.Information FROM [laxreports].[PermitTypeInformationSelectors] ptis 
			INNER JOIN [laxreports].[SelectedInformations] si ON si.[Type] = 'INSPINFO' AND ptis.SelectorId = si.Id
			WHERE ptis.PermitTypeId = p.PMPERMITTYPEID AND ptis.SelectorType = 'INSPINFO'
			ORDER BY ptis.SelectorSortOrder)) AS "InspectionInformation"
	FROM [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON pwfs.PMPERMITID = p.PMPERMITID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.USERS u ON p.ASSIGNEDTO = u.SUSERGUID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
	INNER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTIONTYPE it ON pwfas.IMINSPECTIONTYPEID = it.IMINSPECTIONTYPEID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTIONACTREF iar ON pwfas.PMPERMITWFACTIONSTEPID = iar.OBJECTID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTION i ON iar.IMINSPECTIONID = i.IMINSPECTIONID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTIONSTATUS ins ON i.IMINSPECTIONSTATUSID = ins.IMINSPECTIONSTATUSID
	WHERE pwfs.PMPERMITID = @PERMITID AND pwfas.WFACTIONTYPEID = 6
	ORDER BY pwfs.PRIORITYORDER ASC, pwfs.SORTORDER ASC, pwfas.PRIORITYORDER ASC, pwfas.SORTORDER ASC
