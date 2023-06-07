﻿
/*
EXEC [rpt_CA_SR_Transactions_By_GL_Account] '20160601', '20170701'
EXEC [rpt_CA_SR_Transactions_By_GL_Account_Sum] '20160101', '20160201' ''
EXEC [rpt_CA_SR_Transactions_By_GL_Account_GrandSum] '20160101', '20160201'
EXEC [rpt_CA_SR_Transactions_By_GL_Account_Param] '20160101', '20180201'
*/


CREATE PROCEDURE [dbo].[rpt_CA_SR_Transactions_By_GL_Account]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
BEGIN

SET @STARTDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(SECOND,-1,DATEDIFF(DAY,0,@ENDDATE) + 1)

SELECT	CACOMPUTEDFEE.CACOMPUTEDFEEID, CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, 
		(CATRANSACTIONFEE.PAIDAMOUNT - 2*CATRANSACTIONFEE.REFUNDAMOUNT) AS PAIDAMOUNT, 
		CASE WHEN (SELECT COALESCE(S.BITVALUE,0) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration') = 0 THEN (
		CATRANSACTIONGLPOSTING.POSTINGAMOUNT * CASE WHEN CATRANSACTIONTYPE.NAME = 'Refund' THEN -1 ELSE 1 END)
		ELSE (CATRANSACTIONFEE.PAIDAMOUNT - 2*CATRANSACTIONFEE.REFUNDAMOUNT) END AS POSTINGAMOUNT,
		CATRANSACTION.RECEIPTNUMBER, CAINVOICE.INVOICENUMBER, CATRANSACTION.TRANSACTIONDATE, CAPAYMENTMETHOD.NAME AS PaymentMethod, 
		CATRANSACTIONTYPE.NAME AS TransactionType, CATRANSACTIONSTATUS.NAME AS TransactionStatus, CAINVOICEFEE.CAINVOICEFEEID,
		COALESCE(GLACCOUNT.GLACCOUNTID,CAFEE.ARFEECODE) AS GLACCOUNTID, COALESCE(GLACCOUNT.NAME,CAFEE.ARFEECODE) AS GLACCOUNTNAME, GLACCOUNT.ACCOUNTNUMBER
		,COALESCE(BLLICENSE.BLLICENSEID, CMCODECASE.CMCODECASEID, CODEVIO.CMCODECASEID, ILLICENSE.ILLICENSEID, PLAPPLICATION.PLAPPLICATIONID
				, PLPLAN.PLPLANID, PMPERMIT.PMPERMITID, PRPROJECT.PRPROJECTID, RPLANDLORDLICENSE.RPLANDLORDLICENSEID
				, RPPROPERTY.RPPROPERTYID, TXREMITTANCEACCOUNT.TXREMITTANCEACCOUNTID, IPCASE.IPCASEID
				, IMINSPECTION.IMINSPECTIONID) AS CaseID
		,COALESCE(BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, CODEVIO.CASENUMBER, ILLICENSE.LICENSENUMBER, PLAPPLICATION.APPNUMBER
				, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, PRPROJECT.PROJECTNUMBER, RPLANDLORDLICENSE.LANDLORDNUMBER
				, RPPROPERTY.PROPERTYNUMBER, TXREMITTANCEACCOUNT.REMITTANCEACCOUNTNUMBER, IPCASE.CASENUMBER
				, IMINSPECTION.INSPECTIONNUMBER) AS CaseNumber
		--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
		,(SELECT COALESCE(S.BITVALUE,0) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration') AS TCIntegration
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM CACOMPUTEDFEE 
INNER JOIN CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID
INNER JOIN CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID
INNER JOIN CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
LEFT JOIN CATRANSACTIONFEEPOSTING ON CATRANSACTIONFEE.CATRANSACTIONFEEID = CATRANSACTIONFEEPOSTING.CATRANSACTIONFEEID
LEFT JOIN CATRANSACTIONGLPOSTING ON CATRANSACTIONFEEPOSTING.CATRANSACTIONGLPOSTINGID = CATRANSACTIONGLPOSTING.CATRANSACTIONGLPOSTINGID
LEFT JOIN GLACCOUNT ON CATRANSACTIONGLPOSTING.CREDITACCOUNTID = GLACCOUNT.GLACCOUNTID
LEFT OUTER JOIN BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN BLLICENSE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID 
LEFT OUTER JOIN CMCODECASEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMCODECASEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN CMCODECASE ON CMCODECASEFEE.CMCODECASEID = CMCODECASE.CMCODECASEID 
LEFT OUTER JOIN CMVIOLATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMVIOLATIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CMVIOLATION ON CMVIOLATIONFEE.CMVIOLATIONID = CMVIOLATION.CMVIOLATIONID
LEFT OUTER JOIN CMCODEWFSTEP ON CMVIOLATION.CMCODEWFSTEPID = CMCODEWFSTEP.CMCODEWFSTEPID
LEFT OUTER JOIN CMCODECASE CODEVIO ON CMCODEWFSTEP.CMCODECASEID = CODEVIO.CMCODECASEID 
LEFT OUTER JOIN ILLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = ILLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN ILLICENSE ON ILLICENSEFEE.ILLICENSEID = ILLICENSE.ILLICENSEID 
LEFT OUTER JOIN PLAPPLICATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLAPPLICATIONFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLAPPLICATION ON PLAPPLICATIONFEE.PLAPPLICATIONID = PLAPPLICATION.PLAPPLICATIONID 
LEFT OUTER JOIN PLPLANFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLPLAN ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID 
LEFT OUTER JOIN PMPERMITFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PMPERMIT ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID 
LEFT OUTER JOIN PRPROJECTFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PRPROJECTFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PRPROJECT ON PRPROJECTFEE.PRPROJECTID = PRPROJECT.PRPROJECTID 
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
LEFT OUTER JOIN IMINSPECTION ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONFEE.IMINSPECTIONID
WHERE (CATRANSACTION.TRANSACTIONDATE BETWEEN @STARTDATE AND @ENDDATE)
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Void Reversal')) 
AND   (NOT (CATRANSACTIONSTATUS.NAME = 'Void')) 
--AND   (CAInvoice.CAStatusID <> 5)

UNION ALL

SELECT	CAMISCFEE.CAMISCFEEID AS CACOMPUTEDFEEID, CAMISCFEE.FEENAME, CAMISCFEE.AMOUNT AS COMPUTEDAMOUNT, 
		(CATRANSACTIONMISCFEE.PAIDAMOUNT - 2*CATRANSACTIONMISCFEE.REFUNDAMOUNT) AS PAIDAMOUNT,
		CASE WHEN (SELECT COALESCE(S.BITVALUE,0) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration') = 0 THEN (
		CATRANSACTIONGLPOSTING.POSTINGAMOUNT * CASE WHEN CATRANSACTIONTYPE.NAME = 'Refund' THEN -1 ELSE 1 END)
		ELSE (CATRANSACTIONMISCFEE.PAIDAMOUNT - 2*CATRANSACTIONMISCFEE.REFUNDAMOUNT) END AS POSTINGAMOUNT,
		--CATRANSACTIONGLPOSTING.POSTINGAMOUNT * CASE WHEN CATRANSACTIONTYPE.NAME = 'Refund' THEN -1 ELSE 1 END AS POSTINGAMOUNT,
		CATRANSACTION.RECEIPTNUMBER, CAINVOICE.INVOICENUMBER, CATRANSACTION.TRANSACTIONDATE, CAPAYMENTMETHOD.NAME AS PaymentMethod, 
		CATRANSACTIONTYPE.NAME AS TransactionType, CATRANSACTIONSTATUS.NAME AS TransactionStatus, CAINVOICEMISCFEE.CAINVOICEMISCFEEID AS CAINVOICEFEEID,
		COALESCE(GLACCOUNT.GLACCOUNTID,CAFEE.ARFEECODE) AS GLACCOUNTID, COALESCE(GLACCOUNT.NAME,CAFEE.ARFEECODE) AS GLACCOUNTNAME, GLACCOUNT.ACCOUNTNUMBER
		, 'Misc Fee' AS CaseID, 'Misc Fee' AS CaseNumber
		--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
		,(SELECT COALESCE(S.BITVALUE,0) FROM SETTINGS S WHERE S.NAME = 'EnableTCIntegration') AS TCIntegration
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM CAMISCFEE 
INNER JOIN CAFEE ON CAMISCFEE.CAFEEID = CAFEE.CAFEEID
INNER JOIN CAINVOICEMISCFEE ON CAMISCFEE.CAMISCFEEID = CAINVOICEMISCFEE.CAMISCFEEID 
INNER JOIN CAINVOICE ON CAINVOICEMISCFEE.CAINVOICEID = CAINVOICE.CAINVOICEID 
INNER JOIN CATRANSACTIONMISCFEE ON CAMISCFEE.CAMISCFEEID = CATRANSACTIONMISCFEE.CAMISCFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
LEFT JOIN CATRANSACTIONMISCFEEPOSTING ON CATRANSACTIONMISCFEE.CATRANSACTIONMISCFEEID = CATRANSACTIONMISCFEEPOSTING.CATRANSACTIONMISCFEEID 
LEFT JOIN CATRANSACTIONGLPOSTING ON CATRANSACTIONMISCFEEPOSTING.CATRANSACTIONGLPOSTINGID = CATRANSACTIONGLPOSTING.CATRANSACTIONGLPOSTINGID
LEFT JOIN GLACCOUNT ON CATRANSACTIONGLPOSTING.CREDITACCOUNTID = GLACCOUNT.GLACCOUNTID
WHERE (CATRANSACTION.TRANSACTIONDATE BETWEEN @STARTDATE AND @ENDDATE)		 
AND   (NOT (CATRANSACTIONTYPE.NAME = 'Void Reversal')) 
AND   (NOT (CATRANSACTIONSTATUS.NAME = 'Void')) 
--AND   (CAInvoice.CAStatusID <> 5)

END
