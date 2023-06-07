﻿CREATE PROCEDURE [dbo].[USP_IDENTITY_LOGIN]
(
	@ID NVARCHAR(254)
)
AS
DECLARE @ROLE_ID AS CHAR(36)
DECLARE @SERVICE_USER char(36) = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa'

SELECT 
	SUSERGUID,
	ID,
	SROLEID,
	FNAME,
	LNAME,
	EMAIL,
	BACTIVE,
	GMAPID,
	GLOBALENTITYID,
	APPLICATIONERRORS,
	MIDDLENAME,
	TITLE,
	OFFICEID,
	LICENSE_SUITE,
	(SELECT TOP 1 BITVALUE FROM SETTINGS WHERE SETTINGS.NAME='ServerUpgradeCacheRebuildIncomplete') AS UPGRADE_IN_PROGRESS,
	(SELECT TOP 1 STRINGVALUE FROM SETTINGS WHERE SETTINGS.NAME='AppInfo') AS APPINFO,
	(SELECT TOP 1 INTVALUE FROM SETTINGS WHERE SETTINGS.NAME='CommandTimeout') AS COMMANDTIMEOUT,
	(SELECT TOP 1 STRINGVALUE FROM SETTINGS WHERE SETTINGS.NAME='ServiceBusTenant') AS SERVICEBUSTENANT,
	(SELECT TOP 1 STRINGVALUE FROM SETTINGS WHERE SETTINGS.NAME='TimeZoneOffsetInHours') AS TIMEZONENAME,
	PHONE

FROM USERS
WHERE ID = @ID AND (BACTIVE = 1 or SUSERGUID = @SERVICE_USER)

SET @ROLE_ID = (SELECT SROLEID FROM USERS WHERE ID = @id AND (BACTIVE = 1 or SUSERGUID = @SERVICE_USER))

SELECT 
	CUSTOMFIELDID, ISHIDDEN, ISDISABLED, CUSTOMFIELDTABLECOLUMNREFID
FROM ROLESCUSTOMFIELDS
WHERE ROLEID = @ROLE_ID

SELECT
	ROLEFORMSXREF.FKFORMSID, ROLEFORMSXREF.BVISIBLE, ROLEFORMSXREF.BALLOWADD, ROLEFORMSXREF.BALLOWUPDATE, ROLEFORMSXREF.BALLOWDELETE,
	FORMS.SCOMMONNAME, FORMS.SFORMNAME , FORMS.MODULE_ID,
	COALESCE(ROLESUBMENUXREF.BVISIBLE, CAST(1 AS BIT)) AS SUBMENU_VISISBLE,
	COALESCE(ROLEMENUXREF.BVISIBLE, CAST(1 AS BIT)) AS MENU_VISISBLE
FROM ROLEFORMSXREF 
INNER JOIN FORMS ON FORMS.SFORMSGUID = ROLEFORMSXREF.FKFORMSID 
LEFT JOIN SUBMENUS ON SUBMENUS.SSUBMENUGUID = FORMS.FKSUBMENUGUID
LEFT JOIN ROLESUBMENUXREF ON ROLESUBMENUXREF.FKSUBMENUID = SUBMENUS.SSUBMENUGUID AND ROLESUBMENUXREF.FKROLEID = @ROLE_ID
LEFT OUTER JOIN MENUS ON MENUS.SMENUGUID = SUBMENUS.FKMENUGUID
LEFT OUTER JOIN ROLEMENUXREF ON ROLEMENUXREF.FKMENUID = MENUS.SMENUGUID AND ROLEMENUXREF.FKROLEID = @ROLE_ID
WHERE ROLEFORMSXREF.FKROLEID = @ROLE_ID

SELECT 
	ROLESAPPLICATIONCLASSPROPERTY.APPLICATIONCLASSPROPERTYID, ISHIDDEN, ISDISABLED, 
	APPLICATIONCLASSPROPERTY.CLASSNAME, APPLICATIONCLASSPROPERTY.PROPERTYNAME
FROM ROLESAPPLICATIONCLASSPROPERTY
INNER JOIN APPLICATIONCLASSPROPERTY ON APPLICATIONCLASSPROPERTY.APPLICATIONCLASSPROPERTYID = ROLESAPPLICATIONCLASSPROPERTY.APPLICATIONCLASSPROPERTYID
WHERE ROLESAPPLICATIONCLASSPROPERTY.ROLEID = @ROLE_ID

SELECT 
	CAPAYMENTMETHODID, DISABLEDFLAG
FROM ROLEPAYMENTMETHODXREF
WHERE ROLEPAYMENTMETHODXREF.SROLEGUID = @ROLE_ID