

CREATE PROCEDURE [dbo].[rpt_BL_Year_Over_Year_License_Report_By_License_Type]
@YEAR AS INT
AS
SELECT BLLICENSE.LicenseNumber AS LicenseNumber, BLLICENSETYPE.Name AS LicenseType, BLLICENSE.EstimatedReceipts AS EstimatedReceipts, BLLICENSE.AppliedDate AS ApplyDate, 
       BLLICENSE.ReportedReceipts AS ReportedReceipts, BLLICENSE.ExpirationDate AS ExpireDate, BLLICENSE.IssuedDate AS IssuedDate
FROM BLLICENSE 
INNER JOIN BLLICENSETYPE ON BLLICENSE.BLLICENSETYPEID = BLLICENSETYPE.BLLICENSETYPEID


