CREATE PROCEDURE [dbo].[InvoiceCompleteForFireOccupancy]
	@InvoiceNumberBegin AS NVARCHAR(20),
	@InvoiceNumberEnd AS NVARCHAR(20)
AS

SELECT 
	i.CAINVOICEID AS "InvoiceId",
	i.INVOICENUMBER AS "InvoiceNumber",
	i.INVOICEDATE AS "InvoiceDate",
	i.INVOICEDUEDATE AS "InvoiceDueDate",
	i.ADJUSTEDDATE AS "InvoiceAdjustedDate",
	i.INVOICEDESCRIPTION AS "InvoiceDescription",
	_is.NAME AS "InvoiceStatusName",
	ge.GLOBALENTITYNAME AS "BillingContactCompanyName",
	ge.ISCOMPANY AS "BillingContactIsCompany",
	ge.ISCONTACT AS "BillingContactIsContact",
	ge.FIRSTNAME AS "BillingContactFirstName",
	ge.LASTNAME AS "BillingContactLastName",
	(SELECT TOP 1 ma.ADDRESSLINE1 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingContactAddressLine1",
	(SELECT TOP 1 ma.ADDRESSLINE2 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingContactAddressLine2",
	(SELECT TOP 1 ma.ADDRESSLINE3 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingContactAddressLine3",
	(SELECT TOP 1 REPLACE(REPLACE(REPLACE(ma.CITY, 'CITY OF ', ''), 'TOWN OF ', ''), 'VILLAGE OF ', '')
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressCity",
	(SELECT TOP 1 ma.STATE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressState",
	(SELECT TOP 1 ma.POSTALCODE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressPostalCode",
	(SELECT TOP 1 ma.POSTDIRECTION 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressPostDirection",
	(SELECT TOP 1 ma.PREDIRECTION 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressPreDirection",
	(SELECT TOP 1 ma.STREETTYPE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressStreetType",
	(SELECT TOP 1 ma.UNITORSUITE 
		FROM [$(EnerGovDatabase)].dbo.GLOBALENTITYMAILINGADDRESS gema 
		INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS ma ON gema.MAILINGADDRESSID = ma.MAILINGADDRESSID 
		WHERE gema.GLOBALENTITYID = i.GLOBALENTITYID) AS "BillingAddressUnitOrSuite",
	f.CaseType,
	f.CaseId,
	f.CaseNumber,
	f.CaseTypeName,
	f.CaseClassName,
	f.PaidAmount,
	f.TotalAmount,
	f.DisplayInputAmount,
	f.InputName,
	f.FeeName,
	f.CaseAddresses,
	ISNULL((SELECT COUNT(*)
		FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE caif
		INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
		WHERE caif.CAINVOICEID = i.CAINVOICEID AND (cacf.FEENAME = 'Credit Card Processing Fee' OR cacf.FEENAME = 'Credit Card Convenience Fee' OR cacf.FEENAME = 'Credit Card Convenience Fee (CRM)')), 0) AS "OnlineInvoice"
FROM (
	SELECT
		ftf.CAFEEID AS "FeeId",
		'Inspection' AS "CaseType",
		insp.IMINSPECTIONID AS "CaseId",
		ISNULL((SELECT TOP 1 blge.STATETAXNUMBER FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSION blge
		    WHERE blge.BLGLOBALENTITYEXTENSIONID = insp.LINKID), '') AS "CaseNumber",
		inspType.NAME AS "CaseTypeName",
		'' AS "CaseClassName",
		inf.PAIDAMOUNT AS "PaidAmount",
		cf.COMPUTEDAMOUNT AS "TotalAmount",
		cf.DISPLAYINPUTVALUE AS "DisplayInputAmount",
		cafeesetup.COMPUTATIONVALUENAME AS "InputName",
		inf.CAINVOICEID AS "InvoiceId",
		cf.FEENAME AS "FeeName",
		(SELECT
				ISNULL(STUFF((SELECT CAST(', ' +
						LTRIM(RTRIM(a.ADDRESSLINE1 + ' '  +
							LTRIM(RTRIM(ISNULL(a.PREDIRECTION, '') + ' ' +
								LTRIM(RTRIM(ISNULL(a.ADDRESSLINE2, ''))) + ' ' +
									LTRIM(RTRIM(ISNULL(a.STREETTYPE, '') + ' ' +
										LTRIM(RTRIM(ISNULL(a.POSTDIRECTION, '') + ' ' +
											LTRIM(RTRIM(ISNULL(a.UNITORSUITE, '')
										))
									))
								))
							))
						))
						AS NVARCHAR(MAX)) [text()]
					FROM [$(EnerGovDatabase)].dbo.IMINSPECTIONADDRESS inspa
					INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON inspa.MAILINGADDRESSID = a.MAILINGADDRESSID
					WHERE inspa.IMINSPECTIONID = inspx.IMINSPECTIONID
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "Addresses"
			FROM [$(EnerGovDatabase)].dbo.IMINSPECTION inspx
			WHERE inspx.IMINSPECTIONID = insp.IMINSPECTIONID) AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE inf
	INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON inf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE caftf ON cf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEE cfee ON caftf.CAFEEID = cfee.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEESETUP cafeesetup ON cfee.CAFEEID = cafeesetup.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CASCHEDULE casched ON cafeesetup.CASCHEDULEID = casched.CASCHEDULEID AND cf.CREATEDON BETWEEN casched.STARTDATE AND casched.ENDDATE
	INNER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTIONFEE inspf ON cf.CACOMPUTEDFEEID = inspf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTION insp ON inspf.IMINSPECTIONID = insp.IMINSPECTIONID
	INNER JOIN [$(EnerGovDatabase)].dbo.IMINSPECTIONTYPE inspType ON insp.IMINSPECTIONTYPEID = inspType.IMINSPECTIONTYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE ftf ON cf.CAFEETEMPLATEFEEID = ftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAINVOICE invx ON inf.CAINVOICEID = invx.CAINVOICEID
	WHERE invx.CREATEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa' AND invx.CASTATUSID = 1
	) AS f
INNER JOIN [$(EnerGovDatabase)].dbo.CAINVOICE i ON f.InvoiceId = i.CAINVOICEID
INNER JOIN [$(EnerGovDatabase)].dbo.CASTATUS _is ON i.CASTATUSID = _is.CASTATUSID
INNER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY ge ON i.GLOBALENTITYID = ge.GLOBALENTITYID
WHERE i.INVOICENUMBER BETWEEN @InvoiceNumberBegin AND @InvoiceNumberEnd