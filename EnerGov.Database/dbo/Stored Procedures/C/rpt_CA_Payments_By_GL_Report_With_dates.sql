﻿


create PROCEDURE [dbo].[rpt_CA_Payments_By_GL_Report_With_dates]

@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT     CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CATRANSACTIONFEE.PAIDAMOUNT, CATRANSACTIONFEE.REFUNDAMOUNT,
                      CATRANSACTIONPAYMENT.PAYMENTDATE, CATRANSACTIONGLPOSTING.CREDITACCOUNTNUMBER AS GLACCOUNT, 
                      CATRANSACTIONGLPOSTING.POSTINGAMOUNT,
                      CATransactionType.Name AS TransactionType, CAPaymentMethod.Name AS PaymentMethod
FROM         CACOMPUTEDFEE INNER JOIN
                      CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID INNER JOIN
                      CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID INNER JOIN
                      CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID INNER JOIN
                      CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID INNER JOIN
                      CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID INNER JOIN
                      CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID INNER JOIN 
                      CATRANSACTIONFEEPOSTING ON CATRANSACTIONFEE.CATRANSACTIONFEEID = CATRANSACTIONFEEPOSTING.CATRANSACTIONFEEID INNER JOIN
                      CATRANSACTIONGLPOSTING ON CATRANSACTIONFEEPOSTING.CATRANSACTIONGLPOSTINGID = CATRANSACTIONGLPOSTING.CATRANSACTIONGLPOSTINGID
WHERE CATransactionPayment.PaymentDate BETWEEN @STARTDATE AND @ENDDATE
AND (CATransactionType.CATransactionTypeID NOT IN (5, 6)) 
AND (CATransactionStatus.CATransactionStatusID NOT IN (2, 3))
AND (CATransactionFee.CAStatusID NOT IN (5, 6))

UNION ALL
SELECT     CAMISCFEE.FEENAME, CAMISCFEE.AMOUNT AS COMPUTEDAMOUNT, CATRANSACTIONMISCFEE.PAIDAMOUNT, CATRANSACTIONMISCFEE.REFUNDAMOUNT,
                      CATRANSACTIONPAYMENT.PAYMENTDATE, CATRANSACTIONGLPOSTING.CREDITACCOUNTNUMBER AS GLACCOUNT, 
                      CATRANSACTIONGLPOSTING.POSTINGAMOUNT, CATransactionType.Name AS TransactionType, CAPaymentMethod.Name AS PaymentMethod
FROM         CAMISCFEE INNER JOIN
                      CATRANSACTIONMISCFEE ON CAMISCFEE.CAMISCFEEID = CATRANSACTIONMISCFEE.CAMISCFEEID INNER JOIN
                      CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID INNER JOIN
                      CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID INNER JOIN
                      CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID INNER JOIN
                      CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID INNER JOIN
                      CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID INNER JOIN
                      CATRANSACTIONMISCFEEPOSTING ON CATRANSACTIONMISCFEE.CATRANSACTIONMISCFEEID = CATRANSACTIONMISCFEEPOSTING.CATRANSACTIONMISCFEEID INNER JOIN
                      CATRANSACTIONGLPOSTING ON CATRANSACTIONMISCFEEPOSTING.CATRANSACTIONGLPOSTINGID = CATRANSACTIONGLPOSTING.CATRANSACTIONGLPOSTINGID
WHERE CATransactionPayment.PaymentDate BETWEEN @STARTDATE AND @ENDDATE
AND (CATransactionType.CATransactionTypeID NOT IN (5, 6)) 
AND (CATransactionStatus.CATransactionStatusID NOT IN (2, 3))
AND (CATRANSACTIONMISCFEE.CAStatusID NOT IN (5, 6))

