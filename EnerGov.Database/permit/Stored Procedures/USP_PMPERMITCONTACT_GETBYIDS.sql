﻿CREATE PROCEDURE [permit].[USP_PMPERMITCONTACT_GETBYIDS]
(
	@PMPERMITLIST RecordIDs READONLY
)
AS
BEGIN
	SELECT 
		PMPERMITCONTACT.PMPERMITID,
		PMPERMITCONTACT.GLOBALENTITYID,
		GLOBALENTITY.FIRSTNAME,
		GLOBALENTITY.LASTNAME,
		GLOBALENTITY.GLOBALENTITYNAME,
		PMPERMITCONTACT.ISBILLING, 
		GLOBALENTITY.TITLE,
		GLOBALENTITY.ISACTIVE,
		LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID,
		LANDMANAGEMENTCONTACTTYPE.NAME
	FROM PMPERMITCONTACT JOIN GLOBALENTITY ON PMPERMITCONTACT.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
	INNER JOIN LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PMPERMITCONTACT.LANDMANAGEMENTCONTACTTYPEID
	INNER JOIN @PMPERMITLIST PMPERMITLIST ON PMPERMITCONTACT.PMPERMITID = PMPERMITLIST.RECORDID
END