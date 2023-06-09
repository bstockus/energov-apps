﻿CREATE TABLE [dbo].[ELASTICSEARCHOBJECT] (
    [ELASTICSEARCHOBJECTID]       CHAR (36)      NOT NULL,
    [OBJECTID]                    CHAR (36)      NOT NULL,
    [OBJECTCLASSNAME]             NVARCHAR (250) NOT NULL,
    [ROWVERSION]                  INT            NOT NULL,
    [CREATEDATE]                  DATETIME       NOT NULL,
    [PROCESSEDDATE]               DATETIME       NULL,
    [OBJECTACTION]                INT            NOT NULL,
    [INDEXNAME]                   NVARCHAR (100) NOT NULL,
    [RESERVEDBY]                  CHAR (36)      NULL,
    [RESERVEDDATE]                DATETIME       NULL,
    [ELASTICSEARCHOBJECTSTATUSID] INT            CONSTRAINT [DF_ELASTICSEARCHOBJECT_ELASTICSEARCHOBJECTSTATUSID] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ELASTICSEARCHOBJECT] PRIMARY KEY CLUSTERED ([ELASTICSEARCHOBJECTID] ASC),
    CONSTRAINT [FK_ELASTICSEARCHOBJECT_ELASTICSEARCHOBJECTSTATUSID] FOREIGN KEY ([ELASTICSEARCHOBJECTSTATUSID]) REFERENCES [dbo].[ELASTICSEARCHOBJECTSTATUS] ([ELASTICSEARCHOBJECTSTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [ELASTIC_PROCESSDATE]
    ON [dbo].[ELASTICSEARCHOBJECT]([PROCESSEDDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ELASTIC_PROCESSEDDATE_CREATEDATE]
    ON [dbo].[ELASTICSEARCHOBJECT]([PROCESSEDDATE] ASC, [CREATEDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ELASTIC_CREATEDATE]
    ON [dbo].[ELASTICSEARCHOBJECT]([CREATEDATE] ASC, [OBJECTID] ASC, [RESERVEDBY] ASC, [PROCESSEDDATE] ASC)
    INCLUDE([RESERVEDDATE]);


GO
CREATE NONCLUSTERED INDEX [IX_ELASTIC_OBJECTID]
    ON [dbo].[ELASTICSEARCHOBJECT]([OBJECTID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ELASTIC_RESERVEDBY]
    ON [dbo].[ELASTICSEARCHOBJECT]([RESERVEDBY] ASC, [PROCESSEDDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ELASTIC_RESERVEDDATE]
    ON [dbo].[ELASTICSEARCHOBJECT]([PROCESSEDDATE] ASC, [RESERVEDDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ELASTICSEARCHOBJECT_ELASTICSEARCHOBJECTSTATUSID]
    ON [dbo].[ELASTICSEARCHOBJECT]([ELASTICSEARCHOBJECTSTATUSID] ASC);


GO

CREATE TRIGGER [TG_ELASTIC_INSERT_RECORDCHANGETRACKQUEUE] ON ELASTICSEARCHOBJECT
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [RECORDCHANGETRACKQUEUE]
    (
		[RECORDID], 
		[RECORDSOURCEID], 
		[CREATEDATE], 
		[PROCESSEDDATE], 
		[RECORDSTATUSID], 
		[RECORDACTIONID]
    )
	SELECT
		[Inserted].[OBJECTID],
		CASE [Inserted].[OBJECTCLASSNAME]
			WHEN 'EnerGovBusiness.BusinessLicense.BusinessLicense' THEN 1
			WHEN 'EnerGovBusiness.BusinessLicense.BusinessLicenseGlobalEntityExtension' THEN 2
		    WHEN 'EnerGovBusiness.Cashier.CashieringInvoice' THEN 3
			WHEN 'EnerGovBusiness.CitizenRequest.Requestmgmt' THEN 4
			WHEN 'EnerGovBusiness.CodeEnforcement.CodeCase' THEN 5
			WHEN 'EnerGovBusiness.FireOccupancy.FireOccupancy' THEN 6
			WHEN 'EnerGovBusiness.IndividualLicense.License' THEN 7
			WHEN 'EnerGovBusiness.Inspections.Inspection' THEN 8
			WHEN 'EnerGovBusiness.PermitManagement.Permit' THEN 9
			WHEN 'EnerGovBusiness.PlanManagement.EProject' THEN 10
			WHEN 'EnerGovBusiness.PlanManagement.Plan' THEN 11
			WHEN 'EnerGovBusiness.ProjectManagement.Project' THEN 12
			WHEN 'EnerGovBusiness.SystemSetup.GlobalEntity' THEN 13
		END AS RECORDSOURCEID,
        GETDATE(),
        NULL, -- ProcessedDate is null
        1, -- Pending from RECORDSTATUS table
        [Inserted].[OBJECTACTION] -- refered from RECORDACTION table
	FROM [Inserted]
	WHERE [Inserted].[OBJECTCLASSNAME] IN (
			'EnerGovBusiness.BusinessLicense.BusinessLicense',
			'EnerGovBusiness.CitizenRequest.Requestmgmt',
			'EnerGovBusiness.CodeEnforcement.CodeCase',
			'EnerGovBusiness.IndividualLicense.License',
			'EnerGovBusiness.Inspections.Inspection',
			'EnerGovBusiness.PermitManagement.Permit',
			'EnerGovBusiness.PlanManagement.Plan',
			'EnerGovBusiness.ProjectManagement.Project'
			)
END