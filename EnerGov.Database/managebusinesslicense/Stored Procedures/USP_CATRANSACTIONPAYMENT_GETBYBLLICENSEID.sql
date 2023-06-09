﻿CREATE PROCEDURE [managebusinesslicense].[USP_CATRANSACTIONPAYMENT_GETBYBLLICENSEID]
(
	@ID CHAR(36)
)
AS
BEGIN
	SELECT DISTINCT TOP 15 
			CATRANSACTIONPAYMENT.PAYMENTDATE,
			CATRANSACTION.CATRANSACTIONID,
			CATRANSACTIONINVOICE.PAIDAMOUNT,
			CATRANSACTION.TRANSACTIONDATE
	FROM CATRANSACTIONPAYMENT 
		INNER JOIN CATRANSACTION ON CATRANSACTIONPAYMENT.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
		INNER JOIN CATRANSACTIONFEE ON  CATRANSACTION.CATRANSACTIONID = CATRANSACTIONFEE.CATRANSACTIONID
		INNER JOIN CATRANSACTIONINVOICE ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTIONINVOICE.CATRANSACTIONID
		INNER JOIN CAINVOICE ON CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID
		INNER JOIN CAINVOICEFEE ON CAINVOICE.CAINVOICEID = CAINVOICEFEE.CAINVOICEID
		INNER JOIN CACOMPUTEDFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
		INNER JOIN BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID
	WHERE 
		BLLICENSEFEE.BLLICENSEID = @ID 
	ORDER BY CATRANSACTION.TRANSACTIONDATE, CATRANSACTIONPAYMENT.PAYMENTDATE DESC
END