

create PROCEDURE [dbo].[rpt_Invoice-Open-AllModules]
-- Created to be used for Standard Invoice report that needs to show open invoices from ALL modules
-- 10/11/2010 - Kyong Hwangbo
-- This query filters out all Invoices with Invoice Status of "Paid In Full" "Void" "Refunded";
-- Report(s) using this stored proc:
-- Open Invoices (By Module).rpt
-- If Billing Contact's address needs to be shown, please use "rpt_Contacts-Billing" stored procedure as a subreport for the report

AS
BEGIN

	SET NOCOUNT ON;

(
SELECT       CAInvoice.InvoiceNumber ,CAInvoice.InvoiceDate, CAInvoice.InvoiceTotal, GlobalEntity.FirstName, GlobalEntity.LastName, CAFee.Name AS FeeName 
           , CAStatus.Name AS CAStatus, CAInvoice.InvoiceDueDate, CAInvoice.InvoiceDescription 
           , CAComputedFee.FeeOrder, GlobalEntity.GlobalEntityID, CAInvoice.CAInvoiceID, GlobalEntity.GlobalEntityName
           ,COALESCE(
				PLPlan.PLANNumber,
				PMPermit.PermitNumber,
				CMCodeCase.CaseNumber,
				PLApplication.APPNumber
				) as CaseNumber
			,CAComputedFee.ComputedAmount as ComputedAmount
			,CAInvoiceFee.PaidAmount
			,CAComputedFee.CAComputedFeeID as FeeID
			,CAModule.Name AS ModuleName

FROM         CAInvoice 
                INNER JOIN CAStatus 
                        ON CAInvoice.CAStatusID = CAStatus.CAStatusID
                INNER JOIN GlobalEntity 
                        ON CAInvoice.GlobalEntityID = GlobalEntity.GlobalEntityID                       
                INNER JOIN CAInvoiceFee  
                        ON CAInvoice.CAInvoiceID = CAInvoiceFee.CAInvoiceID
                INNER JOIN CAComputedFee  
                        ON CAComputedFee.CAComputedFeeID = CAInvoiceFee.CAComputedFeeID 
                INNER JOIN CAFeeTemplateFee 
                        ON CAComputedFee.CAFeeTemplateFeeID = CAFeeTemplateFee.CAFeeTemplateFeeID 
                INNER JOIN CAFee 
                        ON CAFeeTemplateFee.CAFeeID = CAFee.CAFeeID         
				INNER JOIN CAModuleFeeXRef 
						ON CAFee.CAFeeID = CAModuleFeeXRef.CAFeeID
				INNER JOIN CAModule
						ON CAModuleFeeXRef.CAModuleID = CAModule.CAModuleID 		                                      
                LEFT OUTER JOIN PLPlanFee 
                        ON CAComputedFee.CAComputedFeeID = PLPlanFee.CAComputedFeeID 
                LEFT OUTER JOIN PLPlan 
                        ON PLPlanFee.PLPlanID = PLPlan.PLPlanID 
                LEFT OUTER JOIN PMPermitFee 
                        ON CAComputedFee.CAComputedFeeID = PMPermitFee.CAComputedFeeID 
                LEFT OUTER JOIN PMPermit 
                        ON PMPermitFee.PMPermitID = PMPermit.PMPermitID
                LEFT OUTER JOIN CMCodeCaseFee
                        ON CAComputedFee.CAComputedFeeID = CMCodeCaseFee.CAComputedFeeID 
                LEFT OUTER JOIN CMCodeCase 
                        ON CMCodeCaseFee.CMCodeCaseID = CMCodeCase.CMCodeCaseID
                LEFT OUTER JOIN PLApplicationFee
                        ON CAComputedFee.CAComputedFeeID = PLApplicationFee.CAComputedFeeID 
                LEFT OUTER JOIN PLApplication 
                        ON PLApplicationFee.PLApplicationID = PLApplication.PLApplicationID
WHERE CAInvoice.CAStatusID NOT IN (4,5,9)  
				                               
UNION ALL

SELECT       CAInvoice.InvoiceNumber ,CAInvoice.InvoiceDate, CAInvoice.InvoiceTotal, GlobalEntity.FirstName, GlobalEntity.LastName, CAFee.Name AS FeeName 
           , CAStatus.Name AS CAStatus, CAInvoice.InvoiceDueDate, CAInvoice.InvoiceDescription 
           , null as FeeOrder, GlobalEntity.GlobalEntityID, CAInvoice.CAInvoiceID, GlobalEntity.GlobalEntityName
           ,'Misc Fee' as CaseNumber
			,CAMiscFee.Amount as ComputedAmount
			, CAMiscFee.PaidAmount 
			,CAMiscFee.CAMiscFeeID as FeeID
			,CAModule.Name AS ModuleName

FROM         CAInvoice 
                INNER JOIN CAStatus 
                        ON CAInvoice.CAStatusID = CAStatus.CAStatusID
                INNER JOIN GlobalEntity 
                        ON CAInvoice.GlobalEntityID = GlobalEntity.GlobalEntityID                       
                INNER JOIN CAInvoiceMiscFee  
                        ON CAInvoice.CAInvoiceID = CAInvoiceMiscFee.CAInvoiceID
                INNER JOIN CAMiscFee
                        ON CAInvoiceMiscFee.CAMiscFeeID = CAMiscFee.CAMiscFeeID
                INNER JOIN CAFee 
                        ON CAMiscFee.CAFeeID = CAFee.CAFeeID  
				INNER JOIN CAModuleFeeXRef 
						ON CAFee.CAFeeID = CAModuleFeeXRef.CAFeeID
				INNER JOIN CAModule
						ON CAModuleFeeXRef.CAModuleID = CAModule.CAModuleID 		                                      
WHERE CAInvoice.CAStatusID NOT IN (4,5,9)                      
)                      
END


