﻿
CREATE PROCEDURE [dbo].[rpt_CA_SR_Open_Invoices_By_Module]

@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS

BEGIN

SET @STARTDATE = DATEADD(dd, DATEDIFF(dd, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL
		, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, GLOBALENTITY.GLOBALENTITYNAME
		, COALESCE(BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, CODEVIO.CASENUMBER, ILLICENSE.LICENSENUMBER, PLAPPLICATION.APPNUMBER, PLPLAN.PLANNUMBER
					, PMPERMIT.PERMITNUMBER, PRPROJECT.PROJECTNUMBER, RPLANDLORDLICENSE.LANDLORDNUMBER, RPPROPERTY.PROPERTYNUMBER
					, TXREMITTANCEACCOUNT.REMITTANCEACCOUNTNUMBER, IPCASE.CASENUMBER) AS CaseNumber, CACOMPUTEDFEE.COMPUTEDAMOUNT AS ComputedAmount
					, CAINVOICEFEE.PAIDAMOUNT, CAENTITY.NAME AS ModuleName
		--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM CAINVOICE 
INNER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID 
INNER JOIN GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN CAINVOICEFEE ON CAINVOICE.CAINVOICEID = CAINVOICEFEE.CAINVOICEID 
INNER JOIN CACOMPUTEDFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID 
INNER JOIN CAFEETEMPLATE ON CAFEETEMPLATEFEE.CAFEETEMPLATEID = CAFEETEMPLATE.CAFEETEMPLATEID 
INNER JOIN CAENTITY ON CAFEETEMPLATE.CAENTITYID = CAENTITY.CAENTITYID 
LEFT OUTER JOIN BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN BLLICENSE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID 
LEFT OUTER JOIN PLPLANFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLPLAN ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID 
LEFT OUTER JOIN PMPERMITFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PMPERMIT ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID 
LEFT OUTER JOIN CMCODECASEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMCODECASEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN CMCODECASE ON CMCODECASEFEE.CMCODECASEID = CMCODECASE.CMCODECASEID 
LEFT OUTER JOIN CMVIOLATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMVIOLATIONFEE.CACOMPUTEDFEEID
LEFT OUTER JOIN CMVIOLATION ON CMVIOLATIONFEE.CMVIOLATIONID = CMVIOLATION.CMVIOLATIONID
LEFT OUTER JOIN CMCODEWFSTEP ON CMVIOLATION.CMCODEWFSTEPID = CMCODEWFSTEP.CMCODEWFSTEPID
LEFT OUTER JOIN CMCODECASE CODEVIO ON CMCODEWFSTEP.CMCODECASEID = CODEVIO.CMCODECASEID 
LEFT OUTER JOIN PLAPPLICATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLAPPLICATIONFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLAPPLICATION ON PLAPPLICATIONFEE.PLAPPLICATIONID = PLAPPLICATION.PLAPPLICATIONID
LEFT OUTER JOIN ILLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = ILLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN ILLICENSE ON ILLICENSEFEE.ILLICENSEID = ILLICENSE.ILLICENSEID
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

WHERE (CAINVOICE.INVOICEDATE BETWEEN @STARTDATE AND @ENDDATE) 
AND (CAINVOICE.CASTATUSID NOT IN (4, 5, 9))
UNION ALL
SELECT CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL
		, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, GLOBALENTITY.GLOBALENTITYNAME
		, 'Misc Fee' AS CaseNumber
		, CAMISCFEE.AMOUNT AS ComputedAmount, CAMISCFEE.PAIDAMOUNT
		, 'Cashier' AS ModuleName
		--,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM CAINVOICE 
INNER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID 
INNER JOIN GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN CAINVOICEMISCFEE ON CAINVOICE.CAINVOICEID = CAINVOICEMISCFEE.CAINVOICEID 
INNER JOIN CAMISCFEE ON CAINVOICEMISCFEE.CAMISCFEEID = CAMISCFEE.CAMISCFEEID  	                     
WHERE (CAINVOICE.INVOICEDATE BETWEEN @STARTDATE AND @ENDDATE) 
AND (CAINVOICE.CASTATUSID NOT IN (4, 5, 9))

END