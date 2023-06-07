

CREATE PROCEDURE [dbo].[rpt_Payments_By_User_Report]
AS
SELECT     CAComputedFee.FeeName, CATransactionFee.PaidAmount, CATransaction.ReceiptNumber, COALESCE (PMPermit.PermitNumber, PLPlan.PLANNumber, 
                      BLLicense.LicenseNumber, CMCodeCase.CaseNumber, PRProject.Name) AS CaseNumber, Users.ID, CAInvoice.InvoiceNumber, CAComputedFee.ComputedAmount, 
                      CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData, 
                      CATransactionStatus.Name AS TransactionStatus, CAStatus.Name AS InvoiceStatus, CATransactionType.Name AS TransactionType
FROM         CATransactionFee INNER JOIN
                      CAComputedFee ON CATransactionFee.CAComputedFeeID = CAComputedFee.CAComputedFeeID INNER JOIN
                      CATransaction ON CATransactionFee.CATransactionID = CATransaction.CATransactionID INNER JOIN
                      Users ON CATransaction.CreatedBy = Users.sUserGUID INNER JOIN
                      CATransactionPayment ON CATransaction.CATransactionID = CATransactionPayment.CATransactionID INNER JOIN
                      CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID INNER JOIN
                      CATransactionInvoice ON CATransaction.CATransactionID = CATransactionInvoice.CATransactionID INNER JOIN
                      CAInvoice ON CATransactionInvoice.CAInvoiceID = CAInvoice.CAInvoiceID INNER JOIN
                      CATransactionStatus ON CATransaction.CATransactionStatusID = CATransactionStatus.CATransactionStatusID INNER JOIN
                      CAStatus ON CAInvoice.CAStatusID = CAStatus.CAStatusID INNER JOIN
                      CATransactionType ON CATransaction.CATransactionTypeID = CATransactionType.CATransactionTypeID LEFT OUTER JOIN
                      PRProjectFee INNER JOIN
                      PRProject ON PRProjectFee.PRProjectID = PRProject.PRProjectID ON CAComputedFee.CAComputedFeeID = PRProjectFee.CAComputedFeeID LEFT OUTER JOIN
                      BLLicenseFee INNER JOIN
                      BLLicense ON BLLicenseFee.BLLicenseID = BLLicense.BLLicenseID ON CAComputedFee.CAComputedFeeID = BLLicenseFee.CAComputedFeeID LEFT OUTER JOIN
                      CMCodeCaseFee INNER JOIN
                      CMCodeCase ON CMCodeCaseFee.CMCodeCaseID = CMCodeCase.CMCodeCaseID ON 
                      CAComputedFee.CAComputedFeeID = CMCodeCaseFee.CAComputedFeeID LEFT OUTER JOIN
                      PLPlan INNER JOIN
                      PLPlanFee ON PLPlan.PLPlanID = PLPlanFee.PLPlanID ON CAComputedFee.CAComputedFeeID = PLPlanFee.CAComputedFeeID LEFT OUTER JOIN
                      PMPermit INNER JOIN
                      PMPermitFee ON PMPermit.PMPermitID = PMPermitFee.PMPermitID ON CAComputedFee.CAComputedFeeID = PMPermitFee.CAComputedFeeID
WHERE CATransactionType.CATransactionTypeID not in (5,6) and CATransactionStatus.CATransactionStatusID not in (2,3) and CAInvoice.CAStatusID != 5

