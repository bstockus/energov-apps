


create PROCEDURE [dbo].[rpt_Payments-Permit]
--Created to be used for Standard Receipt report and any of the Standard payment reports that needs to show payments from ALL modules
--8/27/2010 - Kyong Hwangbo
--Report(s) using this stored proc:
--Receipt.rpt
--8/30/2010 - Kyong Hwangbo
--Removed Billing Contact's Address(es); If a contact has multiple addresses, the fees will be duplicated;
--If Billing Contact's address needs to be shown, please use "rpt_Contacts-Billing" stored procedure as a subreport for the report

AS
BEGIN

	SET NOCOUNT ON;

SELECT
 CAEntity.Name AS ModuleName
, CAComputedFee.CAComputedFeeID, CAComputedFee.FeeName, CAComputedFee.ComputedAmount AS ComputedFeeAmount, CATransactionFee.PaidAmount AS PaidFeeAmount  
, CATransaction.CATransactionID, CATransaction.ReceiptNumber, CATransactionType.Name AS TransactionType, CATransactionStatus.Name AS TransactionStatus
, CATransactionInvoice.PaidAmount AS AmountAppliedToInvoice
, CATransactionPayment.PaymentDate, CATransactionPayment.PaymentAmount AS AmountPaid, CATransactionPayment.SupplementalData AS CheckNumber 
, CAPaymentMethod.Name AS PaymentType, CAPaymentStatus.Name AS PaymentStatus  
, PMPermit.PMPermitID
--, PMPermit.PermitNumber, PMPermitType.Name AS PermitType
, CAInvoice.InvoiceNumber, CAInvoiceFee.PaidAmount AS InvoiceFeePaidAmount, CAFeeTemplateFee.CAFeeID

FROM CATransaction 
		INNER JOIN CATransactionType on CATransactionType.CATransactionTypeID = CATransaction.CATransactionTypeID
		INNER JOIN CATransactionStatus on CATransactionStatus.CATransactionStatusID = CATransaction.CATransactionStatusID
		INNER JOIN CATransactionInvoice on CATransactionInvoice.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CATransactionPayment on CATransactionPayment.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CATransactionFee on CATransactionFee.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CAComputedFee on CAComputedFee.CAComputedFeeID = CATransactionFee.CAComputedFeeID
		INNER JOIN CAFeeTemplateFee ON CAFeeTemplateFee.CAFeeTemplateFeeID = CAComputedFee.CAFeeTemplateFeeID
		INNER JOIN CAFeeTemplate ON CAFeeTemplate.CAFeeTemplateID = CAFeeTemplateFee.CAFeeTemplateID
		INNER JOIN CAEntity ON CAEntity.CAEntityID = CAFeeTemplate.CAEntityID
		INNER JOIN CAPaymentMethod on CAPaymentMethod.CAPaymentMethodID = CATransactionPayment.CAPaymentMethodID
		INNER JOIN CAPaymentStatus on CAPaymentStatus.CAPaymentStatusID = CATransactionPayment.CAPaymentStatusID
		INNER JOIN CAInvoice on CAInvoice.CAInvoiceID = CATransactionInvoice.CAInvoiceID
		INNER JOIN CAInvoiceFee on CAInvoiceFee.CAInvoiceID = CATransactionInvoice.CAInvoiceID
		       and CAInvoiceFee.CAComputedFeeID = CATransactionFee.CAComputedFeeID 
--Permit Module                
		INNER JOIN PMPermitFee ON CAComputedFee.CAComputedFeeID = PMPermitFee.CAComputedFeeID 
		INNER JOIN PMPermit ON PMPermitFee.PMPermitID = PMPermit.PMPermitID
		--INNER JOIN PMPermitType ON PMPermit.PMPermitTypeID = PMPermitType.PMPermitTypeID                 

Where 1 = 1
  and CATransactionType.CATransactionTypeID not in (5,6)
  and CATransactionStatus.CATransactionStatusID not in (2,3)
  and CAInvoice.CAStatusID != 5

ORDER BY PMPermit.PermitNumber 
                      
END



