







create PROCEDURE [dbo].[rpt_Payment-AllModules]
--Created to be used for Standard Receipt report and any of the Standard payment reports that needs to show payments from ALL modules
--8/27/2010 - Kyong Hwangbo
--Report(s) using this stored proc:
--Receipt.rpt
--8/30/2010 - Kyong Hwangbo
--Removed Billing Contact's Address(es); If a contact has multiple addresses, the fees will be duplicated;
--If Billing Contact's address needs to be shown, please use "rpt_Contacts-Billing" stored procedure as a subreport for the report



--@TransactionID varchar(36)

AS
BEGIN

	SET NOCOUNT ON;


(SELECT
 CAEntity.Name AS ModuleName
, CAComputedFee.CAComputedFeeID 
, CAComputedFee.CAComputedFeeID AS FeeGUID
, CAComputedFee.FeeName
, CAComputedFee.ComputedAmount AS ComputedFeeAmount
, CATransactionFee.PaidAmount AS PaidFeeAmount  
, CATransaction.CATransactionID
, CATransaction.ReceiptNumber
, CATransactionType.Name AS TransactionType
, CATransactionStatus.Name AS TransactionStatus
, CATransactionInvoice.PaidAmount AS AmountAppliedToInvoice
, CATransactionPayment.PaymentDate
, CATransactionPayment.PaymentAmount AS AmountPaid
, CATransactionPayment.SupplementalData AS CheckNumber 
, CAPaymentMethod.Name AS PaymentType
, CAPaymentStatus.Name AS PaymentStatus  
, GlobalEntity.GlobalEntityID  
, GlobalEntity.GlobalEntityName AS BillingContactCompName 
, GlobalEntity.FirstName AS BillingContactFName
, GlobalEntity.LastName AS BillingContactLName
, GlobalEntity.BusinessPhone AS BillingContactBusPhone 
, Users.sUserGUID AS CreatedByUserGUID
, Users.ID AS CreatedByUserID 
, Users.FName AS CreatedByUserFName
, Users.LName AS CreatedByUserLName 
, COALESCE(
CMCodeCase.CaseNumber
, PLApplication.APPNumber
, PLPlan.PLANNumber
, PMPermit.PermitNumber
, PRProject.ProjectNumber
) as CaseNumber
, CAInvoice.InvoiceNumber							
, CAInvoiceFee.PaidAmount AS InvoiceFeePaidAmount
, CAFeeTemplateFee.CAFeeID

FROM CATransaction 
		INNER JOIN CATransactionType
		        on CATransactionType.CATransactionTypeID = CATransaction.CATransactionTypeID
		INNER JOIN CATransactionStatus
				on CATransactionStatus.CATransactionStatusID = CATransaction.CATransactionStatusID
		INNER JOIN CATransactionInvoice
		        on CATransactionInvoice.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CATransactionPayment
				on CATransactionPayment.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CATransactionFee
				on CATransactionFee.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CAComputedFee
		        on CAComputedFee.CAComputedFeeID = CATransactionFee.CAComputedFeeID
		INNER JOIN CAFeeTemplateFee
				ON CAFeeTemplateFee.CAFeeTemplateFeeID = CAComputedFee.CAFeeTemplateFeeID
		INNER JOIN CAFeeTemplate
				ON CAFeeTemplate.CAFeeTemplateID = CAFeeTemplateFee.CAFeeTemplateID
		INNER JOIN CAEntity
				ON CAEntity.CAEntityID = CAFeeTemplate.CAEntityID
		INNER JOIN CAPaymentMethod
		        on CAPaymentMethod.CAPaymentMethodID = CATransactionPayment.CAPaymentMethodID
		INNER JOIN CAPaymentStatus
				on CAPaymentStatus.CAPaymentStatusID = CATransactionPayment.CAPaymentStatusID
		INNER JOIN GlobalEntity 
				on CATransaction.GlobalEntityID = GlobalEntity.GlobalEntityID
			
		INNER JOIN Users
		        on Users.sUserGUID = CATransaction.CreatedBy
		INNER JOIN CAInvoice
				on CAInvoice.CAInvoiceID = CATransactionInvoice.CAInvoiceID
		INNER JOIN CAInvoiceFee
		        on CAInvoiceFee.CAInvoiceID = CATransactionInvoice.CAInvoiceID
		       and CAInvoiceFee.CAComputedFeeID = CATransactionFee.CAComputedFeeID 

--Code Module
		LEFT OUTER JOIN CMCodeCaseFee
				ON CAComputedFee.CAComputedFeeID = CMCodeCaseFee.CAComputedFeeID
		LEFT OUTER JOIN CMCodeCase	
				ON CMCodeCaseFee.CMCodeCaseID = CMCodeCase.CMCodeCaseID
--Plan Application 
		LEFT OUTER JOIN PLApplicationFee
				ON CAComputedFee.CAComputedFeeID = PLApplicationFee.CAComputedFeeID
		LEFT OUTER JOIN PLApplication
				ON PLApplicationFee.PLApplicationID = PLApplication.PLApplicationID
--Plan Module
		LEFT OUTER JOIN PLPlanFee 
                ON CAComputedFee.CAComputedFeeID = PLPlanFee.CAComputedFeeID 
		LEFT OUTER JOIN PLPlan 
                ON PLPlanFee.PLPlanID = PLPlan.PLPlanID 
--Permit Module                
		LEFT OUTER JOIN PMPermitFee 
                ON CAComputedFee.CAComputedFeeID = PMPermitFee.CAComputedFeeID 
		LEFT OUTER JOIN PMPermit 
                ON PMPermitFee.PMPermitID = PMPermit.PMPermitID
--Project Module
		LEFT OUTER JOIN PRProjectFee
				ON CAComputedFee.CAComputedFeeID = PRProjectFee.CAComputedFeeID
		LEFT OUTER JOIN PRProject
				ON PRProjectFee.PRProjectID = PRProject.PRProjectID                
                
                

Where 1 = 1
  and CATransactionType.CATransactionTypeID not in (5,6)
  and CATransactionStatus.CATransactionStatusID not in (2,3)
  and CAInvoice.CAStatusID != 5
  --and  CATransaction.CATransactionID = @TransactionID


  
Union ALL
SELECT          
'Cashier' AS ModuleName
, CAMiscFee.CAMiscFeeID AS CAComputedFeeID 
, CAMiscFee.CAMiscFeeID AS FeeGUID
, CAMiscFee.FeeName
, CAMiscFee.Amount AS ComputedFeeAmount
, CATransactionMiscFee.PaidAmount AS PaidFeeAmount  
, CATransaction.CATransactionID
, CATransaction.ReceiptNumber
, CATransactionType.Name
, CATransactionStatus.Name
, CATransactionInvoice.PaidAmount AS AmountAppliedToInvoice

, CATransactionPayment.PaymentDate
, CATransactionPayment.PaymentAmount AS AmountPaid
, CATransactionPayment.SupplementalData AS CheckNumber 
, CAPaymentMethod.Name AS PaymentMethod
, CAPaymentStatus.Name AS PaymentStatus  

, GlobalEntity.GlobalEntityID  
, GlobalEntity.GlobalEntityName AS BillingContactCompName 
, GlobalEntity.FirstName AS BillingContactFName
, GlobalEntity.LastName AS BillingContactLName
, GlobalEntity.BusinessPhone AS BillingContactBusPhone 
, Users.sUserGUID AS CreatedByUserGUID
, Users.ID AS CreatedByUserID 
, Users.FName AS CreatedByUserFName
, Users.LName AS CreatedByUserLName 
, '' as CaseNumber	
, CAInvoice.InvoiceNumber							
, CAMiscFee.PaidAmount AS InvoiceFeePaidAmount  
, '' AS CAFeeID       
          
FROM  CATransaction 
		INNER JOIN CATransactionType
		        on CATransactionType.CATransactionTypeID = CATransaction.CATransactionTypeID
		INNER JOIN CATransactionStatus
				on CATransactionStatus.CATransactionStatusID = CATransaction.CATransactionStatusID
		INNER JOIN CATransactionInvoice
		        on CATransactionInvoice.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CATransactionPayment
				on CATransactionPayment.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CATransactionMiscFee
				on CATransactionMiscFee.CATransactionID = CATransaction.CATransactionID
		INNER JOIN CAMiscFee
		        on CAMiscFee.CAMiscFeeID = CATransactionMiscFee.CAMiscFeeID
		INNER JOIN CAPaymentMethod
		        on CAPaymentMethod.CAPaymentMethodID = CATransactionPayment.CAPaymentMethodID
		INNER JOIN CAPaymentStatus
				on CAPaymentStatus.CAPaymentStatusID = CATransactionPayment.CAPaymentStatusID
		INNER JOIN GlobalEntity 
				on CATransaction.GlobalEntityID = GlobalEntity.GlobalEntityID
		INNER JOIN Users
		        on Users.sUserGUID = CATransaction.CreatedBy
		INNER JOIN CAInvoice
				on CAInvoice.CAInvoiceID = CATransactionInvoice.CAInvoiceID
Where 1 = 1
  and CATransactionType.CATransactionTypeID not in (5,6)
  and CATransactionStatus.CATransactionStatusID not in (2,3)
  and CAInvoice.CAStatusID != 5
  --and CATransaction.CATransactionID = @TransactionID
)
ORDER BY CAComputedFeeID
                      
                      
END





