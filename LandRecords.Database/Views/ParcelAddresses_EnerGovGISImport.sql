CREATE VIEW [dbo].[ParcelAddresses_EnerGovGISImport]
	AS SELECT
		--rpm.PropertyInternalID AS "PropertyId",
		--pam.PropertyAddressID AS "AddressId",
		CONVERT(VARCHAR(48), CONVERT(VARCHAR(10), rpm.LocalMunicipalityCode) + '-' + CONVERT(VARCHAR(10), rpm.MiddleParcelNumber) + '-' + CONVERT(VARCHAR(10), rpm.RightParcelNumber)) AS "TAXPARCELNUM",
		CONVERT(VARCHAR(28), pam.PropertyStreetName) AS "PROPADDSTNAME",
		CONVERT(VARCHAR(4), pam.PropertyStreetType) AS "PROPADDSTTYPE",
		--pam.PropertyStreetPrefixDirectional AS "StreetDirectionalPrefix",
		CONVERT(VARCHAR(2), pam.PropertyStreetSuffixDirectional) AS "PROPADDSTSUFF",
		CONVERT(VARCHAR(10), pam.PropertyHouseNumber) AS "PROPADDNUM",
		CONVERT(VARCHAR(6), pam.PropertySecondaryNumber) AS "PROPADDSECNUM",
		CONVERT(VARCHAR(10), pam.PropertySecondaryType) AS "PROPADDSECTYPE",
		CONVERT(VARCHAR(100), pam.PropertyCity) AS "PROPADDMUNI",
		--pam.PropertyState AS "State",
		CONVERT(VARCHAR(10), pam.PropertyZipCode) AS "PROPADDZIP",
		LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(LTRIM(RTRIM(pam.PropertyHouseNumber)) + ' ' + pam.PropertyStreetName)) + ' ' + pam.PropertyStreetType)) + ' ' + 
			pam.PropertyStreetSuffixDirectional)) + ' ' + pam.PropertySecondaryType)) + ' ' + pam.PropertySecondaryNumber)) AS "PROPADDCOMP",
		LTRIM(RTRIM(LTRIM(RTRIM(pam.PropertySecondaryType)) + ' ' + pam.PropertySecondaryNumber)) AS "PROPADDSEC",
		'P' + FORMAT(rpm.PropertyInternalID, '000000') + '-A' + FORMAT(pam.PropertyAddressID, '000000') AS "PROPADDID"
	FROM [dbo].[RealPropertyAddresses] paxref
	INNER JOIN [dbo].[RealProperties] rpm ON paxref.PropertyInternalID = rpm.PropertyInternalID
	INNER JOIN [dbo].[PropertyAddresses] pam ON paxref.PropertyAddressID = pam.PropertyAddressID
	WHERE rpm.IsHistory = 0
