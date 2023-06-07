CREATE VIEW [dbo].[ParcelZones]
	AS SELECT
		rpm.PropertyInternalID AS "PropertyId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		zc.Code AS "ZoneCode",
		zc.Description AS "ZoneCodeDescription",
		zct.CodeType AS "ZoneCodeType",
		zct.Description AS "ZoneCodeTypeDescription",
		zc.IsActive AS "IsActive"
	FROM [dbo].[RealPropertyZones] rpz
	INNER JOIN [dbo].[RealProperties] rpm ON rpz.PropertyInternalID = rpm.PropertyInternalID
	INNER JOIN [dbo].[ZoneCodes] zc ON rpz.ZoneCode = zc.Code AND rpz.ZoneCodeType = zc.CodeType AND rpz.LocalMunicipalityCode = zc.LocalMunicipalityCode
	INNER JOIN [dbo].[ZoneCodeTypes] zct ON zc.CodeType = zct.CodeType
