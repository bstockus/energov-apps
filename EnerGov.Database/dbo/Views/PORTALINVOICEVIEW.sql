﻿
CREATE VIEW [dbo].[PORTALINVOICEVIEW]
AS
SELECT	CAINVOICEID,
		INVOICENUMBER,
		INVOICEDESCRIPTION,
		INVOICEDATE,
		INVOICEDUEDATE,
		CASTATUSID,
		STATUSNAME,
		INVOICETOTAL,
		(CASE WHEN PAIDTODATE IS NULL THEN 0 ELSE PAIDTODATE END) AS PAIDTODATE,
		(CASE WHEN TOTALDUE IS NULL THEN INVOICETOTAL ELSE TOTALDUE END) AS TOTALDUE,
		LASTPAIDDATE,
		GLOBALENTITYID,
		ENTITYID,		
		ENTITYTYPE
FROM 
(SELECT TOP 100 PERCENT
      CAINVOICE.CAINVOICEID,
      CAINVOICE.INVOICENUMBER,
      CAINVOICE.INVOICEDESCRIPTION,
      CAINVOICE.INVOICEDATE,
      CAINVOICE.INVOICEDUEDATE,
      CAINVOICE.CASTATUSID,
      (SELECT NAME FROM CASTATUS WHERE CASTATUSID = CAINVOICE.CASTATUSID) AS 'STATUSNAME',
	  CAINVOICE.INVOICETOTAL,
	  (SELECT SUM(CATRANSACTIONINVOICE.PAIDAMOUNT) FROM CATRANSACTIONINVOICE WHERE CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID) AS PAIDTODATE,
	  (SELECT CAINVOICE.INVOICETOTAL - SUM(CATRANSACTIONINVOICE.PAIDAMOUNT) FROM CATRANSACTIONINVOICE WHERE CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID) AS TOTALDUE, 
	  (SELECT MAX(CATRANSACTION.TRANSACTIONDATE) FROM CATRANSACTION
      LEFT OUTER JOIN CATRANSACTIONINVOICE ON CATRANSACTIONINVOICE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID WHERE CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID) AS LASTPAIDDATE,      
      GLOBALENTITY.GLOBALENTITYID,
      COALESCE(
            (SELECT TOP 1 PLPLAN.PLPLANID AS "ENTITYID"
                  FROM PLPLAN
                  INNER JOIN PLPLANFEE ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID), 
            (SELECT TOP 1 PMPERMIT.PMPERMITID AS "ENTITYID"
                  FROM PMPERMIT
                  INNER JOIN PMPERMITFEE ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),             
			(SELECT TOP 1 BLLICENSE.BLLICENSEID AS "ENTITYID"
                  FROM BLLICENSE
                  INNER JOIN BLLICENSEFEE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
            (SELECT TOP 1 BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID AS "ENTITYID"
                  FROM BLGLOBALENTITYEXTENSION
                  INNER JOIN BLGLOBALENTITYEXTENSIONFEE ON BLGLOBALENTITYEXTENSIONFEE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLGLOBALENTITYEXTENSIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
			(SELECT TOP 1 IMINSPECTION.IMINSPECTIONID AS "ENTITYID"
                  FROM IMINSPECTION
                  INNER JOIN IMINSPECTIONFEE ON IMINSPECTIONFEE.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = IMINSPECTIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),            						 			
            ''
      ) AS ENTITYID,
	  COALESCE(
            (SELECT TOP 1 2 AS "ENTITYTYPE"
                  FROM PLPLAN
                  INNER JOIN PLPLANFEE ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID), 
            (SELECT TOP 1 3 AS "ENTITYTYPE"
                  FROM PMPERMIT
                  INNER JOIN PMPERMITFEE ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),             
			(SELECT TOP 1 5 AS "ENTITYTYPE"
                  FROM BLLICENSE
                  INNER JOIN BLLICENSEFEE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
            (SELECT TOP 1 8 AS "ENTITYTYPE"
                  FROM BLGLOBALENTITYEXTENSION
                  INNER JOIN BLGLOBALENTITYEXTENSIONFEE ON BLGLOBALENTITYEXTENSIONFEE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLGLOBALENTITYEXTENSIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
			(SELECT TOP 1 4 AS "ENTITYTYPE"
                  FROM IMINSPECTION
                  INNER JOIN IMINSPECTIONFEE ON IMINSPECTIONFEE.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = IMINSPECTIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),            						 			
            1
      ) AS ENTITYTYPE
FROM CAINVOICE

INNER JOIN GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = CAINVOICE.GLOBALENTITYID
LEFT JOIN CAINVOICECONTACT ON CAINVOICECONTACT.CAINVOICEID = CAINVOICE.CAINVOICEID WHERE CAINVOICECONTACT.GLOBALENTITYID IS NULL

UNION ALL
SELECT  TOP (100) PERCENT 
		CAINVOICE.CAINVOICEID, 
		CAINVOICE.INVOICENUMBER, 
		CAINVOICE.INVOICEDESCRIPTION, 
		CAINVOICE.INVOICEDATE,                       
		CAINVOICE.INVOICEDUEDATE, 
		CAINVOICE.CASTATUSID,
		(SELECT NAME FROM CASTATUS WHERE CASTATUSID = CAINVOICE.CASTATUSID) AS 'STATUSNAME',
        CAINVOICE.INVOICETOTAL,
		(SELECT SUM(CATRANSACTIONINVOICE.PAIDAMOUNT) FROM CATRANSACTIONINVOICE WHERE CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID) AS PAIDTODATE,
		(SELECT CAINVOICE.INVOICETOTAL - SUM(CATRANSACTIONINVOICE.PAIDAMOUNT) FROM CATRANSACTIONINVOICE WHERE CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID) AS TOTALDUE, 
		(SELECT MAX(CATRANSACTION.TRANSACTIONDATE) FROM CATRANSACTION
        LEFT OUTER JOIN CATRANSACTIONINVOICE ON CATRANSACTIONINVOICE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID WHERE CATRANSACTIONINVOICE.CAINVOICEID = CAINVOICE.CAINVOICEID) AS LASTPAIDDATE,      
        CAINVOICECONTACT.GLOBALENTITYID, 
		COALESCE(
            (SELECT TOP 1 PLPLAN.PLPLANID AS "ENTITYID"
                  FROM PLPLAN
                  INNER JOIN PLPLANFEE ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID), 
            (SELECT TOP 1 PMPERMIT.PMPERMITID AS "ENTITYID"
                  FROM PMPERMIT
                  INNER JOIN PMPERMITFEE ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),             
			(SELECT TOP 1 BLLICENSE.BLLICENSEID AS "ENTITYID"
                  FROM BLLICENSE
                  INNER JOIN BLLICENSEFEE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
            (SELECT TOP 1 BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID AS "ENTITYID"
                  FROM BLGLOBALENTITYEXTENSION
                  INNER JOIN BLGLOBALENTITYEXTENSIONFEE ON BLGLOBALENTITYEXTENSIONFEE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLGLOBALENTITYEXTENSIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
			(SELECT TOP 1 IMINSPECTION.IMINSPECTIONID AS "ENTITYID"
                  FROM IMINSPECTION
                  INNER JOIN IMINSPECTIONFEE ON IMINSPECTIONFEE.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = IMINSPECTIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),            						 			
            ''
      ) AS ENTITYID,
	  COALESCE(
            (SELECT TOP 1 2 AS "ENTITYTYPE"
                  FROM PLPLAN
                  INNER JOIN PLPLANFEE ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID), 
            (SELECT TOP 1 3 AS "ENTITYTYPE"
                  FROM PMPERMIT
                  INNER JOIN PMPERMITFEE ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),             
			(SELECT TOP 1 5 AS "ENTITYTYPE"
                  FROM BLLICENSE
                  INNER JOIN BLLICENSEFEE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
            (SELECT TOP 1 8 AS "ENTITYTYPE"
                  FROM BLGLOBALENTITYEXTENSION
                  INNER JOIN BLGLOBALENTITYEXTENSIONFEE ON BLGLOBALENTITYEXTENSIONFEE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = BLGLOBALENTITYEXTENSIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),
			(SELECT TOP 1 4 AS "ENTITYTYPE"
                  FROM IMINSPECTION
                  INNER JOIN IMINSPECTIONFEE ON IMINSPECTIONFEE.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID
                  INNER JOIN CAINVOICEFEE ON CAINVOICEFEE.CACOMPUTEDFEEID = IMINSPECTIONFEE.CACOMPUTEDFEEID
                  WHERE CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID),            						 			
            1
      ) AS ENTITYTYPE
FROM   CAINVOICE 
INNER JOIN CAINVOICECONTACT ON CAINVOICECONTACT.CAINVOICEID = CAINVOICE.CAINVOICEID
) INVOICEVIEW