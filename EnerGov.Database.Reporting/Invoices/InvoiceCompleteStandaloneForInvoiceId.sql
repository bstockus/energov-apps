CREATE PROCEDURE [dbo].[InvoiceCompleteStandaloneForInvoiceId]
	@INVOICEID AS varchar(36)
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
	(SELECT TOP 1 ma.CITY 
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
FROM (SELECT
		ftf.CAFEEID AS "FeeId",
		'Permit' AS "CaseType",
		p.PMPERMITID AS "CaseId",
		p.PERMITNUMBER AS "CaseNumber",
		pt.NAME AS "CaseTypeName",
		pwc.NAME AS "CaseClassName",
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
					FROM [$(EnerGovDatabase)].dbo.PMPERMITADDRESS pa
					INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON pa.MAILINGADDRESSID = a.MAILINGADDRESSID
					WHERE pa.PMPERMITID = p.PMPERMITID
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "Addresses"
			FROM [$(EnerGovDatabase)].dbo.PMPERMIT perm
			WHERE perm.PMPERMITID = p.PMPERMITID) AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE inf
	INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON inf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE caftf ON cf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEE cfee ON caftf.CAFEEID = cfee.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEESETUP cafeesetup ON cfee.CAFEEID = cafeesetup.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CASCHEDULE casched ON cafeesetup.CASCHEDULEID = casched.CASCHEDULEID AND cf.CREATEDON BETWEEN casched.STARTDATE AND casched.ENDDATE
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITFEE pf ON cf.CACOMPUTEDFEEID = pf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON pf.PMPERMITID = p.PMPERMITID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE ftf ON cf.CAFEETEMPLATEFEEID = ftf.CAFEETEMPLATEFEEID
	WHERE inf.CAINVOICEID = @INVOICEID

	UNION ALL

	SELECT
		ftf.CAFEEID AS "FeeId",
		'Plan' AS "CaseType",
		p.PLPLANID AS "CaseId",
		p.PLANNUMBER AS "CaseNumber",
		pt.PLANNAME AS "CaseTypeName",
		pwc.NAME AS "CaseClassName",
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
					FROM [$(EnerGovDatabase)].dbo.PLPLANADDRESS plpa
					INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON plpa.MAILINGADDRESSID = a.MAILINGADDRESSID
					WHERE plpa.PLPLANID = plp.PLPLANID
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "Addresses"
			FROM [$(EnerGovDatabase)].dbo.PLPLAN plp
			WHERE plp.PLPLANID = p.PLPLANID) AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE inf
	INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON inf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE caftf ON cf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEE cfee ON caftf.CAFEEID = cfee.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEESETUP cafeesetup ON cfee.CAFEEID = cafeesetup.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CASCHEDULE casched ON cafeesetup.CASCHEDULEID = casched.CASCHEDULEID AND cf.CREATEDON BETWEEN casched.STARTDATE AND casched.ENDDATE
	INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANFEE pf ON cf.CACOMPUTEDFEEID = pf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.PLPLAN p ON pf.PLPLANID = p.PLPLANID
	INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANTYPE pt ON p.PLPLANTYPEID = pt.PLPLANTYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANWORKCLASS pwc ON p.PLPLANWORKCLASSID = pwc.PLPLANWORKCLASSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE ftf ON cf.CAFEETEMPLATEFEEID = ftf.CAFEETEMPLATEFEEID
	WHERE inf.CAINVOICEID = @INVOICEID

	UNION ALL

	SELECT
		ftf.CAFEEID AS "FeeId",
		'Code Enforcement' AS "CaseType",
		p.CMCODECASEID AS "CaseId",
		p.CASENUMBER AS "CaseNumber",
		pt.NAME AS "CaseTypeName",
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
					FROM [$(EnerGovDatabase)].dbo.CMCODECASEADDRESS cca
					INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON cca.MAILINGADDRESSID = a.MAILINGADDRESSID
					WHERE cca.CMCODECASEID = codecase.CMCODECASEID
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "Addresses"
			FROM [$(EnerGovDatabase)].dbo.CMCODECASE codecase
			WHERE codecase.CMCODECASEID = p.CMCODECASEID) AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE inf
	INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON inf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE caftf ON cf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEE cfee ON caftf.CAFEEID = cfee.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEESETUP cafeesetup ON cfee.CAFEEID = cafeesetup.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CASCHEDULE casched ON cafeesetup.CASCHEDULEID = casched.CASCHEDULEID AND cf.CREATEDON BETWEEN casched.STARTDATE AND casched.ENDDATE
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODECASEFEE pf ON cf.CACOMPUTEDFEEID = pf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCODECASE p ON pf.CMCODECASEID = p.CMCODECASEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CMCASETYPE pt ON p.CMCASETYPEID = pt.CMCASETYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE ftf ON cf.CAFEETEMPLATEFEEID = ftf.CAFEETEMPLATEFEEID
	WHERE inf.CAINVOICEID = @INVOICEID

	UNION ALL

	SELECT
		ftf.CAFEEID AS "FeeId",
		'Inspection' AS "CaseType",
		insp.IMINSPECTIONID AS "CaseId",
		insp.INSPECTIONNUMBER AS "CaseNumber",
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
	WHERE inf.CAINVOICEID = @INVOICEID

	UNION ALL

	SELECT
		ftf.CAFEEID AS "FeeId",
		'Business License' AS "CaseType",
		p.BLLICENSEID AS "CaseId",
		p.LICENSENUMBER AS "CaseNumber",
		pt.NAME AS "CaseTypeName",
		pc.NAME AS "CaseClassName",
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
					FROM [$(EnerGovDatabase)].dbo.BLLICENSEADDRESS cca
					INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS a ON cca.MAILINGADDRESSID = a.MAILINGADDRESSID
					WHERE cca.BLLICENSEID = codecase.BLLICENSEID AND cca.MAIN = 1
					FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "Addresses"
			FROM [$(EnerGovDatabase)].dbo.BLLICENSE codecase
			WHERE codecase.BLLICENSEID = p.BLLICENSEID) AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE inf
	INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON inf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE caftf ON cf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEE cfee ON caftf.CAFEEID = cfee.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEESETUP cafeesetup ON cfee.CAFEEID = cafeesetup.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CASCHEDULE casched ON cafeesetup.CASCHEDULEID = casched.CASCHEDULEID AND cf.CREATEDON BETWEEN casched.STARTDATE AND casched.ENDDATE
	INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSEFEE pf ON cf.CACOMPUTEDFEEID = pf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSE p ON pf.BLLICENSEID = p.BLLICENSEID
	INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSETYPE pt ON p.BLLICENSETYPEID = pt.BLLICENSETYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECLASS pc ON p.BLLICENSECLASSID = pc.BLLICENSECLASSID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE ftf ON cf.CAFEETEMPLATEFEEID = ftf.CAFEETEMPLATEFEEID
	WHERE inf.CAINVOICEID = @INVOICEID

	UNION ALL

	SELECT
		ftf.CAFEEID AS "FeeId",
		'Professional License' AS "CaseType",
		p.ILLICENSEID AS "CaseId",
		p.LICENSENUMBER AS "CaseNumber",
		pt.NAME AS "CaseTypeName",
		pc.NAME AS "CaseClassName",
		inf.PAIDAMOUNT AS "PaidAmount",
		cf.COMPUTEDAMOUNT AS "TotalAmount",
		cf.DISPLAYINPUTVALUE AS "DisplayInputAmount",
		cafeesetup.COMPUTATIONVALUENAME AS "InputName",
		inf.CAINVOICEID AS "InvoiceId",
		cf.FEENAME AS "FeeName",
		'' AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE inf
	INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON inf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID	
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE caftf ON cf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEE cfee ON caftf.CAFEEID = cfee.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEESETUP cafeesetup ON cfee.CAFEEID = cafeesetup.CAFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.CASCHEDULE casched ON cafeesetup.CASCHEDULEID = casched.CASCHEDULEID AND cf.CREATEDON BETWEEN casched.STARTDATE AND casched.ENDDATE
	INNER JOIN [$(EnerGovDatabase)].dbo.ILLICENSEFEE pf ON cf.CACOMPUTEDFEEID = pf.CACOMPUTEDFEEID
	INNER JOIN [$(EnerGovDatabase)].dbo.ILLICENSE p ON pf.ILLICENSEID = p.ILLICENSEID
	INNER JOIN [$(EnerGovDatabase)].dbo.ILLICENSETYPE pt ON p.ILLICENSETYPEID = pt.ILLICENSETYPEID
	INNER JOIN [$(EnerGovDatabase)].dbo.ILLICENSECLASSIFICATION pc ON p.ILLICENSECLASSIFICATIONID = pc.ILLICENSECLASSIFICATIONID
	INNER JOIN [$(EnerGovDatabase)].dbo.CAFEETEMPLATEFEE ftf ON cf.CAFEETEMPLATEFEEID = ftf.CAFEETEMPLATEFEEID
	WHERE inf.CAINVOICEID = @INVOICEID

	UNION ALL

	SELECT
		mf.CAFEEID AS "FeeId",
		'Miscellaneous' AS "CaseType",
		'MISC' AS "CaseId",
		NULL AS "CaseNumber",
		NULL AS "CaseTypeName",
		NULL AS "CaseClassName",
		mf.PAIDAMOUNT AS "PaidAmount",
		mf.AMOUNT AS "TotalAmount",
		mf.INPUTVALUE AS "DisplayInputAmount",
		'' AS "InputName",
		inmf.CAINVOICEID AS "InvoiceId",
		mf.FEENAME AS "FeeName",
		'' AS "CaseAddresses"
	FROM [$(EnerGovDatabase)].dbo.CAINVOICEMISCFEE inmf
	INNER JOIN [$(EnerGovDatabase)].dbo.CAMISCFEE mf ON inmf.CAMISCFEEID = mf.CAMISCFEEID
	WHERE inmf.CAINVOICEID = @INVOICEID) AS f
INNER JOIN [$(EnerGovDatabase)].dbo.CAINVOICE i ON f.InvoiceId = i.CAINVOICEID
INNER JOIN [$(EnerGovDatabase)].dbo.CASTATUS _is ON i.CASTATUSID = _is.CASTATUSID
INNER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY ge ON i.GLOBALENTITYID = ge.GLOBALENTITYID
WHERE i.CAINVOICEID = @INVOICEID