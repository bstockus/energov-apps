


CREATE PROCEDURE [dbo].[rpt_Avery_5160_Business_License_Company_Labels]
@TAXYEAR AS NUMERIC(4)
AS

SELECT GlobalEntity.GlobalEntityName, GlobalEntity.FirstName+' '+GlobalEntity.LastName AS NAME, BLLicense.IssuedDate, BLLicenseType.Name AS LicenseType, 
       AddressType, AddressLine1, AddressLine2, AddressLine3, City, MailingAddress.State, PostalCode, PostDirection, PreDirection, StreetType, UnitOrSuite
FROM BLGlobalEntityExtension 
INNER JOIN GlobalEntity ON BLGlobalEntityExtension.GlobalEntityID = GlobalEntity.GlobalEntityID 
INNER JOIN BLGlobalEntityExtensionAddress ON BLGlobalEntityExtension.BLGlobalEntityExtensionID = BLGlobalEntityExtensionAddress.BLGlobalEntityExtensionID 
INNER JOIN MailingAddress ON BLGlobalEntityExtensionAddress.MailingAddressID = MailingAddress.MailingAddressID 
INNER JOIN BLLicense ON BLGlobalEntityExtension.BLGlobalEntityExtensionID = BLLicense.BLGlobalEntityExtensionID 
INNER JOIN BLLicenseType ON BLLicense.BLLicenseTypeID = BLLicenseType.BLLicenseTypeID

WHERE MailingAddress.AddressType = 'Mailing Address' 
AND BLLicense.TaxYear = @TAXYEAR


