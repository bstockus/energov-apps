CREATE PROCEDURE [dbo].[PermitLandDisturbanceCustomFields]
	@PERMITID AS VARCHAR(36)
AS

SELECT
	(CASE p.PMPERMITTYPEID WHEN '051b9ba5-d143-45e9-836e-e1e8e32c4e93' THEN p.PERMITNUMBER ELSE '' END) AS "PermitNumber",
	'<b>Permit: </b>Land Disturbance' AS "PermitTypeWorkClassName",

	'Area Disturbed: <b>' + STR(ISNULL(cspm.SquareFeetDisturbed, 0), 12, 2) + '</b> sq. ft.' AS "SquareFeetDisturbed",
	'Volume Filled: <b>' + STR(ISNULL(cspm.CubicFeetFilled, 0), 12, 2) + '</b> cu. ft.' AS "CubicFeetFilled",
	'Volume Excavated: <b>' + STR(ISNULL(cspm.CubicYardsExcavated, 0), 12, 2) + '</b> cu. yds.' AS "CubicYardsExcavated",
	'Length Disturbed: <b>' + STR(ISNULL(cspm.LinearFeetDisturbed, 0), 12, 2) + '</b> ft.' AS "LinearFeetDisturbed",

	'CPCP Provided from DNR (if over 1 acre)? <b>' + (CASE ISNULL(cspm.Over1AcreCPCPProvidedFromDNR, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "Over1AcreCPCPProvidedFromDNR",
	'Slope 20% or greater? <b>' + (CASE ISNULL(cspm.Slope20PctOrGreater, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "Slope20PctOrGreater",
	'Exempt from Land Disturbance Fee? <b>' + (CASE ISNULL(cspm.ExemptFromLandDisturbanceFee, 0) WHEN 1 THEN 'Y' ELSE 'N' END) + '</b>' AS "ExemptFromLandDisturbanceFee"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON cspm.ID = p.PMPERMITID
WHERE cspm.ID = @PERMITID AND 
		((p.PMPERMITWORKCLASSID = '016aca7a-abe2-4c0f-abac-3ef1eca172e5' OR
			(ISNULL(cspm.Slope20PctOrGreater, 0) = 1 AND ISNULL(cspm.SquareFeetDisturbed, 0) >= 2000) OR
			(ISNULL(cspm.Slope20PctOrGreater, 0) = 0 AND ISNULL(cspm.SquareFeetDisturbed, 0) >= 4000)) AND 
			ISNULL(cspm.ExemptFromLandDisturbanceFee, 0) = 0)