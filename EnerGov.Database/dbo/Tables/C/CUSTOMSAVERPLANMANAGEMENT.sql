CREATE TABLE [dbo].[CUSTOMSAVERPLANMANAGEMENT] (
    [ID]                           CHAR (36)      NOT NULL,
    [NonProfitTaxExempt]           NVARCHAR (50)  NULL,
    [WISellersPermitNbr]           NVARCHAR (50)  NULL,
    [EventName]                    NVARCHAR (50)  NULL,
    [EventDates]                   NVARCHAR (MAX) NULL,
    [EventStartTime]               NVARCHAR (50)  NULL,
    [EventEndTime]                 NVARCHAR (50)  NULL,
    [EventSetupBegins]             NVARCHAR (50)  NULL,
    [EventTakeDownEnds]            NVARCHAR (50)  NULL,
    [EventLocation]                NVARCHAR (36)  NULL,
    [EventLocationDescription]     NVARCHAR (MAX) NULL,
    [TotalAnticipatedAttendance]   NVARCHAR (50)  NULL,
    [DailyAnticipatedAttendance]   NVARCHAR (50)  NULL,
    [EventAdmissionRequirements]   NVARCHAR (MAX) NULL,
    [EventDescription]             NVARCHAR (MAX) NULL,
    [EventType]                    NVARCHAR (36)  NULL,
    [EventClass]                   NVARCHAR (36)  NULL,
    [EventSubClass]                NVARCHAR (36)  NULL,
    [ExemptFromFees]               BIT            NULL,
    [ExpeditedPermit]              BIT            NULL,
    [LateApplication]              BIT            NULL,
    [AnticipatedTotalNumberOfJobs] INT            NULL,
    [DesignReviewType]             NVARCHAR (36)  NULL,
    [DesignReviewReason]           NVARCHAR (36)  NULL,
    [EstimatedCompletionDate]      DATETIME       NULL,
    [EstimatedProjectValue]        MONEY          NULL,
    [NumberOfDwellingUnits]        INT            NULL,
    [NumberOfParkingSpace]         INT            NULL,
    [NumberOfBedrooms]             INT            NULL,
    [TotalCubicFootage]            FLOAT (53)     NULL,
    [OfficeSpaceSquareFootage]     FLOAT (53)     NULL,
    [ResidentialSquareFootage]     FLOAT (53)     NULL,
    [RetailSquareFootage]          FLOAT (53)     NULL,
    [TotalSquareFootage]           FLOAT (53)     NULL,
    [FinalDesignReview]            BIT            NULL,
    [RequiresExemption]            BIT            NULL,
    TemporaryClassBLicenseType         nvarchar(36),
    OrganizationType                   nvarchar(36),
    PremiseDescriptionQuestion         nvarchar(max),
    PremiseDescriptionStorageQuestion  nvarchar(max),
    AlcoholLicenseWISellersPermit      nvarchar(50),
    HasCarnivalPermit                  bit,
    HasCircusPermit                    bit,
    HasMenageriePermit                 bit,
    DescriptionOfShowAnimals           nvarchar(max),
    DaystoBillAlcohol                  int,
    DaystoBillCarnival                 int,
    NumberOfTentInspections            int,
    AlcoholLicenseExpansionType        nvarchar(36),
    ExistingAlcoholBusinessNumber      nvarchar(50),
    AlcoholExpansionPremiseDescription nvarchar(max),
    CarnivalPremiseDescription         nvarchar(max),
    ExistingAlcoholLicenseYear         nvarchar(50),
    TemporaryClassBTimePeriod          nvarchar(max),
    AlcoholExpansionTimePeriod         nvarchar(max),
    CarnivalTimePeriod                 nvarchar(max),
    CONSTRAINT [PK_PlanManagement] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERPLANMANAGEMENT_UPDATE_ELASTIC] ON  CUSTOMSAVERPLANMANAGEMENT
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[P].[PLPLANID] ,
        'EnerGovBusiness.PlanManagement.Plan' ,
        [P].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [PLPLAN] AS [P] WITH (NOLOCK) ON [P].[PLPLANID] = [Inserted].[ID]

	UNION ALL

	SELECT 
		NEWID(),
		[PLAPPLICATION].[PLAPPLICATIONID],
		'EnerGovBusiness.PlanManagement.Application',
		[PLAPPLICATION].[ROWVERSION],
		GETDATE() ,
        NULL ,
		2,
		(SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [PLAPPLICATION] WITH (NOLOCK) ON [PLAPPLICATION].[PLAPPLICATIONID] = [Inserted].[ID];

END
