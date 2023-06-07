CREATE PROCEDURE [dbo].[PermitMechanicalCustomFields]
	@PERMITID AS VARCHAR(36),
	@ARG1 AS VARCHAR(100)
AS

SELECT

	@ARG1 AS "LayoutSelector",
	p.PERMITNUMBER AS "PermitNumber",
	'<b>Permit: </b>' + pt.[NAME] + (CASE pwc.[NAME] WHEN 'HVAC' THEN '' WHEN 'Electrical' THEN '' WHEN 'Plumbing' THEN '' ELSE (' - ' + pwc.[NAME]) END) AS "PermitTypeWorkClassName",

	'Is New Building? <b>' + (CASE ISNULL(cspm.IsNewBuilding, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "IsNewBuilding",
	'Cut and Cap Only? <b>' + (CASE ISNULL(cspm.PlumbingCutAndCapOnly, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "PlumbingCutAndCapOnly",
	'Connect or Relay Only? <b>' + (CASE ISNULL(cspm.PlumbingConnectOrRelayOnly, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "PlumbingConnectOrRelayOnly",
	'Number of Dwelling Units: <b>' + STR(ISNULL(cspm.NumberOfDwellingUnits, 0), 4, 0) + '</b>' AS "NumberOfDwellingUnits",
	'Building Type: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.BuildingType), '') + '</b>' AS "BuildingType",

	'Temporary Service: <b>' + STR(ISNULL(cspm.TemporaryService, 0), 5, 0) + '</b>' AS "TemporaryService",
	'Service Size: <b>' + STR(ISNULL(cspm.ServiceSize, 0), 5, 0) + '</b>' AS "ServiceSize",
	'Furnace(s): <b>' + STR(ISNULL(cspm.Furnaces, 0), 5, 0) + '</b>' AS "Furnaces",
	'AC Unit(s): <b>' + STR(ISNULL(cspm.ACUnits, 0), 5, 0) + '</b>' AS "ACUnits",
	'Water Heater(s): <b>' + STR(ISNULL(cspm.WaterHeaters, 0), 5, 0) + '</b>' AS "WaterHeaters",
	'Dryer(s): <b>' + STR(ISNULL(cspm.Dryers, 0), 5, 0) + '</b>' AS "Dryers",
	'Range(s): <b>' + STR(ISNULL(cspm.Ranges, 0), 5, 0) + '</b>' AS "Ranges",
	'Heater(s): <b>' + STR(ISNULL(cspm.Heaters, 0), 5, 0) + '</b>' AS "Heaters",
	'Outlet(s): <b>' + STR(ISNULL(cspm.Outlets, 0), 5, 0) + '</b>' AS "Outlets",
	'Motor(s): <b>' + STR(ISNULL(cspm.Motors, 0), 5, 0) + '</b>' AS "Motors",
	'Sign(s): <b>' + STR(ISNULL(cspm.Signs, 0), 5, 0) + '</b>' AS "Signs",
	'Bath Tub(s): <b>' + STR(ISNULL(cspm.BathTubs, 0), 5, 0) + '</b>' AS "BathTubs",
	'Floor Drain(s): <b>' + STR(ISNULL(cspm.FloorDrains, 0), 5, 0) + '</b>' AS "FloorDrains",
	'Laundry Tub(s): <b>' + STR(ISNULL(cspm.LaundryTubs, 0), 5, 0) + '</b>' AS "LaundryTubs",
	'Shower(s): <b>' + STR(ISNULL(cspm.Showers, 0), 5, 0) + '</b>' AS "Showers",
	'Urinal(s): <b>' + STR(ISNULL(cspm.Urinals, 0), 5, 0) + '</b>' AS "Urinals",
	'Garbage Disposal Unit(s): <b>' + STR(ISNULL(cspm.GarbageDisposalUnits, 0), 5, 0) + '</b>' AS "GarbageDisposalUnits",
	'Drinking Fountains(s): <b>' + STR(ISNULL(cspm.DrinkingFountains, 0), 5, 0) + '</b>' AS "DrinkingFountains",
	'Water Softener(s): <b>' + STR(ISNULL(cspm.WaterSofteners, 0), 5, 0) + '</b>' AS "WaterSofteners",
	'Roof Drain(s): <b>' + STR(ISNULL(cspm.RoofDrains, 0), 5, 0) + '</b>' AS "RoofDrains",
	'Water Closet(s): <b>' + STR(ISNULL(cspm.WaterClosets, 0), 5, 0) + '</b>' AS "WaterClosets",
	'Grease Interceptor(s): <b>' + STR(ISNULL(cspm.GreaseInterceptor, 0), 5, 0) + '</b>' AS "GreaseInterceptor",
	'Catch Basin(s): <b>' + STR(ISNULL(cspm.CatchBasins, 0), 5, 0) + '</b>' AS "CatchBasins",
	'Sink(s): <b>' + STR(ISNULL(cspm.Sinks, 0), 5, 0) + '</b>' AS "Sinks",
	'Other Fixture(s): <b>' + STR(ISNULL(cspm.OtherFixtures, 0), 5, 0) + '</b>' AS "OtherFixtures",

	'Furnace: <b>' + STR(ISNULL(cspm.FurnaceBTUs, 0), 12, 2) + '</b> BTUs' AS "FurnaceBTUs",
	'Air Conditioner: <b>' + STR(ISNULL(cspm.AirConditionerBTUs, 0), 12, 2) + '</b> BTUs' AS "AirConditionerBTUs",
	'Boiler: <b>' + STR(ISNULL(cspm.BoilerBTUs, 0), 12, 2) + '</b> BTUs' AS "BoilerBTUs",
	
	'Plumbing District: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.PlumbingDistrict), '') + '</b>' AS "PlumbingDistrict",
	'Sanitary Sewer Connect/Relay: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.SanitarySewerConnectRelay), '') + '</b>' AS "SanitarySewerConnectRelay",
	'Storm Sewer Connect/Relay: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.StormSewerConnectRelay), '') + '</b>' AS "StormSewerConnectRelay",
	'Water Connect/Relay: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.WaterConnectRelay), '') + '</b>' AS "WaterConnectRelay",
	
	'Equipment being Replaced: <b>' + ISNULL(STUFF((SELECT CAST(', ' + cfpli.SVALUE AS VARCHAR(201)) [text()]
			FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms ON cfpli.GCUSTOMFIELDPICKLISTITEM = cspmms.CUSTOMFIELDPICKLISTITEMID
			WHERE cspmms.ID = @PERMITID AND cfpli.FKGCUSTOMFIELDPICKLIST IN ('06912092-49b2-4072-89b0-39724f53ac9d', 'ed4e8eef-812d-4d27-ad42-c93e393f32ab', '91f6fe30-4b99-49f6-9259-65dde24a3a17')
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '), '') + '</b>' AS "HVACEquipmentBeingReplaced",

	'Ductwork: <b>' + ISNULL(STUFF((SELECT CAST(', ' + cfpli.SVALUE AS VARCHAR(201)) [text()]
			FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli
			INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms ON cfpli.GCUSTOMFIELDPICKLISTITEM = cspmms.CUSTOMFIELDPICKLISTITEMID
			WHERE cspmms.ID = @PERMITID AND cfpli.FKGCUSTOMFIELDPICKLIST IN ('848c85eb-b125-440f-97e3-5d9a5abd7791', 'cc6e9a56-035b-4688-929c-0150eb56837a', '59ed0dc9-b044-4168-8092-d96c7ad42bba')
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '), '') + '</b>' AS "HVACDuctwork",

	'Connection to Existing Wiring? <b>' + (CASE ISNULL(cspm.ConnectionToExistingWiring, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "ConnectionToExisitingWiring",
	'Boilers, Cooling Towers and Related Equipment directly connected to Potable Water System? <b>' + (CASE ISNULL(cspm.MechanicalEquipmentConnectedtoPotableWaterSystem, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "MechanicalEquipmentConnectedtoPotableWaterSystem",

	'Backflow Device Manufacturer: <b>' + ISNULL(cspm.BackflowDeviceManufacturer, '') + '</b>' AS "BackflowDeviceManufacturer",
	'Backflow Device Model Number: <b>' + ISNULL(cspm.BackflowDeviceModelNumber, '') + '</b>' AS "BackflowDeviceModelNumber",

	'Chimney Construction: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.ChimneyConstruction), '') + '</b>' AS "ChimneyConstruction",
	'Type of Liner: <b>' + ISNULL((SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = cspm.TypeOfChimneyLiner), '') + '</b>' AS "TypeOfChimneyLiner",

	'Chimney Dimensions: <b>' + ISNULL(cspm.ChimneyDimensions, '') + '</b>' AS "ChimneyDimensions",
	'Size of Liner: <b>' + ISNULL(cspm.SizeOfChimneyLiner, '') + '</b>' AS "SizeOfChimneyLiner",
	'' AS "EquipmentType",
	'' AS "EquipmentQuantity",
	'' AS "EquipmentIsReplacement",
	'' AS "EquipmentManufacturer",
	'' AS "EquipmentModelNumber",
	'' AS "EquipmentDetails"

FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm ON p.PMPERMITID = cspm.ID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
WHERE cspm.ID = @PERMITID

UNION

SELECT
	'HVAC-LIST' AS "LayoutSelector",
	'' AS "PermitNumber",
	'' AS "PermitTypeWorkClassName",
	'' AS "IsNewBuilding",
	'' AS "PlumbingCutAndCapOnly",
	'' AS "PlumbingConnectOrRelayOnly",
	'' AS "NumberOfDwellingUnits",
	'' AS "BuildingType",
	'' AS "TemporaryService",
	'' AS "ServiceSize",
	'' AS "Furnaces",
	'' AS "ACUnits",
	'' AS "WaterHeaters",
	'' AS "Dryers",
	'' AS "Ranges",
	'' AS "Heaters",
	'' AS "Outlets",
	'' AS "Motors",
	'' AS "Signs",
	'' AS "BathTubs",
	'' AS "FloorDrains",
	'' AS "LaundryTubs",
	'' AS "Showers",
	'' AS "Urinals",
	'' AS "GarbageDisposalUnits",
	'' AS "DrinkingFountains",
	'' AS "WaterSofteners",
	'' AS "RoofDrains",
	'' AS "WaterClosets",
	'' AS "GreaseInterceptor",
	'' AS "CatchBasins",
	'' AS "Sinks",
	'' AS "OtherFixtures",

	'' AS "FurnaceBTUs",
	'' AS "AirConditionerBTUs",
	'' AS "BoilerBTUs",

	'' AS "PlumbingDistrict",
	'' AS "SanitarySewerConnectRelay",
	'' AS "StormSewerConnectRelay",
	'' AS "WaterConnectRelay",

	'' AS "HVACEquipmentBeingReplaced",
	'' AS "HVACDuctwork",

	'' AS "ConnectionToExisitingWiring",
	'' AS "MechanicalEquipmentConnectedtoPotableWaterSystem",
	'' AS "BackflowDeviceManufacturer",
	'' AS "BackflowDeviceModelNumber",
	'' AS "ChimneyConstruction",
	'' AS "TypeOfChimneyLiner",
	'' AS "ChimneyDimensions",
	'' AS "SizeOfChimneyLiner",
	x.EquipmentType AS "EquipmentType",
	x.EquipmentQuantity AS "EquipmentQuantity",
	x.EquipmentIsReplacement AS "EquipmentIsReplacement",
	x.EquipmentManufacturer AS "EquipmentManufacturer",
	x.EquipmentModelNumber AS "EquipmentModelNumber",
	x.EquipmentDetails AS "EquipmentDetails"
FROM [laxreports].[HVACTableValues](@PERMITID) x