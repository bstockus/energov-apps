﻿

CREATE PROCEDURE [dbo].[rpt_CA_Invoice_CaseAddress]
@CaseID AS VARCHAR(36)
AS

SELECT BLLICENSEADDRESS.BLLICENSEID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM BLLICENSEADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON BLLICENSEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE BLLICENSEADDRESS.MAIN = 1
AND BLLICENSEADDRESS.BLLICENSEID = @CaseID

UNION ALL
SELECT BLLICENSE.BLLICENSEID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM BLLICENSE
INNER JOIN BLGLOBALENTITYEXTENSION AS BLGEE ON BLLICENSE.BLGLOBALENTITYEXTENSIONID = BLGEE.BLGLOBALENTITYEXTENSIONID
INNER JOIN GLOBALENTITY ON BLGEE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
LEFT OUTER JOIN GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID
LEFT OUTER JOIN MAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE BLLICENSE.BLLICENSEID NOT IN ( SELECT BLLICENSEADDRESS.BLLICENSEID
                                     FROM BLLICENSEADDRESS
                                     WHERE BLLICENSEADDRESS.MAIN = 1 )
AND BLLICENSE.BLLICENSEID = @CaseID

UNION ALL

SELECT CMCODECASEADDRESS.CMCODECASEID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM CMCODECASEADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON CMCODECASEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE CMCODECASEADDRESS.MAIN = 1
AND CMCODECASEADDRESS.CMCODECASEID = @CaseID

UNION ALL

SELECT ILLICENSEADDRESS.ILLICENSEID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM ILLICENSEADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON ILLICENSEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE ILLICENSEADDRESS.MAIN = 1
AND ILLICENSEADDRESS.ILLICENSEID = @CaseID

UNION ALL

SELECT PLAPPLICATIONADDRESS.PLAPPLICATIONID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM PLAPPLICATIONADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON PLAPPLICATIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PLAPPLICATIONADDRESS.MAIN = 1
AND PLAPPLICATIONADDRESS.PLAPPLICATIONID = @CaseID

UNION ALL

SELECT PLPLANADDRESS.PLPLANID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM PLPLANADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON PLPLANADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PLPLANADDRESS.MAIN = 1
AND PLPLANADDRESS.PLPLANID = @CaseID

UNION ALL

SELECT PMPERMITADDRESS.PMPERMITID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM PMPERMITADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON PMPERMITADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PMPERMITADDRESS.MAIN = 1
AND PMPERMITADDRESS.PMPERMITID = @CaseID

UNION ALL

SELECT PRPROJECTADDRESS.PRPROJECTID,
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSTYPE
FROM PRPROJECTADDRESS
LEFT OUTER JOIN MAILINGADDRESS ON PRPROJECTADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PRPROJECTADDRESS.MAIN = 1
AND PRPROJECTADDRESS.PRPROJECTID = @CaseID


