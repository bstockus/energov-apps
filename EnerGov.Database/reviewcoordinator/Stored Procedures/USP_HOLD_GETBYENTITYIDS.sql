﻿CREATE PROCEDURE [reviewcoordinator].[USP_HOLD_GETBYENTITYIDS]
@ENTITYIDS AS RECORDIDS READONLY
AS
BEGIN

SET NOCOUNT ON;
SELECT
	PMPERMITHOLD.PMPERMITID ENTITYID,
	PMPERMITHOLD.PMPERMITHOLDID HOLDID,
	HOLDTYPE.HOLDTYPENAME,
	PMPERMITHOLD.ACTIVE,
	PMPERMITHOLD.COMMENTS
	FROM PMPERMITHOLD
	INNER JOIN HOLDTYPESETUPS ON HOLDTYPESETUPS.HOLDSETUPID = PMPERMITHOLD.HOLDSETUPID
	INNER JOIN HOLDTYPE ON HOLDTYPE.HOLDTYPEID = HOLDTYPESETUPS.HOLDTYPEID
	WHERE PMPERMITHOLD.PMPERMITID IN (SELECT RECORDID FROM @ENTITYIDS)
UNION ALL
SELECT
	PLPLANHOLD.PLPLANID ENTITYID,
	PLPLANHOLD.PLPLANHOLDID HOLDID,
	HOLDTYPE.HOLDTYPENAME,
	PLPLANHOLD.ACTIVE,
	PLPLANHOLD.COMMENTS
	FROM PLPLANHOLD
	INNER JOIN HOLDTYPESETUPS ON HOLDTYPESETUPS.HOLDSETUPID = PLPLANHOLD.HOLDSETUPID
	INNER JOIN HOLDTYPE ON HOLDTYPE.HOLDTYPEID = HOLDTYPESETUPS.HOLDTYPEID
	WHERE PLPLANHOLD.PLPLANID IN (SELECT RECORDID FROM @ENTITYIDS)
END