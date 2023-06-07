CREATE PROCEDURE [dbo].[PermitZonesForPermitId]
	@PERMITID AS VARCHAR(36)
AS
	SELECT
		pzc.SectionName AS "PermitZoneSectionName",
		pzc.SectionSortOrder AS "PermitZoneSectionSortOrder",
		ISNULL(STUFF((SELECT CAST(', ' + zx.[DESCRIPTION] + ' (' + zx.ZONECODE + ')' AS NVARCHAR(MAX)) [text()]
			FROM [$(EnerGovDatabase)].dbo.PMPERMITZONE pzx
			INNER JOIN [$(EnerGovDatabase)].dbo.ZONE zx ON pzx.ZONEID = zx.ZONEID
			INNER JOIN [laxreports].[PermitZonesClassification] pzcx ON pzcx.ZoneId = zx.ZONEID
			WHERE pzx.PMPERMITID = @PERMITID AND pzcx.SectionName = pzc.SectionName AND pzcx.SectionSortOrder = pzc.SectionSortOrder
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "PermitZones"
	FROM [$(EnerGovDatabase)].dbo.PMPERMITZONE pz
	INNER JOIN [$(EnerGovDatabase)].dbo.ZONE z ON pz.ZONEID = z.ZONEID
	INNER JOIN [laxreports].[PermitZonesClassification] pzc ON pzc.ZoneId = z.ZONEID
	WHERE pz.PMPERMITID = @PERMITID
	GROUP BY pzc.SectionName, pzc.SectionSortOrder
