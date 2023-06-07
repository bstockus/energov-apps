

CREATE PROCEDURE [dbo].[rpt_Business_License_Companies_Reports_By_Close_Date]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SELECT     BLLicenseType.Name AS LicenseType, BLLicense.LicenseNumber, BLLicenseStatus.Name AS LicenseStatus, BLLicenseClass.Name AS Classification, 
                      BLLicense.IssuedDate, BLLicense.ExpirationDate, BLLicense.AppliedDate, BLLicense.TaxYear, GlobalEntity.GlobalEntityName, 
                      BLExtBusinessType.Name AS CompanyType, BLExtStatus.Name AS CompanyStatus, BLGlobalEntityExtension.DBA, BLGlobalEntityExtension.OpenDate, 
                      BLGlobalEntityExtension.CloseDate, BLGlobalEntityExtension.BLGlobalEntityExtensionID, BLGlobalEntityExtension.EINNumber, BLExtLocation.Name AS Location, 
                      MailingAddress.AddressLine1, MailingAddress.AddressLine2, MailingAddress.AddressLine3, MailingAddress.City, MailingAddress.State, MailingAddress.PostalCode, 
                      MailingAddress.StreetType, MailingAddress.PostDirection, MailingAddress.PreDirection, 
                      BLLicense.BLGlobalEntityExtensionID AS BLLicense_GlobalEntityExtensionID
FROM         MailingAddress INNER JOIN
                      BLGlobalEntityExtensionAddress ON MailingAddress.MailingAddressID = BLGlobalEntityExtensionAddress.MailingAddressID RIGHT OUTER JOIN
                      BLGlobalEntityExtensionBusinessType INNER JOIN
                      GlobalEntity INNER JOIN
                      BLGlobalEntityExtension ON GlobalEntity.GlobalEntityID = BLGlobalEntityExtension.GlobalEntityID ON 
                      BLGlobalEntityExtensionBusinessType.BLGlobalEntityExtensionID = BLGlobalEntityExtension.BLGlobalEntityExtensionID INNER JOIN
                      BLExtBusinessType ON BLGlobalEntityExtensionBusinessType.BLExtBusinessTypeID = BLExtBusinessType.BLExtBusinessTypeID INNER JOIN
                      BLExtStatus ON BLGlobalEntityExtension.BLExtStatusID = BLExtStatus.BLExtStatusID ON 
                      BLGlobalEntityExtensionAddress.BLGlobalEntityExtensionID = BLGlobalEntityExtension.BLGlobalEntityExtensionID LEFT OUTER JOIN
                      BLExtLocation ON BLGlobalEntityExtension.BLExtLocationID = BLExtLocation.BLExtLocationID LEFT OUTER JOIN
                      BLLicenseType INNER JOIN
                      BLLicense ON BLLicenseType.BLLicenseTypeID = BLLicense.BLLicenseTypeID INNER JOIN
                      BLLicenseStatus ON BLLicense.BLLicenseStatusID = BLLicenseStatus.BLLicenseStatusID INNER JOIN
                      BLLicenseClass ON BLLicense.BLLicenseClassID = BLLicenseClass.BLLicenseClassID ON 
                      BLGlobalEntityExtension.BLGlobalEntityExtensionID = BLLicense.BLGlobalEntityExtensionID
WHERE BLGlobalEntityExtension.CloseDate >= @STARTDATE AND BLGlobalEntityExtension.CloseDate <= @ENDDATE

