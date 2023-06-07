CREATE PROCEDURE [dbo].[rpt_Permit_TemporaryOccupancyCertificate]
	@PERMITID AS VARCHAR(36)
AS


-- The Permit Itself

SELECT
	p.PMPERMITID AS "PermitId",
	p.PERMITNUMBER AS "PermitNumber",
	pt.NAME AS "PermitTypeName",
	pwc.NAME AS "PermitWorkClassName",
	ptcdh.DepartmentHeaderType AS "DepartmentHeaderType",
	dh.LeftLogoType AS "DepartmentHeaderLeftLogoType",
	dh.RightLogoType AS "DepartmentHeaderRightLogoType",
	dh.MainText AS "DepartmentHeaderMainText",
	dh.SubMainText AS "DepartmentHeaderSubMainText",
	dh.LeftTextLine1 AS "DepartmentHeaderLeftTextLine1",
	dh.LeftTextLine2 AS "DepartmentHeaderLeftTextLine2",
	dh.RightTextLine1 AS "DepartmentHeaderRightTextLine1",
	dh.RightTextLine2 AS "DepartmentHeaderRightTextLine2",
	p.ISSUEDATE AS "PermitIssueDate",
	par.PARCELNUMBER AS "ParcelNumber",
	a.ADDRESSLINE1 AS "PermitAddressLine1",
	a.ADDRESSLINE2 AS "PermitAddressLine2",
	a.ADDRESSLINE3 AS "PermitAddressLine3",
	a.CITY AS "PermitAddressCity",
	a.STATE AS "PermitAddressState",
	a.POSTALCODE AS "PermitAddressPostalCode",
	a.POSTDIRECTION AS "PermitAddressPostDirection",
	a.PREDIRECTION AS "PermitAddressPreDirection",
	a.STREETTYPE AS "PermitAddressStreetType",
	a.UNITORSUITE AS "PermitAddressUnitOrSuite",
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
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressCity",
	(SELECT TOP 1 ma.STATE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressState",
	(SELECT TOP 1 ma.POSTALCODE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressPostalCode",
	(SELECT TOP 1 ma.POSTDIRECTION 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressPostDirection",
	(SELECT TOP 1 ma.PREDIRECTION 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressPreDirection",
	(SELECT TOP 1 ma.STREETTYPE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressStreetType",
	(SELECT TOP 1 ma.UNITORSUITE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = c.GLOBALENTITYID) AS "PermitContactAddressUnitOrSuite",
	cspm.OccupantLoadCapacity AS "OccupancyMax",
	cspm.NumberOfStories AS "Stories",
	cspm.TotalSquareFootage AS "GrossArea",
	'' AS "BuildingUseCode",
	'' AS "BuildingUseDescription",
	'' AS "IssuerFirstName",
	'' AS "IssuerLastName",
	'' AS "IssuerSignature",
	'2017-01-01' AS "IssuedDate",
	cspm.TemporaryOccupancyPermitText AS "Comments",
	'' AS "PermitNotes"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p 
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
LEFT OUTER JOIN laxreports.PermitTypeDepartmentHeader ptcdh ON p.PMPERMITTYPEID = ptcdh.PermitTypeId
LEFT OUTER JOIN laxreports.DepartmentHeaders dh ON ptcdh.DepartmentHeaderType = dh.Id
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PMPERMITADDRESS pa ON p.PMPERMITID = pa.PMPERMITID AND pa.MAIN = 1
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON pa.MAILINGADDRESSID = a.MAILINGADDRESSID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PMPERMITPARCEL pp ON p.PMPERMITID = pp.PMPERMITID AND pp.MAIN = 1
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PARCEL par ON pp.PARCELID = par.PARCELID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PMPERMITCONTACT pc ON p.PMPERMITID = pc.PMPERMITID AND pc.LANDMANAGEMENTCONTACTTYPEID = '959EBD4C-472D-4775-B8CE-A53B0077AADA'
INNER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY c ON pc.GLOBALENTITYID = c.GLOBALENTITYID
INNER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm ON p.PMPERMITID = cspm.ID
WHERE p.PMPERMITID = @PERMITID;