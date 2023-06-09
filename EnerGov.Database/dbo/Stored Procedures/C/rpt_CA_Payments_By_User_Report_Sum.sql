﻿


CREATE PROCEDURE [dbo].[rpt_CA_Payments_By_User_Report_Sum]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@USERID AS VARCHAR(36)
AS

SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))


SELECT TB.ID, TB.SUSERGUID, LTRIM(RTRIM(TB.FNAME))+' '+LTRIM(RTRIM(TB.LNAME)) AS UserName, UPPER(TB.PaymentMethod) AS PaymentMethod, SUM(ISNULL(TB.PAIDAMOUNT,0)) AS PAIDAMOUNT
FROM (

SELECT USERS.ID, USERS.SUSERGUID, USERS.FNAME, USERS.LNAME, CAPAYMENTMETHOD.NAME AS PaymentMethod, CATRANSACTIONFEE.PAIDAMOUNT, 
       CATRANSACTION.RECEIPTNUMBER, CAINVOICE.INVOICENUMBER, CATRANSACTION.TRANSACTIONDATE, 
       CATRANSACTIONTYPE.NAME AS TransactionType, CATRANSACTIONSTATUS.NAME AS TransactionStatus, CAInvoice.CAStatusID
FROM CACOMPUTEDFEE
INNER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
WHERE CATRANSACTIONPAYMENT.PAYMENTDATE BETWEEN @STARTDATE AND @ENDDATE
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Void Reversal')) 
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Refund'))
AND   (NOT (CATRANSACTIONSTATUS.NAME = 'Void')) 
AND   (CAInvoice.CAStatusID <> 5)
AND   (USERS.SUSERGUID = @USERID)

UNION ALL

SELECT USERS.ID, USERS.SUSERGUID, USERS.FNAME, USERS.LNAME, CAPAYMENTMETHOD.NAME AS PaymentMethod, CATRANSACTIONMISCFEE.PAIDAMOUNT, 
       CATRANSACTION.RECEIPTNUMBER, CAINVOICE.INVOICENUMBER, CATRANSACTION.TRANSACTIONDATE, 
       CATRANSACTIONTYPE.NAME AS TransactionType, CATRANSACTIONSTATUS.NAME AS TransactionStatus, CAInvoice.CAStatusID
FROM CAMISCFEE 
INNER JOIN CAINVOICEMISCFEE ON CAMISCFEE.CAMISCFEEID = CAINVOICEMISCFEE.CAMISCFEEID 
INNER JOIN CAINVOICE ON CAINVOICEMISCFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CATRANSACTIONMISCFEE ON CAMISCFEE.CAMISCFEEID = CATRANSACTIONMISCFEE.CAMISCFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
WHERE CATRANSACTIONPAYMENT.PAYMENTDATE BETWEEN @STARTDATE AND @ENDDATE
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Void Reversal')) 
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Refund'))
AND   (NOT (CATRANSACTIONSTATUS.NAME = 'Void')) 
AND   (CAInvoice.CAStatusID <> 5)
AND   (USERS.SUSERGUID = @USERID)

UNION ALL

SELECT USERS.ID, USERS.SUSERGUID, USERS.FNAME, USERS.LNAME, 'REFUND' AS PaymentMethod, 0 - CATRANSACTIONFEE.REFUNDAMOUNT AS PAIDAMOUNT,
       CATRANSACTION.RECEIPTNUMBER, CAINVOICE.INVOICENUMBER, CATRANSACTION.TRANSACTIONDATE, 
       CATRANSACTIONTYPE.NAME AS TransactionType, CATRANSACTIONSTATUS.NAME AS TransactionStatus, CAInvoice.CAStatusID
FROM CACOMPUTEDFEE 
INNER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
WHERE CATRANSACTIONPAYMENT.PAYMENTDATE BETWEEN @STARTDATE AND @ENDDATE
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Void Reversal')) 
AND   ((CATRANSACTIONTYPE.NAME = 'Refund'))
AND   (NOT (CATRANSACTIONSTATUS.NAME = 'Void')) 
AND   (CAInvoice.CAStatusID <> 5)
AND   (USERS.SUSERGUID = @USERID)

UNION ALL

SELECT USERS.ID, USERS.SUSERGUID, USERS.FNAME, USERS.LNAME, 'REFUND' AS PaymentMethod, 0 - CATRANSACTIONMISCFEE.REFUNDAMOUNT AS PAIDAMOUNT,
       CATRANSACTION.RECEIPTNUMBER, CAINVOICE.INVOICENUMBER, CATRANSACTION.TRANSACTIONDATE, 
       CATRANSACTIONTYPE.NAME AS TransactionType, CATRANSACTIONSTATUS.NAME AS TransactionStatus, CAInvoice.CAStatusID
FROM CAMISCFEE 
INNER JOIN CAINVOICEMISCFEE ON CAMISCFEE.CAMISCFEEID = CAINVOICEMISCFEE.CAMISCFEEID 
INNER JOIN CAINVOICE ON CAINVOICEMISCFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CATRANSACTIONMISCFEE ON CAMISCFEE.CAMISCFEEID = CATRANSACTIONMISCFEE.CAMISCFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
WHERE CATRANSACTIONPAYMENT.PAYMENTDATE BETWEEN @STARTDATE AND @ENDDATE
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Void Reversal')) 
AND   ((CATRANSACTIONTYPE.NAME = 'Refund'))
AND   (NOT (CATRANSACTIONSTATUS.NAME = 'Void')) 
AND   (CAInvoice.CAStatusID <> 5)
AND   (USERS.SUSERGUID = @USERID)

) AS TB
GROUP BY TB.ID, TB.SUSERGUID, TB.FNAME, TB.LNAME, TB.PaymentMethod


