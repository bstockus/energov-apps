


create PROCEDURE [dbo].[rpt_PaymentRefunded-AllModules]
-- Created to be used for Standard Voided Transaction report and any of the Standard payment reports that needs to show Refunded payments from ALL modules
-- Currently shows CATransactionType of "Refund";
-- 9/30/2010 - Kyong Hwangbo
-- Report(s) using this stored proc:
-- RefundedTransactions.rpt
AS
BEGIN
	SET NOCOUNT ON;


SELECT     CATransaction.CATransactionID, CATransaction.ParentTransactionID, CATransaction.TransactionDate, CATransaction.ReceiptNumber, 
           CATransaction.Note AS TransactionNote, CATransactionType.Name AS TransactionType, CATransactionStatus.Name AS TransactionStatus, CATransactionPayment.PaymentAmount,
           Users.ID AS CreatedByUserID, Users.FName AS CreatedByUserFName, Users.LName AS CreatedByUserLName 
           
FROM       CATransaction 
	INNER JOIN CATransactionType ON CATransaction.CATransactionTypeID = CATransactionType.CATransactionTypeID 
	INNER JOIN CATransactionStatus ON CATransaction.CATransactionStatusID = CATransactionStatus.CATransactionStatusID 
	INNER JOIN CATransactionPayment ON CATransaction.CATransactionID = CATransactionPayment.CATransactionID
	INNER JOIN Users ON Users.sUserGUID = CATransaction.CreatedBy

WHERE     (CATransaction.CATransactionTypeID = 4)
                    
                      
END



