﻿
CREATE PROCEDURE rpt_PM_Permit_Detailed_Dept_B_Contacts
@PMPERMITID varchar(36)
AS

/*BUILD LIST OF ADDRESSES FOR CONTACTS*/
SELECT GEMA.GLOBALENTITYID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + MA.POSTALCODE) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY GEMA.GLOBALENTITYID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE 'Mailing%' THEN 1 WHEN MA.ADDRESSTYPE LIKE 'Billing%' THEN 2 WHEN MA.ADDRESSTYPE LIKE 'Location%' THEN 3 ELSE 4 END, MA.MAILINGADDRESSID) AS ROWNBR
INTO #CONTACTADDRESS
FROM GLOBALENTITYMAILINGADDRESS GEMA 
INNER JOIN MAILINGADDRESS MA ON GEMA.MAILINGADDRESSID = MA.MAILINGADDRESSID


SELECT PMC.PMPERMITID, 
	CASE WHEN GE.ISCOMPANY = 1 THEN GE.GLOBALENTITYNAME ELSE GE.FIRSTNAME + ' ' + GE.LASTNAME END CONTACTNAME,
	GE.EMAIL, 
	CASE	WHEN LEN(LTRIM(GE.BUSINESSPHONE)) > 0 THEN GE.BUSINESSPHONE 
		WHEN LEN(LTRIM(GE.MOBILEPHONE)) > 0 THEN GE.MOBILEPHONE 
		WHEN LEN(LTRIM(GE.HOMEPHONE)) > 0 THEN GE.HOMEPHONE 
		WHEN LEN(LTRIM(GE.OTHERPHONE)) > 0 THEN GE.OTHERPHONE 
		ELSE '' END AS PHONE, LMCT.NAME CONTACTTYPE,
	CONADD.ADDRESS_LINE1, CONADD.ADDRESS_LINE2

FROM PMPERMITCONTACT PMC
INNER JOIN GLOBALENTITY GE ON PMC.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN LANDMANAGEMENTCONTACTTYPE LMCT ON PMC.LANDMANAGEMENTCONTACTTYPEID = LMCT.LANDMANAGEMENTCONTACTTYPEID
LEFT  JOIN #CONTACTADDRESS CONADD ON GE.GLOBALENTITYID = CONADD.GLOBALENTITYID AND CONADD.ROWNBR = 1
WHERE PMC.PMPERMITID = @PMPERMITID


DROP TABLE #CONTACTADDRESS;

