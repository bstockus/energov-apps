﻿
/****** Object:  StoredProcedure [dbo].[rpt_IP_SR_Impact_Case_Detail_Report_Conditions]    Script Date: 01/08/2014 15:58:53 ******/
CREATE PROCEDURE [dbo].[rpt_IP_SR_Impact_Case_Detail_Report_Conditions]
@IPCASEID AS VARCHAR(36)
as

SELECT	IPCONDITION.IPCASEID, IPCONDITION.CONDITIONNUMBER, IPCONDITION.DESCRIPTION, IPCONDITION.CREATEDDATE, IPCONDITION.SATISFIEDDATE, 
		IPCONDITIONTYPE.NAME as CONDITIONTYPE,
		IPCONDITIONSTATUS.NAME as CONDITIONSTATUS,
		CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.CAINVOICEID, 
		CAINVOICEFEE.CACOMPUTEDFEEID, CASTATUS.NAME AS INVOICESTATUS, CASTATUS_1.NAME AS COMPUTEDFEESTATUS, CASTATUS_2.NAME AS [TRANSACTIONFEE STATUS], 
		CATRANSACTIONSTATUS.NAME AS TRANSACTIONSTATUS, CATRANSACTIONFEE.PAIDAMOUNT, CATRANSACTION.RECEIPTNUMBER

FROM	IPCONDITION
		INNER JOIN IPCONDITIONTYPE ON IPCONDITIONTYPE.IPCONDITIONTYPEID = IPCONDITION.IPCONDITIONTYPEID
		INNER JOIN IPCONDITIONSTATUS ON IPCONDITIONSTATUS.IPCONDITIONSTATUSID = IPCONDITION.IPCONDITIONSTATUSID
		LEFT OUTER JOIN IPCONDITIONFEE ON IPCONDITIONFEE.IPCONDITIONID = IPCONDITION.IPCONDITIONID
		LEFT OUTER JOIN CACOMPUTEDFEE ON IPCONDITIONFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID 
		LEFT OUTER JOIN CASTATUS AS CASTATUS_1 ON CACOMPUTEDFEE.CASTATUSID = CASTATUS_1.CASTATUSID AND CASTATUS_1.CASTATUSID <> 5	-- Exclude Voided Transactions
		LEFT OUTER JOIN CATRANSACTIONFEE ON CATRANSACTIONFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
		LEFT OUTER JOIN CATRANSACTION ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONFEE.CATRANSACTIONID 
		LEFT OUTER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID AND CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID NOT IN (2,3)	-- Exclude Voided and NSF transactions
		LEFT OUTER JOIN CASTATUS AS CASTATUS_2 ON CATRANSACTIONFEE.CASTATUSID = CASTATUS_2.CASTATUSID  
		LEFT OUTER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
		LEFT OUTER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
		LEFT OUTER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID AND CASTATUS.CASTATUSID <> 5	-- Exclude Voided Invoices

WHERE	IPCONDITION.IPCASEID = @IPCASEID
