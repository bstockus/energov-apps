CREATE VIEW [dbo].[ParcelLegalDescriptions]
	AS SELECT 
		rpm.PropertyInternalID AS "PropertyId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		rpld.LegalDescription AS "LegalDescription",
		rpm.Section AS "Section",
		rpm.Township AS "Township",
		rpm.[Range] AS "Range",
		rpm.[QuarterQuarter] AS "QuarterQuarter",
		rpm.IsHistory AS "ParcelIsHistory"
	FROM [dbo].[RealPropertyLegalDescriptions] rpld
	INNER JOIN [dbo].[RealProperties] rpm ON rpld.[PropertyInternalID] = rpm.[PropertyInternalID];
