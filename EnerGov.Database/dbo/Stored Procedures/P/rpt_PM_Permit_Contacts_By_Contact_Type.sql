﻿

CREATE PROCEDURE [dbo].[rpt_PM_Permit_Contacts_By_Contact_Type]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT TB_CONT.ContactType, TB_CONT.GlobalEntityName, TB_CONT.FirstName, TB_CONT.LastName, PM.PMPermitID, 
       PM.PermitNumber, PMPermitType.Name AS PermitType, PMPermitWorkClass.Name AS WorkClass,
--CONTACT ADDRESS
       TB_CONT.ADDRESSLINE1, TB_CONT.ADDRESSLINE2, TB_CONT.ADDRESSLINE3, TB_CONT.CITY, TB_CONT.STATE, 
       TB_CONT.POSTALCODE, TB_CONT.POSTDIRECTION, TB_CONT.PREDIRECTION, TB_CONT.STREETTYPE, TB_CONT.UNITORSUITE

FROM PMPermit AS PM 
INNER JOIN PMPermitType ON PM.PMPermitTypeID = PMPermitType.PMPermitTypeID 
INNER JOIN PMPermitWorkClass ON PM.PMPermitWorkClassID = PMPermitWorkClass.PMPermitWorkClassID
INNER JOIN ( SELECT PMPERMITCONTACT.PMPERMITID, PMPERMITCONTACT.ISBILLING, LANDMANAGEMENTCONTACTTYPE.NAME AS ContactType, 
                    GLOBALENTITY.GLOBALENTITYID, GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME,
                    GLOBALENTITY.BUSINESSPHONE, GLOBALENTITY.HOMEPHONE, GLOBALENTITY.MOBILEPHONE, GLOBALENTITY.EMAIL,
                    MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, 
                    MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE
             FROM PMPERMITCONTACT
             INNER JOIN LANDMANAGEMENTCONTACTTYPE ON PMPERMITCONTACT.LANDMANAGEMENTCONTACTTYPEID = LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID
             INNER JOIN GLOBALENTITY ON PMPERMITCONTACT.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
             LEFT OUTER JOIN GLOBALENTITYMAILINGADDRESS ON GLOBALENTITYMAILINGADDRESS.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
             LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = GLOBALENTITYMAILINGADDRESS.MAILINGADDRESSID
           ) AS TB_CONT ON PM.PMPERMITID = TB_CONT.PMPERMITID
WHERE PM.IssueDate BETWEEN @STARTDATE AND @ENDDATE 


