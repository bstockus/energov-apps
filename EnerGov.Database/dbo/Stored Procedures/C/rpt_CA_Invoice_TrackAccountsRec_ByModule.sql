﻿



CREATE PROCEDURE [dbo].[rpt_CA_Invoice_TrackAccountsRec_ByModule]
AS

BEGIN


;WITH  CTE_CompAMT AS(    
        select COMPUTEDAMOUNT, cacomputedfee.CACOMPUTEDFEEID from CACOMPUTEDFEE 
        INNER JOIN CAFeeTemplateFee ON CAComputedFee.CAFeeTemplateFeeID = CAFeeTemplateFee.CAFeeTemplateFeeID 
        INNER JOIN CAFEETEMPLATE ON CAFeeTemplateFee.CAFEETEMPLATEID = CAFEETEMPLATE.CAFEETEMPLATEID
        INNER JOIN CAFee ON CAFeeTemplateFee.CAFeeID = CAFee.CAFeeID
        WHERE cafee.ISARFEE = 1      
     )   ,
      
CTE_INV_TOTAL AS (    
      SELECT SUM(COMPUTEDAMOUNT) AS  INVOICETOTAL, SUM(PAIDAMOUNT) AS paidAMT,SUM(COMPUTEDAMOUNT)-SUM(PAIDAMOUNT) AS Balance,
       CAINVOICEFEE.CAINVOICEID
      FROM CTE_CompAMT
      LEFT OUTER JOIN CAINVOICEFEE ON CTE_CompAMT.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
      LEFT OUTER JOIN CAINVOICEFEEARPOSTING ON CAINVOICEFEE.CAINVOICEFEEID = CAINVOICEFEEARPOSTING.CAINVOICEFEEID
      LEFT OUTER JOIN CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID
      WHERE CAINVOICE.INVOICEDUEDATE < GETDATE ()
      GROUP BY CAINVOICEFEE.CAINVOICEID
      HAVING SUM(COMPUTEDAMOUNT)> SUM(PAIDAMOUNT)
)


SELECT DISTINCT
       CASE WHEN BLLICENSE.BLLICENSEID IS NOT NULL THEN 'Business License'
            WHEN CMCODECASE.CMCODECASEID IS NOT NULL THEN 'Code Case'
            WHEN ILLICENSE.ILLICENSEID IS NOT NULL THEN 'Professional License'
            WHEN PLAPPLICATION.PLAPPLICATIONID IS NOT NULL THEN 'Application'
            WHEN PLPLAN.PLPLANID IS NOT NULL THEN 'Plan'
            WHEN PMPERMIT.PMPERMITID IS NOT NULL THEN 'Permit'
            WHEN PRPROJECT.PRPROJECTID IS NOT NULL THEN 'Project'
            END AS MODULE,
      
        CAINVOICE.INVOICENUMBER, CONVERT(VARCHAR(15),CAINVOICE.INVOICEDATE,101) INVOICEDATE, CONVERT(VARCHAR(15),CAINVOICE.INVOICEDUEDATE,101)INVOICEDUEDATE,
        CAINVOICE.LASTCHANGEDBY,
        GLOBALENTITY.GLOBALENTITYNAME,  USERS.FNAME FIRSTNAME, USERS.LNAME LASTNAME, 
        COALESCE(BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, BLLICENSE.LICENSENUMBER, ILLICENSE.LICENSENUMBER, PLAPPLICATION.APPNUMBER, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, PRPROJECT.PROJECTNUMBER
       )AS CaseNumber, CTE_INV_TOTAL.Balance, CTE_INV_TOTAL.INVOICETOTAL AS INVOICEAMOUNT,
       CASE WHEN DATEDIFF(D, CAINVOICE.INVOICEDUEDATE,GETDATE ()) < 30 THEN CTE_INV_TOTAL.Balance ELSE 0 END AS '0-30',
       CASE WHEN 30 < DATEDIFF(D, CAINVOICE.INVOICEDUEDATE,GETDATE ()) AND  DATEDIFF(D, CAINVOICE.INVOICEDUEDATE,GETDATE ()) < = 60 THEN CTE_INV_TOTAL.Balance ElSE 0 END AS '31-60',
       CASE WHEN 60 < DATEDIFF(D, CAINVOICE.INVOICEDUEDATE,GETDATE ()) AND  DATEDIFF(D, CAINVOICE.INVOICEDUEDATE,GETDATE ()) < = 90 THEN CTE_INV_TOTAL.Balance ELSE 0 END AS '61-90',
       CASE WHEN DATEDIFF(D, CAINVOICE.INVOICEDUEDATE,GETDATE ()) > 90 THEN CTE_INV_TOTAL.Balance ELSE 0 END AS '91 +' 
FROM CAINVOICE 
INNER JOIN USERS ON CAINVOICE.LASTCHANGEDBY = USERS.SUSERGUID
INNER JOIN GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN CAINVOICEFEE ON CAINVOICE.CAINVOICEID = CAINVOICEFEE.CAINVOICEID 
INNER JOIN CACOMPUTEDFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID 
INNER JOIN CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID 
INNER JOIN CTE_INV_TOTAL ON CAINVOICE.CAINVOICEID = CTE_INV_TOTAL.CAINVOICEID
LEFT OUTER JOIN BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN BLLICENSE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID 
LEFT OUTER JOIN CMCODECASEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMCODECASEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN CMCODECASE ON CMCODECASEFEE.CMCODECASEID = CMCODECASE.CMCODECASEID
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


 
 
END

