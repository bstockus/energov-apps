

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Certifications]
@GLOBALENTITYID as varchar(36)
AS
SELECT     COLicenseCertification.IssueDate, COLicenseCertification.ExpireDate, COLicenseCertification.LicenseNumber, 
                      COLicenseCertificationType.Name AS [Certification Type], COLicenseCertification.COSimpleLicCertID
FROM         COLicenseCertification INNER JOIN
                      COLicenseCertificationType ON COLicenseCertification.COSimpleLicCertTypeID = COLicenseCertificationType.COSimpleLicCertTypeID
WHERE COLicenseCertification.GlobalEntityID = @GLOBALENTITYID

