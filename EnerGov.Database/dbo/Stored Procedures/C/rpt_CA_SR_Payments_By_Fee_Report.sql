﻿
/*
EXEC [rpt_CA_SR_Payments_By_Fee_Report] '20160101', '20160201'
*/

CREATE PROCEDURE [dbo].[rpt_CA_SR_Payments_By_Fee_Report]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @STARTDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @ENDDATE), 1)

BEGIN
SET NOCOUNT ON;

DECLARE @TCINTEGRATION AS BIT = (SELECT CAST(COALESCE(S.BITVALUE,0) AS BIT) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration');

SELECT	COALESCE(CATRANSACTIONGLPOSTING.CREDITACCOUNTNUMBER,CAFEE.ARFEECODE) AS GLACCOUNT
		, CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.CACOMPUTEDFEEID
		, CATRANSACTIONPAYMENT.PAYMENTDATE
		--, (CATRANSACTIONFEE.PAIDAMOUNT - 2*CATRANSACTIONFEE.REFUNDAMOUNT) AS TRANSACTIONAMOUNT
		, CASE WHEN @TCINTEGRATION = 0
			THEN (CATRANSACTIONGLPOSTING.POSTINGAMOUNT * CASE WHEN CATRANSACTIONFEE.REFUNDAMOUNT > 0 THEN -1 ELSE 1 END)
			ELSE (CATRANSACTIONFEE.PAIDAMOUNT - 2*CATRANSACTIONFEE.REFUNDAMOUNT)
		  END AS TRANSACTIONAMOUNT
		, CATRANSACTIONFEE.CATRANSACTIONFEEID
		, CAPAYMENTMETHOD.NAME AS PAYMENTMETHOD
		, COALESCE(BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, CODEVIO.CASENUMBER, ILLICENSE.LICENSENUMBER, PLAPPLICATION.APPNUMBER
					, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, PRPROJECT.PROJECTNUMBER, RPLANDLORDLICENSE.LANDLORDNUMBER
					, RPPROPERTY.PROPERTYNUMBER, TXREMITTANCEACCOUNT.REMITTANCEACCOUNTNUMBER, IPCASE.CASENUMBER, IMINSPECTION.INSPECTIONNUMBER) AS CaseNumber
		, CAENTITY.NAME AS Module
		, CACOMPUTEDFEE.COMPUTEDAMOUNT AS FEEAMOUNT
		, CATRANSACTION.RECEIPTNUMBER
		, CATRANSACTIONPAYMENT.CATRANSACTIONPAYMENTID
		--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
		,(SELECT COALESCE(S.BITVALUE,0) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration') AS TCIntegration
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM CACOMPUTEDFEE 
INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN GLOBALENTITY GE ON CATRANSACTION.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID 
INNER JOIN CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID 
INNER JOIN CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID
INNER JOIN CAFEETEMPLATE ON CAFEETEMPLATEFEE.CAFEETEMPLATEID = CAFEETEMPLATE.CAFEETEMPLATEID 
LEFT OUTER JOIN CATRANSACTIONFEEPOSTING ON CATRANSACTIONFEE.CATRANSACTIONFEEID = CATRANSACTIONFEEPOSTING.CATRANSACTIONFEEID 
LEFT OUTER JOIN CATRANSACTIONGLPOSTING ON CATRANSACTIONFEEPOSTING.CATRANSACTIONGLPOSTINGID = CATRANSACTIONGLPOSTING.CATRANSACTIONGLPOSTINGID

LEFT OUTER JOIN CAENTITY ON CAENTITY.CAENTITYID = CAFEETEMPLATE.CAENTITYID 

LEFT OUTER JOIN PLAPPLICATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLAPPLICATIONFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLAPPLICATION ON PLAPPLICATIONFEE.PLAPPLICATIONID = PLAPPLICATION.PLAPPLICATIONID 

LEFT OUTER JOIN PLPLANFEE ON PLPLANFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLPLAN ON PLPLAN.PLPLANID = PLPLANFEE.PLPLANID 

LEFT OUTER JOIN PRPROJECTFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PRPROJECTFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PRPROJECT ON PRPROJECTFEE.PRPROJECTID = PRPROJECT.PRPROJECTID 

LEFT OUTER JOIN BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN BLLICENSE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID 

LEFT OUTER JOIN ILLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = ILLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN ILLICENSE ON ILLICENSEFEE.ILLICENSEID = ILLICENSE.ILLICENSEID 

LEFT OUTER JOIN CMCODECASEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMCODECASEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN CMCODECASE ON CMCODECASEFEE.CMCODECASEID = CMCODECASE.CMCODECASEID 

LEFT OUTER JOIN CMVIOLATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMVIOLATIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CMVIOLATION ON CMVIOLATIONFEE.CMVIOLATIONID = CMVIOLATION.CMVIOLATIONID
LEFT OUTER JOIN CMCODEWFSTEP ON CMVIOLATION.CMCODEWFSTEPID = CMCODEWFSTEP.CMCODEWFSTEPID
LEFT OUTER JOIN CMCODECASE CODEVIO ON CMCODEWFSTEP.CMCODECASEID = CODEVIO.CMCODECASEID 

LEFT OUTER JOIN PMPERMITFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PMPERMITFEE.PMPERMITID 

LEFT OUTER JOIN RPLANDLORDLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = RPLANDLORDLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN RPLANDLORDLICENSE ON RPLANDLORDLICENSEFEE.RPLANDLORDLICENSEID = RPLANDLORDLICENSE.RPLANDLORDLICENSEID 

LEFT OUTER JOIN RPPROPERTYFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = RPPROPERTYFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN RPPROPERTY ON RPPROPERTYFEE.RPPROPERTYID = RPPROPERTY.RPPROPERTYID 

LEFT OUTER JOIN TXREMITTANCEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = TXREMITTANCEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN TXREMITTANCE ON TXREMITTANCEFEE.TXREMITTANCEID = TXREMITTANCE.TXREMITTANCEID 
LEFT OUTER JOIN TXREMITTANCEACCOUNT ON TXREMITTANCE.TXREMITTANCEACCOUNTID = TXREMITTANCEACCOUNT.TXREMITTANCEACCOUNTID

LEFT OUTER JOIN IPCONDITIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = IPCONDITIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN IPCONDITION ON IPCONDITIONFEE.IPCONDITIONID = IPCONDITION.IPCONDITIONID
LEFT OUTER JOIN IPCASE ON IPCONDITION.IPCASEID = IPCASE.IPCASEID

LEFT OUTER JOIN IMINSPECTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = IMINSPECTIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN IMINSPECTION ON IMINSPECTIONFEE.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID

WHERE CATransactionPayment.PaymentDate >= @STARTDATE AND CATransactionPayment.PaymentDate < @ENDDATE
AND (CATransactionType.CATransactionTypeID NOT IN (6)) --void reversal
AND (CATransactionStatus.CATransactionStatusID NOT IN (2)) --void
AND (CATransactionFee.CAStatusID NOT IN (5, 10)) --void, deleted

UNION ALL

SELECT	COALESCE(CATRANSACTIONGLPOSTING.CREDITACCOUNTNUMBER,CAFEE.ARFEECODE) AS GLACCOUNT
		, CAMISCFEE.FEENAME, CAMISCFEE.CAMISCFEEID
		, CATRANSACTIONPAYMENT.PAYMENTDATE
		--, (CATRANSACTIONMISCFEE.PAIDAMOUNT - 2*CATRANSACTIONMISCFEE.REFUNDAMOUNT) AS TRANSACTIONAMOUNT
		, CASE WHEN @TCINTEGRATION = 0
			THEN (CATRANSACTIONGLPOSTING.POSTINGAMOUNT * CASE WHEN CATRANSACTIONMISCFEE.REFUNDAMOUNT > 0 THEN -1 ELSE 1 END)
			ELSE (CATRANSACTIONMISCFEE.PAIDAMOUNT - 2*CATRANSACTIONMISCFEE.REFUNDAMOUNT)
		  END AS TRANSACTIONAMOUNT
		, CATRANSACTIONMISCFEE.CATRANSACTIONMISCFEEID
		, CAPAYMENTMETHOD.NAME AS PAYMENTMETHOD
		, 'Misc. Fee' AS CaseNumber, 'Cashier' AS Module
		, CAMISCFEE.AMOUNT AS FEEAMOUNT
		, CATRANSACTION.RECEIPTNUMBER
		, CATRANSACTIONPAYMENT.CATRANSACTIONPAYMENTID
		--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
		,(SELECT COALESCE(S.BITVALUE,0) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration') AS TCIntegration
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM CAMISCFEE 
INNER JOIN CAFEE ON CAMISCFEE.CAFEEID = CAFEE.CAFEEID
INNER JOIN CATRANSACTIONMISCFEE ON CAMISCFEE.CAMISCFEEID = CATRANSACTIONMISCFEE.CAMISCFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
INNER JOIN GLOBALENTITY GE ON CATRANSACTION.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPaymentMethod ON CATransactionPayment.CAPaymentMethodID = CAPaymentMethod.CAPaymentMethodID 
LEFT OUTER JOIN CATRANSACTIONMISCFEEPOSTING ON CATRANSACTIONMISCFEE.CATRANSACTIONMISCFEEID = CATRANSACTIONMISCFEEPOSTING.CATRANSACTIONMISCFEEID 
LEFT OUTER JOIN CATRANSACTIONGLPOSTING ON CATRANSACTIONMISCFEEPOSTING.CATRANSACTIONGLPOSTINGID = CATRANSACTIONGLPOSTING.CATRANSACTIONGLPOSTINGID
WHERE CATransactionPayment.PaymentDate >= @STARTDATE AND CATransactionPayment.PaymentDate < @ENDDATE
AND (CATransactionType.CATransactionTypeID NOT IN (6)) --void reversal
AND (CATransactionStatus.CATransactionStatusID NOT IN (2)) --void
AND (CATRANSACTIONMISCFEE.CAStatusID NOT IN (5, 10)) --void, deleted

END
