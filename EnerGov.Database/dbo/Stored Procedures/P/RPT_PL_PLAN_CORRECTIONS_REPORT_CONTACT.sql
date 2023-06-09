﻿

CREATE PROCEDURE [dbo].[RPT_PL_PLAN_CORRECTIONS_REPORT_CONTACT]
@PLPLANID AS VARCHAR(36)
AS
SELECT GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, 
       MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, 
       MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, LANDMANAGEMENTCONTACTTYPE.NAME AS CONTACTTYPE
FROM PLPLANCONTACT 
INNER JOIN LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PLPLANCONTACT.LANDMANAGEMENTCONTACTTYPEID 
INNER JOIN GLOBALENTITY ON PLPLANCONTACT.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
LEFT OUTER JOIN GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID
LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID 
WHERE PLPLANCONTACT.PLPLANID = @PLPLANID

