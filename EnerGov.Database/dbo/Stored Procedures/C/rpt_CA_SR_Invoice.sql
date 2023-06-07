﻿
-- exec rpt_CA_SR_Invoice 'ba49fc17-6be3-4080-96b8-1698f0e3b4ad'
-- select * from cainvoice where invoicedescription <> 'Converted Invoice' order by invoicenumber
CREATE PROCEDURE [dbo].[rpt_CA_SR_Invoice]
@CAINVOICEID AS VARCHAR(36)
AS
BEGIN

SELECT	CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION
		,CASTATUS.NAME AS INVOICESTATUS
		,CACOMPUTEDFEE.CACOMPUTEDFEEID, CACOMPUTEDFEE.FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT
		,COALESCE(BLLICENSE.BLLICENSEID, CMCODECASE.CMCODECASEID, CODEVIO.CMCODECASEID, ILLICENSE.ILLICENSEID, PLAPPLICATION.PLAPPLICATIONID
				, PLPLAN.PLPLANID, PMPERMIT.PMPERMITID, PRPROJECT.PRPROJECTID, RPLANDLORDLICENSE.RPLANDLORDLICENSEID
				, RPPROPERTY.RPPROPERTYID, TXREMITTANCEACCOUNT.TXREMITTANCEACCOUNTID, IPCASE.IPCASEID
				, IMINSPECTION.IMINSPECTIONID) AS CaseID
		,COALESCE(BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, CODEVIO.CASENUMBER, ILLICENSE.LICENSENUMBER, PLAPPLICATION.APPNUMBER
				, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, PRPROJECT.PROJECTNUMBER, RPLANDLORDLICENSE.LANDLORDNUMBER
				, RPPROPERTY.PROPERTYNUMBER, TXREMITTANCEACCOUNT.REMITTANCEACCOUNTNUMBER, IPCASE.CASENUMBER
				, IMINSPECTION.INSPECTIONNUMBER) AS CaseNumber
		,CAINVOICE.GLOBALENTITYID, GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME+' '+GLOBALENTITY.LASTNAME AS BILLINGCONTACTNAME
		,ISNULL(TB_TRANS.PaidAmount,0) AS PaidAmount
		,COALESCE((SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo')
			,(SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage')) LOGO
		,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
		,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
		,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
		,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Invoice_Remit_To') Municipality_Invoice_Remit_To
FROM CAINVOICE 
INNER JOIN GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN CAINVOICEFEE ON CAINVOICE.CAINVOICEID = CAINVOICEFEE.CAINVOICEID 
INNER JOIN CACOMPUTEDFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID 
LEFT OUTER JOIN ( SELECT CACOMPUTEDFEE.CACOMPUTEDFEEID, 
                         SUM(CASE WHEN CATRANSACTIONFEE.REFUNDAMOUNT > 0 THEN 0 - CATRANSACTIONFEE.REFUNDAMOUNT
                              WHEN CATRANSACTIONFEE.REFUNDAMOUNT < 0 THEN CATRANSACTIONFEE.REFUNDAMOUNT
                              ELSE CATRANSACTIONFEE.PAIDAMOUNT
                         END) AS PaidAmount
                  FROM CACOMPUTEDFEE 
                  INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID
                  INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
                  INNER JOIN CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID 
                  INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID
                  WHERE (CATRANSACTIONTYPE.NAME NOT IN ('Void Reversal','NSF Reversal'))
                  AND   (CATRANSACTIONSTATUS.NAME NOT IN ('Void','NSF'))
				  GROUP BY CACOMPUTEDFEE.CACOMPUTEDFEEID
                ) AS TB_TRANS ON CACOMPUTEDFEE.CACOMPUTEDFEEID = TB_TRANS.CACOMPUTEDFEEID
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
WHERE (CAINVOICE.CAINVOICEID = @CAINVOICEID)

UNION ALL

SELECT	CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION
		,CASTATUS.NAME AS INVOICESTATUS
		,CAMISCFEE.CAMISCFEEID AS CACOMPUTEDFEEID, CAMISCFEE.FEENAME, CAMISCFEE.AMOUNT AS COMPUTEDAMOUNT
		,'Misc Fee' AS CaseID, 'Misc Fee' AS CaseNumber
		,CAINVOICE.GLOBALENTITYID
		,GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME+' '+GLOBALENTITY.LASTNAME AS BILLINGCONTACTNAME
		,ISNULL(TB_TRANS.PaidAmount,0) AS PaidAmount
		,COALESCE((SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo')
			,(SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage')) LOGO
		,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
		,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
		,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
		,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Invoice_Remit_To') Municipality_Invoice_Remit_To
FROM CAINVOICE 
INNER JOIN GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN CAINVOICEMISCFEE ON CAINVOICE.CAINVOICEID = CAINVOICEMISCFEE.CAINVOICEID 
INNER JOIN CAMISCFEE ON CAMISCFEE.CAMISCFEEID = CAINVOICEMISCFEE.CAMISCFEEID 
INNER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID 
LEFT OUTER JOIN ( SELECT CAMiscFee.CAMISCFEEID ,                          
                         SUM(CASE WHEN CATRANSACTIONMISCFEE.REFUNDAMOUNT > 0 THEN 0 - CATRANSACTIONMISCFEE.REFUNDAMOUNT
                              WHEN CATRANSACTIONMISCFEE.REFUNDAMOUNT < 0 THEN CATRANSACTIONMISCFEE.REFUNDAMOUNT
                              ELSE CATRANSACTIONMISCFEE.PAIDAMOUNT
                         END) AS PaidAmount
                 FROM CAMISCFEE 
                 INNER JOIN CATRANSACTIONMISCFEE ON CATRANSACTIONMISCFEE.CAMISCFEEID = CAMISCFEE.CAMISCFEEID 
                 INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
                 INNER JOIN CATRANSACTIONTYPE ON CATRANSACTIONTYPE.CATRANSACTIONTYPEID = CATRANSACTION.CATRANSACTIONTYPEID 
                 INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID  
                 INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
                 INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
                 WHERE (NOT (CATRANSACTIONTYPE.NAME IN ('Void Reversal','NSF Reversal'))) 
                 AND   (NOT (CATRANSACTIONSTATUS.NAME IN ('Void','NSF'))) 
				 GROUP BY CAMiscFee.CAMISCFEEID
                ) AS TB_TRANS ON CAMISCFEE.CAMISCFEEID = TB_TRANS.CAMISCFEEID
WHERE (CAInvoice.CAInvoiceID = @CAINVOICEID) 

END
