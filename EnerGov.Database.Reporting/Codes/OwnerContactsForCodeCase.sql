﻿CREATE PROCEDURE [dbo].[OwnerContactsForCodeCase]
	@CODECASEID AS VARCHAR(36)
AS
	SELECT TOP 1
		c.GLOBALENTITYNAME AS "PermitContactCompanyName",
		c.ISCOMPANY AS "PermitContactIsCompany",
		c.ISCONTACT AS "PermitContactIsContact",
		c.EMAIL AS "PermitContactEmailAddress",
		c.BUSINESSPHONE AS "PermitContactBusinessPhone",
		c.HOMEPHONE AS "PermitContactHomePhone",
		c.MOBILEPHONE AS "PermitContactMobilePhone",
		c.OTHERPHONE AS "PermitContactOtherPhone",
		c.FAX AS "PermitContactFax",
		c.FIRSTNAME AS "PermitContactFirstName",
		c.LASTNAME AS "PermitContactLastName",
		c.MIDDLENAME AS "PermitContactMiddleName",
		c.TITLE AS "PermitContactTitle",
		(SELECT TOP 1 ma.ADDRESSLINE1 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressLine1",
		(SELECT TOP 1 ma.ADDRESSLINE2 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressLine2",
		(SELECT TOP 1 ma.ADDRESSLINE3 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressLine3",
		(SELECT TOP 1 ma.CITY 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressCity",
		(SELECT TOP 1 ma.STATE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressState",
		(SELECT TOP 1 ma.POSTALCODE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressPostalCode",
		(SELECT TOP 1 ma.POSTDIRECTION 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressPostDirection",
		(SELECT TOP 1 ma.PREDIRECTION 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressPreDirection",
		(SELECT TOP 1 ma.STREETTYPE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressStreetType",
		(SELECT TOP 1 ma.UNITORSUITE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressUnitOrSuite"
	FROM [$(EnerGovDatabase)].dbo.CMCODECASECONTACT pc
	INNER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY c ON pc.GLOBALENTITYID = c.GLOBALENTITYID
	WHERE pc.CMCODECASEID = @CODECASEID AND pc.CMCODECASECONTACTTYPEID = '3AB42CBB-7DA8-403F-91F3-5F5669386180'
	
	UNION
	SELECT
		c.GLOBALENTITYNAME AS "PermitContactCompanyName",
		c.ISCOMPANY AS "PermitContactIsCompany",
		c.ISCONTACT AS "PermitContactIsContact",
		c.EMAIL AS "PermitContactEmailAddress",
		c.BUSINESSPHONE AS "PermitContactBusinessPhone",
		c.HOMEPHONE AS "PermitContactHomePhone",
		c.MOBILEPHONE AS "PermitContactMobilePhone",
		c.OTHERPHONE AS "PermitContactOtherPhone",
		c.FAX AS "PermitContactFax",
		c.FIRSTNAME AS "PermitContactFirstName",
		c.LASTNAME AS "PermitContactLastName",
		c.MIDDLENAME AS "PermitContactMiddleName",
		c.TITLE AS "PermitContactTitle",
		(SELECT TOP 1 ma.ADDRESSLINE1 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressLine1",
		(SELECT TOP 1 ma.ADDRESSLINE2 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressLine2",
		(SELECT TOP 1 ma.ADDRESSLINE3 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressLine3",
		(SELECT TOP 1 ma.CITY 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressCity",
		(SELECT TOP 1 ma.STATE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressState",
		(SELECT TOP 1 ma.POSTALCODE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressPostalCode",
		(SELECT TOP 1 ma.POSTDIRECTION 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressPostDirection",
		(SELECT TOP 1 ma.PREDIRECTION 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressPreDirection",
		(SELECT TOP 1 ma.STREETTYPE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressStreetType",
		(SELECT TOP 1 ma.UNITORSUITE 
			FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
			INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
			WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitAddressUnitOrSuite"
	FROM [$(EnerGovDatabase)].dbo.CMCODECASECONTACT pc
	INNER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY c ON pc.GLOBALENTITYID = c.GLOBALENTITYID
	WHERE pc.CMCODECASEID = @CODECASEID AND pc.CMCODECASECONTACTTYPEID = '3AB42CBB-7DA8-403F-91F3-5F5669386180'