﻿
CREATE PROCEDURE rpt_PM_Permit_Detailed_Dept_A_Fees_Paid 
@PMPERMITID VARCHAR(36)
AS

;WITH CTE_OWED AS (
SELECT p.PMPERMITID, SUM(CF.COMPUTEDAMOUNT) TOTAL
FROM PMPERMIT P
INNER JOIN PMPERMITFEE PF ON p.PMPERMITID=PF.PMPERMITID
INNER JOIN CACOMPUTEDFEE CF ON PF.CACOMPUTEDFEEID=CF.CACOMPUTEDFEEID AND CF.CASTATUSID NOT IN (5,10)
WHERE P.PMPERMITID=@PMPERMITID
GROUP BY P.PMPERMITID 
)


SELECT DISTINCT 
	P.PMPERMITID,
	O.TOTAL,
	T.CATRANSACTIONID,
	I.CAINVOICEID,
	I.INVOICENUMBER,
	SUM(CASE WHEN T.CATRANSACTIONTYPEID = 4 THEN 0-TF.REFUNDAMOUNT ELSE TF.PAIDAMOUNT END) PAYMENT_AMOUNT,
	CPM.NAME PAYMETHOD,
	TP.SUPPLEMENTALDATA AS CHECK_NUMBER
	
FROM PMPERMIT P
INNER JOIN CTE_OWED O ON P.PMPERMITID=O.PMPERMITID
INNER JOIN PMPERMITFEE PMF ON P.PMPERMITID=PMF.PMPERMITID
INNER JOIN CACOMPUTEDFEE CF ON PMF.CACOMPUTEDFEEID = CF.CACOMPUTEDFEEID AND CF.CASTATUSID NOT IN (5,10) --VOID, DELETED
INNER JOIN CATRANSACTIONFEE TF ON CF.CACOMPUTEDFEEID = TF.CACOMPUTEDFEEID AND (TF.CASTATUSID NOT IN (5, 10)) --VOID, DELETED
INNER JOIN CATRANSACTION T ON TF.CATRANSACTIONID = T.CATRANSACTIONID AND T.CATRANSACTIONSTATUSID NOT IN (2,3) --VOID, NSF
INNER JOIN CATRANSACTIONPAYMENT TP ON T.CATRANSACTIONID = TP.CATRANSACTIONID AND TP.CAPAYMENTSTATUSID NOT IN (3,5) --NSF, VOID
INNER JOIN CATRANSACTIONTYPE TT ON T.CATRANSACTIONTYPEID = TT.CATRANSACTIONTYPEID AND (TT.CATRANSACTIONTYPEID NOT IN (5, 6)) --NSF, VOID REVERSAL
INNER JOIN CAPAYMENTMETHOD CPM ON CPM.CAPAYMENTMETHODID = TP.CAPAYMENTMETHODID
INNER JOIN CATRANSACTIONINVOICE TI ON TI.CATRANSACTIONID = T.CATRANSACTIONID
INNER JOIN CAINVOICE I ON I.CAINVOICEID = TI.CAINVOICEID
INNER JOIN CAINVOICEFEE CI ON I.CAINVOICEID = CI.CAINVOICEID AND CI.CACOMPUTEDFEEID = CF.CACOMPUTEDFEEID
WHERE P.PMPERMITID = @PMPERMITID
GROUP BY P.PMPERMITID, O.TOTAL, T.CATRANSACTIONID, CPM.NAME, TP.SUPPLEMENTALDATA, I.CAINVOICEID, I.INVOICENUMBER

