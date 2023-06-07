CREATE TABLE [dbo].[CUSTOMSAVERSYSTEMSETUP] (
    [ID]                   CHAR (36)      NOT NULL,
    [LegistarID]           NVARCHAR (50)  NULL,
    [DriversLicenseState]  NVARCHAR (50)  NULL,
    [DriversLicenseNumber] NVARCHAR (50)  NULL,
    [DateOfBirth]          DATETIME       NULL,
    [PreviousNames]        NVARCHAR (MAX) NULL,
    [PriorOffenses]        NVARCHAR (MAX) NULL,
    [FloodPlainNotes]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_CustomSaverSystemSetup] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERSYSTEMSETUP_UPDATE_ELASTIC] ON  CUSTOMSAVERSYSTEMSETUP
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
		[C].[GLOBALENTITYID] ,
        'EnerGovBusiness.SystemSetup.GlobalEntity' ,
        [C].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [GLOBALENTITY] AS [C] WITH (NOLOCK) ON [C].[GLOBALENTITYID] = [Inserted].[ID];

END
