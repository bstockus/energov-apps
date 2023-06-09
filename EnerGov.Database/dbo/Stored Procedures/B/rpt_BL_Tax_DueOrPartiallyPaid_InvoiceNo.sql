﻿

--exec rpt_BL_Tax_DueOrPartiallyPaid_InvoiceNo '2010-01-01','2012-04-28'

cREATE PROCEDURE [dbo].[rpt_BL_Tax_DueOrPartiallyPaid_InvoiceNo]
@StartDate AS DATETime,
@EndDate As DATETIME
AS

SET @StartDate = DATEADD(S,+1,DATEADD(D,-1,@StartDate))
SET @EndDate= DATEADD(S,-1,DATEADD(D,1,@EndDate))

SELECT  Tx.AmountReported, Tx.PaymentDate,CATRANSACTIONPAYMENT.PAYMENTDATE,
        TxRemittanceAccount.RemittanceAccountNumber AS REMAccount, COALESCE(NULLIF(GlobalEntity.GLOBALENTITYName,''),'N/A') AS BusinessName, TxRemittanceAccount.TxRemittanceStatusID
       ,TXRPTPERIOD.NAME ReportedPeriod
       ,TxRemitStatus.TxRemitStatusSystemID, TxRemitStatus.Name AS [Status], CAcomputedFee.CACOMPUTEDFEEID, 
       CaComputedFee.ComputedAmount AS CompAmtInComputed, CaComputedFee.AmountPaidToDate As AmtPaidToDateInComputed, CaComputedFee.FeeOrder,
       TxBillPeriod.StartDate AS StartDate, TxBillPeriod.ENDDATE AS EndDate,TxBillPeriod.DueDate AS DueDate
       ,TxBillPeriod.PERIODNAME,
       CaTransactionFee.PaidAmount As PaidAmtInTransaction,
        CaInvoice.InvoiceNumber,Cainvoice.CAINVOICEID, CAINVOICE.INVOICETOTAL AS FeeAmount,CaComputedFee.CAStatusID, CaStatus.Name As InvoiceStatus,
       GlobalEntity.GlobalEntityID, CACOMPUTEDFEE.FeeName


FROM   TXREMITTANCE AS Tx
INNER JOIN TxRemittanceAccount ON Tx.TXREMITTANCEACCOUNTID = TxRemittanceAccount.TXREMITTANCEACCOUNTID
LEFT OUTER JOIN TXRPTPERIOD ON TXREMITTANCEACCOUNT.REPORTPERIODID = TXRPTPERIOD.TXRPTPERIODID
INNER JOIN TXREMITTANCETYPE ON TXREMITTANCEACCOUNT.TXREMITTANCETYPEID = TXREMITTANCETYPE.TXREMITTANCETYPEID
INNER JOIN TXBILLPERIOD On Tx.TXBILLPERIODID = TxBillPeriod.BillPeriodID
INNER JOIN TxRemitStatus ON TxRemittanceAccount.TxRemittanceStatusID = TxRemitStatus.TxRemitStatusID
LEFT OUTER JOIN TXREMACCCONTACT ON TXREMACCCONTACT.TXREMITTANCEACCOUNTID = TxRemittanceAccount.TXREMITTANCEACCOUNTID
LEFT OUTER JOIN TxRemittanceFee ON Tx.TXREMITTANCEID = TxRemittanceFee.TXREMITTANCEID
LEFT OUTER JOIN CAComputedFee ON CAComputedFee.CAComputedFeeID = TxRemittanceFee.CAComputedFeeID 
LEFT OUTER JOIN CAFeeTemplateFee ON CAComputedFee.CAFeeTemplateFeeID = CAFeeTemplateFee.CAFeeTemplateFeeID
LEFT OUTER JOIN CATransactionFee ON CAComputedFee.CAComputedFeeID = CATransactionFee.CaComputedFeeID
LEFT OUTER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID
INNER JOIN BLGLOBALENTITYEXTENSION ON TXREMITTANCEACCOUNT.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
INNER JOIN GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID  = BLGLOBALENTITYEXTENSION.GLOBALENTITYID
LEFT OUTER JOIN CATRANSACTIONINVOICE ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONINVOICE.CATRANSACTIONID 
LEFT OUTER JOIN CAINVOICE ON CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID
LEFT OUTER JOIN CAStatus ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID

WHERE TxRemitStatus.TxRemitStatusSystemID <> 2 
AND  ( (CATRANSACTIONTYPE.NAME <> 'Void Reversal') OR   (CATRANSACTIONSTATUS.NAME <>'Void'))
AND CASTATUS.NAME <> 'Void'
AND CAINVOICE.INVOICEDATE BETWEEN @StartDate AND @EndDate
AND CASTATUS.CASTATUSID in (2,3,6,7,8)




--FROM   TXREMITTANCE Tx
--INNER JOIN TxRemittanceAccount ON Tx.TXREMITTANCEACCOUNTID = TxRemittanceAccount.TXREMITTANCEACCOUNTID
--LEFT OUTER JOIN TXRPTPERIOD ON TXREMITTANCEACCOUNT.REPORTPERIODID = TXRPTPERIOD.TXRPTPERIODID
--INNER JOIN TXBILLPERIOD On Tx.TXBILLPERIODID = TxBillPeriod.BillPeriodID
--INNER JOIN TxRemitStatus ON TxRemittanceAccount.TxRemittanceStatusID = TxRemitStatus.TxRemitStatusID
--LEFT OUTER JOIN TXREMACCCONTACT ON TXREMACCCONTACT.TXREMITTANCEACCOUNTID = TxRemittanceAccount.TXREMITTANCEACCOUNTID
--LEFT OUTER JOIN TxRemittanceFee ON Tx.TXREMITTANCEID = TxRemittanceFee.TXREMITTANCEID
--LEFT OUTER JOIN CAComputedFee ON CAComputedFee.CAComputedFeeID = TxRemittanceFee.CAComputedFeeID 
----LEFT OUTER JOIN CAStatus ON CaComputedFee.CASTATUSID = CASTATUS.CASTATUSID
--LEFT OUTER JOIN CAFeeTemplateFee ON CAComputedFee.CAFeeTemplateFeeID = CAFeeTemplateFee.CAFeeTemplateFeeID
--LEFT OUTER JOIN CATransactionFee ON CAComputedFee.CAComputedFeeID = CATransactionFee.CaComputedFeeID
--LEFT OUTER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
--LEFT OUTER JOIN GLOBALENTITY ON  GLOBALENTITY.GLOBALENTITYID = TXREMACCCONTACT.GLOBALENTITYID 
--LEFT OUTER JOIN GLOBALENTITYACCOUNTENTITY ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYACCOUNTENTITY.GLOBALENTITYID
--LEFT JOIN GLOBALENTITYACCOUNT ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID =GLOBALENTITYACCOUNTENTITY.GLOBALENTITYACCOUNTID
--LEFT OUTER JOIN CATRANSACTIONINVOICE ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONINVOICE.CATRANSACTIONID -- CATRANSACTIONINVOICE is a link (VERY IMPORTANT)
--INNER JOIN CAInvoiceFee ON CAComputedFee.CAComputedFeeID = CAInvoiceFee.CAComputedFeeID
--LEFT OUTER JOIN CAINVOICE ON   CAInvoiceFee.CAInvoiceID = CAInvoice.CAInvoiceID   
--LEFT OUTER JOIN CAStatus ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID
--LEFT OUTER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID
--LEFT OUTER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID  
--LEFT OUTER JOIN(SELECT sum(CATRANSACTIONFEE.Paidamount)PaidAmount, CAINVOICE.INVOICENUMBER,CAINVOICE.CAINVOICEID 
--                FROM   CACOMPUTEDFEE 
--                INNER JOIN   CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
--                INNER JOIN   CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
--              	INNER JOIN   CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
--				INNER JOIN   CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
--				INNER JOIN   CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
--				INNER JOIN   CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
--				WHERE     (NOT (CATRANSACTIONTYPE.NAME IN ('Void Reversal'))) 
--				AND       (NOT (CATRANSACTIONSTATUS.NAME IN ('Void'))) 
--				AND       (CAInvoice.CAStatusID <> 5)
--				GROUP BY CAINVOICE.CAINVOICEID,CAINVOICE.INVOICENUMBER
--                 )InvoicePay ON CAINVOICE.CAINVOICEID = InvoicePay.CAINVOICEID 






