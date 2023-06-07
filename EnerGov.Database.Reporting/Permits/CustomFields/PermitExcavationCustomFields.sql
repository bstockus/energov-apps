﻿CREATE PROCEDURE [dbo].[PermitExcavationCustomFields]
	@PERMITID AS VARCHAR(36)
AS

SELECT
	cspm.EstimatedStartDate,
	cspm.EstimatedCompletionDate,
	cspm.NumberOfParkingLanesToBeClosed,
	cspm.NumberOfTrafficLanesToBeClosed,
	cspm.PurposeOfExcavationOther AS "PurposeOfExcavationOtherText",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '06bbc476-d64f-4bf2-88a3-ab3c841b943b') AS "AreaToBeExcavatedCurbRamp",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '1a94061c-5c96-4b6b-9509-0eb7abeef7f8') AS "AreaToBeExcavatedStreet",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '2b7aba53-d5cd-454c-bb04-0140c38ada9c') AS "AreaToBeExcavatedSidewalk",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '612c8cce-9a09-4b25-81c3-b3e5c851d1b9') AS "AreaToBeExcavatedBoulevardTerrace",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '8fffc581-b982-4523-be84-dce5e952607a') AS "AreaToBeExcavatedAlley",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '9759b7c9-f782-4ccf-8943-fed7211359a7') AS "AreaToBeExcavatedCurbGutter",
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = 'a16b041a-a0ee-4035-a540-304bc7e8b25b') AS "AreaToBeExcavatedDriveway",

	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '2e74ac4a-10c2-410f-8eea-941e9f51cf46') AS PurposeOfExcavationCommunication,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '32fdc296-a9a2-4073-a1f2-07763f96b160') AS PurposeOfExcavationGas,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '37dfbf7d-52c5-4c30-9c8e-96456d7a4ab6') AS PurposeOfExcavationElectrical,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '4e6ac06d-3c2a-47bf-8132-310e40909612') AS PurposeOfExcavationOther,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '53176463-8e54-4df4-86aa-54529c2d8e53') AS PurposeOfExcavationStormSewer,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '6c3451ba-a87e-464e-9f29-84f0539bf4c0') AS PurposeOfExcavationReplacementDriveway,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '7212f004-aa81-496b-92b9-4b6b788c0df4') AS PurposeOfExcavationNewSidewalk,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '7a00756b-a513-46fc-94e4-9449e5c0d9e0') AS PurposeOfExcavationReplacementSidewalk,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = '7e47c792-1237-4c4a-b2f3-a70eb0768508') AS PurposeOfExcavationSanSewer,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = 'abe9d7d7-185c-4b76-b6d4-c15cc78240c1') AS PurposeOfExcavationNewCurbCut,
	(SELECT TOP 1 cfpli.SVALUE FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENTMS cspmms 
		INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspmms.CUSTOMFIELDPICKLISTITEMID = cfpli.GCUSTOMFIELDPICKLISTITEM 
		WHERE cspmms.ID = @PERMITID AND cspmms.CUSTOMFIELDPICKLISTITEMID = 'ad2e8254-1cea-4c04-b63f-d3195173eac2') AS PurposeOfExcavationWater,
	p.PERMITNUMBER
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON cspm.ID = p.PMPERMITID
WHERE cspm.ID = @PERMITID
