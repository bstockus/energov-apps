CREATE PROCEDURE [dbo].[PermitFireCustomFields]
	@PERMITID AS VARCHAR(36),
	@ARG1 AS VARCHAR(100)
AS
	SELECT
		@ARG1 AS "LayoutSelector",
		p.PERMITNUMBER AS "PermitNumber",
		'<b>Permit: </b>' + pt.[NAME] + ' - ' + pwc.[NAME] AS "PermitTypeWorkClassName",
		'Fire Pump Acceptance Test? <b>' + (CASE ISNULL(cspm.FirePumpAcceptanceTest, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "FirePumpAcceptanceTest",
		'Alarm Panel Only? <b>' + (CASE ISNULL(cspm.AlarmPanelOnly, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "AlarmPanelOnly",
		'System Type: <b>' + ISNULL(STUFF((SELECT CAST(', ' + cfpli.SVALUE AS VARCHAR(201)) [text()]
			FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms ON cfpli.GCUSTOMFIELDPICKLISTITEM = cspmms.CUSTOMFIELDPICKLISTITEMID
			WHERE cspmms.ID = @PERMITID AND cfpli.FKGCUSTOMFIELDPICKLIST = '2709cb7e-b595-42b5-96e8-51eea989c574'
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '), '') + '</b>' AS "FireSprinlerSystemType",
		'Number of Sprinkler Heads<b>' + STR(ISNULL(cspm.NumberOfSprinklerHeads, 0), 5, 0) + '</b>' AS "NumberOfSprinklerHeads",
		'Number of Detectors<b>' + STR(ISNULL(cspm.NumberOfDetectors, 0), 5, 0) + '</b>' AS "NumberOfDetectors",
		'Number of Clean Agent Systems<b>' + STR(ISNULL(cspm.NumberOfCleanAgentSystems, 0), 5, 0) + '</b>' AS "NumberOfCleanAgentSystems",
		CASE p.PMPERMITSTATUSID WHEN '8d4d91f1-bd78-477e-b2b7-ef9cbf672427' THEN (ISNULL((SELECT TOP 1 si.Information FROM [laxreports].[PermitTypeWorkClassInformationSelectors] ptwcis 
			INNER JOIN [laxreports].[SelectedInformations] si ON si.[Type] = 'SUBPINFO' AND ptwcis.SelectorId = si.Id
			WHERE ptwcis.PermitTypeId = p.PMPERMITTYPEID AND ptwcis.PermitWorkClassId = p.PMPERMITWORKCLASSID AND ptwcis.SelectorType = 'SUBPINFO'
			ORDER BY ptwcis.SelectorSortOrder),
			(SELECT TOP 1 si.Information FROM [laxreports].[PermitTypeInformationSelectors] ptis 
			INNER JOIN [laxreports].[SelectedInformations] si ON si.[Type] = 'SUBPINFO' AND ptis.SelectorId = si.Id
			WHERE ptis.PermitTypeId = p.PMPERMITTYPEID AND ptis.SelectorType = 'SUBPINFO'
			ORDER BY ptis.SelectorSortOrder))) ELSE NULL END AS "SubPermitInfo"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITSTATUS ps ON p.PMPERMITSTATUSID = ps.PMPERMITSTATUSID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm ON p.PMPERMITID = cspm.ID
	WHERE p.PMPERMITID = @PERMITID
