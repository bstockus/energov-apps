﻿
CREATE PROCEDURE [dbo].[rpt_CA_SR_Daily_Transaction_Listing_GrandSum]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@VOIDS AS NVARCHAR(3)
AS
BEGIN
SET @STARTDATE = DATEADD(dd, DATEDIFF(dd, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT UPPER(TB.PaymentMethod) AS PaymentMethod, SUM(ISNULL(TB.PAIDAMOUNT,0)) AS PAIDAMOUNT
FROM (
	SELECT	CAPAYMENTMETHOD.NAME AS PaymentMethod, (CATRANSACTIONFEE.PAIDAMOUNT - 2*CATRANSACTIONFEE.REFUNDAMOUNT) AS PAIDAMOUNT
	FROM CACOMPUTEDFEE
	INNER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
	INNER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
	INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
	INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
	INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
	INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
	--INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
	INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
	INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
	WHERE (CATRANSACTION.TRANSACTIONDATE BETWEEN @STARTDATE AND @ENDDATE)
		AND CASE WHEN @VOIDS = 'YES' 
				THEN 1
				ELSE CASE WHEN (CATRANSACTIONTYPE.NAME = 'Void Reversal') OR (CATRANSACTIONSTATUS.NAME = 'Void')
					THEN 0
					ELSE 1
					END
				END = 1
	--AND   (CAInvoice.CAStatusID <> 5)

	UNION ALL

	SELECT	CAPAYMENTMETHOD.NAME AS PaymentMethod, (CATRANSACTIONMISCFEE.PAIDAMOUNT - 2*CATRANSACTIONMISCFEE.REFUNDAMOUNT) AS PAIDAMOUNT
	FROM CAMISCFEE 
	INNER JOIN CAINVOICEMISCFEE ON CAMISCFEE.CAMISCFEEID = CAINVOICEMISCFEE.CAMISCFEEID 
	INNER JOIN CAINVOICE ON CAINVOICEMISCFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
	INNER JOIN CATRANSACTIONMISCFEE ON CAMISCFEE.CAMISCFEEID = CATRANSACTIONMISCFEE.CAMISCFEEID 
	INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
	INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
	INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
	--INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
	INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
	INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
	WHERE (CATRANSACTION.TRANSACTIONDATE BETWEEN @STARTDATE AND @ENDDATE)
		AND CASE WHEN @VOIDS = 'YES' 
				THEN 1
				ELSE CASE WHEN (CATRANSACTIONTYPE.NAME = 'Void Reversal') OR (CATRANSACTIONSTATUS.NAME = 'Void')
					THEN 0
					ELSE 1
					END
				END = 1
	--AND   (CAInvoice.CAStatusID <> 5)
) AS TB
GROUP BY TB.PaymentMethod

END
