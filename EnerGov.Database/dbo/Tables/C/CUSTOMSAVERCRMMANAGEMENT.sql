CREATE TABLE [dbo].[CUSTOMSAVERCRMMANAGEMENT] (
    [ID]                        CHAR (36)      NOT NULL,
    [RentalProperty]            NVARCHAR (36)  NULL,
    [CreatedFromServiceRequest] BIT            NULL,
    [DriversLicenseState]       NVARCHAR (50)  NULL,
    [DriversLicenseNumber]      NVARCHAR (50)  NULL,
    [DateOfBirth]               DATETIME       NULL,
    [PreviousNames]             NVARCHAR (MAX) NULL,
    [PriorOffenses]             NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_CRMManagement] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERCRMMANAGEMENT_UPDATE_ELASTIC] ON  CUSTOMSAVERCRMMANAGEMENT
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
		[C].[CITIZENREQUESTID] ,
        'EnerGovBusiness.CitizenRequest.Requestmgmt' ,
        [C].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CITIZENREQUEST] AS [C] WITH (NOLOCK) ON [C].[CITIZENREQUESTID] = [Inserted].[ID];

END
