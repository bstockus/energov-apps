
CREATE PROCEDURE [dbo].[rpt_BusinessLicenseByExpiration]
--=============================================================
-- [rpt_BusinessLicenseByExpiration]
--=============================================================
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/24/2010>
-- Description:	<Created as a script to pull all business license information;
-- Report(s) using this query:
-- BusinessLicenseByExpiration.rpt
-- =============================================
AS
BEGIN
	SET NOCOUNT ON;
	
SELECT BLGlobalEntityExtension.GlobalEntityID, GlobalEntityName, DBA, EINNumber, RegistrationID
	, BLLicense.BLLicenseID, LicenseNumber, BLLicenseType.Name AS LicenseType, BLLicenseClass.Name AS LicenseClass, BLLicenseStatus.Name AS LicenseStatus
	, AppliedDate, IssuedDate, ExpirationDate, LastRenewalDate, TaxYear
	, District.Name AS District, Users.FName AS IssuedByFName, Users.LName AS IssuedByLName
	, AddressType, AddressLine1, PreDirection, AddressLine2, StreetType, PostDirection, AddressLine3, City, State, PostalCode 
FROM 
	BLLicense
	INNER JOIN BLLicenseType ON BLLicense.BLLicenseTypeID = BLLicenseType.BLLicenseTypeID 
	INNER JOIN BLLicenseStatus ON BLLicense.BLLicenseStatusID = BLLicenseStatus.BLLicenseStatusID 
	INNER JOIN BLLicenseClass ON BLLicense.BLLicenseClassID = BLLicenseClass.BLLicenseClassID 
	LEFT OUTER JOIN Users ON BLLicense.IssuedBy = Users.sUserGUID
	INNER JOIN District ON BLLicense.DistrictID = District.DistrictID 

	INNER JOIN BLGlobalEntityExtension ON BLLicense.BLGlobalEntityExtensionID = BLGlobalEntityExtension.BLGlobalEntityExtensionID
	INNER JOIN GlobalEntity ON BLGlobalEntityExtension.GlobalEntityID = GlobalEntity.GlobalEntityID 	
	INNER JOIN BLExtCompanyType ON BLGlobalEntityExtension.BLExtCompanyTypeID = BLExtCompanyType.BLExtCompanyTypeID 
	--LEFT OUTER JOIN BLLicenseAddress ON BLLicense.BLLicenseID = BLLicenseAddress.BLLicenseID 
	--LEFT OUTER JOIN MailingAddress ON BLLicenseAddress.MailingAddressID = MailingAddress.MailingAddressID 
	LEFT OUTER JOIN BLGlobalEntityExtensionAddress ON BLGlobalEntityExtension.BLGlobalEntityExtensionID = BLGlobalEntityExtensionAddress.BLGlobalEntityExtensionID
	LEFT OUTER JOIN MailingAddress ON BLGlobalEntityExtensionAddress.MailingAddressID = MailingAddress.MailingAddressID 
	
WHERE BLGlobalEntityExtensionAddress.Main = 'TRUE'	
--order by GlobalEntityName
END

