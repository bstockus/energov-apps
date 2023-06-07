CREATE VIEW [dbo].[ParcelOverview]
	AS SELECT
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",		
		STUFF((SELECT ', ' + LTRIM(RTRIM(CAST(LTRIM(RTRIM(nam2.FirstName)) + ' ' + LTRIM(RTRIM(nam2.LastName)) AS VARCHAR(201)))) [text()]
				 FROM [dbo].[RealPropertyNameAddresses] rpnaxref2
				 INNER JOIN [dbo].[NameAddresses] nam2 ON rpnaxref2.NameAddressID = nam2.NameAddressID
				 WHERE rpnaxref2.PropertyInternalID = rpm.PropertyInternalID AND rpnaxref2.NameTypeCode IN ('L','N','O','V')
				 FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,'') "OwnerName",
		STUFF((SELECT ', ' + LTRIM(RTRIM(CAST((LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(rpa.PropertyHouseNumber)) + ' ' + rpa.PropertyStreetPrefixDirectional)) + ' ' + rpa.PropertyStreetName)) + ' ' + rpa.PropertyStreetType)) + ' ' + 
			rpa.PropertyStreetSuffixDirectional))) AS VARCHAR(1000)))) [text()]
			FROM [dbo].[RealPropertyAddresses] paxref
			INNER JOIN [dbo].[PropertyAddresses] rpa ON paxref.PropertyAddressID = rpa.PropertyAddressID
			WHERE paxref.PropertyInternalID = rpm.PropertyInternalID
			GROUP BY LTRIM(RTRIM(CAST((LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(rpa.PropertyHouseNumber)) + ' ' + rpa.PropertyStreetPrefixDirectional)) + ' ' + rpa.PropertyStreetName)) + ' ' + rpa.PropertyStreetType)) + ' ' + 
			rpa.PropertyStreetSuffixDirectional))) AS VARCHAR(1000))))
			FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, '') "Addresses",
			(CASE WHEN rpm.QuarterQuarter IN (11,21,31,41) THEN 'NE' 
			WHEN rpm.QuarterQuarter IN (12,22,32,42) THEN 'NW'
			WHEN rpm.QuarterQuarter IN (13,23,33,43) THEN 'SW'
			WHEN rpm.QuarterQuarter IN (14,24,34,44) THEN 'SE' END) + ' 1/4, ' + 
			(CASE WHEN rpm.QuarterQuarter IN (11,12,13,14) THEN 'NE' 
			WHEN rpm.QuarterQuarter IN (21,22,23,24) THEN 'NW'
			WHEN rpm.QuarterQuarter IN (31,32,33,34) THEN 'SW'
			WHEN rpm.QuarterQuarter IN (41,42,43,44) THEN 'SE' END) + ' 1/4, S' + RTRIM(LTRIM(rpm.Section)) + ', T' + RTRIM(LTRIM(rpm.Township)) + 'N, R' + RTRIM(LTRIM(rpm.[Range])) + 'W' AS "PLSSLocation",
		(SELECT TOP (1) pld.LegalDescription FROM [dbo].[RealPropertyLegalDescriptions] pld WHERE pld.PropertyInternalID = rpm.PropertyInternalID) AS "LegalDescription",
		rpm.TotalAcreage AS "TotalAcreage"
	FROM [dbo].[RealProperties] rpm
	WHERE rpm.IsHistory = 0
