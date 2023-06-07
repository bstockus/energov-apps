﻿

CREATE PROCEDURE [dbo].[rpt_CR_SR_Citizen_Request_Detailed_Report_Contact]
@REQUESTID AS VARCHAR(36)
AS
-- exec rpt_CR_SR_Citizen_Request_Detailed_Report_Contact '7fb3de92-f94c-439c-8a11-6df3e72173e1'
SELECT * FROM (
SELECT CITIZENREQUESTCALLERXREF.GLOBALENTITYID, CMCODECASECONTACTTYPE.NAME AS CONTACTTYPE, GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME, 
       GLOBALENTITY.LASTNAME, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, 
       MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.ADDRESSTYPE, 
       MAILINGADDRESS.UNITORSUITE, GLOBALENTITY.BUSINESSPHONE, GLOBALENTITY.HOMEPHONE, GLOBALENTITY.MOBILEPHONE,
       ROW_NUMBER() OVER (PARTITION BY GLOBALENTITY.GLOBALENTITYID ORDER BY MAILINGADDRESS.ADDRESSTYPE, MAILINGADDRESS.MAILINGADDRESSID) 'RowNBR'
FROM CITIZENREQUESTCALLERXREF 
INNER JOIN GLOBALENTITY ON CITIZENREQUESTCALLERXREF.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN CMCODECASECONTACTTYPE ON CITIZENREQUESTCALLERXREF.CMCODECASECONTACTTYPEID = CMCODECASECONTACTTYPE.CMCODECASECONTACTTYPEID
LEFT OUTER JOIN GLOBALENTITYMAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID
WHERE CITIZENREQUESTCALLERXREF.CITIZENREQUESTID = @REQUESTID
) AS CONTACTINFO WHERE CONTACTINFO.RowNBR = 1