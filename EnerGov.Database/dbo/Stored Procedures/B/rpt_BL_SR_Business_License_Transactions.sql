﻿

CREATE PROCEDURE [dbo].[rpt_BL_SR_Business_License_Transactions]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
BEGIN

SET @STARTDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(SECOND,-1,DATEDIFF(DAY,0,@ENDDATE) + 1)

;with CTE_Account_Balance as(
	select BLLICENSE.BLLICENSEID, BLLICENSE.LICENSENUMBER
		,GLOBALENTITY.GLOBALENTITYNAME as Buiness_name
		,GLOBALENTITYACCOUNT.BALANCE
	from BLLICENSE
	INNER JOIN BLGLOBALENTITYEXTENSION ON BLLICENSE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
	INNER JOIN GLOBALENTITY ON BLGLOBALENTITYEXTENSION.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
	left JOIN GLOBALENTITYACCOUNTENTITY ON GLOBALENTITYACCOUNTENTITY.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
	left join GLOBALENTITYACCOUNT on GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID = GLOBALENTITYACCOUNTENTITY.GLOBALENTITYACCOUNTID
)


              
SELECT CAComputedFee.CAComputedFeeID, CATransaction.ReceiptNumber, CAInvoice.InvoiceNumber, 

	BLLICENSE.LICENSENUMBER AS CaseNumber, BLLICENSETYPE.NAME as License_Type, BLLICENSE.TAXYEAR, isnull(CTE_Account_Balance.BALANCE, 0) as Balance,
	--CTE_Account_Balance.Buiness_name,
	CASE WHEN ISNULL(GE.GLOBALENTITYNAME,'') = '' THEN GE.FIRSTNAME + ' ' + GE.LASTNAME ELSE GE.GLOBALENTITYNAME END AS Buiness_name,
	CATransactionFee.PaidAmount, CATransactionFee.REFUNDAMOUNT, CAComputedFee.ComputedAmount, 
	CATransaction.TRANSACTIONDATE, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData, 
	CATransactionType.Name AS TransactionType, CACOMPUTEDFEE.FEEName AS FeeName, 'Business License' AS Module
	,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM CACOMPUTEDFEE 
INNER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID AND (CAInvoice.CAStatusID <> 5)
INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID AND CATRANSACTIONFEE.CASTATUSID NOT IN (5,10) --VOID, DELETED
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID AND CATRANSACTION.CATRANSACTIONSTATUSID NOT IN (2,3) --VOID, NSF
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID AND CATRANSACTIONTYPE.CATRANSACTIONTYPEID NOT IN (5, 6) --NSF, VOID REVERSAL
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN USERS ON CATRANSACTION.CREATEDBY = USERS.SUSERGUID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID AND CATRANSACTIONPAYMENT.CAPAYMENTSTATUSID NOT IN (3,5) --NSF, VOID
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
inner JOIN BLLicenseFee ON CAComputedFee.CAComputedFeeID = BLLicenseFee.CAComputedFeeID
inner JOIN BLLicense ON BLLicenseFee.BLLicenseID = BLLicense.BLLicenseID 
LEFT JOIN BLGLOBALENTITYEXTENSION Blgee ON Blgee.BLGLOBALENTITYEXTENSIONID = BLLICENSE.BLGLOBALENTITYEXTENSIONID
LEFT JOIN GLOBALENTITY GE ON GE.GLOBALENTITYID = Blgee.GLOBALENTITYID
INNER JOIN BLLICENSETYPE ON BLLICENSE.BLLICENSETYPEID = BLLICENSETYPE.BLLICENSETYPEID  
LEFT OUTER JOIN CTE_Account_Balance ON CTE_Account_Balance.BLLicenseID = BLLicense.BLLicenseID

WHERE CATransaction.TransactionDate BETWEEN @STARTDATE AND @ENDDATE
AND CACOMPUTEDFEE.CASTATUSID NOT IN (5,10) --VOID, DELETED
END