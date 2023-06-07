CREATE TABLE [dbo].[CUSTOMSAVERCODEMANAGEMENT] (
    [ID]                                  CHAR (36)      NOT NULL,
    [RentalProperty]                      NVARCHAR (36)  NULL,
    [CodeCaseSource]                      NVARCHAR (36)  NULL,
    [CreatedFromServiceRequest]           BIT            NULL,
    [DateOTCMailed]                       DATETIME       NULL,
    [CitationNumber]                      NVARCHAR (50)  NULL,
    [DateCitationIssued]                  DATETIME       NULL,
    [CitationVerdict]                     NVARCHAR (36)  NULL,
    [MethodOfServing]                     NVARCHAR (36)  NULL,
    [VerdictDate]                         DATETIME       NULL,
    [WorkOrderContractor]                 NVARCHAR (36)  NULL,
    [DateSentToContractor]                DATETIME       NULL,
    [ReceivedInvoiceFromContractor]       BIT            NULL,
    [PaidContractorInvoice]               BIT            NULL,
    [SentContractorInvoiceToFinance]      BIT            NULL,
    [NotarizedBy]                         NVARCHAR (36)  NULL,
    [AdministrativeCodeSection]           NVARCHAR (50)  NULL,
    [AdditionalOTCText]                   NVARCHAR (MAX) NULL,
    [GarbageMunicipalCodeSections]        NVARCHAR (36)  NULL,
    [OfficialContactLetterPremise]        NVARCHAR (50)  NULL,
    [OfficialContactLetterInspectionDate] DATETIME       NULL,
    [SidewalkLinearFootage]               INT            NULL,
    [NumberOfViolations]                  INT            NULL,
    [NumberOfViolationsThatAreNuisances]  INT            NULL,
    [DateSince]                           DATETIME       NULL,
    [MeetingDate]                         DATETIME       NULL,
    [MeetingTime]                         NVARCHAR (50)  NULL,
    [AbatementPlanItems]                  NVARCHAR (36)  NULL,
    [MandatoryCourtAppearance]            NVARCHAR (36)  NULL,
    [CourtAppearanceDate]                 DATETIME       NULL,
    [ViolationOccuranceDate]              DATETIME       NULL,
    [ViolationOccuranceTime]              NVARCHAR (50)  NULL,
    [ViolationOccuranceLocation]          NVARCHAR (50)  NULL,
    [DepositAmount]                       MONEY          NULL,
    [OrdinanceViolated]                   NVARCHAR (50)  NULL,
    [StateStatuteViolated]                NVARCHAR (50)  NULL,
    [DescriptionOfViolation]              NVARCHAR (MAX) NULL,
    [CitationServed]                      NVARCHAR (36)  NULL,
    [LegalDescription]                    NVARCHAR (MAX) NULL,
    [OwnerClaimedAsIllegalDump]           BIT            NULL,
    [IncludeWorkOrderFees]                BIT            NULL,
    [WorkOrderAmount]                     MONEY          NULL,
    [SnowfallStartDate]                   DATETIME       NULL,
    [SnowfallEndDate]                     DATETIME       NULL,
    [SnowRemovedDate]                     DATETIME       NULL,
    [CornerLinearFootage]                 INT            NULL,
    [AlleyLinearFootage]                  INT            NULL,
    [TotalLinearFootage]                  INT            NULL,
    CONSTRAINT [PK_CodeManagement] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERCODEMANAGEMENT_UPDATE_ELASTIC_VIO] ON  CUSTOMSAVERCODEMANAGEMENT
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
		[C].[CMCODECASEID] ,
        'EnerGovBusiness.CodeEnforcement.CodeCase' ,
        [C].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CMVIOLATION] AS [V] WITH (NOLOCK) ON [V].[CMVIOLATIONID] = [Inserted].[ID]
	JOIN [CMCODEWFACTIONSTEP] AS [A] WITH (NOLOCK) ON [A].[CMCODEWFACTIONSTEPID] = [V].[CMCODEWFACTIONID]
	JOIN [CMCODEWFSTEP] AS [S] WITH (NOLOCK) ON [S].[CMCODEWFSTEPID] = [A].[CMCODEWFSTEPID]
	JOIN [CMCODECASE] AS [C] WITH (NOLOCK) ON [C].[CMCODECASEID] = [Inserted].[ID];

END

GO

CREATE TRIGGER [TG_CUSTOMSAVERCODEMANAGEMENT_UPDATE_ELASTIC] ON  CUSTOMSAVERCODEMANAGEMENT
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
		[C].[CMCODECASEID] ,
        'EnerGovBusiness.CodeEnforcement.CodeCase' ,
        [C].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CMCODECASE] AS [C] WITH (NOLOCK) ON [C].[CMCODECASEID] = [Inserted].[ID];

END
