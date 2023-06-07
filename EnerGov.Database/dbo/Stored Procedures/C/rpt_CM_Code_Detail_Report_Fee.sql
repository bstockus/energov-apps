﻿


CREATE PROCEDURE [dbo].[rpt_CM_Code_Detail_Report_Fee]
@CODECASEID AS VARCHAR(36)
AS
SELECT CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.CAINVOICEID, 
       CAINVOICEFEE.CACOMPUTEDFEEID, CASTATUS.NAME AS INVOICESTATUS, CASTATUS_1.NAME AS COMPUTEDFEESTATUS, CASTATUS_2.NAME AS [TRANSACTIONFEE STATUS], 
       CATRANSACTIONSTATUS.NAME AS TRANSACTIONSTATUS, CATRANSACTIONFEE.PAIDAMOUNT, CATRANSACTION.RECEIPTNUMBER
FROM CMCODECASEFEE 
INNER JOIN CACOMPUTEDFEE ON CMCODECASEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID 
INNER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID 
INNER JOIN CASTATUS AS CASTATUS_1 ON CACOMPUTEDFEE.CASTATUSID = CASTATUS_1.CASTATUSID 
LEFT OUTER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CATRANSACTION ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONFEE.CATRANSACTIONID 
LEFT OUTER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
LEFT OUTER JOIN CASTATUS AS CASTATUS_2 ON CATRANSACTIONFEE.CASTATUSID = CASTATUS_2.CASTATUSID 
WHERE (CMCODECASEFEE.CMCODECASEID = @CODECASEID)
AND   (CASTATUS.CASTATUSID <> 5) 
AND   (CASTATUS_1.CASTATUSID <> 5) 
AND   (CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID NOT IN (2,3))

