CREATE VIEW [dbo].[ParentRecordInfo]
AS
SELECT        permit.PMPERMITID AS RecordId, permit.PERMITNUMBER AS CaseNumber, permit.DESCRIPTION AS Description, 2 AS LinkType, permitstatus.NAME AS CaseStatus, project.NAME AS ProjectName, 
                         permit.LASTINSPECTIONDATE AS LastInspectionDate, gisfeature.keyvalue as SpatialCollection
FROM            dbo.PMPERMIT AS permit INNER JOIN
                         dbo.PMPERMITSTATUS AS permitstatus ON permitstatus.PMPERMITSTATUSID = permit.PMPERMITSTATUSID LEFT OUTER JOIN
                         dbo.PRPROJECTPERMIT AS projectpermit ON projectpermit.PMPERMITID = permit.PMPERMITID LEFT OUTER JOIN
                         dbo.PRPROJECT AS project ON project.PRPROJECTID = projectpermit.PRPROJECTID

outer apply (select top(1) * from dbo.pmpermitgisfeature where pmpermitid = permit.pmpermitid) as gisfeature


UNION
SELECT        plplan.PLPLANID AS RecordId, plplan.PLANNUMBER AS CaseNumber, plplan.DESCRIPTION AS Description, 1 AS LinkType, planstatus.NAME AS ParentCaseStatus, project.NAME AS ProjectName, NULL 
                         AS LastInspectionDate, gisfeature.keyvalue as SpatialCollection

FROM            dbo.PLPLAN AS plplan INNER JOIN
                         dbo.PLPLANSTATUS AS planstatus ON planstatus.PLPLANSTATUSID = plplan.PLPLANSTATUSID LEFT OUTER JOIN
                         dbo.PRPROJECTPLAN AS projectplan ON projectplan.PLPLANID = plplan.PLPLANID LEFT OUTER JOIN
                         dbo.PRPROJECT AS project ON project.PRPROJECTID = projectplan.PRPROJECTID
outer apply (select top(1) * from dbo.plplangisfeature where plplanid = plplan.plplanid) as gisfeature
UNION
SELECT        codecase.CMCODECASEID AS RecordId, codecase.CASENUMBER AS CaseNumber, codecase.DESCRIPTION AS Description, 3 AS LinkType, codecasestatus.NAME AS ParentCaseStatus, project.NAME AS ProjectName, NULL 
                         AS LastInspectionDate, null as SpatialCollection
FROM            dbo.CMCODECASE AS codecase INNER JOIN
                         dbo.CMCODECASESTATUS AS codecasestatus ON codecasestatus.CMCODECASESTATUSID = codecase.CMCODECASESTATUSID LEFT OUTER JOIN
                         dbo.PRPROJECTCODECASE AS projectcodecase ON projectcodecase.CMCODECASEID = codecase.CMCODECASEID LEFT OUTER JOIN
                         dbo.PRPROJECT AS project ON project.PRPROJECTID = projectcodecase.PRPROJECTID
UNION
SELECT        license.ILLICENSEID AS RecordId, license.LICENSENUMBER AS CaseNumber, license.DESCRIPTION AS Description, 6 AS LinkType, licensestatus.NAME AS ParentCaseStatus, NULL AS ProjectName, NULL 
                         AS LastInspectionDate, null as SpatialCollection
FROM            dbo.ILLICENSE AS license INNER JOIN
                         dbo.ILLICENSESTATUS AS licensestatus ON licensestatus.ILLICENSESTATUSID = license.ILLICENSESTATUSID
UNION
SELECT        license.BLLICENSEID AS RecordId, license.LICENSENUMBER AS CaseNumber, license.DESCRIPTION AS Description, 7 AS LinkType, licensestatus.NAME AS ParentCaseStatus, NULL AS ProjectName, NULL 
                         AS LastInspectionDate, null as SpatialCollection
FROM            dbo.BLLICENSE AS license INNER JOIN
                         dbo.BLLICENSESTATUS AS licensestatus ON licensestatus.BLLICENSESTATUSID = license.BLLICENSESTATUSID