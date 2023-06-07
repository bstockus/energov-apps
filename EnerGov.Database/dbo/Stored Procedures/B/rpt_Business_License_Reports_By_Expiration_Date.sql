

CREATE PROCEDURE [dbo].[rpt_Business_License_Reports_By_Expiration_Date]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SELECT     BLLicenseType.Name AS LicenseType, BLLicense.LicenseNumber, BLLicenseStatus.Name AS LicenseStatus, BLLicenseClass.Name AS Classification, 
                      BLLicense.IssuedDate, BLLicense.ExpirationDate, BLLicense.TaxYear, GlobalEntity.GlobalEntityName
FROM         BLLicense INNER JOIN
                      BLGlobalEntityExtension ON BLLicense.BLGlobalEntityExtensionID = BLGlobalEntityExtension.BLGlobalEntityExtensionID INNER JOIN
                      GlobalEntity ON BLGlobalEntityExtension.GlobalEntityID = GlobalEntity.GlobalEntityID INNER JOIN
                      BLLicenseType ON BLLicense.BLLicenseTypeID = BLLicenseType.BLLicenseTypeID INNER JOIN
                      BLLicenseStatus ON BLLicense.BLLicenseStatusID = BLLicenseStatus.BLLicenseStatusID INNER JOIN
                      BLLicenseClass ON BLLicense.BLLicenseClassID = BLLicenseClass.BLLicenseClassID
WHERE BLLicense.ExpirationDate >= @STARTDATE AND BLLicense.ExpirationDate <= @ENDDATE

