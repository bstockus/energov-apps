CREATE PROCEDURE [dbo].[rpt_PermitPacket]
	@PERMITID AS VARCHAR(36)
AS


-- The Permit Itself

SELECT
	v.SectionType,
	v.SectionSortOrder,
	v.SectionReference,
	v.SectionSubReference,
	v.SectionSubSubReference,
	v.SectionSubSubSubReference,
	v.PermitId,
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
	dh.RightTextLine2 AS "DepartmentHeaderRightTextLine2"
FROM (

-- Banner Messages

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'STORM DAMAGE REPAIRS' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.StormDamageRepairs = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'FIRE DAMAGE REPAIRS' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.FireDamageRepairs = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'FLOOD DAMAGE REPAIRS' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.FloodDamageRepairs = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'STARTED WORK WITHOUT PERMIT' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.WorkStartedWithoutPermit = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'EXPEDITED PERMIT' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.ExpeditedPermit = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'CITY PULLED PERMIT' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.CityPulledPermit = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'EXEMPT FROM FEES' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.ExemptFromFees = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'TOWN OF MEDARY' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.[TownOfMedary] = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'TOWN OF MEDARY' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.PlumbingDistrict IN ('9a67f03d-cefc-46db-b8fa-ceae605ebbc0', '01bfc781-4fe6-4e3d-ab2d-3c8e6d160933')

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'TOWN OF CAMPBELL' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.PlumbingDistrict IN ('9d52445d-667c-49f5-adbb-60af5749ff22', 'fffd798b-9a71-46e9-846c-ea648ed5fc4d')

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'TOWN OF SHELBY - DISTRICT #1' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.PlumbingDistrict IN ('30180918-0630-4119-92bb-9069e0f0ef04', '4ae9162a-774d-4879-8d51-c0180ec976fc')

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'TOWN OF SHELBY - DISTRICT #2' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.PlumbingDistrict IN ('f454736f-d702-4fdb-b8eb-44b3d9c32e37', '2025ad97-42be-456f-92ca-305c9bb13f68')

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'CONNECT OR RELAY ONLY PERMIT' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.PlumbingConnectOrRelayOnly = 1

UNION

SELECT
	'B' AS "SectionType",
	1 AS "SectionSortOrder",
	cspm.ID AS "PermitId",
	NULL AS "SectionReference",
	'CUT AND CAP ONLY PERMIT' AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CUSTOMSAVERPERMITMANAGEMENT cspm
WHERE cspm.ID = @PERMITID AND cspm.PlumbingCutAndCapOnly = 1

UNION

SELECT
	'PG' AS "SectionType",
	10 AS "SectionSortOrder",
	p.PMPERMITID AS "PermitId",
	p.PMPERMITID AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
WHERE p.PMPERMITID = @PERMITID

UNION

SELECT
	'PC' AS "SectionType",
	10 AS "SectionSortOrder",
	p.PMPERMITID AS "PermitId",
	p.PMPERMITID AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	10 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
WHERE p.PMPERMITID = @PERMITID

UNION

SELECT
	'PL' AS "SectionType",
	10 AS "SectionSortOrder",
	p.PMPERMITID AS "PermitId",
	p.PMPERMITID AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	20 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
WHERE p.PMPERMITID = @PERMITID

UNION

-- Custom Field

SELECT
	'CF' AS "SectionType",
	20 AS "SectionSortOrder",
	p.PMPERMITID AS "PermitId",
	ptccfs.CustomFieldSectionType AS "SectionReference",
	ptccfs.CustomFieldSectionName AS "SectionSubReference",
	p.PMPERMITID AS "SectionSubSubReference",
	'' AS "SectionSubSubSubReference",
	ptccfs.SortOrder AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPEWORKCLASS ptwc ON p.PMPERMITTYPEID = ptwc.PMPERMITTYPEID AND p.PMPERMITWORKCLASSID = ptwc.PMPERMITWORKCLASSID
INNER JOIN laxreports.PermitCustomFieldSections ptccfs ON ptwc.CUSTOMFIELDLAYOUTID = ptccfs.CustomFieldLayoutId
WHERE p.PMPERMITID = @PERMITID

UNION

-- Sub-Permits

--SELECT
--	'SP' AS "SectionType",
--	30 AS "SectionSortOrder",
--	@PERMITID AS "PermitId",
--	p.PMPERMITID AS "SectionReference",
--	NULL AS "SectionSubReference",
--	p.PMPERMITID AS "SectionSubSubReference",
--	NULL AS "SectionSubSubSubReference",
--	HASHBYTES('MD5', p.PMPERMITID) AS "SubSort",
--	-1 AS "SubSubSort"
--FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
--WHERE p.PMPERMITPARENTID = @PERMITID

--UNION

--SELECT
--	'SP' AS "SectionType",
--	30 AS "SectionSortOrder",
--	@PERMITID AS "PermitId",
--	par.PMPERMITID AS "SectionReference",
--	NULL AS "SectionSubReference",
--	par.PMPERMITID AS "SectionSubSubReference",
--	NULL AS "SectionSubSubSubReference",
--	HASHBYTES('MD5', par.PMPERMITID) AS "SubSort",
--	-1 AS "SubSubSort"
--FROM [$(EnerGovDatabase)].dbo.PMPERMITACTIONREF par
--INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas ON par.OBJECTID = pwfas.PMPERMITWFACTIONSTEPID
--INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID
--WHERE pwfs.PMPERMITID = @PERMITID

--UNION

-- Sub-Permit Custom Fields

SELECT 
	'CF' AS "SectionType",
	30 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	ptccfs.CustomFieldSectionType AS "SectionReference",
	ptccfs.CustomFieldSectionName AS "SectionSubReference",
	sp.SubPermitId AS "SectionSubSubReference",
	'SUB' AS "SectionSubSubSubReference",
	HASHBYTES('MD5', sp.SubPermitId) AS "SubSort",
	ptccfs.SortOrder AS "SubSubSort"
FROM (
	SELECT
		p.PMPERMITID AS "SubPermitId",
		p.PMPERMITTYPEID AS "SubPermitTypeId",
		p.PMPERMITWORKCLASSID AS "SubPermitClassId"
	FROM [$(EnerGovDatabase)].dbo.PMPERMITACTIONREF par
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas ON par.OBJECTID = pwfas.PMPERMITWFACTIONSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON par.PMPERMITID = p.PMPERMITID
	WHERE pwfs.PMPERMITID = @PERMITID

	UNION

	SELECT
		p.PMPERMITID AS "SubPermitId",
		p.PMPERMITTYPEID AS "SubPermitTypeId",
		p.PMPERMITWORKCLASSID AS "SubPermitClassId"
	FROM [$(EnerGovDatabase)].dbo.PMPERMITACTIONREF par
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFACTIONSTEP pwfas ON par.OBJECTID = pwfas.PMPERMITWFACTIONSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWFSTEP pwfs ON pwfas.PMPERMITWFSTEPID = pwfs.PMPERMITWFSTEPID
	INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON par.PMPERMITID = p.PMPERMITID
	WHERE pwfs.PMPERMITID = @PERMITID) AS sp
INNER JOIN [$(EnerGovDatabase)].[dbo].[PMPERMITTYPEWORKCLASS] ptwc ON sp.SubPermitTypeId = ptwc.PMPERMITTYPEID AND sp.SubPermitClassId = ptwc.PMPERMITWORKCLASSID
INNER JOIN laxreports.PermitCustomFieldSections ptccfs ON ptwc.CUSTOMFIELDLAYOUTID = ptccfs.CustomFieldLayoutId

UNION

-- Projects

SELECT
	'PR' AS "SectionType",
	40 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	pp.PRPROJECTID AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PRPROJECTPERMIT pp
WHERE pp.PMPERMITID = @PERMITID

UNION

-- Plan-Review Comments

SELECT
	'RH' AS "SectionType",
	100 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	NULL AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
LEFT OUTER JOIN laxreports.PermitTypeDepartmentHeader ptcdh ON p.PMPERMITTYPEID = ptcdh.PermitTypeId
WHERE p.PMPERMITID = @PERMITID AND ptcdh.DisplaysPlanReview = 1

UNION

SELECT
	'PR' AS "SectionType",
	101 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	pa.PMPERMITACTIVITYID AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].[dbo].[PMPERMIT] p
LEFT OUTER JOIN laxreports.PermitTypeDepartmentHeader ptcdh ON p.PMPERMITTYPEID = ptcdh.PermitTypeId
INNER JOIN [$(EnerGovDatabase)].[dbo].[PMPERMITWFSTEP] pwfs ON p.PMPERMITID = pwfs.PMPERMITID
INNER JOIN [$(EnerGovDatabase)].[dbo].[PMPERMITWFACTIONSTEP] pwfas ON pwfs.PMPERMITWFSTEPID = pwfas.PMPERMITWFSTEPID
INNER JOIN [$(EnerGovDatabase)].[dbo].[PMPERMITACTIVITY] pa ON pwfas.PMPERMITWFACTIONSTEPID = pa.PMPERMITWFACTIONSTEPID
WHERE 
	p.PMPERMITID = @PERMITID AND ptcdh.DisplaysPlanReview = 1 AND
	(pa.PMPERMITACTIVITYTYPEID = '49a602bf-3223-445a-ab1f-de672a12170d' OR		-- Plan Review - Building - Commercial
	 pa.PMPERMITACTIVITYTYPEID = 'a5f27206-6325-42af-812b-ac3dc51081ca' OR		-- Plan Review - Building - Residential
	 pa.PMPERMITACTIVITYTYPEID = 'dd532874-0e39-4cd2-b472-e982011f6411' OR		-- Plan Review - Building - Accessory
	 pa.PMPERMITACTIVITYTYPEID = 'dd3b26f4-5ce2-4720-9591-e9314d241ff6' OR		-- Plan Review - Building - Demolition
	 pa.PMPERMITACTIVITYTYPEID = '663344c5-9b65-4af3-90ec-02831c21cb46' OR		-- Plan Review - Fire - Alarm
	 pa.PMPERMITACTIVITYTYPEID = '6922fb8e-31e2-4884-8ae0-72e3619e19bd' OR		-- Plan Review - Fire - Clean Agent
	 pa.PMPERMITACTIVITYTYPEID = '41983949-2315-4d53-a0c5-36d7607945e9' OR		-- Plan Review - Fire - Commercial Kitchen
	 pa.PMPERMITACTIVITYTYPEID = 'c65e35f8-71ce-40dd-a458-01d1bd0bc7b0' OR		-- Plan Review - Fire - Spray Booth
	 pa.PMPERMITACTIVITYTYPEID = 'e9fe01fe-4a72-493d-a10d-66836aa541b3' OR		-- Plan Review - Fire - Sprinkler
	 pa.PMPERMITACTIVITYTYPEID = 'b655d02a-615e-47e7-befb-c76f26e5f614'			-- Plan Review - Fire - Storage Tank
	) AND
		pwfas.WORKFLOWSTATUSID = 1

UNION

-- Inspections

SELECT
	'IN' AS "SectionType",
	110 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	NULL AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
INNER JOIN [laxreports].PermitTypeDepartmentHeader ptcdh ON p.PMPERMITTYPEID = ptcdh.PermitTypeId
WHERE p.PMPERMITID = @PERMITID AND ptcdh.DisplaysRequiredInspections = 1

UNION

-- Additional Information

SELECT
	'AI' AS "SectionType",
	109 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	NULL AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	NULL AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].[dbo].[PMPERMIT] p
WHERE p.PMPERMITID = @PERMITID

UNION

-- Signatures

-- TODO: Append optional additional signature text based on Permit Work Class

SELECT
	'S' AS "SectionType",
	99 AS "SectionSortOrder",
	p.PMPERMITID AS "PermitId",
	p.PMPERMITID AS "SectionReference",
	NULL AS "SectionSubReference",
	NULL AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.PMPERMIT p
WHERE p.PMPERMITID = @PERMITID

UNION

-- Invoices

SELECT
	'I' AS "SectionType",
	200 AS "SectionSortOrder",
	@PERMITID AS "PermitId",
	NULL AS "SectionReference",
	NULL AS "SectionSubReference",
	_if.CAINVOICEID AS "SectionSubSubReference",
	NULL AS "SectionSubSubSubReference",
	0 AS "SubSort",
	0 AS "SubSubSort"
FROM [$(EnerGovDatabase)].dbo.CAINVOICEFEE _if
INNER JOIN [$(EnerGovDatabase)].dbo.CAINVOICE inv ON _if.CAINVOICEID = inv.CAINVOICEID
INNER JOIN [$(EnerGovDatabase)].dbo.CACOMPUTEDFEE cf ON _if.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITFEE pf ON cf.CACOMPUTEDFEEID = pf.CACOMPUTEDFEEID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON pf.PMPERMITID = p.PMPERMITID
INNER JOIN [laxreports].PermitTypeDepartmentHeader ptcdh ON p.PMPERMITTYPEID = ptcdh.PermitTypeId
WHERE pf.PMPERMITID = @PERMITID AND ptcdh.DisplaysInvoices = 1 AND inv.CASTATUSID != 5
GROUP BY _if.CAINVOICEID



) AS v 
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMIT p ON v.PermitId = p.PMPERMITID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
LEFT OUTER JOIN laxreports.PermitTypeDepartmentHeader ptcdh ON p.PMPERMITTYPEID = ptcdh.PermitTypeId
LEFT OUTER JOIN laxreports.DepartmentHeaders dh ON ptcdh.DepartmentHeaderType = dh.Id
ORDER BY v.SectionSortOrder ASC, v.SubSort ASC, v.SubSubSort ASC;