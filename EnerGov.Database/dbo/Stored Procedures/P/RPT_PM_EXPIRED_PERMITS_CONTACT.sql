﻿


CREATE PROCEDURE [dbo].[RPT_PM_EXPIRED_PERMITS_CONTACT]
@PERMITID AS VARCHAR(36)
AS
SELECT GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME, GLOBALENTITY.EMAIL, GLOBALENTITY.WEBSITE, GLOBALENTITY.BUSINESSPHONE, 
       GLOBALENTITY.HomePHONE, GLOBALENTITY.MOBILEPHONE, GLOBALENTITY.OTHERPHONE, GLOBALENTITY.FAX, GLOBALENTITY.MIDDLENAME, GLOBALENTITY.TITLE, 
       MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.ADDRESSTYPE, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE, 
       LANDMANAGEMENTCONTACTTYPE.NAME AS CONTACTTYPE, LANDMANAGEMENTCONTACTSYSTEMTYP.NAME AS SYSTEMCONTACTTYPE
FROM PMPERMITCONTACT 
INNER JOIN LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PMPERMITCONTACT.LANDMANAGEMENTCONTACTTYPEID 
INNER JOIN LANDMANAGEMENTCONTACTSYSTEMTYP ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTSYSTEMTYP = LANDMANAGEMENTCONTACTSYSTEMTYP.LANDMANAGEMENTCONTACTSYSTEMTYP 
LEFT OUTER JOIN GLOBALENTITY ON PMPERMITCONTACT.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
LEFT OUTER JOIN GLOBALENTITYMAILINGADDRESS ON GLOBALENTITY.GLOBALENTITYID = GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID
LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID 

WHERE PMPERMITCONTACT.PMPERMITID = @PERMITID


