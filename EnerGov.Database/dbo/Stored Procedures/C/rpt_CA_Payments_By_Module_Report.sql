


CREATE PROCEDURE [dbo].[rpt_CA_Payments_By_Module_Report]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT CATransaction.CATransactionID, CATransactionFee.CATransactionFeeID, CAComputedFee.CAComputedFeeID, 
       CATransaction.ReceiptNumber, CAInvoice.InvoiceNumber, COALESCE(PMPermit.PermitNumber, PLPlan.PLANNumber, BLLicense.LicenseNumber, CMCodeCase.CaseNumber, PRProject.Name) AS CaseNumber, 
       CATransactionFee.PaidAmount, CATransactionFee.REFUNDAMOUNT, CAComputedFee.ComputedAmount, 
       CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData, 
       CATransactionStatus.Name AS TransactionStatus, CAStatus.Name AS InvoiceStatus, CAStatus_1.Name AS [Transaction Fee Status], 
       CATransactionType.Name AS TransactionType, CAFee.Name AS FeeName, CAModule.Name AS Module, CAEntity.Name AS Entity, 
       Users.ID, CATransaction.GlobalEntityID, CAInvoiceFee.CAInvoiceFeeID
FROM CATransactionFee 
INNER JOIN CAComputedFee ON CATransactionFee.CAComputedFeeID = CAComputedFee.CAComputedFeeID 
INNER JOIN CATransaction ON CATransactionFee.CATransactionID = CATransaction.CATransactionID 
INNER JOIN Users ON CATransaction.CreatedBy = Users.sUserGUID 
INNER JOIN CATransactionPayment ON CATransaction.CATransactionID = CATransactionPayment.CATransactionID 
INNER JOIN CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID 
INNER JOIN CATransactionStatus ON CATransaction.CATransactionStatusID = CATransactionStatus.CATransactionStatusID 
INNER JOIN CAStatus AS CAStatus_1 ON CATransactionFee.CAStatusID = CAStatus_1.CAStatusID 
INNER JOIN CAInvoiceFee ON CAComputedFee.CAComputedFeeID = CAInvoiceFee.CAComputedFeeID 
INNER JOIN CATransactionType ON CATransactionType.CATransactionTypeID = CATransaction.CATransactionTypeID 
INNER JOIN CAInvoice ON CAInvoiceFee.CAInvoiceID = CAInvoice.CAInvoiceID 
INNER JOIN CAStatus ON CAStatus.CAStatusID = CAInvoice.CAStatusID
INNER JOIN CAFeeTemplateFee ON CAComputedFee.CAFeeTemplateFeeID = CAFeeTemplateFee.CAFeeTemplateFeeID 
INNER JOIN CAFEETEMPLATE ON CAFeeTemplateFee.CAFEETEMPLATEID = CAFEETEMPLATE.CAFEETEMPLATEID
INNER JOIN CAFee ON CAFeeTemplateFee.CAFeeID = CAFee.CAFeeID
LEFT OUTER JOIN CMCodeCaseFee ON CMCodeCaseFee.CAComputedFeeID = CAComputedFee.CAComputedFeeID
LEFT OUTER JOIN CMCodeCase ON CMCodeCaseFee.CMCodeCaseID = CMCodeCase.CMCodeCaseID 
LEFT OUTER JOIN PRProjectFee ON CAComputedFee.CAComputedFeeID = PRProjectFee.CAComputedFeeID
LEFT OUTER JOIN PRProject ON PRProjectFee.PRProjectID = PRProject.PRProjectID
LEFT OUTER JOIN BLLicenseFee ON CAComputedFee.CAComputedFeeID = BLLicenseFee.CAComputedFeeID
LEFT OUTER JOIN BLLicense ON BLLicenseFee.BLLicenseID = BLLicense.BLLicenseID 
LEFT OUTER JOIN PLPlanFee ON CAComputedFee.CAComputedFeeID = PLPlanFee.CAComputedFeeID
LEFT OUTER JOIN PLPlan ON PLPlan.PLPlanID = PLPlanFee.PLPlanID 
LEFT OUTER JOIN PMPermitFee ON CAComputedFee.CAComputedFeeID = PMPermitFee.CAComputedFeeID
LEFT OUTER JOIN PMPermit ON PMPermit.PMPermitID = PMPermitFee.PMPermitID 
LEFT OUTER JOIN CAEntity ON CAFEETEMPLATE.CAENTITYID = CAENTITY.CAENTITYID
LEFT OUTER JOIN CAModule ON CAEntity.CAMODULEID = CAMODULE.CAMODULEID
WHERE CATransactionPayment.PaymentDate BETWEEN @STARTDATE AND @ENDDATE
AND (CATransactionType.CATransactionTypeID NOT IN (5, 6)) 
AND (CATransactionStatus.CATransactionStatusID NOT IN (2, 3))
AND (CAInvoice.CAStatusID <> 5) 
AND (CATransactionFee.CAStatusID NOT IN (5, 6))

UNION ALL

SELECT CATransaction.CATransactionID, CATransactionMiscFee.CATransactionMiscFeeID AS CATransactionFeeID, CAMiscFee.CAMiscFeeID AS CAComputedFeeID, 
       CATransaction.ReceiptNumber, CAInvoice.InvoiceNumber, 'Misc Fee' AS CaseNumber, 
       CATransactionMiscFee.PaidAmount, CATransactionMiscFee.REFUNDAMOUNT, CAMiscFee.Amount AS ComputedAmount, 
       CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData, 
       CATransactionStatus.Name AS TransactionStatus, CAStatus.Name AS InvoiceStatus, CAStatus_1.Name AS [Transaction Fee Status], 
       CATransactionType.Name AS TransactionType, CAFee.Name AS FeeName, CAModule.Name AS Module, CAEntity.Name AS Entity, 
       Users.ID, CATransaction.GlobalEntityID, CAInvoiceMiscFee.CAInvoiceMiscFeeID
FROM CATransactionMiscFee 
INNER JOIN CAMiscFee ON CATransactionMiscFee.CAMiscFeeID = CAMiscFee.CAMiscFeeID 
INNER JOIN CAStatus AS CAStatus_1 ON CATransactionMiscFee.CAStatusID = CAStatus_1.CAStatusID 
INNER JOIN CATransaction ON CATransactionMiscFee.CATransactionID = CATransaction.CATransactionID 
INNER JOIN CATransactionPayment ON CATransaction.CATransactionID = CATransactionPayment.CATransactionID 
INNER JOIN CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID 
INNER JOIN CATransactionStatus ON CATransaction.CATransactionStatusID = CATransactionStatus.CATransactionStatusID 
INNER JOIN CATransactionType ON CATransaction.CATransactionTypeID = CATransactionType.CATransactionTypeID 
INNER JOIN Users ON Users.sUserGUID = CATransaction.CreatedBy 
INNER JOIN CAInvoiceMiscFee ON CAMiscFee.CAMiscFeeID = CAInvoiceMiscFee.CAMiscFeeID 
INNER JOIN CAInvoice ON CAInvoiceMiscFee.CAInvoiceID = CAInvoice.CAInvoiceID 
INNER JOIN CAStatus ON CAStatus.CAStatusID = CAInvoice.CAStatusID 
INNER JOIN CAFee ON CAMiscFee.CAFeeID = CAFee.CAFeeID 
INNER JOIN CAModuleFeeXRef ON CAFee.CAFeeID = CAModuleFeeXRef.CAFeeID 
INNER JOIN CAModule ON CAModuleFeeXRef.CAModuleID = CAModule.CAModuleID 
INNER JOIN CAEntity ON CAModule.CAModuleID = CAEntity.CAModuleID
WHERE CATransactionPayment.PaymentDate BETWEEN @STARTDATE AND @ENDDATE 
AND  (CATransactionType.CATransactionTypeID NOT IN (5, 6)) 
AND  (CATransactionStatus.CATransactionStatusID NOT IN (2, 3))
AND  (CAInvoice.CAStatusID <> 5) 
AND  (CATransactionMiscFee.CAStatusID NOT IN (5, 6))


