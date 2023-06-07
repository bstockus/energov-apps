CREATE PROCEDURE [dbo].[PermitSignatureSectionForPermitId]
	@PERMITID AS VARCHAR(36)
AS
	
	SELECT
		ISNULL((SELECT TOP 1 si.Information FROM [laxreports].[PermitTypeWorkClassInformationSelectors] ptwcis 
			INNER JOIN [laxreports].[SelectedInformations] si ON si.[Type] = 'SIGSECT' AND ptwcis.SelectorId = si.Id
			WHERE ptwcis.PermitTypeId = p.PMPERMITTYPEID AND ptwcis.PermitWorkClassId = p.PMPERMITWORKCLASSID AND ptwcis.SelectorType = 'SIGSECT'
			ORDER BY ptwcis.SelectorSortOrder),
			(SELECT TOP 1 si.Information FROM [laxreports].[PermitTypeInformationSelectors] ptis 
				INNER JOIN [laxreports].[SelectedInformations] si ON si.[Type] = 'SIGSECT' AND ptis.SelectorId = si.Id
				WHERE ptis.PermitTypeId = p.PMPERMITTYPEID AND ptis.SelectorType = 'SIGSECT'
				ORDER BY ptis.SelectorSortOrder)) AS "SignatureSectionText",
		(SELECT TOP 1 ins.InspectorSignatureImage FROM [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID 
			INNER JOIN laxreports.InspectorSignatures ins ON pwfas.LASTCHANGEDBY = ins.InspectorUserId 
			WHERE pwfas.NAME = 'Approve Permit' AND pwfas.WORKFLOWSTATUSID = 1 AND pwfs.PMPERMITID = @PERMITID) AS "InspectorSignatureImage",
		p.APPLYDATE AS "PermitApplyDate",
		(SELECT TOP 1 pwfas.ENDDATE FROM [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID 
			WHERE pwfas.NAME = 'Approve Permit' AND pwfas.WORKFLOWSTATUSID = 1 AND pwfs.PMPERMITID = @PERMITID) AS "PermitApprovedDate",
		(SELECT TOP 1 u.FNAME FROM [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID 
			INNER JOIN [$(EnerGovDatabase)].dbo.USERS u ON pwfas.LASTCHANGEDBY = u.SUSERGUID 
			WHERE pwfas.NAME = 'Approve Permit' AND pwfas.WORKFLOWSTATUSID = 1 AND pwfs.PMPERMITID = @PERMITID) AS "InspectorFirstName",
		(SELECT TOP 1 u.LNAME FROM [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas 
			INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID 
			INNER JOIN [$(EnerGovDatabase)].dbo.USERS u ON pwfas.LASTCHANGEDBY = u.SUSERGUID 
			WHERE pwfas.NAME = 'Approve Permit' AND pwfas.WORKFLOWSTATUSID = 1 AND pwfs.PMPERMITID = @PERMITID) AS "InspectorLastName"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	WHERE p.PMPERMITID = @PERMITID
