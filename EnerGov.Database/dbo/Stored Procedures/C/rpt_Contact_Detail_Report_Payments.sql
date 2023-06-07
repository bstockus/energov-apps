

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Payments]
@GLOBALENTITYID as varchar(36)
AS
SELECT     CATransaction.ReceiptNumber, CATransactionStatus.Name AS Status, CATransactionPayment.PaymentDate, CATransactionPayment.PaymentAmount, 
                      CAPaymentType.Name AS PaymentType, CATransaction.CATransactionID
FROM         CATransaction INNER JOIN
                      CATransactionStatus ON CATransaction.CATransactionStatusID = CATransactionStatus.CATransactionStatusID INNER JOIN
                      CATransactionPayment ON CATransaction.CATransactionID = CATransactionPayment.CATransactionID INNER JOIN
                      CAPaymentType ON CATransactionPayment.CAPaymentTypeID = CAPaymentType.CAPaymentTypeID
WHERE CATransaction.GlobalEntityID = @GLOBALENTITYID

