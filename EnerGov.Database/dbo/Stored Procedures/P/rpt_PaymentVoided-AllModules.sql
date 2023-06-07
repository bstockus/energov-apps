


create PROCEDURE [dbo].[rpt_PaymentVoided-AllModules]
-- Created to be used for Standard Voided Transaction report and any of the Standard payment reports that needs to show Voided payments from ALL modules
-- Currently shows CATransactionStatus of "Void" and CAPaymentStatus of "Void";
-- 9/30/2010 - Kyong Hwangbo
-- Report(s) using this stored proc:
-- VoidedTransactions.rpt
AS
BEGIN
	SET NOCOUNT ON;


SELECT     CATransaction.CATransactionID, CATransaction.TransactionDate, CATransaction.ReceiptNumber, 
           CATransaction.Note AS TransactionNote, CATransactionType.Name AS TransactionType, CATransactionStatus.Name AS TransactionStatus, CATransactionPayment.PaymentAmount,
           CAPaymentStatus.Name AS PaymentStatus,
           Users.ID AS CreatedByUserID, Users.FName AS CreatedByUserFName, Users.LName AS CreatedByUserLName 
           
FROM       CATransaction 
	INNER JOIN CATransactionType ON CATransaction.CATransactionTypeID = CATransactionType.CATransactionTypeID 
	INNER JOIN CATransactionStatus ON CATransaction.CATransactionStatusID = CATransactionStatus.CATransactionStatusID 
	INNER JOIN CATransactionPayment ON CATransaction.CATransactionID = CATransactionPayment.CATransactionID
	INNER JOIN CAPaymentStatus ON CATransactionPayment.CAPaymentStatusID = CAPaymentStatus.CAPaymentStatusID 
	INNER JOIN Users ON Users.sUserGUID = CATransaction.CreatedBy

WHERE     (CATransaction.CATransactionStatusID = 2 AND CATransactionPayment.CAPaymentStatusID = 5)
                    
                      
END


