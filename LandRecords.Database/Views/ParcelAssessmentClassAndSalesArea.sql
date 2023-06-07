CREATE VIEW [dbo].[ParcelAssessmentClassAndSalesArea]
	AS SELECT
		rpm.PropertyInternalID AS "PropertyId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		(SELECT TOP 1 rpta.TaxAssessmentClassCode FROM [dbo].[RealPropertyTaxAssessments] rpta WHERE rpta.PropertyInternalID = rpm.PropertyInternalID ORDER BY rpta.TaxationYear DESC) AS "TaxAssessmentClass",
		(SELECT TOP 1 psa.SalesArea FROM [dbo].[PropertySalesAreas] psa WHERE CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) = psa.ParcelNumber) AS "SalesArea"
	FROM [dbo].[RealProperties] rpm
	WHERE rpm.IsHistory != 1 AND rpm.PropertyTaxableCurrentYear = 1