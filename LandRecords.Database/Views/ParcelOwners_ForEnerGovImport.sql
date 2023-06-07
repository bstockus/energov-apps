CREATE VIEW [dbo].[ParcelOwners_ForEnerGovImport]
	AS SELECT 
		rpm.PropertyInternalID AS "PropertyId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		(SELECT TOP (1) LTRIM(RTRIM(CAST(LTRIM(RTRIM(nam2.FirstName)) + ' ' + LTRIM(RTRIM(nam2.LastName)) AS VARCHAR(201)))) 
			FROM [dbo].[RealPropertyNameAddresses] rpnaxref2
			INNER JOIN [dbo].[NameAddresses] nam2 ON rpnaxref2.NameAddressID = nam2.NameAddressID
				 WHERE rpnaxref2.PropertyInternalID = rpm.PropertyInternalID AND rpnaxref2.NameTypeCode IN ('L','N','O','V')
			ORDER BY nam2.LastName, nam2.FirstName) AS "Owner1Name",
		(SELECT LTRIM(RTRIM(CAST(LTRIM(RTRIM(nam2.FirstName)) + ' ' + LTRIM(RTRIM(nam2.LastName)) AS VARCHAR(201)))) 
			FROM [dbo].[RealPropertyNameAddresses] rpnaxref2
			INNER JOIN [dbo].[NameAddresses] nam2 ON rpnaxref2.NameAddressID = nam2.NameAddressID
				 WHERE rpnaxref2.PropertyInternalID = rpm.PropertyInternalID AND rpnaxref2.NameTypeCode IN ('L','N','O','V')
			ORDER BY nam2.LastName, nam2.FirstName
			OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY) AS "Owner2Name",
		
		STUFF((SELECT ', ' + LTRIM(RTRIM(CAST(LTRIM(RTRIM(nam2.FirstName)) + ' ' + LTRIM(RTRIM(nam2.LastName)) AS VARCHAR(201)))) [text()]
				 FROM [dbo].[RealPropertyNameAddresses] rpnaxref2
				 INNER JOIN [dbo].[NameAddresses] nam2 ON rpnaxref2.NameAddressID = nam2.NameAddressID
				 WHERE rpnaxref2.PropertyInternalID = rpm.PropertyInternalID AND rpnaxref2.NameTypeCode IN ('L','N','O','V')
				 FOR XML PATH(''), TYPE)
				.value('.','NVARCHAR(MAX)'),1,2,' ') "OwnerName",
		nam.IsBusiness AS "IsBusiness",
		nam.StreetName AS "StreetName",
		nam.StreetType AS "StreetType",
		nam.StreetPrefixDirectional AS "StreetPrefixDirectional",
		nam.StreetSuffixDirectional AS "StreetSuffixDirectional",
		nam.HouseNumber AS "HouseNumber",
		nam.StreetSecondaryNumber AS "SecondaryNumber",
		nam.SecondaryType AS "SecondaryType",
		nam.City AS "City",
		nam.[State] AS "State",
		CASE WHEN Len(nam.ZipCode) = 9 THEN Left(nam.ZipCode, 5) + '-' + Right(nam.ZipCode, 4) ELSE nam.ZipCode END AS "ZipCode",
		LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(nam.HouseNumber)) + ' ' + nam.StreetPrefixDirectional)) + ' ' + nam.StreetName)) + ' ' + nam.StreetType)) + ' ' + 
			nam.StreetSuffixDirectional)) AS "CompleteAddress",
		LTRIM(RTRIM(LTRIM(RTRIM(nam.SecondaryType)) + ' ' + nam.StreetSecondaryNumber)) AS "CompleteSecondary"
	FROM [dbo].[RealProperties] rpm
	INNER JOIN [dbo].[RealPropertyNameAddresses] rpnaxref ON rpm.PropertyInternalID = rpnaxref.PropertyInternalID
	INNER JOIN [dbo].[NameAddresses] nam ON rpnaxref.NameAddressID = nam.NameAddressID
	WHERE rpnaxref.IsBillToIndicator = 1 AND rpm.IsHistory = 0
