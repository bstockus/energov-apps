CREATE PROCEDURE [dbo].[PermitBuildingCustomFields]
	@PERMITID AS VARCHAR(36),
	@ARG1 AS VARCHAR(100)
AS

SELECT
	@ARG1 AS "LayoutSelector",
	p.PERMITNUMBER AS "PermitNumber",
	'<b>Permit: </b>' + pt.[NAME] + ' - ' + pwc.[NAME] AS "PermitTypeWorkClassName",
	'<b>' + STR(ISNULL(cspm.FrontYardSetback, 0), 5, 2) + '</b>''' AS "FrontYardSetback",
	'<b>' + STR(ISNULL(cspm.RearYardSetback, 0), 5, 2) + '</b>''' AS "RearYardSetback",
	'<b>' + STR(ISNULL(cspm.LeftSideYardSetback, 0), 5, 2) + '</b>''' AS "LeftSideYardSetback",
	'<b>' + STR(ISNULL(cspm.RightSideYardSetback, 0), 5, 2) + '</b>''' AS "RightSideYardSetback",
	'Commercial: <b>' + STR(ISNULL(cspm.CommercialSquareFootage, 0), 12, 2) + '</b> sq. ft.' AS "CommercialSquareFootage",
	'Residential: <b>' + STR(ISNULL(cspm.ResidentialSquareFootage, 0), 12, 2) + '</b> sq. ft.' AS "ResidentialSquareFootage",
	'Total: <b>' + STR(ISNULL(cspm.TotalSquareFootage, 0), 12, 2) + '</b> sq. ft.' AS "TotalSquareFootage",
	'Number of Dwelling Units: <b>' + STR(ISNULL(cspm.NumberOfDwellingUnits, 0), 4, 0) + '</b>' AS "NumberOfDwellingUnits",
	'Structural Alteration? <b>' + (CASE ISNULL(cspm.StructuralAlteration, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "StructuralAlteration",
	'State Reviewed Plans? <b>' + (CASE ISNULL(cspm.StateReviewedPlans, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "StateReviewedPlans",
	'Original Tenant? <b>' + (CASE ISNULL(cspm.OriginalTenant, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "OriginalTenant",
	'Building Type: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.BuildingType), '') + '</b>' AS "BuildingType",
	'New or Repair: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.FootingFoundationNewOrRepair), '') + '</b>' AS "FootingFoundationNewOrRepair",
	'Demolition Type: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.DemolitionType), '') + '</b>' AS "DemolitionType",
	'Underlayment Type: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.RoofUnderlaymentType), '') + '</b>' AS "RoofUnderlaymentType",
	'Flashing Material: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.RoofFlashingMaterial), '') + '</b>' AS "RoofFlashingMaterial",
	'Flashing Type: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.RoofFlashingType), '') + '</b>' AS "RoofFlashingType",
	'Roofing Material: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.RoofingMaterial), '') + '</b>' AS "RoofingMaterial",
	'Deck Material: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.RoofDeckMaterial), '') + '</b>' AS "RoofDeckMaterial",
	'Removing Exisitin Roofing Material? <b>' + (CASE ISNULL(cspm.RemovingExistingRoofingMaterial, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "RemovingExistingRoofingMaterial",
	'Applying Over Exisiting Roofing Material? <b>' + (CASE ISNULL(cspm.ApplyingOverExistingRoofingMaterial, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "ApplyingOverExistingRoofingMaterial",
	'Number of Existing Layers of Roofing Material: <b>' + STR(ISNULL(cspm.NumberOfExistingLayersOfRoofingMaterial, 0), 2, 0) + '</b>' AS "NumberOfExistingLayersOfRoofingMaterial",
	'Roof Slope: <b>' + ISNULL(cspm.RoofSlope, '') + '</b>' AS "RoofSlope",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '37f06138-7994-4761-ac27-e56e24733e8a' AND [CUSTOMFIELDWORKSHEETITEMID] = 'ab6a7a42-651f-4e79-a1da-b0530c73e0bd' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit1UnfinishedBasement",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '37f06138-7994-4761-ac27-e56e24733e8a' AND [CUSTOMFIELDWORKSHEETITEMID] = '98235f14-8cbe-46ab-964f-fea68e13c054' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit1LivingArea",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '37f06138-7994-4761-ac27-e56e24733e8a' AND [CUSTOMFIELDWORKSHEETITEMID] = '880357d5-6940-443d-8a5b-d72f7b7a4748' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit1Garage",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '37f06138-7994-4761-ac27-e56e24733e8a' AND [CUSTOMFIELDWORKSHEETITEMID] = 'be923652-b9be-4fe1-b30f-21ca82cf8b2d' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit1Deck",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '76652ae6-82d7-4ebb-89c1-caeb43aceaa0' AND [CUSTOMFIELDWORKSHEETITEMID] = '371b4912-74e9-41a1-8eff-4338a2860ca1' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit2UnfinishedBasement",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '76652ae6-82d7-4ebb-89c1-caeb43aceaa0' AND [CUSTOMFIELDWORKSHEETITEMID] = 'e9896b5f-b34a-41e9-83ad-0dd42015a963' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit2LivingArea",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '76652ae6-82d7-4ebb-89c1-caeb43aceaa0' AND [CUSTOMFIELDWORKSHEETITEMID] = '2c7513b4-b130-4004-81a1-0b26e767f749' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit2Garage",
	'<b>' + STR(ISNULL((SELECT TOP 1 NUMERICVALUE FROM [$(EnerGovDatabase)].[dbo].[CUSTOMSAVERPERMITMANAGEMENTWS] WHERE [CUSTOMFIELDID] = '76652ae6-82d7-4ebb-89c1-caeb43aceaa0' AND [CUSTOMFIELDWORKSHEETITEMID] = 'df79dd08-5a93-4188-be2b-8308e0965447' AND [ID] = @PERMITID), 0), 12, 2) + '</b> sq. ft. ' AS "Unit2Deck",
	'Sign Location: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.SignLocation), '') + '</b>' AS "SignLocation",

	'<b>' + STR(ISNULL(cspm.NumberOfMarqueeSigns, 0), 5, 2) + '</b>' AS "NumberOfMarqueeSigns",
	'<b>' + STR(ISNULL(cspm.NumberOfProjectingSigns, 0), 5, 2) + '</b>' AS "NumberOfProjectingSigns",
	'<b>' + STR(ISNULL(cspm.NumberOfAwningSigns, 0), 5, 2) + '</b>' AS "NumberOfAwningSigns",
	'<b>' + STR(ISNULL(cspm.NumberOfCanopySigns, 0), 5, 2) + '</b>' AS "NumberOfCanopySigns",
	'<b>' + STR(ISNULL(cspm.NumberOfWallSigns, 0), 5, 2) + '</b>' AS "NumberOfWallSigns",
	'<b>' + STR(ISNULL(cspm.NumberOfMonumentSigns, 0), 5, 2) + '</b>' AS "NumberOfMonumentSigns",
	'<b>' + STR(ISNULL(cspm.NumberOfSignFaces, 0), 5, 2) + '</b>' AS "NumberOfSignFaces",

	'Antenna Type: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.AntennaType), '') + '</b>' AS "AntennaType",
	'New or Existing: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.NewOrExistingBillboard), '') + '</b>' AS "NewOrExistingBillboard"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm ON p.PMPERMITID = cspm.ID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
WHERE cspm.ID = @PERMITID