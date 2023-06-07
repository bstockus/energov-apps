CREATE VIEW [dbo].[ParcelAddresses]
	AS SELECT
		rpm.PropertyInternalID AS "PropertyId",
		pam.PropertyAddressID AS "AddressId",
		CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber) AS "ParcelNumber",
		pam.PropertyStreetName AS "StreetName",
		pam.PropertyStreetType AS "StreetType",
		pam.PropertyStreetPrefixDirectional AS "StreetDirectionalPrefix",
		pam.PropertyStreetSuffixDirectional AS "StreetDirectionalSuffix",
		pam.PropertyHouseNumber AS "HouseNumber",
		pam.PropertySecondaryNumber AS "SecondaryNumber",
		pam.PropertySecondaryType AS "SecondaryType",
		pam.PropertyCity AS "City",
		pam.PropertyState AS "State",
		pam.PropertyZipCode AS "ZipCode"
	FROM [dbo].[RealPropertyAddresses] paxref
	INNER JOIN [dbo].[RealProperties] rpm ON paxref.PropertyInternalID = rpm.PropertyInternalID
	INNER JOIN [dbo].[PropertyAddresses] pam ON paxref.PropertyAddressID = pam.PropertyAddressID
