﻿
CREATE VIEW [dbo].[INVOICEVIEW]
AS
-- Permit Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, CAFEE.NAME AS FEENAME, 
                      CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, PMPERMIT.PERMITNUMBER AS CASENUMBER, CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, 
                      CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, 
                      MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, 
                      MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, 
                      MAILINGADDRESS.ADDRESSTYPE
FROM         PMPERMIT INNER JOIN
                      PMPERMITFEE ON PMPERMIT.PMPERMITID = PMPERMITFEE.PMPERMITID INNER JOIN
                      CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID ON PMPERMITFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
UNION ALL
-- Plan Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, CAFEE.NAME AS FEENAME, 
                      CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, PLPLAN.PLANNUMBER AS CASENUMBER, CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, 
                      CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, 
                      MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, 
                      MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, 
                      MAILINGADDRESS.STREETTYPE
FROM         CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID INNER JOIN
                      PLPLANFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID INNER JOIN
                      PLPLAN ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
UNION ALL
-- CodeCase Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, CAFEE.NAME AS FEENAME, 
                      CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, CMCODECASE.CASENUMBER AS CASENUMBER, CAINVOICE.INVOICEDUEDATE, 
                      CAINVOICE.INVOICEDESCRIPTION, CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, GLOBALENTITY.GLOBALENTITYNAME, 
                      MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, 
                      MAILINGADDRESS.COUNTRY, MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, 
                      MAILINGADDRESS.ADDRESSTYPE, MAILINGADDRESS.STREETTYPE
FROM         CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID INNER JOIN
                      CMCODECASEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMCODECASEFEE.CACOMPUTEDFEEID INNER JOIN
                      CMCODECASE ON CMCODECASEFEE.CMCODECASEID = CMCODECASE.CMCODECASEID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
UNION ALL
-- Application Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, CAFEE.NAME AS FEENAME, 
                      CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, PLAPPLICATION.APPNUMBER AS CASENUMBER, CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, 
                      CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, 
                      MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, 
                      MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, 
                      MAILINGADDRESS.STREETTYPE
FROM         CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID INNER JOIN
                      PLAPPLICATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLAPPLICATIONFEE.CACOMPUTEDFEEID INNER JOIN
                      PLAPPLICATION ON PLAPPLICATIONFEE.PLAPPLICATIONID = PLAPPLICATION.PLAPPLICATIONID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
UNION ALL
-- Business License Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, 
                      CAFEE.NAME AS FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, BLLICENSE.LICENSENUMBER AS CASENUMBER, 
                      CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, 
                      GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, 
                      MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, MAILINGADDRESS.POSTALCODE, 
                      MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, 
                      MAILINGADDRESS.STREETTYPE
FROM         CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID INNER JOIN
                      BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID INNER JOIN
                      BLLICENSE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID

UNION ALL
-- Business Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, 
                      CAFEE.NAME AS FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, BLGLOBALENTITYEXTENSION.REGISTRATIONID AS CASENUMBER, 
                      CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, 
                      GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, 
                      MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, MAILINGADDRESS.POSTALCODE, 
                      MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, 
                      MAILINGADDRESS.STREETTYPE
FROM         CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID INNER JOIN
                      BLGLOBALENTITYEXTENSIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLGLOBALENTITYEXTENSIONFEE.CACOMPUTEDFEEID INNER JOIN
                      BLGLOBALENTITYEXTENSION ON BLGLOBALENTITYEXTENSIONFEE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
UNION ALL
-- Professional License Module
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, 
                      CAFEE.NAME AS FEENAME, CACOMPUTEDFEE.COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, ILLICENSE.LICENSENUMBER AS CASENUMBER, 
                      CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, CACOMPUTEDFEE.FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, 
                      GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, 
                      MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, MAILINGADDRESS.POSTALCODE, 
                      MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, 
                      MAILINGADDRESS.STREETTYPE
FROM         CACOMPUTEDFEE INNER JOIN
                      CAINVOICEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CAINVOICEFEE.CACOMPUTEDFEEID INNER JOIN
                      CAINVOICE ON CAINVOICEFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITY ON CAINVOICE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID INNER JOIN
                      CAFEETEMPLATEFEE ON CACOMPUTEDFEE.CAFEETEMPLATEFEEID = CAFEETEMPLATEFEE.CAFEETEMPLATEFEEID INNER JOIN
                      CAFEE ON CAFEETEMPLATEFEE.CAFEEID = CAFEE.CAFEEID INNER JOIN
                      ILLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = ILLICENSEFEE.CACOMPUTEDFEEID INNER JOIN
                      ILLICENSE ON ILLICENSEFEE.ILLICENSEID = ILLICENSE.ILLICENSEID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID LEFT OUTER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
UNION ALL
SELECT     CAINVOICE.INVOICENUMBER, CAINVOICE.INVOICEDATE, CAINVOICE.INVOICETOTAL, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, CAFEE.NAME AS FEENAME, 
                      CAMISCFEE.AMOUNT AS COMPUTEDAMOUNT, CASTATUS.NAME AS CASTATUS, 'MISC. FEES' AS CASENUMBER, CAINVOICE.INVOICEDUEDATE, CAINVOICE.INVOICEDESCRIPTION, 
                      '' AS FEEORDER, GLOBALENTITY.GLOBALENTITYID, CAINVOICE.CAINVOICEID, GLOBALENTITY.GLOBALENTITYNAME, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, 
                      MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.COUNTY, MAILINGADDRESS.COUNTRY, MAILINGADDRESS.POSTALCODE, 
                      MAILINGADDRESS.COUNTRYTYPE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, MAILINGADDRESS.STREETTYPE
FROM         CAINVOICEMISCFEE INNER JOIN
                      GLOBALENTITY INNER JOIN
                      CAINVOICE ON GLOBALENTITY.GLOBALENTITYID = CAINVOICE.GLOBALENTITYID INNER JOIN
                      CASTATUS ON CAINVOICE.CASTATUSID = CASTATUS.CASTATUSID ON CAINVOICEMISCFEE.CAINVOICEID = CAINVOICE.CAINVOICEID INNER JOIN
                      GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID LEFT OUTER JOIN
                      MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID LEFT OUTER JOIN
                      CAMISCFEE LEFT OUTER JOIN
                      CAFEE ON CAMISCFEE.CAFEEID = CAFEE.CAFEEID ON CAINVOICEMISCFEE.CAMISCFEEID = CAMISCFEE.CAMISCFEEID