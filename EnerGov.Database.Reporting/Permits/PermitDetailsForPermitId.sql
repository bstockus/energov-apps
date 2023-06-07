CREATE PROCEDURE [dbo].[PermitDetailsForPermitId]
	@PERMITID AS VARCHAR(36)
AS
	
	SELECT
		p.PMPERMITID AS "PermitId",
		p.PERMITNUMBER AS "PermitNumber",
		pt.NAME AS "PermitTypeName",
		pt.FRIENDLYNAME AS "PermitTypeFriendlyName",
		pwc.NAME AS "PermitWorkClassName",
		ps.NAME AS "PermitStatusName",
		ps.COMPLETEDFLAG AS "PermitStatusIsCompleted",
		ps.FAILUREFLAG AS "PermitStatusIsFailure",
		ps.HOLDFLAG AS "PermitStatusIsHold",
		ps.ISSUEDFLAG AS "PermitStatusIsIssued",
		pp.PMPERMITID AS "ParentPermitId",
		pp.PERMITNUMBER AS "ParentPermitNumber",
		p.DESCRIPTION AS "PermitDescription",
		p.VALUE AS "PermitValuation",
		p.SQUAREFEET AS "PermitSquareFootage",
		p.APPLYDATE AS "PermitApplicationDate",
		p.ISSUEDATE AS "PermitIssueDate",
		p.EXPIREDATE AS "PermitExpirationDate",
		p.LASTINSPECTIONDATE AS "PermitLastInspectionDate",
		p.FINALIZEDATE AS "PermitFinalizedDate",
		p.LASTCHANGEDON AS "PermitLastChangedOnDate",
		lcbu.SUSERGUID AS "LastChangedByUserId",
		lcbu.FNAME AS "LastChangedByUserFirstName",
		lcbu.LNAME AS "LastChangedByUserLastName",
		atu.SUSERGUID AS "AssignedToUserId",
		atu.FNAME AS "AssignedToUserFirstName",
		atu.LNAME AS "AssignedToUserLastName",
		pd.NAME AS "PermitDistrictName",
		pt.SQUAREFEET AS "PermitUsesSquareFootage",
		pt.VALUATION AS "PermitUsesValuation"
	FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITSTATUS ps ON p.PMPERMITSTATUSID = ps.PMPERMITSTATUSID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT pp ON p.PMPERMITPARENTID = pp.PMPERMITID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.USERS lcbu ON p.LASTCHANGEDBY = lcbu.SUSERGUID
	LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.USERS atu ON p.ASSIGNEDTO = atu.SUSERGUID
	INNER JOIN [$(EnerGovDatabase)].dbo.DISTRICT pd ON p.DISTRICTID = pd.DISTRICTID
	WHERE p.PMPERMITID = @PERMITID