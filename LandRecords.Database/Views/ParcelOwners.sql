CREATE VIEW [dbo].[ParcelOwners]
	AS SELECT 
		rpm.PropertyInternalID AS "PropertyId",
		nam.NameAddressID AS "OwnerId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		nam.LastName AS "LastName",
		nam.FirstName AS "FirstName",
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
		nam.ZipCode AS "ZipCode"
	FROM [dbo].[RealPropertyNameAddresses] rpnaxref
	INNER JOIN [dbo].[RealProperties] rpm ON rpnaxref.PropertyInternalID = rpm.PropertyInternalID
	INNER JOIN [dbo].[NameAddresses] nam ON rpnaxref.NameAddressID = nam.NameAddressID
	WHERE rpnaxref.IsBillToIndicator = 1 AND rpm.IsHistory = 0