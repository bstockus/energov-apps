﻿
CREATE PROCEDURE [dbo].[rpt_CM_SR_Code_Case_Detailed_Report_Fee]
@CMCODECASEID AS VARCHAR(36)
AS
SELECT CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.CAINVOICEID, 
       CACOMPUTEDFEE.CACOMPUTEDFEEID, CASTATUS.NAME AS INVOICESTATUS, CASTATUS_1.NAME AS COMPUTEDFEESTATUS, CASTATUS_2.NAME AS TRANSACTIONSTATUS, 
       CATRANSACTIONSTATUS.NAME AS TRANSACTIONSTATUS, CATRANSACTIONFEE.PAIDAMOUNT, CATRANSACTION.RECEIPTNUMBER
FROM CMCODECASEFEE 
INNER JOIN CACOMPUTEDFEE ON CMCODECASEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
INNER JOIN CASTATUS AS CASTATUS_1 ON CACOMPUTEDFEE.CASTATUSID = CASTATUS_1.CASTATUSID AND (CASTATUS_1.CASTATUSID <> 5)
LEFT OUTER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID
LEFT OUTER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID AND (CASTATUS.CASTATUSID <> 5)
LEFT OUTER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CATRANSACTION ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONFEE.CATRANSACTIONID AND (CATRANSACTION.CATRANSACTIONSTATUSID NOT IN (2,3))
LEFT OUTER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID
LEFT OUTER JOIN CASTATUS AS CASTATUS_2 ON CATRANSACTIONFEE.CASTATUSID = CASTATUS_2.CASTATUSID
WHERE (CMCODECASEFEE.CMCODECASEID = @CMCODECASEID)

UNION ALL

SELECT CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.CAINVOICEID, 
       CACOMPUTEDFEE.CACOMPUTEDFEEID, CASTATUS.NAME AS INVOICESTATUS, CASTATUS_1.NAME AS COMPUTEDFEESTATUS, CASTATUS_2.NAME AS TRANSACTIONSTATUS, 
       CATRANSACTIONSTATUS.NAME AS TRANSACTIONSTATUS, CATRANSACTIONFEE.PAIDAMOUNT, CATRANSACTION.RECEIPTNUMBER
FROM CMVIOLATIONFEE 
INNER JOIN CMVIOLATION ON CMVIOLATIONFEE.CMVIOLATIONID = CMVIOLATION.CMVIOLATIONID
INNER JOIN CMCODEWFSTEP ON CMVIOLATION.CMCODEWFSTEPID = CMCODEWFSTEP.CMCODEWFSTEPID
INNER JOIN CMCODECASE CODEVIO ON CMCODEWFSTEP.CMCODECASEID = CODEVIO.CMCODECASEID 
INNER JOIN CACOMPUTEDFEE ON CMVIOLATIONFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
INNER JOIN CASTATUS AS CASTATUS_1 ON CACOMPUTEDFEE.CASTATUSID = CASTATUS_1.CASTATUSID AND (CASTATUS_1.CASTATUSID <> 5)
LEFT OUTER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID
LEFT OUTER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID AND (CASTATUS.CASTATUSID <> 5)
LEFT OUTER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CATRANSACTION ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONFEE.CATRANSACTIONID AND (CATRANSACTION.CATRANSACTIONSTATUSID NOT IN (2,3))
LEFT OUTER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID
LEFT OUTER JOIN CASTATUS AS CASTATUS_2 ON CATRANSACTIONFEE.CASTATUSID = CASTATUS_2.CASTATUSID
WHERE (CODEVIO.CMCODECASEID = @CMCODECASEID)
