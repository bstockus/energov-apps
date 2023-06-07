CREATE PROCEDURE [dbo].[PermitAdditionalInformationForPermitId]
	@PERMITID AS VARCHAR(36)
AS
	
	SELECT
		x.AdditionalInformationTitle AS "AdditionalInformationTitle",
		x.AdditionalInformationContents AS "AdditionalInformationContents"
	FROM (SELECT
		ptwcai.Title AS "AdditionalInformationTitle",
		ptwcai.Contents AS "AdditionalInformationContents",
		ptwcai.SortOrder AS "SortOrder"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	INNER JOIN laxreports.PermitTypeWorkClassAdditionalInformation ptwcai ON p.PMPERMITTYPEID = ptwcai.PermitTypeId AND p.PMPERMITWORKCLASSID = ptwcai.PermitWorkClassId
	WHERE p.PMPERMITID = @PERMITID

	UNION

	SELECT
		si.Title AS "AdditionalInformationTitle",
		si.Information AS "AdditionalInformationContents",
		ptwcis.SelectorSortOrder AS "SortOrder"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	INNER JOIN laxreports.PermitTypeWorkClassInformationSelectors ptwcis ON p.PMPERMITTYPEID = ptwcis.PermitTypeId AND p.PMPERMITWORKCLASSID = ptwcis.PermitWorkClassId AND ptwcis.SelectorType = 'ADDINFO'
	INNER JOIN laxreports.SelectedInformations si ON ptwcis.SelectorId = si.Id AND si.[Type] = 'ADDINFO'
	WHERE p.PMPERMITID = @PERMITID

	UNION

	SELECT
		si.Title AS "AdditionalInformationTitle",
		si.Information AS "AdditionalInformationContents",
		ptis.SelectorSortOrder AS "SortOrder"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	INNER JOIN laxreports.PermitTypeInformationSelectors ptis ON p.PMPERMITTYPEID = ptis.PermitTypeId AND ptis.SelectorType = 'ADDINFO'
	INNER JOIN laxreports.SelectedInformations si ON ptis.SelectorId = si.Id AND si.[Type] = 'ADDINFO'
	WHERE p.PMPERMITID = @PERMITID) AS x
	ORDER BY x.SortOrder