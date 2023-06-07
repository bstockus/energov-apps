CREATE VIEW [dbo].[ParcelDistricts]
AS SELECT
		rpm.PropertyInternalID AS "PropertyId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		dc.Code AS "DistrictCode",
		dc.Description AS "DistrictCodeDescription",
		dct.CodeType AS "DistrictCodeType",
		dct.Description AS "DistrictCodeTypeDescription",
		dc.IsActive AS "IsActive",
		dct.UsageIndicator AS "DistrictUsageIndicator",
		dct.IsTaxationIndicator AS "IsTaxationIndicator",
		dct.IncludeInAssessmentProcess AS "IncludeInAssessmentProcess"
	FROM [dbo].[RealPropertyDistricts] rpd
	INNER JOIN [dbo].[RealProperties] rpm ON rpd.PropertyInternalID = rpm.PropertyInternalID
	INNER JOIN [dbo].[DistrictCodes] dc ON rpd.DistrictCode = dc.Code AND rpd.DistrictCodeType = dc.CodeType
	INNER JOIN [dbo].[DistrictCodeTypes] dct ON dc.CodeType = dct.CodeType
