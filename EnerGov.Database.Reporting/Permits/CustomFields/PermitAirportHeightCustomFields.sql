CREATE PROCEDURE [dbo].[PermitAirportHeightCustomFields]
	@PERMITID AS VARCHAR(36)
AS

SELECT
	(CASE p.PMPERMITTYPEID WHEN '4457dc56-981b-45ed-b0b8-abc34438a78a' THEN p.PERMITNUMBER ELSE '' END) AS "PermitNumber",
	'<b>Permit: </b>Airport Height' AS "PermitTypeWorkClassName",
	'Height Zone: <b>' + ISNULL(cfpli.SVALUE, '') + '</b>' AS "AirportHeightZone"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON cspm.ID = p.PMPERMITID
INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMFIELDPICKLISTITEM cfpli ON cspm.AirportHeightZone = cfpli.GCUSTOMFIELDPICKLISTITEM
WHERE cspm.ID = @PERMITID AND cfpli.SVALUE <> 'None'