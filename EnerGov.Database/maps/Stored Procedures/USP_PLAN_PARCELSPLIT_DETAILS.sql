﻿CREATE PROCEDURE [maps].[USP_PLAN_PARCELSPLIT_DETAILS]
(
	@ENTITYID AS CHAR(36)
)
AS 
BEGIN
	DECLARE @ENTITYLIST AS RecordIDs
	INSERT INTO @ENTITYLIST (RECORDID) VALUES (@ENTITYID)
SELECT PLPLAN.PLPLANID,
	PLPLAN.PLANNUMBER,
	PLPLANTYPE.PLANNAME,
	PLPLANWORKCLASS.NAME,
	'Plan' AS MODULE,
	PLPLAN.PLPLANTYPEID,
	PLPLAN.PLPLANWORKCLASSID,
	PLPLAN.APPLICATIONDATE,
	PROJECTDETAILS.PRPROJECTID,
	PROJECTDETAILS.NAME
	FROM PLPLAN 
	INNER JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID
	INNER JOIN PLPLANWORKCLASS ON PLPLAN.PLPLANWORKCLASSID = PLPLANWORKCLASS.PLPLANWORKCLASSID
	OUTER APPLY (SELECT TOP 1 PRPROJECT.PRPROJECTID, PRPROJECT.NAME 
		FROM PRPROJECTPLAN
		INNER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID
		WHERE PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID) PROJECTDETAILS
	WHERE [PLPLAN].[PLPLANID] = @ENTITYID
	EXEC [common].[USP_PLPLANADDRESS_GETBYIDS] @ENTITYLIST
	SELECT 
		PLPLANPARCEL.PLPLANPARCELID,
		PARCEL.PARCELID,
		PARCEL.PARCELNUMBER,
		PLPLANPARCEL.MAIN,
		PLPLANPARCEL.PARCELSPLITPROCESS
	FROM PLPLANPARCEL 
	INNER JOIN PARCEL ON PLPLANPARCEL.PARCELID = PARCEL.PARCELID
	WHERE PLPLANPARCEL.PLPLANID = @ENTITYID AND (PLPLANPARCEL.PARCELSPLITPROCESS = 1 OR PLPLANPARCEL.MAIN = 1)
END