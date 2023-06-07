﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETCONTACTS]
(
	 @PLITEMREVIEWIDS RecordIDs readonly
)
AS
BEGIN
SET NOCOUNT ON

SELECT		GLOBALENTITY.GLOBALENTITYID AS CONTACTID
			, PLITEMREVIEW.PLITEMREVIEWID AS PARENTID
			, GLOBALENTITY.GLOBALENTITYNAME AS COMPANYNAME
			, GLOBALENTITY.FIRSTNAME
			, GLOBALENTITY.LASTNAME
			, GLOBALENTITY.EMAIL
			, LANDMANAGEMENTCONTACTTYPE.NAME AS TYPENAME
FROM		PLPLANCONTACT
JOIN		GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = PLPLANCONTACT.GLOBALENTITYID
JOIN		LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PLPLANCONTACT.LANDMANAGEMENTCONTACTTYPEID
JOIN		PLITEMREVIEW ON PLITEMREVIEW.PLPLANID = PLPLANCONTACT.PLPLANID
WHERE		PLITEMREVIEW.PLITEMREVIEWID IN (SELECT RECORDID FROM @PLITEMREVIEWIDS)

UNION ALL

SELECT		GLOBALENTITY.GLOBALENTITYID AS CONTACTID
			, PLITEMREVIEW.PLITEMREVIEWID AS PARENTID
			, GLOBALENTITY.GLOBALENTITYNAME AS COMPANYNAME
			, GLOBALENTITY.FIRSTNAME
			, GLOBALENTITY.LASTNAME
			, GLOBALENTITY.EMAIL
			, LANDMANAGEMENTCONTACTTYPE.NAME AS TYPENAME
FROM		PMPERMITCONTACT
JOIN		GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = PMPERMITCONTACT.GLOBALENTITYID
JOIN		LANDMANAGEMENTCONTACTTYPE ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = PMPERMITCONTACT.LANDMANAGEMENTCONTACTTYPEID
JOIN		PLITEMREVIEW ON PLITEMREVIEW.PMPERMITID = PMPERMITCONTACT.PMPERMITID
WHERE		PLITEMREVIEW.PLITEMREVIEWID IN (SELECT RECORDID FROM @PLITEMREVIEWIDS)

UNION ALL

SELECT		GLOBALENTITY.GLOBALENTITYID AS CONTACTID
			, PLITEMREVIEW.PLITEMREVIEWID AS PARENTID
			, GLOBALENTITY.GLOBALENTITYNAME AS COMPANYNAME
			, GLOBALENTITY.FIRSTNAME
			, GLOBALENTITY.LASTNAME
			, GLOBALENTITY.EMAIL
			, BLCONTACTTYPE.NAME AS TYPENAME
FROM		BLLICENSECONTACT
JOIN		GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = BLLICENSECONTACT.GLOBALENTITYID
JOIN		BLCONTACTTYPE ON BLCONTACTTYPE.BLCONTACTTYPEID = BLLICENSECONTACT.BLCONTACTTYPEID
JOIN		PLITEMREVIEW ON PLITEMREVIEW.BLLICENSEID = BLLICENSECONTACT.BLLICENSEID
WHERE		PLITEMREVIEW.PLITEMREVIEWID IN (SELECT RECORDID FROM @PLITEMREVIEWIDS)

UNION ALL

SELECT		GLOBALENTITY.GLOBALENTITYID AS CONTACTID
			, PLITEMREVIEW.PLITEMREVIEWID AS PARENTID
			, GLOBALENTITY.GLOBALENTITYNAME AS COMPANYNAME
			, GLOBALENTITY.FIRSTNAME
			, GLOBALENTITY.LASTNAME
			, GLOBALENTITY.EMAIL
			, BLCONTACTTYPE.NAME AS TYPENAME
FROM		ILLICENSECONTACT
JOIN		GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = ILLICENSECONTACT.GLOBALENTITYID
JOIN		BLCONTACTTYPE ON BLCONTACTTYPE.BLCONTACTTYPEID = ILLICENSECONTACT.BLCONTACTTYPEID
JOIN		PLITEMREVIEW ON PLITEMREVIEW.ILLICENSEID = ILLICENSECONTACT.ILLICENSEID
WHERE		PLITEMREVIEW.PLITEMREVIEWID IN (SELECT RECORDID FROM @PLITEMREVIEWIDS)

END